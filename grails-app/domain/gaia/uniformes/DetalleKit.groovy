package gaia.uniformes

import gaia.Contratos.esicc.Uniforme

class DetalleKit {
    Kit kit
    Uniforme uniforme
    Integer cantidad = 1

    static mapping = {
        table 'dtkt'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'dtkt__id'
            kit column: 'kit__id'
            uniforme column: 'unfr__id'
            cantidad column:  'dtktcntd'

        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

    }
}
