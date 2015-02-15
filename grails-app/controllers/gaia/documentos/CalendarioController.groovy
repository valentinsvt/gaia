package gaia.documentos

import gaia.seguridad.Shield
import groovy.json.JsonBuilder
import groovy.time.TimeCategory

class CalendarioController extends Shield {

    def calendarioGeneral() {
        def mes = new Date().format("MM")
        def anio = new Date().format("yyyy")
        if (params.mes) {
            mes = params.mes
        }
        def fecha = "${anio}-${mes}-01"
        return [mes: mes, fecha: fecha]
    }

    def documentosCreadosGeneral_ajax() {
        def fechaIni = new Date().parse("yyyy-MM-dd HH:mm", params.start + " 00:00")
        def fechaFin = new Date().parse("yyyy-MM-dd HH:mm", params.end + " 23:59")

//        println "creados  ini: " + fechaIni + " fin: " + fechaFin + " show: " + params.show + "   " + params.show.class

        def docsCreados = Documento.findAllByFechaRegistroBetween(fechaIni, fechaFin)

        def events = []

        if (params.show == "true") {
            docsCreados.each { dc ->
                def des = dc.descripcion
                if (des.size() > 22) {
                    des = des[0..22] + "…"
                }
                des = "<strong>" + dc.estacion.nombre + "</strong><br/>" + des
                if (dc.fin) {
                    if (dc.fin.clearTime() <= new Date().clearTime()) {
                        des += "<br/>" + dc.fin.format("dd-MM-yyyy")
                        des += " <i class='fa fa-exclamation-triangle text-danger'></i>"
                    } else if (dc.fin.clearTime() <= new Date().clearTime() + 30) {
                        des += "<br/>" + dc.fin.format("dd-MM-yyyy")
                        des += " <i class='fa fa-exclamation-circle text-warning'></i>"
                    }
                }
                def event = [:]
                event.id = dc.id
                event.title = des
                event.descripcion = dc.descripcion
                event.allDay = true
                event.start = dc.fechaRegistro.format("yyyy-MM-dd")

                events.add(event)
            }
        }
        def json = new JsonBuilder(events)
        render json
    }

    def documentosPorCaducarGeneral_ajax() {
        def fechaIni = new Date().parse("yyyy-MM-dd HH:mm", (new Date() + 1).format("yyyy-MM-dd") + " 23:59")
        def fechaFin = new Date().parse("yyyy-MM-dd", params.end)

//        println "por caducar  ini: " + fechaIni + " fin: " + fechaFin + " show: " + params.show + "   " + params.show.class

        def docsPorCaducar = Documento.findAllByFinBetween(fechaIni, fechaFin)

        def events = []

        if (params.show == "true") {
            docsPorCaducar.each { dc ->
                def des = dc.descripcion
                if (des.size() > 22) {
                    des = des[0..22] + "…"
                }
                def event = [:]
                event.id = dc.id
                event.title = "<strong>" + dc.estacion.nombre + "</strong><br/>" + des
                event.descripcion = dc.descripcion
                event.allDay = true
                event.start = dc.fin.format("yyyy-MM-dd")

                events.add(event)
            }
        }
        def json = new JsonBuilder(events)
        render json
    }

    def documentosCaducadosGeneral_ajax() {
        def fechaIni = new Date().parse("yyyy-MM-dd HH:mm", params.start + " 00:00")
        def fechaFin = new Date().parse("yyyy-MM-dd HH:mm", (new Date()).format("yyyy-MM-dd") + " 23:59")

//        println "caducados  ini: " + fechaIni + " fin: " + fechaFin + " show: " + params.show + "   " + params.show.class

        def docsPorCaducar = Documento.findAllByFinBetween(fechaIni, fechaFin)

        def events = []

        if (params.show == "true") {
            docsPorCaducar.each { dc ->
                def des = dc.descripcion
                if (des.size() > 22) {
                    des = des[0..22] + "…"
                }
                def event = [:]
                event.id = dc.id
                event.title = "<strong>" + dc.estacion.nombre + "</strong><br/>" + des
                event.descripcion = dc.descripcion
                event.allDay = true
                event.start = dc.fin.format("yyyy-MM-dd")

                events.add(event)
            }
        }
        def json = new JsonBuilder(events)
        render json
    }
}
