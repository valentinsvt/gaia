package gaia.documentos

import gaia.seguridad.Shield
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
}
