package gaia

import gaia.Contratos.DashBoardContratos
import gaia.documentos.Dashboard
import gaia.estaciones.Estacion


class DashboardUpdateJob {
    static triggers = {
        simple name: 'actualizacionDashboardJob', startDelay: 1000 * 10, repeatInterval: 1000 * 60 * 60*24
    }

    final static descripcion="Proceso que se encarga de actualizar el dashboard de las estaciones que siguen con estado activo en el base de datos de esicc "

    def execute() {
        // execute job
        println "Ejecución actualizacionDashboardJob "+new Date().format("dd-MM-yyyy HH:mm:ss")
        Estacion.findAll("from Estacion where aplicacion = 1 and estado!='A' and tipo=1").each {
            def dash = Dashboard.findByEstacion(it)
            if(dash){
                println "Borrado bashboard de getsion ambiental de ${it} por cambio de estado ${it.estado}"
                dash.delete(flush: true)
            }
            dash = DashBoardContratos.findByEstacion(it)
            if(dash){
                println "Borrado bashboard de contratos de ${it} por cambio de estado ${it.estado}"
                dash.delete(flush: true)
            }
        }
        println "Fin Ejecución actualizacionDashboardJob "+new Date().format("dd-MM-yyyy HH:mm:ss")
    }
}
