package gaia.Contratos.esicc

class Tallas {
    int codigo
    String talla

    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'tallas'
        sort 'talla'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id name: "codigo", generator: 'assigned'
        columns {
            codigo column: 'tal_codigo'
            talla column: 'tal_talla'
        }
    }

    static constraints = {
    }

    String toString(){
        return  "${this.talla}"
    }
}
