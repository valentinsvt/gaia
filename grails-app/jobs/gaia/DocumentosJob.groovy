package gaia

import gaia.alertas.Alerta
import gaia.alertas.UsuarioAlerta
import gaia.documentos.Documento

import javax.print.Doc


class DocumentosJob {
    static triggers = {
        simple name: 'documentosJob', startDelay: 1000*50, repeatInterval: 1000*60*60*7
        //simple name: 'mySimpleTrigger', startDelay: 60000, repeatInterval: 1000
    }

    def execute() {
        // execute job
        println "Ejecución documentosJob "+new Date().format("dd-MM-yyyy HH:mm:ss")
        def now = new Date()
        def fechaFin = new Date().plus(15)
        def docs = Documento.findAllByFinBetween(now,fechaFin)
        def usuarios = UsuarioAlerta.findAllByEstado("A")
        docs.each {d->
            println "doc "+d.referencia
            def alerta = Alerta.findAllByDocumentoAndFechaRecibidoIsNull(d)
            if(alerta.size()==0){
                usuarios.each {u->
                    alerta = new Alerta()
                    alerta.documento=d;
                    alerta.controlador="documento"
                    alerta.accion="ver"
                    alerta.id_remoto=d.id.toInteger()
                    alerta.fechaEnvio=new Date()
                    alerta.persona=u.persona
                    alerta.estacion=d.estacion
                    alerta.mensaje = "El documento: ${d.referencia} de la estación ${d.estacion} está por caducar (${d.fin?.format('dd-MM-yyyy')})."
                    alerta.save(flush: true)
                }
            }
            alerta = new Alerta()
            alerta.documento = d;
            alerta.controlador = "documento"
            alerta.accion = "ver"
            alerta.id_remoto = d.id.toInteger()
            alerta.fechaEnvio = new Date()
            alerta.estacion = d.estacion
            alerta.mensaje = "El documento: ${d.referencia} de la estación ${d.estacion} está por caducar (${d.fin?.format('dd-MM-yyyy')})."
            alerta.save(flush: true)
        }
        println "fin de la ejecución documentosJob "+new Date().format("dd-MM-yyyy HH:mm:ss")
    }
}
