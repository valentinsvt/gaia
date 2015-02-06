import gaia.seguridad.Modulo
import gaia.seguridad.Persona
import gaia.seguridad.Perfil
import gaia.seguridad.Sesion
import gaia.seguridad.TipoAccion

class BootStrap {

    def init = { servletContext ->

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


            if(Sesion.count()==0){


                def sesion = new Sesion()
                sesion.usuario = Persona.findByLogin("admin")
                sesion.perfil = perfil
                if (sesion.save(flush: true)) {
                    println "Creada la sesion para admin"
                } else {
                    println "error al crear la sesion para admin: " + sesion.errors
                }
            }



    }
    def destroy = {
    }
}
