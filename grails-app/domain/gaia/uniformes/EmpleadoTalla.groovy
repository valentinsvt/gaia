package gaia.uniformes

import gaia.Contratos.esicc.Tallas
import gaia.Contratos.esicc.Uniforme

class EmpleadoTalla {

    NominaEstacion empleado
    Uniforme uniforme
    Tallas talla

    static mapping = {
        table 'netl'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'netl__id'
            empleado column: 'nmes__id'
            uniforme column: 'unfr__id'
            talla column: 'tlla_id'

        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
            talla(nullable: true,blank:true)
    }
}
