package gaia.documentos

import gaia.estaciones.Estacion

class Documento {

    TipoDocumento tipo
    Estacion estacion
    Date fechaRegistro = new Date()
    Date inicio
    Date fin /*nullable blank*/
    Documento padre /*nullable blank*/
    String descripcion /*512 caracteres*/
    String path
    String codigo
    String referencia

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'dcmt'
        cache usage: 'read-write', include: 'non-lazy'
        version false

        columns {
            id column: 'dcmt__id'
            tipo column: 'tpdc__id'
            estacion column: 'stcn__id'
            fechaRegistro column: 'dcmtfcrg'
            inicio column: 'dcmtfcin'
            fin column: 'dcmtfcfn'
            padre column: 'dcmtpdre'
            descripcion column: 'dcmtdesc'
            path column: 'dcmtpath'
            codigo column: 'dcmtcdgo'
            referencia column: 'dcmtrefr'
        }
    }
    static constraints = {
        fin(nullable: true,blank:true)
        padre(nullable: true,blank:true)
        descripcion(nullable: false,blank:false,size: 1..512)
        path(nullable: false,blank:false,size: 1..100)
        codigo(nullable: false,blank:false,size: 1..10)
        referencia(nullable: false,blank:false,size: 1..20)

    }
}
