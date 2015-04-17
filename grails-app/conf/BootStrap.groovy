import gaia.documentos.Dashboard
import gaia.estaciones.Estacion
import gaia.seguridad.Modulo
import gaia.seguridad.Persona
import gaia.seguridad.Perfil
import gaia.seguridad.Sesion
import gaia.seguridad.TipoAccion
import org.codehaus.groovy.grails.commons.ApplicationAttributes

class BootStrap {

    def init = { servletContext ->

        def ctx=servletContext.getAttribute(
                ApplicationAttributes.APPLICATION_CONTEXT)
        def dataSource = ctx.dataSourceUnproxied
//        println "datasource "+dataSource

        dataSource.setMinEvictableIdleTimeMillis(1000 * 60 * 10)
        dataSource.setTimeBetweenEvictionRunsMillis(1000 * 60 * 10)
        dataSource.setNumTestsPerEvictionRun(3)

        dataSource.setTestOnBorrow(true)
        dataSource.setTestWhileIdle(false)
        dataSource.setTestOnReturn(true)
        dataSource.setValidationQuery("SELECT 1")
        println "propiedades ----------------------------- "
        dataSource.properties.each { println it }

        if (Modulo.count() == 0) {
            def noAsignado = new Modulo()
            noAsignado.nombre = "noAsignado"
            noAsignado.descripcion = "Módulo por defecto"
            noAsignado.orden = 9999
            if (noAsignado.save(flush: true)) {
                println "Creado modulo noAsignado"
            } else {
                println "error al crear modulo noAsignado: " + noAsignado.errors
            }
        }

        if (TipoAccion.count() == 0) {
            def menu = new TipoAccion()
            menu.codigo = "M"
            menu.tipo = "Menú"
            if (menu.save(flush: true)) {
                println "Creado tipo de acción Menú"
            } else {
                println "error al crear tipo de acción menú: " + menu.errors
            }
            def proceso = new TipoAccion()
            proceso.codigo = "P"
            proceso.tipo = "Proceso"
            if (proceso.save(flush: true)) {
                println "Creado tipo de acción Proceso"
            } else {
                println "error al crear tipo de acción Proceso: " + proceso.errors
            }
        }

        if(Dashboard.count()==0){
            Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1").each {
                def dash = new Dashboard()
                dash.estacion=it
                dash.save(flush: true)
            }
        }






    }
    def destroy = {
    }
}
