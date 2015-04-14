package gaia.Contratos

class Item {

    String codigo
    String descripcion

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'ITEM'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "codigo", generator: 'assigned', type:"string"
        version false
        columns {
            codigo column: 'CODIGO_ITEM'
            descripcion column: 'DESCRIPCION_ITEM'
        }
    }
    static constraints = {

    }
    String toString(){
        return "${this.descripcion}"
    }
}
