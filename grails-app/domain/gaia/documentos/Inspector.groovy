package gaia.documentos

class Inspector {

    String nombre
    String telefono
    String mail
    String codigo

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'insp'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort nombre: "asc"
        columns {
            id column: 'insp__id'
            nombre column: 'inspnmbr'
            telefono column: 'insptelf'
            mail column: 'inspmail'
            codigo column: 'inspcdgo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

        nombre(blank: false,nullable: false,size: 1..150)
        telefono(blank: false,nullable: false,size: 1..15)
        mail(blank: false,nullable: false,size: 1..150,email: true)
    }
}
