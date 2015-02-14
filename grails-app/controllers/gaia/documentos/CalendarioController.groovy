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
        /*
        PARAMS
            start:2015-02-01
            end:2015-03-15
        ************************
            start:2015-03-01
            end:2015-04-12

                id                  Optional    Uniquely identifies the given event. Different instances of repeating events should all have the same id.
                title               Required    The text on an event's element
                allDay              Optional    Whether an event occurs at a specific time-of-day.
                start               Required    The date/time an event begins.
                end                 Optional    The exclusive date/time an event ends
                url                 Optional    A URL that will be visited when this event is clicked by the user.
                className           Optional    A CSS class (or array of classes) that will be attached to this event's element.
                color                           Sets an event's background and border color just like the calendar-wide eventColor option.
                backgroundColor                 Sets an event's background color just like the calendar-wide eventBackgroundColor option.
                borderColor                     Sets an event's border color just like the the calendar-wide eventBorderColor option.
                textColor                       Sets an event's text color just like the calendar-wide eventTextColor option.
         */
        def fechaIni = new Date().parse("yyyy-MM-dd", params.start)
        def fechaFin = new Date().parse("yyyy-MM-dd", params.end)

        def docsCreados = Documento.findAllByFechaRegistroBetween(fechaIni, fechaFin)

        def events = []

        docsCreados.each { dc ->
            def des = dc.descripcion
            if (des.size() > 22) {
                des = des[0..22] + "…"
            }
            def event = [:]
            event.id = dc.id
            event.title = "<strong>" + dc.estacion.nombre + "</strong><br/>" + des
            event.descripcion = dc.descripcion
            event.allDay = true
            event.start = dc.fechaRegistro.format("yyyy-MM-dd")

            events.add(event)
        }
        def json = new JsonBuilder(events)
        render json
    }

    def documentosPorCaducarGeneral_ajax() {
        def fechaIni = new Date().parse("yyyy-MM-dd", params.start)
        def fechaFin = new Date().parse("yyyy-MM-dd", params.end)

        def docsPorCaducar = Documento.findAllByFinBetween(fechaIni, fechaFin)

        def events = []

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
        def json = new JsonBuilder(events)
        render json
    }
}
