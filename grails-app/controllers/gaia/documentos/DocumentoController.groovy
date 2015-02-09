package gaia.documentos

import gaia.estaciones.Estacion

class DocumentoController {

    def subir() {
        def estacion = Estacion.findByCodigo(params.id)
        def tipos = TipoDocumento.findAllByTipo("N", [sort: "nombre"])
        def caducan = TipoDocumento.findAllByTipoAndCaduca("N", "S", [sort: "nombre"])
        caducan = caducan.collect { "'" + it.id + "'" }
        [estacion: estacion, tipos: tipos, caducan: caducan]
    }

    def upload() {
        //println "upload "+params
        def estacion = Estacion.findByCodigo(params.estacion_codigo)
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

    def arbolEstacion() {
        if (!params.codigo) {
            params.codigo = "08010235"
        }
        return [arbol: makeTree(params), params: params]
    }

    private String makeTree(params) {
        def estacion = Estacion.findByCodigo(params.codigo)
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

        def tipoPrevId = null

        docs.eachWithIndex { doc, i ->
            def tipo = doc.tipo
            if (tipo.id != tipoPrevId) {
                tipoPrevId = tipo.id
                if (i > 0) {
                    txt += "</li>"
                    txt += "</ul>"
                }
                txt += "<li id='liTipoDoc_${tipo.id}' data-jstree='{\"type\":\"tipoDoc\"}'>"
                txt += "<a href='#'>"
                txt += tipo.nombre
                txt += "</a>"
                txt += "<ul>"
            }
            def dataFile = "data-file='${doc.path}'"
            txt += "<li id='liDoc_${doc.id}' data-jstree='{\"type\":\"doc\"}' ${dataFile}>"
            txt += "<a href='#'>"
            txt += doc.referencia
            if (doc.fin) {
                txt += " <span class='text-info'>Válido hasta: ${doc.fin?.format('dd-MM-yyyy')}"
                if (doc.fin <= hoy) {
                    txt += " <span class='text-danger'>" +
                            "<strong>" +
                            "<i class='fa fa-exclamation-triangle'></i> CADUCADO" +
                            "</strong>" +
                            "</span>"
                } else {
                    def dias = doc.fin - hoy
                    if (dias <= 30) {
                        txt += " <span class='text-warning'>" +
                                "<strong>" +
                                "<i class='fa fa-exclamation-circle'></i> POR CADUCAR (${dias} días)" +
                                "</strong>" +
                                "</span>"
                    }
                }
            }
            txt += "</a>"
            txt += "</li>"
        }

        return txt
    }


}
