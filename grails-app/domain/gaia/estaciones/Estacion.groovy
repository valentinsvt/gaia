package gaia.estaciones

import gaia.documentos.Dashboard
import gaia.documentos.Detalle
import gaia.documentos.Documento
import gaia.documentos.Proceso
import gaia.documentos.RequerimientosEstacion
import gaia.documentos.TipoDocumento
import gaia.documentos.Ubicacion

class Estacion {



    /**
     * Código del perfil
     */
    String codigo

    String nombre

    int aplicacion

    String direccion

    String telefono

    String ruc

    String propetario

    String representante

    String mail

    String estado

    String provincia
    String canton
    String parroquia

    Integer tipo

    String cedulaRepresentante
    String arrendatario
    String representanteArrendatario
    String cedulaRepresentanteArrendatario
    String administrador
    String cedulaAdministrador
    String placaAutotanque
    Double capacidadAutotanque

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]



    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'cliente'
        sort 'nombre'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "codigo", generator: 'assigned', type:"string"
        version false
        columns {
            codigo column: 'codigo_cliente', insertable: false, updateable: false
            estado column: 'estado_cliente'
            nombre column: 'nombre_cliente'
            aplicacion column: 'codigo_aplicacion'
            direccion column: 'direccion_cliente'
            telefono column: 'felefono_cliente'
            ruc column: 'ruc_cliente'
            propetario column: 'propietario_1'
            representante column: 'representante_legal'
            mail column: 'mail_cliente'
            provincia column: 'provincia'
            canton column: 'canton'
            parroquia column: 'parroquia'
            tipo column: 'tipo_cliente'
            cedulaRepresentante column: 'cedula_representante'
            arrendatario column: 'arrendatario'
            representanteArrendatario column: 'representante_arrendatario'
            cedulaRepresentanteArrendatario column: 'cedula_rep_arrendatario'
            administrador column: 'administrador'
            cedulaAdministrador column: 'cedula_administrador'
            placaAutotanque column: 'placa_autotanque'
            capacidadAutotanque column: 'capacidad_autotanque'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        direccion(nullable: true,blank: true)
        mail(nullable: true,blank: true)
        telefono(nullable: true,blank: true)
        propetario(nullable: true,blank: true)
        representante(nullable: true,blank: true)
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return "${this.nombre}"
    }

    def getColorLicencia(){
        //def lic = Documento.findAllByTipoAndEstacion(TipoDocumento.findByCodigo("TP01"),this,[sort: "fechaRegistro",order: "asc"])
        def lic = Documento.findAll("from Documento where tipo=${TipoDocumento.findByCodigo("TP01").id} and estacion='${this.codigo}' and estado='A' order by fechaRegistro asc")
        // println "lics "+lic
        if(lic.size()>0) {
            lic=lic.pop()
            if(!lic.fin)
                return ["card-bg-green",lic]
            else{
                if (lic.fin>new Date()){
                    return ["card-bg-green",lic]
                }else{
                    return ["svt-bg-danger",null]
                }
            }
        }else{
            return ["svt-bg-danger",null]
        }
    }
    def getColorLicenciaSinEstado(){
        //def lic = Documento.findAllByTipoAndEstacion(TipoDocumento.findByCodigo("TP01"),this,[sort: "fechaRegistro",order: "asc"])
        def lic = Documento.findAll("from Documento where tipo=${TipoDocumento.findByCodigo("TP01").id} and estacion='${this.codigo}'  order by fechaRegistro asc")
        // println "lics "+lic
        if(lic.size()>0) {
            lic=lic.pop()
            if(!lic.fin)
                return ["card-bg-green",lic]
            else{
                if (lic.fin>new Date()){
                    return ["card-bg-green",lic]
                }else{
                    return ["svt-bg-danger",null]
                }
            }
        }else{
            return ["svt-bg-danger",null]
        }
    }
    def getColorAuditoriaSinEstado(){
        /*Tipos TP02 TP35 TP36*/
        //Todo esto hay que arreglar.. ordenar por fecha de registro no convence
        def audi = Documento.findAll("from Documento where tipo in (${TipoDocumento.findByCodigo("TP02").id},${TipoDocumento.findByCodigo( "TP35").id},${TipoDocumento.findByCodigo( "TP36").id}) and estacion='${this.codigo}'  order by fin asc")
        // println "lics "+lic
        if(audi.size()>0) {
            audi=audi.pop()
            if(!audi.fin)
                return ["card-bg-green",audi]
            else{
                if (audi.fin>new Date()){
                    return ["card-bg-green",audi]
                }else{
                    return ["svt-bg-danger",null]
                }
            }
        }else{
            return ["svt-bg-danger",null]
        }
    }
    def getColorAuditoria(){
        //Todo esto hay que arreglar.. ordenar por fecha de registro no convence
        def audi = Documento.findAll("from Documento where tipo in (${TipoDocumento.findByCodigo("TP02").id},${TipoDocumento.findByCodigo("TP35").id},${TipoDocumento.findByCodigo("TP36").id},${TipoDocumento.findByCodigo("TP38").id}) and estacion='${this.codigo}' and estado='A'  order by fechaRegistro asc")
        def auditoria = null

        //println "auds  "+audi.referencia
        if(audi.size()>0) {
            //audi=audi.pop()
            audi.each {ad->
                def ok = false
                def proceso = Proceso.findByDocumento(ad)
                //println "proceso "+proceso
                def detalles = Detalle.findAllByProcesoAndPaso(proceso,2)
                detalles.each {d->
                    // println "detalle "+d.documento?.referencia+" "+d.documento?.tipo?.codigo+" "+d.documento?.estado
                    if(d.documento){
                        if(d.documento.tipo.codigo=="TP17"){
                            if(d.documento.estado=="A"){
                                ok=true
                            }
                        }
                    }
                }
                if(!ad.fin && ok)
                    auditoria=ad
                else{
                    if (ad.fin>new Date() && ok){
                        auditoria=ad
                    }
                }
            }
            if(auditoria)
                return ["card-bg-green",auditoria]
            else{
                return ["svt-bg-danger",null]

            }

        }else{
            return ["svt-bg-danger",null]
        }
    }
    def getColorMonitoreo(){
        def doc = Documento.findAll("from Documento where tipo=${TipoDocumento.findByCodigo("TP12").id} and estacion='${this.codigo}' and estado='A' order by fechaRegistro asc")
        //def doc = Documento.findByTipoAndEstacion(TipoDocumento.findByCodigo("TP12"),this)
        def d = null
        if(doc.size()>0) {
            doc=doc.pop()
            if(!doc.fin)
                return ["card-bg-green",doc]
            else{
                if (doc.fin>new Date()){
                    return ["card-bg-green",doc]
                }else{
                    return ["svt-bg-danger",null]
                }
            }
        }else{
            return ["svt-bg-danger",null]
        }
    }
    def getColorMonitoreoSinEstado(){
        def doc = Documento.findAll("from Documento where tipo=${TipoDocumento.findByCodigo("TP12").id} and estacion='${this.codigo}'  order by fechaRegistro asc")
        //def doc = Documento.findByTipoAndEstacion(TipoDocumento.findByCodigo("TP12"),this)

        if(doc.size()>0) {
            doc=doc.pop()
            if(!doc.fin)
                return ["card-bg-green",doc]
            else{
                if (doc.fin>new Date()){
                    return ["card-bg-green",doc]
                }else{
                    return ["svt-bg-danger",null]
                }
            }
        }else{
            return ["svt-bg-danger",null]
        }
    }
    def getColorDocs(){

        def dash = Dashboard.findByEstacion(this)
        //println "dash "+dash.id+"   "+dash.docs
        if(dash.docs==1){
            return ["card-bg-green",null]
        }else{
            return ["svt-bg-danger",null]
        }

    }

    def checkDocs(){
        def reqs = RequerimientosEstacion.findAllByEstacion(this)
        if(reqs.size()==0)
            return false
        def cont = 0
        reqs.each {r->
            def doc = this.getLastDoc(r.tipo)
            // println "tipo "+r.tipo.nombre+" doc  "+doc?.referencia+"  "+doc?.fin
            if(doc){
                if(doc.estado=="A")
                    cont++
            }else{
                return
            }
        }
        if(cont==reqs.size())
            return true
        return false
    }

    def getLastDoc(TipoDocumento tipo){
        def now = new Date()
        //def doc = Documento.findAllByEstacionAndTipo(this,tipo,[sort:"inicio",order:"desc",max:1])
        def doc = Documento.findAll("from Documento where tipo=${tipo.id} and estacion='${this.codigo}' and (fin is null or fin>'${now.format('yyyy-MM-dd HH:mm:ss')}') order by fin asc")
        if(doc.size()>0) {
            if(doc[0].fin)
                doc=doc.pop()
            else
                doc=doc[0]
            if(doc.fin){
                if(doc.fin<new Date())
                    return null
            }
            return doc
        }else
            return null
    }
    def getColorControlSinEstado(){
        //Todo esto hay que arreglar.. ordenar por fecha de registro no convence
        def controles = Documento.findAll("from Documento where tipo =${TipoDocumento.findByCodigo('TP41').id} and estacion='${this.codigo}'  order by fechaRegistro asc")

        def now = new Date()
        def control = null
        //println "copntroles  "+audi.referencia
        if(controles.size()>0) {

            controles.each {ad->
                if(ad.fin>now){
                    control=ad
                }

            }
            if(control){
                if(control.estado=="A")
                    return ["card-bg-green",control]
                else
                    return ["svt-bg-danger",control]
            }else{
                return ["svt-bg-danger",null]

            }

        }else{
            return ["svt-bg-danger",null]
        }
    }
    def getColorControl(){
        //Todo esto hay que arreglar.. ordenar por fecha de registro no convence
        def controles = Documento.findAll("from Documento where tipo =${TipoDocumento.findByCodigo('TP41').id} and estacion='${this.codigo}'  order by fechaRegistro asc")

        def now = new Date()
        def control = null
        //println "copntroles  "+audi.referencia
        if(controles.size()>0) {

            controles.each {ad->
                if(ad.fin>now){
                    control=ad
                }

            }
            if(control){
                if(control.estado=="A")
                    return ["card-bg-green",control]
                else
                    return ["svt-bg-danger",null]
            }else{
                return ["svt-bg-danger",null]

            }

        }else{
            return ["svt-bg-danger",null]
        }
    }

}
