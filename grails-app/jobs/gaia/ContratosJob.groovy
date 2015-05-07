package gaia

import gaia.Contratos.Adendum
import gaia.Contratos.Cliente
import gaia.Contratos.DashBoardContratos
import gaia.pintura.DetallePintura
import gaia.Contratos.esicc.Pedido
import gaia.Contratos.esicc.PeriodoDotacion
import gaia.estaciones.Estacion
import groovy.sql.Sql


class ContratosJob {
    static triggers = {
        simple name: 'contratosJob', startDelay: 1000 * 50, repeatInterval: 1000 * 60 * 60
    }

    final static descripcion="Proceso que se encarga de refrescar los indicadores para: Contratos, dotación semestral y pintura "
    def dataSource_erp

    def execute() {
        println "Ejecución contratosJob "+new Date().format("dd-MM-yyyy HH:mm:ss")
        def periodo = PeriodoDotacion.findByEstado("A")
        //println "periodo  "+periodo
        /*Indicador de los contratos*/
        Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1").each { estacion ->
            def dash = DashBoardContratos.findByEstacion(estacion)
            def cliente = Cliente.findByCodigoAndTipo(estacion.codigo,1)
            if (!dash) {
                dash = new DashBoardContratos()
                dash.estacion = estacion
            }
            def contratos = Adendum.findAllByCliente(estacion.codigo, [sort: "fin", order: "desc"])
            if (contratos.size() > 0) {
                dash.ultimoContrato = contratos.first().fin
            } else {
                if (cliente.fechaTerminaContrato!= null) {
                    dash.ultimoContrato = cliente.fechaTerminaContrato
                }
            }
            /*Indicador de la pintura*/
            def detalles = DetallePintura.findAllByCliente(cliente,[sort: "fin",order: "desc"])
            if(detalles.size()>0){
                dash.ultimaPintura=detalles.first().fin
            }else{
                dash.ultimaPintura=null
            }
            /*Indicador de la dotación semestral*/


            def pedido = Pedido.findAllByEstacionAndPeriodo(estacion,periodo)
            //println " estacion ${dash.estacion}   pedido--> "+pedido
            if(pedido.size()>0){
                pedido.each {p->
                    if(p.estado=="A")
                        dash.ultimoUniforme=periodo.fecha
                }
            }else{
                dash.ultimoUniforme=null
            }
            dash.save(flush: true)
        }
        println "fin de la ejecución contratosJob "+new Date().format("dd-MM-yyyy HH:mm:ss")
    }
}