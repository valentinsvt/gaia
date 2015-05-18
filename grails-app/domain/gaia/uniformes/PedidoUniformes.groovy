package gaia.uniformes

import gaia.Contratos.esicc.PeriodoDotacion
import gaia.documentos.Inspector
import gaia.estaciones.Estacion

class PedidoUniformes {

    PeriodoDotacion periodo
    Estacion estacion
    Inspector supervisor
    String observaciones
    Date registro = new Date()
    String estado="P" /*P-> pendiente de envio  S-> solicitado y esperando aprobacion  A-> aprobado    N-> negado*/


    static mapping = {
        table 'pdun'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort fecha: "asc"
        columns {
            id column: 'pdun__id'
            estacion column: 'estn__id'
            periodo column: 'prdo__id'
            supervisor column: 'insp__id'
            registro column: 'pdunfcha'
            estado column: 'pdunetdo'
            observaciones column: 'pdunobsr'

        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        estado(size: 1..1)
        observaciones(size: 1..255,blank: true,nullable: true)
    }
}
