package gaia.uniformes

import gaia.Contratos.esicc.Uniforme
import gaia.seguridad.Shield

class KitController extends Shield {
    static sistema="UNFR"
    def index() {
    redirect(action: 'lista')
    }

    def lista(){
        def kits = Kit.list([sort: "nombre"])
        [kits:kits]
    }

    def nuevoKit(){
        def kit = null
        def detalles=[]
        if(params.id) {
            kit = Kit.get(params.id)
            detalles = DetalleKit.findAllByKit(kit)
        }

        [kit:kit,detalles:detalles]


    }

    def comboUniforme(){
        def tipos = ["U"]
        tipos.add(params.tipo)
        def uniformes = Uniforme.findAllByTipoInList(tipos)
        [uniformes:uniformes]
    }

    def save(){
        println "params "+params
        def kit
        if(params.id && params.id!=""){
            kit = Kit.get(params.id)
            DetalleKit.findAllByKit(kit).each {
                it.delete(flush: true)
            }
        }else{
            kit=new Kit()
        }
        kit.properties=params
        if(!kit.save(flush: true)) {
            println "error save kit " + kit.errors
            flash.message="Error al guardar el kit"
            redirect(action: "nuevoKit")
        }else{
            def data = params.data.split("W")
            data.each {d->
                if(d  && d!=""){
                    def datos =  d.split(";")
                    def detalle = new DetalleKit()
                    detalle.kit=kit
                    detalle.cantidad=datos[1].toInteger()
                    detalle.uniforme =Uniforme.findByCodigo(datos[0])
                    detalle.save(flush: true)
                }
            }

            redirect(action: "lista")
        }

    }

    def cambiarEstado(){
        def kit = Kit.get(params.id)
        if(kit.estado=='A')
            kit.estado='D'
        else
            kit.estado='A'
        kit.save(flush: true)
        render "ok"
    }


}
