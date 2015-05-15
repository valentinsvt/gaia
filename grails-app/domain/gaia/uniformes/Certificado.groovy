package gaia.uniformes

import gaia.estaciones.Estacion

class Certificado {

    Estacion estacion
    String path
    String observaciones
    Date fecha = new Date()

    static auditable = [ignore: []]

    static mapping = {
        table 'crun'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort fecha: "asc"
        columns {
            id column: 'crun__id'
            estacion column: 'estn__id'
            path column: 'crunpath'
            observaciones column: 'crunobsr'
            fecha column: 'crunfcha'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        observaciones(size: 1..255,blank: true,nullable: true)
        path(size: 1..100,nullable: false,blank: false)
    }
}
