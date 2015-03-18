package gaia.erp

class Surtidor {

    ClienteErp cliente
    String codigo
    Integer mangueras
    String marca
    String serie
    Integer anio

    static auditable = true
    static mapping = {
        table 'surtidores_erpv1'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'id'
        id generator: 'identity'
        version false
        columns {
            cliente column: 'id_cliente'
            codigo column: 'sur_codigodnh'
            mangueras column: 'sur_numeromangueras'
            marca column: 'mar_marca'
            serie column: 'sur_numeroserie'
            anio column: 'sur_aniofabricacion'
        }
    }
    static constraints = {

    }
    String toString(){
        return "${codigo} (${marca})"
    }
}
