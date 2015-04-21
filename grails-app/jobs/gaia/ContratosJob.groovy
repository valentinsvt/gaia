package gaia

import gaia.Contratos.Adendum
import gaia.Contratos.DashBoardContratos
import gaia.Contratos.DetallePintura
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
            if (!dash) {
                dash = new DashBoardContratos()
                dash.estacion = estacion
            }
            def contratos = Adendum.findAllByCliente(estacion.codigo, [sort: "fin", order: "desc"])
            if (contratos.size() > 0) {
                dash.ultimoContrato = contratos.first().fin
            } else {
                def sql = new Sql(dataSource_erp)
                sql.eachRow("select * from CLIENTE where TIPO_CLIENTE=1 and ESTADO_CLIENTE='A' and CODIGO_CLIENTE='${estacion.codigo}'".toString()) { r ->
                    if (r["FECHA_TERMINA_CONTRATO"] != null) {
                        dash.ultimoContrato = r["FECHA_TERMINA_CONTRATO"]
                    }
                }
            }
            /*Indicador de la pintura*/
            def detalles = DetallePintura.findAllByCliente(estacion.codigo,[sort: "fin",order: "desc"])
            if(detalles.size()>0){
                dash.ultimaPintura=detalles.first().fin
            }
            /*Indicador de la dotación semestral*/


            def pedido = Pedido.findAllByEstacionAndPeriodo(estacion,periodo)
            //println " estacion ${dash.estacion}   pedido--> "+pedido
            if(pedido.size()>0){
                pedido.each {p->
                    if(p.estado=="A")
                        dash.ultimoUniforme=periodo.fecha
                }
            }
            dash.save(flush: true)
        }
        println "fin de la ejecución contratosJob "+new Date().format("dd-MM-yyyy HH:mm:ss")
    }
}