package gaia.seguridad

/**
 * Clase para conectar con la tabla 'sesn' de la base de datos
 */
class Sesion implements Serializable {
    /**
     * Usuario de la sesión
     */
    Persona usuario
    /**
     * Perfil de la sesión
     */
    Perfil perfil

    int estado = 0

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'perfil_usuario'
        sort 'usuario'
        cache usage: 'read-write', include: 'non-lazy'
        id composite:['usuario', 'perfil']
        version false
        columns {
            usuario column: 'login_user'
            estado column: 'estado'
            perfil column: 'codigo_perfil'
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
