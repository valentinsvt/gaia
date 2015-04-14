package gaia.Contratos

import gaia.estaciones.Estacion
import gaia.parametros.Parametros

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
        def check = 180
        def fechaMaxima = this.ultimoUniforme.plus(check)
        def fechaNaranja = this.ultimoUniforme.plus(check-30)

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
}
