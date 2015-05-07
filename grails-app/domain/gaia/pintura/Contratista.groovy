package gaia.pintura

class Contratista {

    Integer codigo
    String nombre
    String ruc
    String cedula
    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'CONTRATISTA'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "codigo"
        version false
        columns {
            codigo column: 'CODIGO_CONTRATISTA'
            nombre column: 'NOMBRE_CONTRATISTA'
            ruc column: 'RUC_CONTRATISTA'
            cedula column: 'CEDULA_CONTRATISTA'
        }
    }
    static constraints = {
    }
}
