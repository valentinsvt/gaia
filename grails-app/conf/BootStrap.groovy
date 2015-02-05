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

        if (Persona.count() == 0) {
            def admin = new Persona()

            admin.cedula = "1715068159"
            admin.nombre = "Valentin"
            admin.apellido = "Zapata"
            admin.sexo = "F"
            admin.fechaNacimiento = new Date().parse("dd-MM-yyyy", "23-01-1987")
            admin.mail = "valentinsvt@hotmail.com"
            admin.login = "admin"
            admin.password = "123".encodeAsMD5()
            admin.autorizacion = "456".encodeAsMD5()
            admin.activo = 1
            if (admin.save(flush: true)) {
                println "Creado el admin"
            } else {
                println "error al crear el admin: " + admin.errors
            }

            def perfil = new Perfil()
            perfil.nombre = "Administrador"
            perfil.descripcion = "Perfil de administración"
            perfil.codigo = "ADM"
            if (perfil.save(flush: true)) {
                println "Creado el perfil admin"
            } else {
                println "error al crear el perfil admin: " + perfil.errors
            }

            def sesion = new Sesion()
            sesion.usuario = admin
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
