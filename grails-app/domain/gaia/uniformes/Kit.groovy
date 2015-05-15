package gaia.uniformes

class Kit {

    String nombre
    String estado="A"
    String genero

    static mapping = {
        table 'kit'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort fecha: "asc"
        columns {
            id column: 'kit__id'
            nombre column: 'kit_nmbr'
            estado column: 'kit_etdo'
            genero column: 'kit_gnro'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        nombre(size: 1..100)
        estado(size: 1..1)
        genero(size: 1..1,inList: ["M","F","U"])
    }
}
