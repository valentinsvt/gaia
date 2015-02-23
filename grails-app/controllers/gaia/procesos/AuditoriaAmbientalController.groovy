package gaia.procesos

import gaia.alertas.Alerta
import gaia.documentos.Detalle
import gaia.documentos.Documento
import gaia.documentos.Proceso
import gaia.documentos.TipoDocumento
import gaia.estaciones.Estacion

class AuditoriaAmbientalController {

    def diasLaborablesService
    def alertasService


    def showProcesos(){
        def estacion = Estacion.findByCodigo(params.id)
        def tipos = TipoDocumento.findAllByCodigoInList(["TP02","TP35","TP36"])
        def procesos = Proceso.findAllByEstacionAndTipoInList(estacion,tipos)
        [procesos:procesos,estacion: estacion,tipos:tipos]
    }


    def nuevoProceso(){
        println "params "+params
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
            redirect(action: "registrarAuditoria",id: proceso.id)
        }



    }

    /*Tipos TP02 TP35 TP36*/
    def registrarAuditoria(){
        def proceso = Proceso.get(params.id)
        def estacion = proceso.estacion
        def detalleTdr = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP16"))
        def detalleObs = Detalle.findAll("from Detalle where proceso=${proceso.id} and tipo="+TipoDocumento.findByCodigo("TP07").id+" and paso=1 order by id desc")
        def detalleAprobacion = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP18"))
        if(detalleObs.size()>0)
            detalleObs =  detalleObs.pop()
        [estacion:estacion,proceso:proceso,detalleTdr:detalleTdr,detalleObs:detalleObs,detalleApb:detalleAprobacion]
    }

    def upload(){

        println "upload audt "+params
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
            case "tdr":
                tipoDoc = TipoDocumento.findByCodigo("TP16")
                redirectStr = "registrarAuditoria"
                break;
            case "obs":
                tipoDoc = TipoDocumento.findByCodigo("TP07")
                params.descripcion = "Oficio de observaciones"
                if(params.padre)
                    padre = Detalle.get(params.padre)
                redirectStr = params.origen
                if(params.plazo)
                    plazo=params.plazo.toInteger()
                else
                    plazo=30
                break;
            case "alc":
                tipoDoc = TipoDocumento.findByCodigo("TP05")
                padre = Detalle.get(params.padre)
                params.descripcion = "Alcance a las observaciones"
                redirectStr = params.origen
                break;
            case "apbTdr":
                tipoDoc = TipoDocumento.findByCodigo("TP18")
                redirectStr = "auditoria"
                break;
            case "apbAud":
                tipoDoc = TipoDocumento.findByCodigo("TP17")
                redirectStr = "auditoriaPago"
                break;
            case "aud":
                tipoDoc = proceso.tipo
                redirectStr = "auditoria"
                break;
            case "pago":
                tipoDoc = TipoDocumento.findByCodigo("TP15")
                redirectStr = "auditoriaPago"
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
                    detalle.save(flush: true)
                    flash.message="Datos guardados, por favor continue con el siguiente paso"
                    redirect(action: ""+redirectStr,controller: 'auditoriaAmbiental',id: proceso.id)
                    return
                } else {
                    println "errores "+documento.errors
                    flash.message = "Ha ocurrido un error al guardar: " + renderErrors(bean: documento)
                    redirect(action: ""+redirectStr,controller: 'auditoriaAmbiental',id: proceso.id)
                    return
                }

            } //ok contents
            else {
                println "llego else no se acepta"
                flash.message= "Extensión no permitida"
                redirect(action: ""+redirectStr,controller: 'auditoriaAmbiental',id: proceso.id)
                return

            }
        }else{
            println "no file"
            params.remove("id")
            params.remove("tipo")

            detalle.documento.properties =params
            detalle.documento.consultor = proceso.consultor
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
            redirect(action: redirectStr,controller: 'auditoriaAmbiental',id: proceso.id)
            return
        } //f && !f.empty
    }

    def auditoria(){

    }

    def auditoriaPago(){

    }
}
