package gaia.seguridad

/**
 * Clase para conectar con la tabla 'ctrl' de la base de datos
 */
class Controlador {
    /**
     * Nombre del controlador
     */
    String nombre
    static hasMany = [acciones: Accion]
    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'ctrl'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        sort nombre: "asc"
        columns {
            id column: 'ctrl__id'
            nombre column: 'ctrlnmbr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        nombre(blank: false, size: 0..50)
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        "${this.nombre}"
    }
}
