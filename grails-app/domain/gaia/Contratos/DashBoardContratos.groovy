package gaia.Contratos

import gaia.Contratos.esicc.PeriodoDotacion
import gaia.estaciones.Estacion
import gaia.pintura.DetallePintura
import gaia.pintura.SubDetallePintura
import gaia.uniformes.PedidoUniformes

class DashBoardContratos {

    Estacion estacion
    Date ultimoContrato
    Date ultimaPintura
    Date ultimoUniforme
    Double porcentajeComercializacion

    static mapping = {
        table 'dhcn'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'dash__id'
            estacion column: 'stcn__id'
            ultimoContrato column: 'dhcnfccn'
            ultimaPintura column: 'dhcnfcpn'
            ultimoUniforme column: 'dhcnfcun'
            porcentajeComercializacion column: 'prctcmlz'
        }
    }
    static constraints = {
        ultimaPintura(nullable: true,blank:true)
        ultimoContrato(nullable: true,blank:true)
        ultimoUniforme(nullable: true,blank:true)
        porcentajeComercializacion(nullable: true,blank:true)
    }

    def getColorSemaforoContrato(fecha){
        def now = new Date()
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]

        if (this.ultimoContrato > now) {
            if(this.ultimoContrato<fecha){
                return [colores[1],"orange-contrato"]
            }else{
                return [colores[0],"green-contrato"]
            }

        }
        return [colores[2],"red-contrato"]
    }
    def getColorSemaforoUniforme(){
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        if(!this.ultimoUniforme)
            return [colores[2],"red-equipo"]
        def now = new Date()
        def check = 360
        def fechaMaxima = this.ultimoUniforme.plus(check)
        def fechaNaranja = this.ultimoUniforme.plus(check-100)

        if (fechaMaxima > now) {
            if(fechaNaranja<now){
                return [colores[1],"orange-equipo"]
            }else{
                return [colores[0],"green-equipo"]
            }

        }
        return [colores[2],"red-equipo"]
    }
    def getColorSemaforoPintura(){
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        if(!this.ultimaPintura)
            return [colores[2],"red-pintura"]
        def now = new Date()
        def check = 365*2
        def fechaMaxima = this.ultimaPintura.plus(check)
        def fechaNaranja = this.ultimaPintura.plus(check-180)

        if (fechaMaxima > now) {
            if(fechaNaranja<now){
                return [colores[1],"orange-pintura"]
            }else{
                return [colores[0],"green-pintura"]
            }

        }
        return [colores[2],"red-pintura"]
    }

    def getParcialesPintura(inicio,fin){

        def pintura = DetallePintura.findByClienteAndFinBetween(this.estacion.codigo,inicio,fin,[sort: "fin",order: "desc"])
        def parametros = ["pintura":[1,2],"mantenimiento":[3],"rotulacion":[4,5,6,7,8,9]]
        def p=0,r=0,m=0
        if(pintura){
            def detalles = SubDetallePintura.findAllBySecuencialAndCliente(pintura.secuencial,estacion.codigo)
            detalles.each {d->
                if(parametros["pintura"].contains(d.item.codigo)){
//                    println "item "+d.item.descripcion +" suma en pintura"
                    p+=d.total
                }
                if(parametros["mantenimiento"].contains(d.item.codigo)){
//                    println "item "+d.item.descripcion +" suma en mantenimiento"
                    m+=d.total
                }
                if(parametros["rotulacion"].contains(d.item.codigo)){
//                    println "item "+d.item.descripcion +" suma en rotulacion"
                    r+=d.total
                }
            }
        }
        return ["Pintura":p,"Rotulación":r,"Mantenimiento":m,"factura":pintura?.numeroFactura]
    }

    def getSolEnivada(){
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        def periodo = PeriodoDotacion.list([sort: "codigo", order: "desc",max:2])?.first()
        def pedido=PedidoUniformes.findByPeriodoAndEstacion(periodo,this.estacion)
        if(!pedido)
            return colores[2]
        else{
            if(pedido.estado!="S"){
                return colores[1]
            }else{
                return colores[0]
            }
        }
    }


}
