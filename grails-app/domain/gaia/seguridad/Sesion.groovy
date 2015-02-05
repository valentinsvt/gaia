package gaia.seguridad

/**
 * Clase para conectar con la tabla 'sesn' de la base de datos
 */
class Sesion {
    /**
     * Usuario de la sesión
     */
    Persona usuario
    /**
     * Perfil de la sesión
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
        table 'sesn'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        sort "perfil"
        columns {
            id column: 'sesn__id'
            perfil column: 'prfl__id'
            usuario column: 'prsn__id'
        }
    }

    /**
     * Genera un string para mostrar
     * @return el perfil - login
     */
    String toString() {
        return this.perfil.nombre
    }

}
