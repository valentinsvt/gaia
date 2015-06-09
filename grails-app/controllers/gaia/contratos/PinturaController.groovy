package gaia.contratos

import gaia.Contratos.DashBoardContratos
import gaia.pintura.DetallePintura
import gaia.pintura.ItemImagen
import gaia.pintura.SubDetallePintura
import gaia.seguridad.Shield

class PinturaController extends Shield {
    static final sistema="CNTR"

    def lista(){

    }

    def tablaImagen(){
        def inicio = new Date().parse("dd-MM-yyyy",params.desde)
        def fin = new Date().parse("dd-MM-yyyy",params.hasta)
        def datos = DetallePintura.findAllByFinBetween(inicio,fin)
        [datos:datos,inicio:inicio,fin:fin]
    }

    def listaContable(){


    }

    def tablaContable(){
        def inicio = new Date().parse("dd-MM-yyyy",params.desde)
        def fin = new Date().parse("dd-MM-yyyy",params.hasta)
        def datos = DetallePintura.findAllByFinBetween(inicio,fin)
        def items = gaia.pintura.ItemImagen.findAllByPadreIsNull()
        def totales = [:]
        items.each {
            totales.put(it.id,0)
        }
        [datos:datos,items:items,totales:totales]
    }



    def verDetalles(){

        def pintura = DetallePintura.get(params.id)
        def detalle = SubDetallePintura.findAllByDetallePintura(pintura)



        [detalle:detalle,pintura:pintura]
    }

    def reporteExistentes(){

    }

    def tablaExistentes(){
        def inicio = new Date().parse("dd-MM-yyyy",params.desde)
        def fin = new Date().parse("dd-MM-yyyy",params.hasta)
        def det = DetallePintura.findAllByFinBetween(inicio,fin)
        def items = ItemImagen.findAll("from ItemImagen where tipoItem='R' and tipo='N' and padre is not null")
        def itemMan = ItemImagen.findById(3)

        def datos = [:]
        def total = [:]
        total.put("TOTAL",["Mantenimiento":0])
        items.each { i ->
            total["TOTAL"].put(i.descripcion,0)
        }
        det.each {d->
            def totParcial = 0
            def man = d.getTotalGrupo(itemMan)
            totParcial+=man
            if(!datos[d.numeroFactura+"-"+d.numeroAp]){
                def tmp = ["fecha":d.fin]
                tmp.put("Mantenimiento",man)
                tmp.put("estacion",d.cliente.nombre)
                tmp.put("codigo",d.cliente.codigo)
                total["TOTAL"]["Mantenimiento"]+=man
                items.each {i->
                    def valor = d.getTotalItem(i)
                    tmp.put(i.descripcion,valor)
                    total["TOTAL"][i.descripcion]+=valor
                    totParcial+=valor
                }
                if(totParcial>0)
                    datos.put(d.numeroFactura+"-"+d.numeroAp,tmp)
            }else{
                total["TOTAL"]["Mantenimiento"]+=man
                datos[d.numeroFactura+"-"+d.numeroAp]["Mantenimiento"]+=man
                items.each { i ->
                    def valor = d.getTotalItem(i)
                    datos[d.numeroFactura+"-"+d.numeroAp][i.descripcion]+=valor
                    total["TOTAL"][i.descripcion]+=valor
                }
            }
        }

        [datos:datos,items: items,total:total]

    }

    def reportePintura(){

    }

    def tablaPintura(){
        def inicio = new Date().parse("dd-MM-yyyy",params.desde)
        def fin = new Date().parse("dd-MM-yyyy",params.hasta)
        def det = DetallePintura.findAllByFinBetween(inicio,fin,[sort:"fin"])
        def itemPintura = ItemImagen.findById(12)
        def datos = [:]
        det.each {d->
            def valores = d.getCantidadYPrecioItem(itemPintura)
            if(valores[0]+valores[1]>0){
                if(!datos[d.numeroFactura+"-"+d.numeroAp]){
                    def tmp = ["fecha":d.fin]
                    tmp.put("Pintura",valores[0])
                    tmp.put("M2",valores[1])
                    tmp.put("Autorización",d.numeroAp)
                    tmp.put("codigo",d.cliente.codigo)
                    tmp.put("estacion",d.cliente.nombre)
                    datos.put(d.cliente.nombre,tmp)
                }else{

                    datos[d.numeroFactura+"-"+d.numeroAp]["Pintura"]+=valores[0]
                    datos[d.numeroFactura+"-"+d.numeroAp]["M2"]+=valores[1]


                }
            }

        }

        [datos:datos]
    }


    def reportePinturaNueva(){

    }

    def tablaPinturaNueva(){
        def inicio = new Date().parse("dd-MM-yyyy",params.desde)
        def fin = new Date().parse("dd-MM-yyyy",params.hasta)
        def det = DetallePintura.findAllByFinBetween(inicio,fin,[sort:"fin"])
        def itemPintura = ItemImagen.findById(11)
        def datos = [:]
        det.each {d->
            def valores = d.getCantidadYPrecioItem(itemPintura)
            if(valores[0]+valores[1]>0){
                if(!datos[d.numeroFactura+"-"+d.numeroAp]){
                    def tmp = ["fecha":d.fin]
                    tmp.put("Pintura",valores[0])
                    tmp.put("M2",valores[1])
                    tmp.put("Autorización",d.numeroAp)
                    tmp.put("codigo",d.cliente.codigo)
                    tmp.put("estacion",d.cliente.nombre)
                    datos.put(d.cliente.nombre,tmp)
                }else{

                    datos[d.numeroFactura+"-"+d.numeroAp]["Pintura"]+=valores[0]
                    datos[d.numeroFactura+"-"+d.numeroAp]["M2"]+=valores[1]


                }
            }

        }

        [datos:datos]
    }


}
