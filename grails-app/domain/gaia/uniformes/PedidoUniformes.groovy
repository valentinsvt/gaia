package gaia.uniformes

import gaia.Contratos.esicc.PeriodoDotacion
import gaia.documentos.Inspector
import gaia.estaciones.Estacion

class PedidoUniformes {

    PeriodoDotacion periodo
    Estacion estacion
    Inspector supervisor
    Date registro = new Date()
    String estado="S" /*S-> solicitado A-> aprobado*/


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

        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        estado(size: 1..1)
    }
}
