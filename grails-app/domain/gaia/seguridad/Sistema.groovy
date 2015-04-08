package gaia.seguridad

class Sistema {
    /**
    * Nombre del sistema
    */
    String nombre
    /**
     * Descripción del sistema
     */
    String descripcion

    /**
     * Código
     */
    String codigo

    /**
     * Imagen
     */
    String imagen

    /**
     * Controlador principal donde se encuentra la acción index del sistema
     */
    Controlador controlador

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'sstm'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'sstm__id'
            nombre column: 'sstmnmbr'
            descripcion column: 'sstmdscr'
            codigo column: 'sstmcdgo'
            imagen column: 'sstmimgn'
            controlador column: 'ctrl__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        nombre(size: 1..128)
        descripcion(size: 1..511)
        codigo(size: 1..4)
        imagen(size: 1..30,nullable: true,blank: true)
        controlador(nullable: true,blank: true)
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        "${this.nombre}"
    }
}
