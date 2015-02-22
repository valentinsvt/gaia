package gaia.procesos

import gaia.documentos.Detalle
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
        def detalle = null
        [estacion:estacion,proceso:proceso,detalle:detalle]
    }
}
