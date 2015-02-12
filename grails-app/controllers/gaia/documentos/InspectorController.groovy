package gaia.documentos

import gaia.estaciones.Estacion
import org.springframework.dao.DataIntegrityViolationException
import gaia.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Inspector
 */
class InspectorController extends Shield {

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
            def c = Inspector.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("mail", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Inspector.list(params)
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
        def inspectorInstanceList = getList(params, false)
        def inspectorInstanceCount = getList(params, true).size()
        return [inspectorInstanceList: inspectorInstanceList, inspectorInstanceCount: inspectorInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     */
    def show_ajax() {
        if (params.id) {
            def inspectorInstance = Inspector.get(params.id)
            if (!inspectorInstance) {
                render "ERROR*No se encontró Inspector."
                return
            }
            return [inspectorInstance: inspectorInstance]
        } else {
            render "ERROR*No se encontró Inspector."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     */
    def form_ajax() {
        def inspectorInstance = new Inspector()
        if (params.id) {
            inspectorInstance = Inspector.get(params.id)
            if (!inspectorInstance) {
                render "ERROR*No se encontró Inspector."
                return
            }
        }
        inspectorInstance.properties = params
        return [inspectorInstance: inspectorInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     */
    def save_ajax() {
        def inspectorInstance = new Inspector()
        if (params.id) {
            inspectorInstance = Inspector.get(params.id)
            if (!inspectorInstance) {
                render "ERROR*No se encontró Inspector."
                return
            }
        }
        inspectorInstance.properties = params
        if (!inspectorInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Inspector: " + renderErrors(bean: inspectorInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Inspector exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     */
    def delete_ajax() {
        if (params.id) {
            def inspectorInstance = Inspector.get(params.id)
            if (!inspectorInstance) {
                render "ERROR*No se encontró Inspector."
                return
            }
            try {
                inspectorInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Inspector exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Inspector"
                return
            }
        } else {
            render "ERROR*No se encontró Inspector."
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
            def obj = Inspector.get(params.id)
            if (obj.mail.toLowerCase() == params.mail.toLowerCase()) {
                render true
                return
            } else {
                render Inspector.countByMailIlike(params.mail) == 0
                return
            }
        } else {
            render Inspector.countByMailIlike(params.mail) == 0
            return
        }
    }

    def listEstacion_ajax() {
        def estacion = Estacion.findByCodigo(params.codigo)
        def inspectores = InspectorEstacion.findAllByEstacion(estacion)
        return [estacion: estacion, inspectores: inspectores]
    }

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     */
    def deleteInspector_ajax() {
        if (params.id) {
            def inspectorInstance = InspectorEstacion.get(params.id)
            if (!inspectorInstance) {
                render "ERROR*No se encontró Inspector."
                return
            }
            try {
                inspectorInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Inspector exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Inspector"
                return
            }
        } else {
            render "ERROR*No se encontró Inspector."
            return
        }
    } //delete para eliminar via ajax

    def addInspector_ajax() {
        def estacion = Estacion.findByCodigo(params.codigo)
        def inspector = Inspector.get(params.ins)

        def inspectorEstacion = new InspectorEstacion()
        inspectorEstacion.inspector = inspector
        inspectorEstacion.estacion = estacion
        if (inspectorEstacion.save(flush: true)) {
            render "SUCCESS*Inspector agregado"
        } else {
            render "ERROR*" + renderErrors(bean: inspectorEstacion)
        }
    }

}
