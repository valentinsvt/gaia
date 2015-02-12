package gaia.documentos

import gaia.estaciones.Estacion
import org.springframework.dao.DataIntegrityViolationException
import gaia.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Consultor
 */
class ConsultorController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    def listEstacion_ajax() {
        def estacion = Estacion.findByCodigo(params.codigo)
        def consultores = ConsultorEstacion.findAllByEstacion(estacion)
        return [estacion: estacion, consultores: consultores]
    }

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     */
    def delete_ajax() {
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
        def estacion = Estacion.findByCodigo(params.codigo)
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
