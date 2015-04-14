package gaia.Contratos

class DetalleEgreso implements Serializable{

    Egreso egreso
    Item item
    Double cantidad
    Double valorUnitario
    Double valorTotal

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'DETALLE_EGRESO'
        cache usage: 'read-write', include: 'non-lazy'
        id composite:['egreso', 'item']
        version false
        columns {
            egreso column: 'NUMERO_EGRESO'
            item column: 'CODIGO_ITEM'
            cantidad column: 'CANTIDAD'
            valorUnitario column: 'VALOR_UNITARIO'
            valorTotal column: 'VALOR_TOTAL_ITEM'
        }
    }
    static constraints = {

    }

    String toString(){
        return "${this.egreso} - ${this.item}"
    }
}
