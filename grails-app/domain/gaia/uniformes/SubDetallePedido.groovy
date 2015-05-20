package gaia.uniformes

import gaia.Contratos.esicc.Tallas
import gaia.Contratos.esicc.Uniforme
import gaia.estaciones.Estacion

class SubDetallePedido {

    PedidoUniformes pedido
    Estacion estacion
    NominaEstacion empleado
    Uniforme uniforme
    Integer cantidad
    Tallas talla
    Double precio = 0
    Date fecha = new Date()

    static mapping = {
        table 'sbpd'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'sbpd__id'
            pedido column: 'pdun__id'
            empleado column: 'nmes__id'
            estacion column: 'estn__id'
            uniforme column: 'unfr__id'
            cantidad column: 'sbpdcnta'
            talla column: 'talla__id'
            precio column: 'sbpdprco'
            fecha column: 'sbpdfcha'
        }
    }


    static constraints = {
    }
}
