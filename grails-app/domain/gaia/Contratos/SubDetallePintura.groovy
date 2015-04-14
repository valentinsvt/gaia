package gaia.Contratos

class SubDetallePintura  implements Serializable{

    Integer secuencial
    String cliente
    ItemImagen item
    Double cantidad
    Double unitario
    Double total

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'SUBDETALLE_PINTURA'
        cache usage: 'read-write', include: 'non-lazy'
        id composite:['secuencial', 'cliente','item']
        version false
        columns {
            secuencial column: 'SECUENCIAL_PINTURA'
            cliente column: 'CODIGO_CLIENTE'
            item column: 'CODIGO_ITEM'
            cantidad column: 'CANTIDAD'
            unitario column: 'VALOR_UNITARIO'
            total column: 'VALOR_TOTAL'
        }
    }
    static constraints = {

    }

    String toString(){
        return "${item} ${cantidad} ${unitario} ${total}"
    }

}
