package gaia.documentos

class Dependencia {

    String nombre
    String codigo


    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: ['fechaEnvio', 'fechaRecibido']]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'dpnd'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort nombre: "asc"
        columns {
            id column: 'dpnd__id'
            nombre column: 'dpndnmbr'
            codigo column: 'dpndcdgo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

        nombre(blank: false,nullable: false,size: 1..150)
        codigo(blank: false,nullable: false,size: 1..5)
    }
}
