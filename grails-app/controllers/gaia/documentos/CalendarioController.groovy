package gaia.documentos

import gaia.estaciones.Estacion
import gaia.seguridad.Shield
import groovy.json.JsonBuilder
import groovy.time.TimeCategory

class CalendarioController extends Shield {
    static final sistema="AMBT"
    def calendarioGeneral() {
        def mes = new Date().format("MM")
        def anio = new Date().format("yyyy")
        if (params.mes) {
            mes = params.mes
        }
        def fecha = "${anio}-${mes}-01"
        return [mes: mes, fecha: fecha]
    }

    def findDocumentos(params) {
        def fechaIni, fechaFin, docs
        def events = []

        def est = null
        if (params.est && params.est != "") {
            est = Estacion.findByCodigo(params.est)
        }

        def tipoDoc = null
        if (params.td && params.td != "") {
            tipoDoc = TipoDocumento.get(params.td)
        }

        switch (params.tipo) {
            case "creado":
                fechaIni = new Date().parse("yyyy-MM-dd HH:mm", params.start + " 00:00")
                fechaFin = new Date().parse("yyyy-MM-dd HH:mm", params.end + " 23:59")
                break;
            case "porCaducar":
                fechaIni = new Date().parse("yyyy-MM-dd HH:mm", (new Date() + 1).format("yyyy-MM-dd") + " 23:59")
                fechaFin = new Date().parse("yyyy-MM-dd", params.end)
                break;
            case 'caducado':
                fechaIni = new Date().parse("yyyy-MM-dd HH:mm", params.start + " 00:00")
                fechaFin = new Date().parse("yyyy-MM-dd HH:mm", (new Date()).format("yyyy-MM-dd") + " 23:59")
                break;
        }
        docs = Documento.withCriteria {
            if (est) {
                eq("estacion", est)
            }
            if (tipoDoc) {
                eq("tipo", tipoDoc)
            }
            if (params.tipo == 'creado') {
                between("fechaRegistro", fechaIni, fechaFin)
            } else {
                between("fin", fechaIni, fechaFin)
            }
        }

        if (params.show == "true") {
            docs.each { dc ->
                def des = dc.descripcion
                if (des.size() > 22) {
                    des = des[0..22] + "…"
                }
                des = "<strong>" + dc.estacion.nombre + "</strong><br/>" + des
                if (params.tipo == 'creado' && dc.fin) {
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
                if (params.tipo == 'creado') {
                    event.start = dc.fechaRegistro.format("yyyy-MM-dd")
                } else {
                    event.start = dc.fin.format("yyyy-MM-dd")
                }

                events.add(event)
            }
        }
        def json = new JsonBuilder(events)
        return json
    }

    def documentosCreadosGeneral_ajax() {
        params.tipo = 'creado'
        render findDocumentos(params)
    }

    def documentosPorCaducarGeneral_ajax() {
        params.tipo = 'porCaducar'
        render findDocumentos(params)
    }

    def documentosCaducadosGeneral_ajax() {
        params.tipo = 'caducado'
        render findDocumentos(params)
    }
}
