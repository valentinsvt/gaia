package gaia.Contratos.esicc

class PeriodoDotacion {

    int codigo
    String descripcion
    String estado
    Date fecha

    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'periodo_dotacion'
        sort 'descripcion'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id name: "codigo", generator: 'assigned'
        columns {
            codigo column: 'per_codigo'
            descripcion column: 'per_descripcion'
            estado column: 'per_estado'
            fecha column: 'per_fechadotacion'
        }
    }

    static constraints = {
    }

    String toString(){
        return  "${this.descripcion}"
    }
}
