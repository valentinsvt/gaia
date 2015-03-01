package gaia.seguridad

import gaia.alertas.Alerta
import gaia.documentos.Dashboard
import gaia.documentos.Documento
import gaia.estaciones.Estacion

class InicioController extends Shield {

    def index() {

        if(session.tipo=="cliente") {
            redirect(controller: "estacion", action: "showEstacion")
        }else{
            def alertas = Alerta.findAllByPersonaAndFechaRecibidoIsNull(session.usuario).size()
            //alertas+= Alerta.findAllByPersonaIsNullAndEstacionIsNull().size()
            def now = new Date()
            def nextMonth = now.plus(30)
            def documentos = Documento.findAllByFinBetween(now,nextMonth)
            def licencia = 0
            def auditoria = 0
            def docs = 0
            def monitoreo = 0
            def ok = 0
            def tot = 0
            def colores = ["card-bg-green","svt-bg-warning","svt-bg-danger"]
            Dashboard.list([sort: "id"]).each {
                if(it.licencia==1)
                    licencia++
                if(it.auditoria==1)
                    auditoria++
                if(it.docs==1)
                    docs++
                if(it.monitoreo==1)
                    monitoreo++
                if(it.licencia==1 && auditoria==1 && docs==1 && monitoreo==1)
                    ok++
                tot++
            }

            def colorLicencia = 0
            def colorDocs = 0
            def colorAuditoria = 0
            def colorMonitoreo = 0
            def colorOk
            def porcentaje = (licencia*100)/tot
           // println "% lic "+licencia+" tot "+tot+"  % "+porcentaje
            if(porcentaje>80)
                colorLicencia=0
            if(porcentaje>40 &&  porcentaje<80)
                colorLicencia=1
            if(porcentaje<40)
                colorLicencia=2
            porcentaje = auditoria*100/tot
            if(porcentaje>80)
                colorAuditoria=0
            if(porcentaje>40 &&  porcentaje<80)
                colorAuditoria=1
            if(porcentaje<40)
                colorAuditoria=2
            porcentaje = docs*100/tot
            if(porcentaje>80)
                colorDocs=0
            if(porcentaje>40 &&  porcentaje<80)
                colorDocs=1
            if(porcentaje<40)
                colorDocs=2
            porcentaje = ok*100/tot
            if(porcentaje>80)
                colorOk=0
            if(porcentaje>40 &&  porcentaje<80)
                colorOk=1
            if(porcentaje<40)
                colorOk=2
            porcentaje = monitoreo*100/tot
            if(porcentaje>80)
                colorMonitoreo=0
            if(porcentaje>40 &&  porcentaje<80)
                colorMonitoreo=1
            if(porcentaje<40)
                colorMonitoreo=2

            [ok:ok,licencia:licencia,auditoria:auditoria,docs:docs,tot:tot,colorLicencia:colorLicencia,
             colorAuditoria:colorAuditoria,colorDocs:colorDocs,colores:colores,alertas:alertas,colorOk:colorOk,
             documentos:documentos,monitoreo:monitoreo,colorMonitoreo:colorMonitoreo]
        }
    }

    def demoUI() {

    }

    def parametros() {

    }
}


