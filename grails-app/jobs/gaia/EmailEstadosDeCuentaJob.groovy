package gaia

import gaia.financiero.EstadoDeCuenta
import org.codehaus.groovy.grails.web.context.ServletContextHolder
import org.codehaus.groovy.grails.web.servlet.GrailsApplicationAttributes
import org.springframework.context.ApplicationContext


class EmailEstadosDeCuentaJob {
    ApplicationContext applicationContext
    static triggers = {
        simple name: 'emailEstados', startDelay: 1000*60*3, repeatInterval: 1000*60*5
    }


    def execute() {
        println "email job"
        def ctx = ServletContextHolder.servletContext.getAttribute(GrailsApplicationAttributes.APPLICATION_CONTEXT)
        def grailsApplication = ctx.grailsApplication
        def mailService = ctx.mailService
//        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        def estados = EstadoDeCuenta.findAll("from EstadoDeCuenta where path is not null and envio is null and mensaje='Programado para envío' order by registro",[max:15])
        estados.each {e->
            try{
                println "mandando email "+e.id
                def file=grailsApplication.mainContext.getResource(e.path).getFile()
                def parts = e.cliente.email
                if(parts)
                    parts=e.cliente.email.split(",")
                def emails = []
                parts.each {p->
                    if(p!=""){
                        emails.add(p)
                    }
                }
                if(e.copiaEmail){
                    parts=e.copiaEmail.split(",")
                    parts.each {p->
                        if(p!=""){
                            emails.add(p)
                        }

                    }
                }
                def pruebas = ["valentinsvt@hotmail.com"]
//                println "email estacion "+e.cliente.codigo+"  "+emails
                Byte[] pdfData = file.readBytes()
                mailService.sendMail {
                    multipart true
//                    to pruebas
                    to emails
                    subject "Estado de cuenta PyS";
                    attachBytes "Estado-de-cuenta-${e.mes}.pdf", "application/x-pdf", pdfData
                    body( view:"/estadoDeCuenta/estadoDeCuenta")
                    inline 'logo','image/png', new File('./web-app/images/logo-login.png').readBytes()
                }
                e.envio=new Date()
                e.mensaje="Correo enviado"
                e.save(flush: true)
            }catch (ex){
                e.mensaje="Falló el envío: "+ex
                e.envio=null
                e.save(flush: true)
                println "error mail "+ex
            }

        }
    }


}
