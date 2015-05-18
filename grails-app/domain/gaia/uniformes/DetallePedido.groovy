package gaia.uniformes


class DetallePedido {

    PedidoUniformes pedido
    NominaEstacion empleado
    Kit kit

    static mapping = {
        table 'dtpd'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'dtpd__id'
            pedido column: 'pdun__id'
            empleado column: 'nmes__id'
            kit column: 'kit__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

    }
}
