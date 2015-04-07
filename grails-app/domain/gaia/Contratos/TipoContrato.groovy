package gaia.Contratos

class TipoContrato {

    String descripcion

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'TIPO_CONTRATO'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'CODIGO_TIPO_CONTRATO'
        id generator: 'identity'
        version false
        columns {
            descripcion column: 'DESCRIPCION'
        }
    }
    static constraints = {

    }
}
