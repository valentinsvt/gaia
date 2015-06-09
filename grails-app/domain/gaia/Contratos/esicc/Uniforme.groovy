package gaia.Contratos.esicc

class Uniforme {

    int codigo
    String descripcion
    String tipo
    Integer cantidad
    Integer estado
    Double precio

    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'uniforme'
        sort 'descripcion'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id name: "codigo", generator: 'assigned'
        columns {
            codigo column: 'uni_codigo'
            descripcion column: 'uni_descripcion'
            tipo column: 'uni_tipo'
            cantidad column: 'uni_cantidad'
            estado column: 'uni_estado'
            precio column: 'uni_precio'
        }
    }

    static constraints = {
    }

    String toString(){
        return  "${this.descripcion}"
    }

    String toStringCorto(){
        def parts = this.descripcion.split(" ")
        if(parts.size()<=2)
            return this.descripcion
        else{
            def nombre =""
            nombre=parts[0].substring(0,3)+". "
            nombre+=parts[1].substring(0,3)+". "
            nombre+=parts[2].substring(0,3)+". "
            nombre+=this.tipo
            return nombre
        }
    }
}
