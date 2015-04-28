package gaia.Contratos

class ItemImagen implements Serializable{

    Integer codigo
    String tipoItem
    String descripcion
    Double valor
    String unidad
    String estado
    String tipo

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'ITEMS_IMAGEN'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "codigo", generator: 'assigned', type:"string"
        version false
        columns {
            codigo column: 'CODIGO_ITEM'
            descripcion column: 'DESCRIPCION_ITEM'
            tipoItem column: 'TIPO_ITEM'
            valor column: 'VALOR_ITEM'
            unidad column: 'UNIDAD_ITEM'
            estado column: 'ESTADO_ITEM'
            tipo column: 'TIPO'
        }
    }
    static constraints = {

    }
    String toString(){
        return "${this.descripcion} ${this.valor}"
    }


}
