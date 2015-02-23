package gaia.procesos

import gaia.alertas.Alerta
import gaia.documentos.Consultor
import gaia.documentos.Dashboard
import gaia.documentos.Dependencia
import gaia.documentos.Detalle
import gaia.documentos.Documento
import gaia.documentos.Observacion
import gaia.documentos.Proceso
import gaia.documentos.TipoDocumento
import gaia.estaciones.Estacion

class LicenciaController {

    def diasLaborablesService
    def alertasService

    def registrarLicencia(){
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
        def lic = estacion.getColorLicenciaSinEstado()
        def warning = false
        def proceso = null
        def tipoLicencia = TipoDocumento.findByCodigo('TP01')
        def detalle = null
        //println "licencia "+lic[1]+"  "+estacion
        if(lic[1]){
            warning = false
            proceso = Proceso.findAll("from Proceso where estacion='${estacion.codigo}' and tipo=${tipoLicencia.id} and completado='S'")
            if(proceso.size()>0) {
                proceso = proceso.pop()
                //  println "pop "
            }
            detalle = Detalle.findByProcesoAndPaso(proceso,1)
            //println "procesoaaaa "+proceso+" detalle "+detalle
        }else{
            proceso = Proceso.findAll("from Proceso where estacion='${estacion.codigo}' and tipo=${tipoLicencia.id} and completado='N'")
            //println " proceso else"+proceso
            if( proceso.size()==0){
                proceso = new Proceso()
                proceso.completado="N"
                proceso.estacion=estacion
                proceso.tipo = tipoLicencia
                proceso.inicio=new Date()
                if(!proceso.save(flush: true)){
                    println "error save proceso "+proceso.errors
                }
            }else{
                proceso=proceso.pop()
                detalle = Detalle.findByProcesoAndPaso(proceso,1)
                //println "detalle "+detalle
            }

        }
        //println "return "+proceso
        [estacion:estacion,warning:warning,proceso:proceso,detalle:detalle]
    }

    def crearNueva(){
        //println "crear nueva "+params
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
        def tipoLicencia = TipoDocumento.findByCodigo('TP01')
        def proceso = Proceso.findAll("from Proceso where estacion='${estacion.codigo}' and tipo=${tipoLicencia.id} and completado='S'")
        if(proceso.size()>0) {
            proceso = proceso.pop()
            proceso.completado='C'
            proceso.documento.fin=new Date();
            proceso.documento.save()
            proceso.save(flush: true)
            Detalle.findAllByProceso(proceso).each {
                it.documento.fin=new Date()
                it.documento.save(flush: true)
            }
        }
        render "ok"

    }

    def saveCertificado(){
        println "upload "+params

        def estacion = Estacion.findByCodigoAndAplicacion(params.estacion_codigo,1)
        def detalle
        def proceso = Proceso.get(params.proceso)
        if(!proceso)
            response.sendError(403)
        def tipoCert = TipoDocumento.findByCodigo("TP03")
        def pathPart = "documentos/${estacion.codigo}/"
        if(params.id)
            detalle=Detalle.get(params.id)
        else{
            detalle = new Detalle()
            detalle.proceso=proceso
            detalle.tipo = tipoCert
            detalle.dependencia=Dependencia.get(params.dependencia)
            detalle.fechaRegistro=new Date()
            detalle.paso=1
            detalle.plazo = 0
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
                documento.tipo = tipoCert
                documento.estado="N"
                documento.consultor = proceso.consultor
                if (documento.save()) {
                    detalle.dependencia = Dependencia.get(params.dependencia)
                    if(!detalle.documento)
                        detalle.documento=documento
                    detalle.save(flush: true)
                    flash.message="Datos guardados, por favor continue con el siguiente paso"
                    redirect(action: 'licenciaTdr',controller: 'licencia',id: proceso.id)
                    return
                } else {
                    println "errores "+documento.errors
                    flash.message = "Ha ocurrido un error al guardar: " + renderErrors(bean: documento)
                    redirect(action: 'registrarLicencia',controller: 'licencia',id: estacion.codigo)
                    return
                }

            } //ok contents
            else {
                println "llego else no se acepta"
                flash.message= "Extensión no permitida"
                redirect(action: 'registrarLicencia',controller: 'licencia',id: estacion.codigo)
                return

            }
        }else{

            params.remove("id")
            detalle.documento.properties =params
            detalle.dependencia = Dependencia.get(params.dependencia)
            detalle.documento.save()
            detalle.save(flush: true)
            flash.message="Datos guardados, por favor continue con el siguiente paso"
            redirect(action: 'licenciaTdr',controller: 'licencia',id: proceso.id)
            return
        } //f && !f.empty
    }

    def upload(){

        println "upload "+params
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
                tipoDoc = TipoDocumento.findByCodigo("TP04")
                redirectStr = "licenciaTdr"
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
                tipoDoc = TipoDocumento.findByCodigo("TP06")
                redirectStr = "licenciaEia"
                break;
            case "apbEia":
                tipoDoc = TipoDocumento.findByCodigo("TP14")
                redirectStr = "licenciaPago"
                break;
            case "eia":
                tipoDoc = TipoDocumento.findByCodigo("TP13")
                redirectStr = "licenciaEia"
                break;
            case "pago":
                tipoDoc = TipoDocumento.findByCodigo("TP15")
                redirectStr = "licenciaPago"
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
                    redirect(action: ""+redirectStr,controller: 'licencia',id: proceso.id)
                    return
                } else {
                    println "errores "+documento.errors
                    flash.message = "Ha ocurrido un error al guardar: " + renderErrors(bean: documento)
                    redirect(action: ""+redirectStr,controller: 'licencia',id: proceso.id)
                    return
                }

            } //ok contents
            else {
                println "llego else no se acepta"
                flash.message= "Extensión no permitida"
                redirect(action: ""+redirectStr,controller: 'licencia',id: proceso.id)
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
            detalle.dependencia = Dependencia.get(params.dependencia)


            detalle.save(flush: true)
            flash.message="Datos guardados, por favor continue con el siguiente paso"
            redirect(action: redirectStr,controller: 'licencia',id: proceso.id)
            return
        } //f && !f.empty
    }

    def licenciaTdr(){
        if(!params.id)
            response.sendError(403)
        def proceso = Proceso.get(params.id)
        if(!proceso)
            response.sendError(403)
        def estacion = proceso.estacion
        def detalleTdr = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP04"))
        //def detalleTdr = Detalle.findAll("from Detalle where proceso=proceso.id and tipo="+TipoDocumento.findByCodigo("TP04").id+" and paso=2")
        //def detalleObs = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP07"))
        def detalleObs = Detalle.findAll("from Detalle where proceso=${proceso.id} and tipo="+TipoDocumento.findByCodigo("TP07").id+" and paso=2 order by id desc")
        def detalleAprobacion = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP06"))
        //def detalleAprobacion = Detalle.findAll("from Detalle where proceso=proceso.id and tipo="+TipoDocumento.findByCodigo("TP06").id+" and paso=2")
        //println "obs "+detalleObs
        if(detalleObs.size()>0)
            detalleObs =  detalleObs.pop()
        //println " "+detalleObs.paso+"  "+detalleObs.detalle.documento.codigo
        [proceso:proceso,estacion: estacion,detalleTdr:detalleTdr,detalleApb:detalleAprobacion,detalleObs:detalleObs]
    }

    def licenciaEia(){
        if(!params.id)
            response.sendError(403)
        def proceso = Proceso.get(params.id)
        if(!proceso)
            response.sendError(403)
        def estacion = proceso.estacion
        def detalleEia = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP13"))
        def detalleObs = Detalle.findAll("from Detalle where proceso=${proceso.id} and tipo="+TipoDocumento.findByCodigo("TP07").id+" and paso=3 order by id desc")
        def detalleAprobacion = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP14"))
        if(detalleObs.size()>0)
            detalleObs =  detalleObs.pop()
        [proceso:proceso,estacion: estacion,detalleEia:detalleEia,detalleApb:detalleAprobacion,detalleObs:detalleObs]
    }


    def licenciaPago(){
        if(!params.id)
            response.sendError(403)
        def proceso = Proceso.get(params.id)
        if(!proceso)
            response.sendError(403)
        def estacion = proceso.estacion
        def detallePago = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP15"))
        def detalleLicencia = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP01"))

        [proceso:proceso,estacion: estacion,detallePago:detallePago,detalleLicencia:detalleLicencia]
    }

    def uploadLicencia(){
        println "upload "+params

        def estacion = Estacion.findByCodigoAndAplicacion(params.estacion_codigo,1)
        def detalle
        def proceso = Proceso.get(params.proceso)
        if(!proceso)
            response.sendError(403)
        def tipo = TipoDocumento.findByCodigo("TP01")
        def pathPart = "documentos/${estacion.codigo}/"
        def now = new Date().parse("dd-MM-yyyy",params.inicio_input)
        if(params.id)
            detalle=Detalle.get(params.id)
        else{
            detalle = new Detalle()
            detalle.proceso=proceso
            detalle.tipo = tipo
            detalle.fechaRegistro=new Date()
            detalle.paso=4
            detalle.plazo = 0
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
                documento.tipo = tipo
                documento.inicio=now
                documento.estado="N"
                documento.consultor = proceso.consultor
                if (documento.save()) {
                    if(!detalle.documento)
                        detalle.documento=documento
                    if(detalle.save(flush: true)){
                        proceso.completado="S"
                        proceso.documento = detalle.documento
                        proceso.save(flush: true)
                        def dash = Dashboard.findByEstacion(proceso.estacion)
                        dash.licencia=1
                        dash.save(flush: true)
                    }
                    flash.message="Datos guardados, por favor continue con el siguiente paso"
                    redirect(action: 'licenciaPago',controller: 'licencia',id: proceso.id)
                    return
                } else {
                    println "errores "+documento.errors
                    flash.message = "Ha ocurrido un error al guardar: " + renderErrors(bean: documento)
                    redirect(action: 'licenciaPago',controller: 'licencia',id: proceso.id)
                    return
                }

            } //ok contents
            else {
                println "llego else no se acepta"
                flash.message= "Extensión no permitida"
                redirect(action: 'licenciaPago',controller: 'licencia',id: proceso.id)
                return

            }
        }else{

            params.remove("id")
            detalle.documento.properties =params
            detalle.documento.inicio=now
            detalle.documento.save()
            detalle.save(flush: true)
            flash.message="Datos guardados, por favor continue con el siguiente paso"
            redirect(action: 'licenciaPago',controller: 'licencia',id: proceso.id)
            return
        } //f && !f.empty
    }


    def verLicencia(){
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
        def tipoLicencia = TipoDocumento.findByCodigo('TP01')
        def proceso = Proceso.findAll("from Proceso where estacion='${estacion.codigo}' and tipo=${tipoLicencia.id} and completado='S'")
        if(proceso.size()>0){
            proceso=proceso.pop()
        }else{
            response.sendError(403)
        }
        def detalles = Detalle.findAll("from Detalle where proceso = ${proceso.id} order by paso,id")
        [estacion: estacion,proceso: proceso,detalles: detalles]
    }


    def cambiarConsultor(){
        println "cambiar consultor "+params
        def proceso = Proceso.get(params.proceso)
        def consultor = Consultor.get(params.id)
        proceso.consultor=consultor
        
        Detalle.findAllByProceso(proceso).each {
            if(it.documento){
                it.documento.consultor=consultor
                if(!it.documento.save())
                    println "error save consultor"
            }
        }
        if(!proceso.save(flush: true))
            println "error save proceso "+proceso.errors
        render("ok")
    }
}
