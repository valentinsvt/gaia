package gaia

import gaia.Contratos.Adendum
import gaia.Contratos.DashBoardContratos
import gaia.estaciones.Estacion
import groovy.sql.Sql


class ContratosJob {
    static triggers = {
        simple name: 'contratosJob', startDelay: 1000 * 50, repeatInterval: 1000 * 60 * 60
    }
    def dataSource_erp

    def execute() {
        println "Ejecución contratosJob "+new Date().format("dd-MM-yyyy HH:mm:ss")
        Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1").each { estacion ->
            def dash = DashBoardContratos.findByEstacion(estacion)
            if (!dash) {
                dash = new DashBoardContratos()
                dash.estacion = estacion
            }
            def contratos = Adendum.findAllByCliente(estacion.codigo, [sort: "fin", order: "desc"])
            // println "contratos para la estacion ${estacion.codigo} --> "+contratos
            if (contratos.size() > 0) {
                dash.ultimoContrato = contratos.first().fin
            } else {
               // println "no adendums verificando en cliente"
                def sql = new Sql(dataSource_erp)
                sql.eachRow("select * from CLIENTE where TIPO_CLIENTE=1 and ESTADO_CLIENTE='A' and CODIGO_CLIENTE='${estacion.codigo}'".toString()) { r ->
                    //println "termina contrato " + r["FECHA_TERMINA_CONTRATO"]
                    if (r["FECHA_TERMINA_CONTRATO"] != null) {
                        dash.ultimoContrato = r["FECHA_TERMINA_CONTRATO"]
                    }
                }
            }
            dash.save(flush: true)
        }
        println "fin de la ejecución contratosJob "+new Date().format("dd-MM-yyyy HH:mm:ss")
    }
}