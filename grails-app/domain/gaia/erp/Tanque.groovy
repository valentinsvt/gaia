package gaia.erp

class Tanque {

    ClienteErp cliente
    String codigo
    String descripcion
    Integer capacidad


    static auditable = true
    static mapping = {
        table 'tanques_erpv1'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'id'
        id generator: 'identity'
        version false
        columns {
            cliente column: 'id_cliente'
            codigo column: 'tan_codigo'
            descripcion column: 'tan_descripcion'
            capacidad column: 'tan_capacidad'
        }
    }
    static constraints = {

    }
    String toString(){
        return "${codigo}"
    }
}
