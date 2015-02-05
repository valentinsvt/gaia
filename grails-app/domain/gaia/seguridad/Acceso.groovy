package gaia.seguridad

/**
 * Clase para conectar con la tabla 'accs' de la base de datos
 */
class Acceso {
    /**
     * Fecha inicial del acceso
     */
    Date fechaInicial
    /**
     * Fecha final del acceso
     */
    Date fechaFinal
    /**
     * Observaciones
     */
    String observaciones
    /**
     * Usuario para el acceso
     */
    Persona usuario
    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]
    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'accs'
        version false
        id generator: 'identity'

        columns {
            id column: 'accs__id'
            usuario column: 'prsn__id'
            fechaInicial column: 'accsfcin'
            fechaFinal column: 'accsfcfn'
            observaciones column: 'accsobsr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        fechaInicial(blank: false, nullable: false)
        fechaFinal(blank: false, nullable: false)
        observaciones(blank: true, nullable: true)
    }


}
