package gaia.parametros

import org.springframework.dao.DataIntegrityViolationException
import gaia.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de ProgramacionDotacion
 */
class ProgramacionDotacionController extends Shield {

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
            def c = ProgramacionDotacion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                }
            }
        } else {
            list = ProgramacionDotacion.list(params)
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
        def programacionDotacionInstanceList = getList(params, false)
        def programacionDotacionInstanceCount = getList(params, true).size()
        return [programacionDotacionInstanceList: programacionDotacionInstanceList, programacionDotacionInstanceCount: programacionDotacionInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     */
    def show_ajax() {
        if (params.id) {
            def programacionDotacionInstance = ProgramacionDotacion.get(params.id)
            if (!programacionDotacionInstance) {
                render "ERROR*No se encontró ProgramacionDotacion."
                return
            }
            return [programacionDotacionInstance: programacionDotacionInstance]
        } else {
            render "ERROR*No se encontró ProgramacionDotacion."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     */
    def form_ajax() {
        def programacionDotacionInstance = new ProgramacionDotacion()
        if (params.id) {
            programacionDotacionInstance = ProgramacionDotacion.get(params.id)
            if (!programacionDotacionInstance) {
                render "ERROR*No se encontró ProgramacionDotacion."
                return
            }
        }
        programacionDotacionInstance.properties = params
        return [programacionDotacionInstance: programacionDotacionInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     */
    def save_ajax() {
        def programacionDotacionInstance = new ProgramacionDotacion()
        if (params.id) {
            programacionDotacionInstance = ProgramacionDotacion.get(params.id)
            if (!programacionDotacionInstance) {
                render "ERROR*No se encontró ProgramacionDotacion."
                return
            }
        }
        programacionDotacionInstance.properties = params
        if (!programacionDotacionInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar ProgramacionDotacion: " + renderErrors(bean: programacionDotacionInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de ProgramacionDotacion exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     */
    def delete_ajax() {
        if (params.id) {
            def programacionDotacionInstance = ProgramacionDotacion.get(params.id)
            if (!programacionDotacionInstance) {
                render "ERROR*No se encontró ProgramacionDotacion."
                return
            }
            try {
                programacionDotacionInstance.delete(flush: true)
                render "SUCCESS*Eliminación de ProgramacionDotacion exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar ProgramacionDotacion"
                return
            }
        } else {
            render "ERROR*No se encontró ProgramacionDotacion."
            return
        }
    } //delete para eliminar via ajax

}
