package gaia

import gaia.documentos.Dashboard
import gaia.estaciones.Estacion


class DashboardJob {
    static triggers = {
        simple name: 'dashJob', startDelay: 1000*20, repeatInterval: 1000*60*60
        //simple name: 'mySimpleTrigger', startDelay: 60000, repeatInterval: 1000
    }

    def execute() {
        // execute job
        //println "dash job"
        Dashboard.list([sort: "id"]).each {d->
            def cont= 0
            def res = d.estacion.getColorLicencia()
            if(res[0]=="card-bg-green") {
                //println "canbio dash "+d.estacion.nombre+" en dlic"
                d.licencia = 1
                cont++
            }else
                d.licencia=0
            res = d.estacion.getColorAuditoria()
            if(res[0]=="card-bg-green") {
                //println "canbio dash "+d.estacion.nombre+" en audt"
                d.auditoria = 1
                cont++
            }else
                d.auditoria=0
            res = d.estacion.checkDocs()
            if(res) {
                //println "canbio dash "+d.estacion.nombre+" en docs"
                d.docs = 1
                cont++
            } else
                d.docs=0
            res = d.estacion.getColorMonitoreo()
            if(res[0]=="card-bg-green") {
                //println "canbio dash "+d.estacion.nombre+" en mon"
                d.monitoreo = 1
                cont++
            }else
                d.monitoreo=0
            res = d.estacion.getColorControl()
            if(res[0]=="card-bg-green") {
                //println "canbio dash "+d.estacion.nombre+" en mon"
                d.controlAnual = 1
                cont++
            }else
                d.controlAnual=0
            d.save(flush: true)


        }

    }

    def checkEstadoEstacion(Estacion estacion){
        def d = Dashboard.findByEstacion(estacion)
        def cont= 0
        def res = d.estacion.getColorLicencia()
        if(res[0]=="card-bg-green") {
            //println "canbio dash "+d.estacion.nombre+" en dlic"
            d.licencia = 1
            cont++
        }else
            d.licencia=0
        res = d.estacion.getColorAuditoria()
        if(res[0]=="card-bg-green") {
            //println "canbio dash "+d.estacion.nombre+" en audt"
            d.auditoria = 1
            cont++
        }else
            d.auditoria=0
        res = d.estacion.checkDocs()
        if(res) {
            //println "canbio dash "+d.estacion.nombre+" en docs"
            d.docs = 1
            cont++
        } else
            d.docs=0
        res = d.estacion.getColorMonitoreo()
        if(res[0]=="card-bg-green") {
            //println "canbio dash "+d.estacion.nombre+" en mon"
            d.monitoreo = 1
            cont++
        }else
            d.monitoreo=0
        d.save(flush: true)
    }
}
