package gaia

import gaia.documentos.Detalle

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
                if(detalle.tipo.codigo=="TP07"){
                    out<< render(template:"/templates/alcance", model:mapa)
                }else{
                    out<< render(template:"/templates/observaciones", model:mapa)
                }
            }
        }
        out<<html

    }
}
