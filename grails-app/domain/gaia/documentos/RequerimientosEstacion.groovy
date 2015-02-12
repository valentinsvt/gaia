package gaia.documentos

import gaia.estaciones.Estacion

class RequerimientosEstacion {

    TipoDocumento tipo
    Estacion estacion

/**
 * Define los campos que se van a ignorar al momento de hacer logs
 */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'rqrm'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'rqrm__id'
            tipo column: 'tpdc__id'
            estacion column: 'estn__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

    }
}
