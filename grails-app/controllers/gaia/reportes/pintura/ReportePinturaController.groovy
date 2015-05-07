package gaia.reportes.pintura

import gaia.pintura.DetallePintura

class ReportePinturaController {

    def listaContablePdf(){
        def inicio = new Date().parse("dd-MM-yyyy",params.desde)
        def fin = new Date().parse("dd-MM-yyyy",params.hasta)
        def datos = DetallePintura.findAllByFinBetween(inicio,fin)
        def items = gaia.pintura.ItemImagen.findAllByPadreIsNull()
        def totales = [:]
        items.each {
            totales.put(it.id,0)
        }
        [datos:datos,items:items,totales:totales,inicio:inicio,fin:fin]
    }

    def listaImagenPdf(){
        def inicio = new Date().parse("dd-MM-yyyy",params.desde)
        def fin = new Date().parse("dd-MM-yyyy",params.hasta)
        def datos = DetallePintura.findAllByFinBetween(inicio,fin)
        [datos:datos,inicio: inicio,fin: fin]
    }
}
