package gaia.estaciones

import gaia.DashboardJob
import gaia.DashboardService
import gaia.documentos.ConsultorEstacion
import gaia.documentos.Dashboard
import gaia.documentos.Documento
import gaia.documentos.RequerimientosEstacion
import gaia.documentos.TipoDocumento
import gaia.documentos.Ubicacion
import org.springframework.dao.DataIntegrityViolationException
import gaia.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Estacion
 */
class EstacionController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]
    def dashboardService

    def showEstacion() {

      //  def dj =new  DashboardJob()
      //  dj.execute()

        def estacion
        if (session.tipo == "cliente") {
            estacion = session.usuario
        } else {
            estacion = Estacion.findByCodigoAndAplicacion(params.id, 1)
        }

//        def documentos = Documento.findAllByEstacion(estacion)
        def documentos = Documento.withCriteria {
            eq("estacion", estacion)
            if (params.td) {
                eq("tipo", TipoDocumento.get(params.td))
            }
            if (params.search) {
                or {
                    ilike("descripcion", "%" + params.search.trim() + "%")
                    ilike("referencia", "%" + params.search.trim() + "%")
                }
            }
        }
        def docsN =  Documento.findAllByEstacionAndEstadoNotEqual(estacion,'A',[sort: "fechaRegistro"])?.size()
        [estacion: estacion, documentos: documentos, params: params,docsN:docsN]
    }

    def listaSemaforos() {
        def dash = Dashboard.list([sort: "id"])

        [dash: dash, search: params.search]
    }

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action: "list", params: params)
    }

    def documentosPorAprobar(){
        def estacion  = Estacion.findByCodigoAndAplicacion(params.id, 1)
        def docs = Documento.findAllByEstacionAndEstadoNotEqual(estacion,'A',[sort: "fechaRegistro"])
        [docs:docs,estacion: estacion]
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
            def c = Estacion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("direccion", "%" + params.search + "%")
                    ilike("estado", "%" + params.search + "%")
                    ilike("mail", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("propetario", "%" + params.search + "%")
                    ilike("representante", "%" + params.search + "%")
                    ilike("ruc", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Estacion.list(params)
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
        def estacionInstanceList = getList(params, false)
        def estacionInstanceCount = getList(params, true).size()
        return [estacionInstanceList: estacionInstanceList, estacionInstanceCount: estacionInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     */
    def show_ajax() {

        if (params.id) {
            def estacionInstance = Estacion.findByCodigoAndAplicacion(params.id, 1)
            if (!estacionInstance) {
                render "ERROR*No se encontró Estacion."
                return
            }
            return [estacionInstance: estacionInstance]
        } else {
            render "ERROR*No se encontró Estacion."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     */
    def form_ajax() {
        def estacionInstance = new Estacion()
        if (params.id) {
            estacionInstance = Estacion.get(params.id)
            if (!estacionInstance) {
                render "ERROR*No se encontró Estacion."
                return
            }
        }
        estacionInstance.properties = params
        return [estacionInstance: estacionInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     */
    def save_ajax() {
        def estacionInstance = new Estacion()
        if (params.id) {
            estacionInstance = Estacion.get(params.id)
            if (!estacionInstance) {
                render "ERROR*No se encontró Estacion."
                return
            }
        }
        estacionInstance.properties = params
        if (!estacionInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Estacion: " + renderErrors(bean: estacionInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Estacion exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     */
    def delete_ajax() {
        if (params.id) {
            def estacionInstance = Estacion.get(params.id)
            if (!estacionInstance) {
                render "ERROR*No se encontró Estacion."
                return
            }
            try {
                estacionInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Estacion exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Estacion"
                return
            }
        } else {
            render "ERROR*No se encontró Estacion."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigo_ajax() {
        params.codigo = params.codigo.toString().trim()
        if (params.id) {
            def obj = Estacion.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Estacion.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Estacion.countByCodigoIlike(params.codigo) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad mail
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_mail_ajax() {
        params.mail = params.mail.toString().trim()
        if (params.id) {
            def obj = Estacion.get(params.id)
            if (obj.mail.toLowerCase() == params.mail.toLowerCase()) {
                render true
                return
            } else {
                render Estacion.countByMailIlike(params.mail) == 0
                return
            }
        } else {
            render Estacion.countByMailIlike(params.mail) == 0
            return
        }
    }

    def consultores_ajax() {
        def estacion = Estacion.findByCodigoAndAplicacion(params.codigo, 1)
        return [estacion: estacion]
    }

    def inspectores_ajax() {
        def estacion = Estacion.findByCodigoAndAplicacion(params.codigo, 1)
        return [estacion: estacion]
    }


    def requerimientosEstacion() {
        def estacion = Estacion.findByCodigoAndAplicacion(params.id, 1)
        def reqs = RequerimientosEstacion.findAllByEstacion(estacion)
        def tipos = []
        if(session.tipo=="usuario"){
            TipoDocumento.findAllByTipo("N").each {
                if(!reqs.tipo.id.contains(it.id)){
                    tipos.add(it)
                }
            }
        }

        if (reqs.size() == 0) {
            TipoDocumento.findAllByTipo("N").each {
                def rq = new RequerimientosEstacion()
                rq.estacion = estacion
                rq.tipo = it
                rq.save(flush: true)
                reqs.add(rq)
            }
        }
        [estacion: estacion, reqs: reqs,tipos:tipos]

    }

    def borrarReq() {
        def req = RequerimientosEstacion.get(params.id)
        def estacion = req.estacion
        req.delete(flush: true)
        dashboardService.checkDocumentacion(estacion)
        render "ok"
    }

    def agregarReq(){
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
        def tipo = TipoDocumento.get(params.tipo)
        if(estacion && tipo){
            def req = RequerimientosEstacion.findByEstacionAndTipo(estacion,tipo)
            if(!req){
                req=new RequerimientosEstacion()
                req.estacion=estacion
                req.tipo=tipo
                req.save()
                def dash = Dashboard.findByEstacion(estacion)
                dash.docs=0
                //println "dash "+dash.id
                if(!dash.save(flush: true))
                    println "error save dash "+dash.errors
                render "ok"
            }else{
                render "La estación ya tiene ese tipo de documento"
            }
        }else{
            render "error"
        }

    }
}
