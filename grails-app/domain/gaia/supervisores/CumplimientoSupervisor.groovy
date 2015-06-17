package gaia.supervisores

import gaia.documentos.Inspector

class CumplimientoSupervisor {

    Inspector supervisor
    Date fecha
    String observaciones
    ObjetivoSupervisores objetivo
    String path
    String mes
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'cmsp'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'cmsp__id'
            supervisor column: 'insp__id'
            fecha column: 'cmspfcha'
            observaciones column: 'cmspobsr'
            objetivo column: 'obsp__id'
            path column: 'cmsppath'
            mes column: 'cmsp_mes'
        }
    }

    static constraints = {
        observaciones(size: 1..200,nullable: true,blank: true)
        path(size: 1..100,nullable: true,blank: true)
        mes(size: 1..10,nullable: true,blank: true)
    }

}
