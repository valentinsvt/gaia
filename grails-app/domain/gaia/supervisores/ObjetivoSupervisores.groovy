package gaia.supervisores

class ObjetivoSupervisores {

    String descripcion
    String codigo
    String nombre
    String meta
    String objetivo
    String periocidad

    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'obsp'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort objetivo: "asc"
        columns {
            id column: 'obsp__id'
            objetivo column: 'obspobjt'
            descripcion column: 'obspdscr'
            meta column: 'obspmeta'
            codigo column: 'obspcdgo'
            nombre column: 'obspnmbr'
            periocidad column: 'obspprcd'

        }
    }
    static  constraints = {
        objetivo(size: 1..200)
        descripcion(size: 1..200)
        meta(size: 1..200,nullable: true,blank: true)
        nombre(size: 1..50,nullable: true,blank: true)
        periocidad(size: 1..1,nullable: true,blank: true)
        codigo(size: 1..4,nullable: true,blank: true)
    }
}
