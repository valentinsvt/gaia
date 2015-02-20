package gaia.documentos

class Consultor {

    String ruc
    String nombre
    String telefono
    String direccion
    String mail
    String calificacionArch
    String pathOae
    String observaciones

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'cnst'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort nombre: "asc"
        columns {
            id column: 'cnst__id'
            ruc column: 'cnst_ruc'
            nombre column: 'cnstnmbr'
            telefono column: 'cnsttelf'
            direccion column: 'cnstdire'
            mail column: 'cnstmail'
            calificacionArch column: 'cnstcalf'
            pathOae column: 'cnstpath'
            observaciones column: 'cnstobsr'
            observaciones type: 'text'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

        nombre(blank: false,nullable: false,size: 1..150)
        ruc(blank: false,nullable: false,size: 1..20)
        telefono(blank: false,nullable: false,size: 1..15)
        direccion(blank: true,nullable: true,size: 1..150)
        mail(blank: false,nullable: false,size: 1..150,email: true)
        observaciones(blank:true,nullable: true)
        calificacionArch(blank:true,nullable: true,size: 1..50)
        pathOae(blank:true,nullable: true,size: 1..100)
    }
}
