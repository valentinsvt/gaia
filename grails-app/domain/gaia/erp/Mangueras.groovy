package gaia.erp

class Mangueras {

    Tanque tanque
    Surtidor surtidor
    String codigo

    static auditable = true
    static mapping = {
        table 'mangueras_erpv1'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'id'
        id generator: 'identity'
        version false
        columns {
           surtidor column: 'id_surtidor'
            tanque column: 'id_tanque'
            codigo column: 'man_codigomanguera'

        }
    }
    static constraints = {

    }
    String toString(){
        return "${codigo}"
    }
}
