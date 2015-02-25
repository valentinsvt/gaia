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
    String estado = "N" /*N--> no aprobado S--> aprobado*/
    Consultor consultor

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
            estado column: 'dcmtetdo'
            consultor column: 'cnst__id'
        }
    }
    static constraints = {
        fin(nullable: true,blank:true)
        padre(nullable: true,blank:true)
        descripcion(nullable: false,blank:false,size: 1..512)
        path(nullable: false,blank:false,size: 1..100)
        codigo(nullable: false,blank:false,size: 1..10)
        referencia(nullable: false,blank:false,size: 1..20)
        consultor(nullable: true,blank:true)
        estado(nullable: true,blank:true)

    }

    def checkAuditoriaAprobada(){
        def now = new Date()
        if(this.tipo.codigo=="TP17"){
            if(this.estado!="A")
                return false
            def detalle = Detalle.findByDocumento(this)
            if(!detalle.proceso)
                return false
            if(!detalle.proceso.documento)
                return false
            if(detalle.proceso.documento.estado!="A")
                return false
            if(detalle.proceso.documento.fin){
                if(detalle.proceso.documento.fin>now){
                    return true
                }else{
                    return false
                }
            }else{
                return true
            }
        }
        if(this.tipo.codigo=="TP02" || this.tipo.codigo=="TP35" || this.tipo.codigo=="TP36"){
            if(this.fin){
                if(this.fin<now)
                    return false
            }
            if(this.estado!="A")
                return false
           def detalle = Detalle.findByDocumento(this)
            if(!detalle)
                return false
            def detalles = Detalle.findAllByProcesoAndPaso(detalle.proceso,2)
            detalles.each {d->
                if(d.documento){
                    if(d.documento.tipo.codigo=="TP17"){
                        if(d.documento.estado=="A"){
                            return true
                        }
                    }
                }
            }

        }

        return false
    }

}
