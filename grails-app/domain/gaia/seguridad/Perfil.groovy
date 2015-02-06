package gaia.seguridad

/**
 * Clase para conectar con la tabla 'prfl' de la base de datos
 */
class Perfil {

    /**
     * Descripción del perfil
     */
    String descripcion

    /**
     * Código del perfil
     */
    String codigo

    int estado = 0

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define las relaciones uno a varios
     */
    static hasMany = [permisos: Permiso, perfiles: Perfil]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'perfil'
        sort 'descripcion'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "codigo", generator: 'assigned', type:"string"
        version false
        columns {
            codigo column: 'codigo_perfil', insertable: false, updateable: false
            estado column: 'estado_perfil'
            descripcion column: 'nombre_perfil'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return "${this.descripcion}"
    }
}
