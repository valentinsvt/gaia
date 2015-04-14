package gaia.Contratos

class DetallePintura  implements Serializable{

    Integer secuencial
    String cliente
    String numeroFactura
    Date fin
    Double subTotal
    Double iva
    Double totalIva
    Double total

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'DETALLE_PINTURA'
        cache usage: 'read-write', include: 'non-lazy'
        id composite:['secuencial', 'cliente']
        version false
        columns {
            secuencial column: 'SECUENCIAL_PINTURA'
            cliente column: 'CODIGO_CLIENTE'
            numeroFactura column: 'NUMERO_FACTURA'
            fin column: 'FECHA_FIN_TRABAJO'
            total column: 'TOTAL_DETALLE'
            subTotal column: 'SUBTOTAL_SUBDETALLE'
            iva column: 'IVA_PINTURA'
            totalIva column: 'TOTAL_IVA_PINTURA'
        }
    }
    static constraints = {

    }

    String toString(){
        return "${this.secuencial} - ${this.cliente} - Fin de trabajo: ${fin.format('dd-MM-yyyy')}"
    }


}
