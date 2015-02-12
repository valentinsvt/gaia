package gaia.documentos

import gaia.seguridad.Persona

class Observacion {

    Documento documento
    String observacion /*type text*/
    Date fecha = new Date()
    Persona persona
    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'obdt'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'obdt__id'
            documento column: 'dcmt__id'
            observacion column: 'obdtobsr'
            observacion type:"text"
            fecha column: 'obdtfcha'

        }
    }
    static constraints = {
        persona(nullable: false,blank:false)
        observacion(nullable: false,blank: false)
    }
}
