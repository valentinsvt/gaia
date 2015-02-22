package gaia.documentos

import gaia.estaciones.Estacion

class Proceso {

    TipoDocumento tipo
    Estacion estacion
    Date inicio
    Date fin /*nullable blank*/
    String completado = "N" /*S--> si N--> no*/
    Documento documento /*nullable blank*/
    Consultor consultor
/**
 * Define el mapeo entre los campos del dominio y las columnas de la base de datos
 */
    static mapping = {
        table 'prco'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'prco__id'
            tipo column: 'tpdc__id'
            estacion column: 'stcn__id'
            inicio column: 'prcofcin'
            fin column: 'prcofcfn'
            documento column: 'prcodcmt'
            completado column: 'prcscmpt'
            consultor column: 'cnst__id'
        }
    }

    static constraints = {
        completado(blank: false,nullable: false,size: 1..1)
        fin(nullable: true,blank:true)
        inicio(blank: false,nullable: false)
        documento(nullable: true,blank:true)
        consultor(nullable: true,blank:true)
    }
}
