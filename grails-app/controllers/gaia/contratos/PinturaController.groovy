package gaia.contratos

import gaia.Contratos.DashBoardContratos
import gaia.pintura.DetallePintura
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

}
