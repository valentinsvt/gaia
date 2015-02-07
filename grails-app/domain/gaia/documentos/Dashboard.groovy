package gaia.documentos

import gaia.estaciones.Estacion

class Dashboard {

    Estacion estacion
    int licencia = 0
    int auditoria = 0
    int docs = 0

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table: 'dash'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'dash__id'
            estacion column: 'stcn__id'
            licencia column: 'dashlicn'
            auditoria column: 'dashaudt'
            docs column: 'dashdocs'
        }
    }
}
