package gaia.erp

class ClienteErp {

    String codigo
    Integer aplicacion
    Integer tipo

    static auditable = true
    static mapping = {
        table 'clientes_erpv1'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'id'
        id generator: 'identity'
        version false
        columns {
            codigo column: 'codigo_cliente'
            aplicacion column: 'codigo_aplicacion'
            tipo column: 'tipo_cliente'
        }
    }
    static constraints = {

    }
}
