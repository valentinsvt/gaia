package gaia.documentos

import org.springframework.dao.DataIntegrityViolationException
import gaia.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Observacion
 */
class ObservacionController extends Shield {
    static final sistema="AMBT"
    def showObservacionesDoc_ajax() {
        def doc = Documento.get(params.id)
        def obs = Observacion.findAllByDocumento(doc, [sort: "fecha", order: "desc"])
        return [doc: doc, obs: obs]
    }

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     */
    def save_ajax() {
        def observacionInstance = new Observacion()
        if (params.id) {
            observacionInstance = Observacion.get(params.id)
            if (!observacionInstance) {
                render "ERROR*No se encontró Observacion."
                return
            }
        }
        params.persona = session.usuario
        observacionInstance.properties = params
        if (!observacionInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Observacion: " + renderErrors(bean: observacionInstance)
            return
        }
        def html = ""
        Observacion.findAllByDocumento(observacionInstance.documento, [sort: "fecha", order: "desc"]).each { o ->
            html += '<div class="panel panel-info">'
            html += '<div class="panel-heading">'
            html += '<h3 class="panel-title">' + o.persona.nombre + ' <small>' + o.fecha.format("dd-MM-yyyy HH:mm") + '</small></h3>'
            html += '</div>'
            html += '<div class="panel-body">'
            html += o.observacion
            html += '</div>'
            html += '</div>'
        }
        render html
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     */
    def delete_ajax() {
        if (params.id) {
            def observacionInstance = Observacion.get(params.id)
            if (!observacionInstance) {
                render "ERROR*No se encontró Observacion."
                return
            }
            try {
                observacionInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Observacion exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Observacion"
                return
            }
        } else {
            render "ERROR*No se encontró Observacion."
            return
        }
    } //delete para eliminar via ajax

}
