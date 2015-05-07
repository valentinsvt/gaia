package gaia.pintura

class ItemImagen {
    String tipoItem
    String descripcion
    Double valor
    String unidad
    String estado
    String tipo
    ItemImagen padre
    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'ITEMS_IMAGEN'
        cache usage: 'read-write', include: 'non-lazy'
        id column:'CODIGO_ITEM'
        id generator: "increment"
        version false
        columns {

            descripcion column: 'DESCRIPCION_ITEM'
            tipoItem column: 'TIPO_ITEM'
            valor column: 'VALOR_ITEM'
            unidad column: 'UNIDAD_ITEM'
            estado column: 'ESTADO_ITEM'
            tipo column: 'TIPO'
            padre  column: 'PADRE_ITEM'
        }
    }
    static constraints = {
        padre(nullable: true)

    }
    String toString(){
        return "${this.descripcion}"
    }


}
