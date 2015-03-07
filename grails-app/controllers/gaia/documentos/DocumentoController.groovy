package gaia.documentos

import gaia.DashboardJob
import gaia.estaciones.Estacion
import gaia.seguridad.Shield

class DocumentoController extends Shield {
    def dashboardService

    def subir() {
        println "params " + params
        def estacion = Estacion.findByCodigoAndAplicacion(params.id, 1)
        def tipos = TipoDocumento.findAllByTipo("N", [sort: "nombre"])
        def caducan = TipoDocumento.findAllByTipoAndCaduca("N", "S", [sort: "nombre"])
        def doc = null
        if (params.doc && params.doc != "") {
            if (session.tipo == "usuario") {
                doc = Documento.get(params.doc)
            }
        }
        println "doc " + doc + " " + session.tipo
        caducan = caducan.collect { "'" + it.id + "'" }
        [estacion: estacion, tipos: tipos, caducan: caducan, tipo: params.tipo, doc: doc]
    }

    def upload() {
        //println "upload "+params
        def estacion = Estacion.findByCodigoAndAplicacion(params.estacion_codigo, 1)
        def pathPart = "documentos/${estacion.codigo}/"
        def path = servletContext.getRealPath("/") + pathPart
        def numero = Documento.list([sort: "id", order: "desc", max: 1])
        if (numero.size() == 1)
            numero = numero.pop().id + 1
        else
            numero = 1
        def codigo = "PS-DA-" + numero
        new File(path).mkdirs()
        def f = request.getFile('file')  //archivo = name del input type file
        def okContents = [
                'application/pdf'     : 'pdf',
                'application/download': 'pdf'
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
                def documento = new Documento(params)
                //println "path "+pathFile
                //println "codigo "+codigo
                documento.path = pathPart + nombre
                documento.fechaRegistro = new Date()
                documento.estacion = estacion
                documento.codigo = codigo
                if (documento.save(flush: true)) {
                    if (params.observaciones != "") {
                        def obs = new Observacion()
                        obs.documento = documento
                        obs.observacion = params.observaciones
                    }
                    flash.message = "Documento registrado "
                } else {
                    println "errores " + documento.errors
                    flash.message = "Ha ocurrido un error al guardar: " + renderErrors(bean: documento)
                }

            } //ok contents
            else {
                println "llego else no se acepta"
                flash.message = "Extensión no permitida"

            }
        } //f && !f.empty

        redirect(action: 'subir', id: estacion.codigo)
    }

    def ver() {
        redirect(action: "arbolEstacion", params: params)
    }

    def arbolEstacion() {
        params.combo = true
        if (params.id) {
//            println "es doc: " + params
            def doc = Documento.get(params.id)
            params.codigo = doc.estacion.codigo
            params.selected = params.id
        } else {
//            println "es estacion: " + params
            if (session.tipo == "cliente") {
//                println "es cliente"
                params.combo = false
                params.codigo = session.usuario.codigo
            }
            if (!params.codigo) {
                params.codigo = Estacion.list([sort: 'nombre', max: 1]).first().codigo
            }
        }
        return [arbol: makeTree(params), params: params]
    }

    private String makeTree(params) {
        def estacion = Estacion.findByCodigoAndAplicacion(params.codigo, 1)
        def res = ""
        res += "<ul>"
        res += "<li id='estacion' data-level='0' class='root jstree-open' data-jstree='{\"type\":\"estacion\"}'>"
        res += "<a href='#' class='label_arbol'>${estacion.nombre}</a>"
        res += "<ul>"
        res += imprimeTiposDoocumento(estacion, params)
        res += "</li>"
        res += "</ul>"
        return res
    }

    private String imprimeTiposDoocumento(Estacion estacion, params) {
        def hoy = new Date()

        def txt = ""

        def docs = Documento.findAllByEstacion(estacion, ([sort: "tipo"]))

        def docs2 = [:]
        docs.each { d ->
            if (!docs2[d.tipo.entidadId]) {
                docs2[d.tipo.entidadId] = [
                        entidad : d.tipo.entidad,
                        tiposDoc: [:]
                ]
            }
            if (!docs2[d.tipo.entidadId]["tiposDoc"][d.tipoId]) {
                docs2[d.tipo.entidadId]["tiposDoc"][d.tipoId] = [
                        tipo      : d.tipo,
                        documentos: []
                ]
            }
            docs2[d.tipo.entidadId]["tiposDoc"][d.tipoId]["documentos"] += d
        }

        docs2.each { k, doc2 ->
            def entidad = doc2.entidad
            txt += "<li class='jstree-closed' id='liEntidad_${entidad.id}' data-jstree='{\"type\":\"${entidad.codigo}\"}'>"
            txt += "<a href='#' ><span style='color:#006EB7;font-weight: bold'>"
            txt += entidad.nombre
            txt += "</span></a>"
            txt += "<ul>"
            doc2.tiposDoc.each { j, td ->
                txt += "<li class='jstree-closed' id='liTipoDoc_${td.tipo.id}' data-jstree='{\"type\":\"tipoDoc\"}'>"
                txt += "<a href='#'>"
                txt += td.tipo.nombre
                txt += "</a>"
                txt += "<ul>"
                td.documentos.each { doc ->
                    def editable = ""
                    if (doc.tipo.tipo == 'N') {
                        editable = " editable"
                    }
                    def dataFile = "data-file='${doc.path}'"
                    txt += "<li id='liDoc_${doc.id}' data-jstree='{\"type\":\"doc\"}' ${dataFile} class='${doc.estado} ${editable}' >"
                    txt += "<a href='#'>"
                    def icono = ((doc.estado == 'A') ? "<span class='text-success'><i class='fa fa-check'></i></span>" : "<span class='text-danger'><i class='fa fa-times'></i></span>")
                    txt += icono
                    txt += doc.referencia
                    if (doc.inicio) {
                        txt += " - <strong>${doc.inicio.format('dd-MM-yyyy')}</strong>"
                    }
                    if (doc.fin) {

                        if (doc.fin <= hoy) {
                            txt += " <span class='text-danger'>" +
                                    "<strong>" +
                                    "<i class='fa fa-exclamation-triangle'></i> CADUCADO" +
                                    "</strong>" +
                                    "</span>"
                        } else {
                            def dias = doc.fin - hoy
                            txt += " <span class='text-info'>Vence: ${doc.fin?.format('dd-MM-yyyy')}</span>"
                            if (dias <= 30) {
                                txt += " <span class='text-warning'>" +
                                        "<strong>" +
                                        "<i class='fa fa-exclamation-circle'></i> POR CADUCAR (${dias} día${dias == 1 ? '' : 's'})" +
                                        "</strong>" +
                                        "</span>"
                            }
                        }
                    }
                    txt += "</a>"
                    txt += "</li>"
                }
                txt += "</ul>"
                txt += "</li>"
            }
            txt += "</ul>"
            txt += "</li>"
        }
        return txt
    }

    def verDetalles_ajax() {
        def doc = Documento.get(params.id)
        return [doc: doc]
    }

    def download() {
        def doc = Documento.get(params.id)
        def path = servletContext.getRealPath("/") + doc.path
        def file = new File(path)
        if (file.exists()) {
            response.setContentType("application/octet-stream")
            response.setHeader("Content-disposition", "attachment;filename=${file.getName()}")

            response.outputStream << file.newInputStream() // Performing a binary stream copy
        } else {
            render "No existe el documento " + path
        }
    }

    def downloadObs_ajax() {

    }

    def aprobarDocumento() {
        if (request.method != "POST") {
            response.sendError(403)
        } else {
            def documento = Documento.get(params.id)
            documento.estado = "A"
            documento.save(flush: true)
            dashboardService.checkDash(documento)
            render "ok"
        }

    }

    def caducarDocumento() {
        if (session.tipo != "usuario")
            response.sendError(403)
        def now = new Date()
        def doc = Documento.get(params.id)
        def band = false
        if (!doc) {
            render "ok"
            return
        }
        if (!doc.fin) {
            doc.fin = now
            band = true
        } else {
            if (doc.fin > now) {
                doc.fin = now
                band = true
            }
        }
        if (band) {
            def obs = new Observacion()
            obs.documento = doc
            obs.persona = session.usuario
            obs.observacion = "Documento caducado por ${session.usuario.login} el ${new Date().format('dd-MM-yyyy HH:mm:ss')}"
            obs.save()
            doc.save(flush: true)
            def job = new DashboardJob()
            job.checkEstadoEstacion(doc.estacion)
        }
        render "ok"
    }

    def busquedaDocumento() {
        def estaciones = Dashboard.list().estacion
        def tipos = TipoDocumento.list([sort: "nombre"])
        def consultores = Consultor.list([sort: "nombre"])
        [estaciones: estaciones, tipos: tipos, consultores: consultores]
    }

    def buscar() {
        //println "params "+params
        def documentos = Documento.withCriteria {
            if (params.estacion != "-1")
                eq("estacion", Estacion.findByCodigoAndAplicacion(params.estacion, 1))
            if (params.tipo != "-1")
                eq("tipo", TipoDocumento.get(params.tipo))
            if (params.consultor != "-1")
                eq("consultor", Consultor.get(params.consultor))
            if (params.registro_desde != "") {
                gt("fechaRegistro", new Date().parse("dd-MM-yyyy HH:mm:ss", params.registro_desde + " 00:00:01"))
            }
            if (params.registro_hasta != "") {
                lt("fechaRegistro", new Date().parse("dd-MM-yyyy HH:mm:ss", params.registro_hasta + " 23:59:01"))
            }
            if (params.emitido_desde != "") {
                gt("inicio", new Date().parse("dd-MM-yyyy HH:mm:ss", params.emitido_desde + " 00:00:01"))
            }
            if (params.emitido_hasta != "") {
                lt("inicio", new Date().parse("dd-MM-yyyy HH:mm:ss", params.emitido_hasta + " 23:59:01"))
            }
            if (params.vence_desde != "") {
                gt("fin", new Date().parse("dd-MM-yyyy HH:mm:ss", params.vence_desde + " 00:00:01"))
            }
            if (params.vence_hasta != "") {
                lt("fin", new Date().parse("dd-MM-yyyy HH:mm:ss", params.vence_hasta + " 23:59:01"))
            }
            order("inicio")
        }

        [documentos: documentos]

    }

}
