package gaia.seguridad

/**
 * Clase para conectar con la tabla 'prms' de la base de datos
 */
class Permiso {
    /**
     * Acción para el permiso
     */
    Accion accion
    /**
     * Perfil para el permiso
     */
    Perfil perfil

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'prms'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'

        columns {
            id column: 'prms__id'
            accion column: 'accn__id'
            perfil column: 'prfl__id'
        }
    }
}
