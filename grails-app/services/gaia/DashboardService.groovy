package gaia

import gaia.documentos.Dashboard
import gaia.documentos.Detalle
import gaia.documentos.Documento
import gaia.documentos.RequerimientosEstacion
import gaia.estaciones.Estacion
import grails.transaction.Transactional

@Transactional
class DashboardService {

    def checkDash(Documento documento){
        def now = new Date()
        def dash = Dashboard.findByEstacion(documento.estacion)
        switch (documento.tipo.codigo){
            case "TP01":
                //licencia
                if(documento.fin){
                    if(documento.fin>now)
                        dash.licencia=1
                }else{
                    dash.licencia=1
                }
                break;
            case "TP17":
                /*oficio de aprobacion*/
                if(documento.checkAuditoriaAprobada())
                    dash.auditoria=1
                //auditoria
                break;
            case "TP02":
                /*auditoria 1*/
                if(documento.checkAuditoriaAprobada())
                    dash.auditoria=1
                //auditoria
                break;
            case "TP35":
                /*auditoria 2*/
                if(documento.checkAuditoriaAprobada())
                    dash.auditoria=1
                //auditoria
                break;
            case "TP36":
                /*auditoria 3*/
                if(documento.checkAuditoriaAprobada())
                    dash.auditoria=1
                //auditoria
                break;
            case "TP12":
                if(documento.fin){
                    if(documento.fin>now)
                        dash.monitoreo=1
                }else{
                    dash.monitoreo=1
                }
                //monitoreo
                break;
            default:
                def req = RequerimientosEstacion.findAllByEstacion(documento.estacion)
                def cont = 0
                req.each {
                    def doc = it.estacion.getLastDoc(it.tipo)
                    if(doc){
                        if(doc.estado=="A")
                            cont++
                        else{
                            return
                        }
                    }else{
                        return
                    }
                }
                if(cont==req.size()) {
                    dash.docs = 1

                }else
                    dash.docs=0
                break;
        }
        dash.save(flush: true)

    }

    def checkDocumentacion(Estacion estacion){
        def dash = Dashboard.findByEstacion(estacion)
        def req = RequerimientosEstacion.findAllByEstacion(estacion)
        def cont = 0
        req.each {
            def doc = it.estacion.getLastDoc(it.tipo)
            if(doc){
                if(doc.estado=="A")
                    cont++
                else{
                    return
                }
            }else{
                return
            }
        }
        if(cont==req.size()) {
            dash.docs = 1

        }else
            dash.docs=0
       // println "cont "+cont+" "+req.size()+" "+dash.docs
        dash.save()
    }
}
