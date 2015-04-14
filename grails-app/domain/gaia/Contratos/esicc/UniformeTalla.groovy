package gaia.Contratos.esicc

class UniformeTalla implements Serializable{

    int codigo
    Uniforme uniforme
    int estado

    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'uniforme_talla'
        sort 'codigo'
        cache usage: 'read-write', include: 'non-lazy'
        id composite:['codigo', 'uniforme']
        version false
        columns {
            codigo column: 'tal_codigo', insertable: false, updateable: false
            uniforme column: 'uni_codigo'
            estado column: 'ut_estado'
        }
    }

    static constraints = {
    }

    String toString(){
        return "${this.uniforme} ${this.codigo}"
    }
}
