package gaia.procesos

import gaia.alertas.Alerta
import gaia.documentos.Detalle
import gaia.documentos.Documento
import gaia.documentos.Proceso
import gaia.documentos.TipoDocumento
import gaia.estaciones.Estacion
import gaia.seguridad.Shield

class ControlController extends Shield {
    def diasLaborablesService
    def alertasService


   def showControles(){
       def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
       def tipos = TipoDocumento.findAllByCodigo("TP41")
       def procesos = Proceso.findAllByEstacionAndTipoInList(estacion,tipos)
       [procesos:procesos,estacion: estacion,tipos:tipos]
   }

    def nuevoProceso(){
        //println "params "+params
        def estacion = Estacion.findByCodigo(params.id)
        def tipo = TipoDocumento.get(params.tipo)
        def proceso = new Proceso()
        proceso.estacion=estacion
        proceso.tipo=tipo
        proceso.inicio=new Date()
        if(!proceso.save(flush: true)){
            println "error proceso "+proceso.errors
            redirect(controller: "estacion",action: "showEstacion",id: estacion.codigo)
        }else{
            redirect(action: "registrarControl",id: proceso.id)
        }
    }

    def registrarControl(){
        println "registrar control "+params
        def proceso = Proceso.get(params.id)
        def estacion = proceso.estacion
        def now = new Date()
        def detallePago = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP42"))
        def detalleBomberos= Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP20"))
        if(!detalleBomberos){
            def docBomberos = null
            Documento.findAll("from Documento where tipo=${TipoDocumento.findByCodigo('TP20').id} and estacion='${estacion.codigo}' ").each {d->
                if(!docBomberos){
                    if(!d.fin) {
                        docBomberos = d
                    }else{
                        if(d.fin>now)
                            docBomberos=d
                    }

                }
            }
            if(docBomberos){
                detalleBomberos=new Detalle()
                detalleBomberos.proceso=proceso
                detalleBomberos.documento=docBomberos
                detalleBomberos.fechaRegistro=docBomberos.fechaRegistro
                detalleBomberos.paso=1
                detalleBomberos.tipo=docBomberos.tipo
                detalleBomberos.save(flush: true)
            }
        }
        def detalleTanques= Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP43"))
        if(!detalleTanques){
            def docTanques = null
            Documento.findAll("from Documento where tipo=${TipoDocumento.findByCodigo('TP43').id} and estacion='${estacion.codigo}' ").each {d->
                if(!docTanques){
                    if(!d.fin) {
                        docTanques = d
                    }else{
                        if(d.fin>now)
                            docTanques=d
                    }

                }
            }
            if(docTanques){
                detalleTanques=new Detalle()
                detalleTanques.proceso=proceso
                detalleTanques.documento=docTanques
                detalleTanques.fechaRegistro=docTanques.fechaRegistro
                detalleTanques.paso=1
                detalleTanques.tipo=docTanques.tipo
                detalleTanques.save(flush: true)
            }
        }
        def detallePoliza= Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP44"))
        if(!detallePoliza){
            def docPoliza = null
            Documento.findAll("from Documento where tipo=${TipoDocumento.findByCodigo('TP44').id} and estacion='${estacion.codigo}' ").each {d->
                if(!docPoliza){
                    if(!d.fin) {
                        docPoliza = d
                    }else{
                        if(d.fin>now)
                            docPoliza=d
                    }

                }
            }
            if(docPoliza){
                detallePoliza=new Detalle()
                detallePoliza.proceso=proceso
                detallePoliza.documento=docPoliza
                detallePoliza.fechaRegistro=docPoliza.fechaRegistro
                detallePoliza.paso=1
                detallePoliza.tipo=docPoliza.tipo
                detallePoliza.save(flush: true)
            }
        }
        def detalleLicencia= Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP01"))
        if(!detalleLicencia){
            detalleLicencia= Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP45"))
            if(!detalleLicencia){
                def docLic = null
                Documento.findAll("from Documento where tipo=${TipoDocumento.findByCodigo('TP01').id} and estacion='${estacion.codigo}' ").each {d->
                    if(!docLic){
                        if(!d.fin) {
                            docLic = d
                        }else{
                            if(d.fin>now)
                                docLic=d
                        }

                    }
                }
                if(docLic){
                    detalleLicencia=new Detalle()
                    detalleLicencia.proceso=proceso
                    detalleLicencia.documento=docLic
                    detalleLicencia.fechaRegistro=docLic.fechaRegistro
                    detalleLicencia.paso=1
                    detalleLicencia.tipo=docLic.tipo
                    detalleLicencia.save(flush: true)
                }
            }

        }
//        println "detalle licencia "+detalleLicencia.id+"  "+detalleLicencia?.documento+" "+detalleLicencia.tipo.id
        def detallesOtros= Detalle.findAllByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP46"))

        [estacion:estacion,proceso:proceso,detallePago:detallePago,detalleBomberos:detalleBomberos
        ,detalleTanques:detalleTanques,detallePoliza:detallePoliza, detalleLicencia:detalleLicencia,detallesOtros:detallesOtros]
    }


    /*
   * Certificado de control TP41
   * Pago TP42
   * Bomberos TP20
   * Vertificacion tecnica de tanques TP43
   * Póliza de daños a terceros y responsabilidad civil TP44
   * Licencia ambiental TP01
   * Certificado de licencia ambiental TP45
   * Otros TP46
   * Acta de control TP47
   *
   * */
    def upload(){

        println "upload control "+params
        def estacion = Estacion.findByCodigoAndAplicacion(params.estacion_codigo,1)
        def detalle
        def proceso = Proceso.get(params.proceso)
        if(!proceso)
            response.sendError(403)
        def tipoDoc
        def paso = params.paso.toInteger()
        def plazo = 0
        def redirectStr =""
        def padre=null
        def now = new Date().parse("dd-MM-yyyy",params.inicio_input)
        switch (params.tipo){
            case "pago":
                tipoDoc = TipoDocumento.findByCodigo("TP42")
                params.descripcion="Pago de control anual"
                redirectStr = "registrarControl"
                break;
            case "bomberos":
                tipoDoc = TipoDocumento.findByCodigo("TP20")
                redirectStr = "registrarControl"
                break;
            case "tanque":
                tipoDoc = TipoDocumento.findByCodigo("TP43")
                redirectStr = "registrarControl"
                break;
            case "poliza":
                tipoDoc = TipoDocumento.findByCodigo("TP44")
                redirectStr = "registrarControl"
                break;
            case "lic":
                tipoDoc = TipoDocumento.findByCodigo("TP45")
                redirectStr = "registrarControl"
                break;
            case "otros":
                tipoDoc = TipoDocumento.findByCodigo("TP46")
                redirectStr = "registrarControl"
                break;
            case "acta":
                tipoDoc = TipoDocumento.findByCodigo("TP47")
                redirectStr = "certificado"
                break;
            case "cert":
                tipoDoc = TipoDocumento.findByCodigo("TP41")
                redirectStr = "certificado"
                break;

        }
        def pathPart = "documentos/${estacion.codigo}/"
        println "detalle? "+detalle
        if(params.id)
            detalle=Detalle.get(params.id)
        else{
            detalle = new Detalle()
            detalle.proceso=proceso
            detalle.tipo = tipoDoc
            detalle.fechaRegistro=new Date()
            println "padre "+padre
            detalle.detalle=padre
            detalle.paso = paso
            detalle.plazo = plazo
            if(!detalle.save(flush: true)){
                println "error save detalle "+detalle.errors
            }
        }

        def path = servletContext.getRealPath("/") + pathPart
        def numero = Documento.list([sort: "id",order: "desc",max: 1])
        if(numero.size()==1)
            numero=numero.pop().id+1
        else
            numero=1
        def codigo = "PS-DA-"+numero
        new File(path).mkdirs()
        def f = request.getFile('file')  //archivo = name del input type file
        def okContents = [
                'application/pdf'                                                          : 'pdf',
                'application/download'                                                     : 'pdf'
        ]
        if (f && !f.empty) {
            def ext
            if (okContents.containsKey(f.getContentType())) {
                ext = okContents[f.getContentType()]
                def nombre = codigo + "." + ext
                def pathFile = path + nombre
                try {
                    f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                } catch (e) {
                    flash.message = "Ha ocurrido un error al guardar"
                }
                params.remove("tipo")
                def documento
                if(detalle.documento)
                    documento=detalle.documento
                else
                    documento = new Documento(params)
                //println "path "+pathFile
                //println "codigo "+codigo
                documento.path= pathPart + nombre
                documento.fechaRegistro=new Date()
                documento.estacion=estacion
                documento.codigo = codigo
                documento.tipo = tipoDoc
                documento.inicio=now
                documento.estado="N"
                documento.consultor=proceso.consultor
                if(plazo>0){

                    def fechaFin = diasLaborablesService.diasLaborablesDesde(now,plazo)
                    if(fechaFin[0])
                        documento.fin = fechaFin[1]
                    else
                        documento.fin =now.plus(plazo)
                    println "plazo >0 "+documento?.inicio?.format("dd-MM-yyyy")+"  "+documento?.fin?.format("dd-MM-yyyy")
                }
                if (documento.save()) {
                    alertasService.generarAlertaDocumentoVencido(documento)
                    if(!detalle.documento)
                        detalle.documento=documento
                    if(documento.tipo.codigo==proceso.tipo.codigo) {
                        proceso.documento = documento
                        proceso.save()
                    }
                    if(documento.tipo.codigo=="TP19"){
                        proceso.completado="S"
                        proceso.save()
                    }
                    detalle.save(flush: true)
                    flash.message="Datos guardados, por favor continue con el siguiente paso"
                    redirect(action: ""+redirectStr,controller: 'control',id: proceso.id)
                    return
                } else {
                    println "errores "+documento.errors
                    flash.message = "Ha ocurrido un error al guardar: " + renderErrors(bean: documento)
                    redirect(action: ""+redirectStr,controller: 'control',id: proceso.id)
                    return
                }

            } //ok contents
            else {
                println "llego else no se acepta"
                flash.message= "Extensión no permitida"
                redirect(action: ""+redirectStr,controller: 'control',id: proceso.id)
                return

            }
        }else{
            println "no file"
            params.remove("id")
            params.remove("tipo")

            detalle.documento.properties =params
            detalle.documento.consultor = proceso.consultor
            detalle.documento.estado="N"
            if(params.plazo){
                plazo = params.plazo.toInteger()
                detalle.plazo=plazo
                def fechaFin = diasLaborablesService.diasLaborablesDesde(now,plazo)
                if(fechaFin[0])
                    detalle.documento.fin = fechaFin[1]
                else
                    detalle.documento.fin =now.plus(plazo)
                def alerta = Alerta.findByDocumento(detalle.documento)
                if(alerta){
                    if(!alerta.fechaRecibido) {
                        alerta.fechaRecibido = new Date()
                        alerta.save()
                    }
                }
                detalle.documento.save()
                alertasService.generarAlertaDocumentoVencido(detalle.documento)
                println "plazo >0 "+detalle.documento?.inicio?.format("dd-MM-yyyy")+"  "+detalle.documento?.fin?.format("dd-MM-yyyy")
            }else{
                detalle.documento.save()
            }
            detalle.save(flush: true)
            flash.message="Datos guardados, por favor continue con el siguiente paso"
            redirect(action: redirectStr,controller: 'control',id: proceso.id)
            return
        } //f && !f.empty
    }

    def acta(){
        def proceso = Proceso.get(params.id)
        def estacion = proceso.estacion
        def detalleActa = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP47"))

        [estacion:estacion,proceso:proceso,detalleActa:detalleActa]
    }
    def certificado(){
        def proceso = Proceso.get(params.id)
        def estacion = proceso.estacion
        def detalleCert = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP41"))

        [estacion:estacion,proceso:proceso,detalleCert:detalleCert]
    }

}
