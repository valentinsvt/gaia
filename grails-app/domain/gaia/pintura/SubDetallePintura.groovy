package gaia.pintura

import gaia.pintura.ItemImagen

class SubDetallePintura  implements Serializable{

    DetallePintura detallePintura
    ItemImagen item
    Double cantidad
    Double unitario
    Double total

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'SUBDETALLE_PINTURA_N'
        cache usage: 'read-write', include: 'non-lazy'
        id column:'ID',sqlType: "int"
        id generator: "increment"
        version false
        columns {
            detallePintura column: 'DETALLE_ID', sqlType: "int"
            item column: "CODIGO_ITEM", sqlType: "int"
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
