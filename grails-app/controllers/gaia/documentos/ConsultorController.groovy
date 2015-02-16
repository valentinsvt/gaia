package gaia.documentos

import gaia.estaciones.Estacion
import org.springframework.dao.DataIntegrityViolationException
import gaia.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Consultor
 */
class ConsultorController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action: "list", params: params)
    }

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    def getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if (all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if (params.search) {
            def c = Consultor.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("direccion", "%" + params.search + "%")
                    ilike("mail", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("ruc", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Consultor.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     */
    def list() {
        def consultorInstanceList = getList(params, false)
        def consultorInstanceCount = getList(params, true).size()
        return [consultorInstanceList: consultorInstanceList, consultorInstanceCount: consultorInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     */
    def show_ajax() {
        if (params.id) {
            def consultorInstance = Consultor.get(params.id)
            if (!consultorInstance) {
                render "ERROR*No se encontró Consultor."
                return
            }
            return [consultorInstance: consultorInstance]
        } else {
            render "ERROR*No se encontró Consultor."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     */
    def form_ajax() {
        def consultorInstance = new Consultor()
        if (params.id) {
            consultorInstance = Consultor.get(params.id)
            if (!consultorInstance) {
                render "ERROR*No se encontró Consultor."
                return
            }
        }
        consultorInstance.properties = params
        return [consultorInstance: consultorInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     */
    def save_ajax() {
        def consultorInstance = new Consultor()
        if (params.id) {
            consultorInstance = Consultor.get(params.id)
            if (!consultorInstance) {
                render "ERROR*No se encontró Consultor."
                return
            }
        }
        consultorInstance.properties = params
        if (!consultorInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Consultor: " + renderErrors(bean: consultorInstance)
            return
        }
        def select = g.select(from: Consultor.list([sort: "nombre"]), "class": "form-control input-sm", name: "cons",
                optionKey: "id", optionValue: "nombre", value: consultorInstance.id)
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Consultor exitosa.*" + select
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     */
    def delete_ajax() {
        if (params.id) {
            def consultorInstance = Consultor.get(params.id)
            if (!consultorInstance) {
                render "ERROR*No se encontró Consultor."
                return
            }
            try {
                consultorInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Consultor exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Consultor"
                return
            }
        } else {
            render "ERROR*No se encontró Consultor."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad mail
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_mail_ajax() {
        params.mail = params.mail.toString().trim()
        if (params.id) {
            def obj = Consultor.get(params.id)
            if (obj.mail.toLowerCase() == params.mail.toLowerCase()) {
                render true
                return
            } else {
                render Consultor.countByMailIlike(params.mail) == 0
                return
            }
        } else {
            render Consultor.countByMailIlike(params.mail) == 0
            return
        }
    }

    def listEstacion_ajax() {
        def estacion = Estacion.findByCodigoAndAplicacion(params.codigo,1)
        def consultores = ConsultorEstacion.findAllByEstacion(estacion)
        return [estacion: estacion, consultores: consultores]
    }

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     */
    def deleteConsultor_ajax() {
        if (params.id) {
            def consultorInstance = ConsultorEstacion.get(params.id)
            if (!consultorInstance) {
                render "ERROR*No se encontró Consultor."
                return
            }
            try {
                consultorInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Consultor exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Consultor"
                return
            }
        } else {
            render "ERROR*No se encontró Consultor."
            return
        }
    } //delete para eliminar via ajax

    def addConsultor_ajax() {
        def estacion = Estacion.findByCodigoAndAplicacion(params.codigo,1)
        def consultor = Consultor.get(params.cons)

        def consultorEstacion = new ConsultorEstacion()
        consultorEstacion.consultor = consultor
        consultorEstacion.estacion = estacion
        if (consultorEstacion.save(flush: true)) {
            render "SUCCESS*Consultor agregado"
        } else {
            render "ERROR*" + renderErrors(bean: consultorEstacion)
        }
    }
}
