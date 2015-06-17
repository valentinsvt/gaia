package gaia.facturacion

import gaia.Contratos.Cliente

class Factura {

    String numero
    Cliente cliente
    String condicion
    Date fecha
    Date fechaVencimiento
    Integer tipoCliente
    Integer tipoVenta
    Integer plazo
    Double volumen
    Double pago
    Producto producto
    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'FACTURA'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "numero", generator: 'assigned', type:"string"
        version false
        columns {
            numero column: 'NUMERO_FACTURA'
            cliente column: 'CODIGO_CLIENTE'
            condicion column: 'CODIGO_CONDICION'
            fecha column: 'FECHA_VENTA'
            fechaVencimiento column: 'FECHA_VENCIMIENTO'
            tipoCliente column: 'TIPO_CLIENTE'
            tipoVenta column: 'TIPO_VENTA'
            plazo column: 'PLAZO_VENTA'
            volumen column: 'VOLUMEN_VENTA'
            pago column: 'PAGO_FACTURA'
            producto column: 'CODIGO_PRODUCTO'
        }
    }
    static constraints = {
    }
}
