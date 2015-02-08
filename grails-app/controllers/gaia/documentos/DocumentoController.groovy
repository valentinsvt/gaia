package gaia.documentos

import gaia.estaciones.Estacion

class DocumentoController {

    def subir(){
        def estacion = Estacion.findByCodigo(params.id)
        def tipos = TipoDocumento.findAllByTipo("N",[sort:"nombre"])
        def caducan = TipoDocumento.findAllByTipoAndCaduca("N","S",[sort:"nombre"])
        caducan=caducan.collect{"'"+it.id+"'"}
        [estacion:estacion,tipos:tipos,caducan:caducan]
    }
    def upload(){
        println "upload "+params
        def estacion = Estacion.findByCodigo(params.estacion_codigo)
        def path = servletContext.getRealPath("/") + "documentos/${estacion.codigo}/"
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
                def documento = new Documento(params)
                println "path "+pathFile
                println "codigo "+codigo
                documento.path=pathFile
                documento.fechaRegistro=new Date()
                documento.estacion=estacion
                documento.codigo = codigo
                if (documento.save(flush: true)) {
                    if(params.observaciones!=""){
                        def obs = new Observacion()
                        obs.documento=documento
                        obs.observacion=params.observaciones
                    }
                    flash.message = "Documento registrado "
                } else {
                    println "errores "+documento.errors
                    flash.message = "Ha ocurrido un error al guardar: " + renderErrors(bean: documento)
                }

            } //ok contents
            else {
                println "llego else no se acepta"
                flash.message= "Extensión no permitida"

            }
        } //f && !f.empty

        redirect(action: 'subir',id: estacion.codigo)
    }
}