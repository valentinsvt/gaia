package gaia.documentos

class TipoDocumento {

    String nombre

    String tipo /*P--> proceso, N--> no proceso */

    String caduca /*S--> si, N--> no */

    String codigo

    Entidad entidad

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: ['fechaEnvio', 'fechaRecibido']]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'tpdc'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort nombre: "asc"
        columns {
            id column: 'tpdc__id'
            nombre column: 'tpdcnmbr'
            tipo column: 'tpdctipo'
            caduca column: 'tpdccdca'
            codigo column: 'tpdccdgo'
            entidad column: 'enti__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

        nombre(blank: false,nullable: false,size: 1..150)
        tipo(blank: false,nullable: false,size: 1..1,inList: ["P","N"])
        caduca(blank: false,nullable: false,size: 1..1,inList: ["S","N"])
        codigo(blank: false,nullable: false,size: 1..5)
        entidad(blank: true,nullable: true)
    }
}
