package gaia.Contratos.esicc

import gaia.estaciones.Estacion

class Pedido {

    String codigo
    String supervisor
    PeriodoDotacion periodo
    Estacion estacion
    Date fecha
    String estado

    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'pedido'
        sort 'codigo'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id name: "codigo", generator: 'assigned'
        columns {
            codigo column: 'ped_codigo'
            periodo column: 'per_codigo'
            supervisor column: 'codigo_supervisor'
            estacion column: 'codigo_cliente'
            fecha column: 'ped_fecha'
            estado column: 'ped_estado'
        }
    }

    static constraints = {
    }

    String toString(){
        return  "${this.codigo}"
    }

    def getTotal(){
        def total = 0
        Dotacion.findAllByPedido(this).each {d->
            def precio = d.precio
            if(!precio)
                precio=0
            total+=d.cantidadAprobada*d.precio
        }
        return total.toDouble().round(2)
    }


}
