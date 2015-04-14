package gaia.Contratos

class Egreso implements Serializable {

    String numero
    String cliente
    Date fecha
    Double subTotal
    Double impuesto
    Double total
    String comentarios
    String tipo
    String beneficiario

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'EGRESO'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "numero", generator: 'assigned', type:"string"
        version false
        columns {
            numero  column: 'NUMERO_EGRESO', insertable: false, updateable: false
            cliente column: 'CODIGO_CLIENTE'
            fecha  column: 'FECHA_EGRESO'
            subTotal column: 'SUBTOTAL'
            impuesto column: 'IMPUESTO_GLOBAL'
            total column: 'VALOR_TOTAL'
            comentarios column: 'COMENTARIOS'
            tipo column: 'TIPO_EGRESO'
            beneficiario column: 'CODIGO_BENEFICIARIO'
        }
    }
    static constraints = {

    }

    String toString(){
        return "${this.numero} - Fecha: ${fecha.format('dd-MM-yyyy')}"
    }
}
