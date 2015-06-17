package gaia.facturacion

class Producto {

    String codigo
    String nombre

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'PRODUCTO'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "codigo", generator: 'assigned', type:"string"
        version false
        columns {
            codigo column: 'CODIGO_PRODUCTO'
            nombre column: 'NOMBRE_PRODUCTO'
        }
    }
    static constraints = {
        
    }
}
