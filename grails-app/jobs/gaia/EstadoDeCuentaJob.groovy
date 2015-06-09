package gaia

import gaia.financiero.EstadoDeCuenta
import org.codehaus.groovy.grails.web.context.ServletContextHolder as SCH
import org.codehaus.groovy.grails.web.servlet.GrailsApplicationAttributes as GA


class EstadoDeCuentaJob {
    static triggers = {
        simple name: 'estadoDeCuentaJob', startDelay: 1000*2, repeatInterval: 1000*60*3
    }


    def execute() {
        println "estados de cuenta job"
        def ctx = SCH.servletContext.getAttribute(GA.APPLICATION_CONTEXT)
        def estadosDeCuentaService = ctx.estadosDeCuentaService

        def estados = EstadoDeCuenta.findAll("from EstadoDeCuenta where path is null and ultimaEjecucion is null and intentos <4 order by registro",[max:15])
        if(!estados){
            estados = EstadoDeCuenta.findAll("from EstadoDeCuenta where path is null and ultimaEjecucion is not null and intentos <4 order by ultimaEjecucion",[max:15])
        }
        estados.each {
           // println "ejecutando service en "+estadosDeCuentaService
            it.intentos++
            estadosDeCuentaService.generaPdf(it)
        }
    }
}
