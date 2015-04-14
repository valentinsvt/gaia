package gaia.Contratos.esicc

import gaia.estaciones.Estacion

class Dotacion implements Serializable{

    Estacion estacion
    Pedido pedido
    Uniforme uniforme
    int talla
    Integer cantidadPedida
    Integer cantidadAprobada
    Double precio

    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'dotacion'
        sort 'pedido'
        cache usage: 'read-write', include: 'non-lazy'
        id composite:['estacion','pedido' ,'uniforme','talla']
        version false
        columns {
            estacion column: 'codigo_cliente'
            pedido column: 'ped_codigo'
            uniforme column: 'uni_codigo'
            talla column: 'tal_codigo'
            cantidadPedida column: 'dot_cantpedida'
            cantidadAprobada column: 'dot_cantaprobada'
            precio column: 'dot_precioitem'
        }
    }

    static constraints = {
    }

    String toString(){
        return "${this.uniforme} ${this.toString()} ${this.pedido}"
    }
}
