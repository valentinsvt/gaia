package gaia.documentos

import gaia.estaciones.Estacion

class ConsultorEstacion {

    Consultor consultor
    Estacion estacion

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'cset'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort consultor: "asc"
        columns {
            id column: 'cset__id'
            consultor column: 'cnst__id'
            estacion column: 'estn__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

    }
}
