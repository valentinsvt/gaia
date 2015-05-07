package gaia.pintura

import org.springframework.dao.DataIntegrityViolationException
import gaia.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de ItemImagen
 */
class ItemImagenController extends Shield {

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
            def c = ItemImagen.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                    ilike("estado", "%" + params.search + "%")
                    ilike("tipo", "%" + params.search + "%")
                    ilike("tipoItem", "%" + params.search + "%")
                    ilike("unidad", "%" + params.search + "%")
                }
            }
        } else {
            list = ItemImagen.list(params)
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
        def itemImagenInstanceList = getList(params, false)
        def itemImagenInstanceCount = getList(params, true).size()
        return [itemImagenInstanceList: itemImagenInstanceList, itemImagenInstanceCount: itemImagenInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     */
    def show_ajax() {
        if (params.id) {
            def itemImagenInstance = ItemImagen.get(params.id)
            if (!itemImagenInstance) {
                render "ERROR*No se encontró ItemImagen."
                return
            }
            return [itemImagenInstance: itemImagenInstance]
        } else {
            render "ERROR*No se encontró ItemImagen."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     */
    def form_ajax() {
        def itemImagenInstance = new ItemImagen()
        if (params.id) {
            itemImagenInstance = ItemImagen.get(params.id)
            if (!itemImagenInstance) {
                render "ERROR*No se encontró ItemImagen."
                return
            }
        }
        itemImagenInstance.properties = params
        return [itemImagenInstance: itemImagenInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     */
    def save_ajax() {
        def itemImagenInstance = new ItemImagen()
        if (params.id) {
            itemImagenInstance = ItemImagen.get(params.id)
            if (!itemImagenInstance) {
                render "ERROR*No se encontró ItemImagen."
                return
            }
        }
        itemImagenInstance.properties = params
        if (!itemImagenInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar ItemImagen: " + renderErrors(bean: itemImagenInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de ItemImagen exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     */
    def delete_ajax() {
        if (params.id) {
            def itemImagenInstance = ItemImagen.get(params.id)
            if (!itemImagenInstance) {
                render "ERROR*No se encontró ItemImagen."
                return
            }
            try {
                itemImagenInstance.delete(flush: true)
                render "SUCCESS*Eliminación de ItemImagen exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar ItemImagen"
                return
            }
        } else {
            render "ERROR*No se encontró ItemImagen."
            return
        }
    } //delete para eliminar via ajax

    def vistaOrdenada(){
        def items = ItemImagen.findAllByPadreIsNull()
        [items:items,estacion: estacion]
    }


}
