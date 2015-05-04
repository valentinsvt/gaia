package gaia.nomina

class EstadoCivil {

    Integer codigo
    String descripcion


    static mapping = {
        datasource 'nomina'
        table 'ESTADO_CIVIL'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id name: "codigo"
        columns {
            codigo column: 'CODIGO_ESTADO_CIVIL'
            descripcion column: 'DESCRIPCION_ESTADO_CIVIL'
        }
    }

    String toString(){
        return this.descripcion
    }
}
