package gaia

import gaia.financiero.EstadoDeCuenta
import gaia.financiero.EstadoDeCuentaController
import grails.util.GrailsWebUtil
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
        GrailsWebUtil.bindMockWebRequest(ctx)
        def grailsApplication = ctx.grailsApplication
        def mailService = ctx.mailService
        String nameController = "estadoDeCuenta"
        def artefact = grailsApplication.getArtefactByLogicalPropertyName("Controller", nameController)
        def controller = ctx.getBean(artefact.clazz.name)

        //println "bean "+controller
        def estados = EstadoDeCuenta.findAll("from EstadoDeCuenta where path is not null and envio is null and mensaje='Programado para envío' and intentos<4 order by registro ",[max:15])
        estados.each {e->
            println "email "+e.id+"  "+e.cliente.codigo
            e.intentos++
            controller.funcionEnviar(e)
        }
    }




}
