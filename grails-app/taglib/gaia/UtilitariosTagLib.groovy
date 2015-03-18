package gaia

import gaia.documentos.Detalle
import gaia.documentos.Documento


class UtilitariosTagLib {
    static defaultEncodeAs = [taglib: 'none']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]

    static namespace = "util"

    def renderHTML = { attrs ->
        out << attrs.html
    }

    def displayChain = {attrs ->
        //  println "display chain "+attrs
        def id = attrs.detalle
        def paso = attrs.paso
        def origen = attrs.origen
        def padre = attrs.padre
        def controller = "licencia"
        if(attrs.controller && attrs.controller !="")
            controller=attrs.controller
        def html=""
        if(attrs.detalle && attrs.detalle!="" &&  attrs.detalle!="null"){
            def detalle = attrs.detalle
            def mapa=[:]
            mapa["estacion"]=detalle.proceso.estacion
            mapa["proceso"]=detalle.proceso
            mapa["paso"]=paso
            mapa["origen"]=origen
            mapa["detalleObs"]=detalle
            mapa["detalleAlc"]=detalle
            mapa["padre"]=detalle
            mapa["controller"]=controller
            if(detalle.tipo.codigo=="TP07"){
                out<< render(template:"/templates/observaciones", model:mapa)
            }else{
                out<< render(template:"/templates/alcance", model:mapa)
            }
        }else{
            if(padre && padre!="" &&  padre!="null"){
                def detalle = Detalle.get(padre)
                //println "con padre "+detalle
                def mapa=[:]
                mapa["estacion"]=detalle.proceso.estacion
                mapa["proceso"]=detalle.proceso
                mapa["paso"]=paso
                mapa["origen"]=origen
                mapa["detalleObs"]=null
                mapa["detalleAlc"]=null
                mapa["padre"]=detalle
                mapa["controller"]=controller
                if(detalle.tipo.codigo=="TP07"){
                    out<< render(template:"/templates/alcance", model:mapa)
                }else{
                    out<< render(template:"/templates/observaciones", model:mapa)
                }
            }
        }
        out<<html

    }

    def displayEstadoDocumento={attrs->
        Documento documento = attrs.documento
        if(documento)
            out<< render(template:"/templates/estadoDocumento", model:[documento:documento])



    }

    def clean = { attrs ->
//        println("att" + attrs)
        def replace = [
                "&aacute;": "á",
                "&eacute;": "é",
                "&iacute;": "í",
                "&oacute;": "ó",
                "&uacute;": "ú",
                "&ntilde;": "ñ",

                "&Aacute;": "Á",
                "&Eacute;": "É",
                "&Iacute;": "Í",
                "&Oacute;": "Ó",
                "&Uacute;": "Ú",
                "&Ntilde;": "Ñ",

                "&nbsp;"  : " ",
                "&;"  : "y",
                "&"  : "y",

                "&lt;"    : "<",
                "&gt;"    : ">",

                "&amp;"   : "&",

                "&quot;"  : '"',

                "&lsquo;" : '‘',
                "&rsquo;" : '’',
                "&ldquo;" : '“',
                "&rdquo;" : '”',

                "&lsaquo;": '‹',
                "&rsaquo;": '›',
                "&laquo;" : '«',
                "&raquo;" : '»',

                "&permil;": '‰',

                "&hellip;": '...'
        ]
        def str = attrs.str

        replace.each { busca, nuevo ->
            str = str?.replaceAll(busca, nuevo)
         }
        out << str
    }



}
