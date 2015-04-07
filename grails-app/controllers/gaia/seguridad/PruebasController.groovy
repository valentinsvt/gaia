package gaia.seguridad

import gaia.Contratos.Adendum
import gaia.Contratos.DashBoardContratos
import gaia.Contratos.TipoContrato
import gaia.documentos.Dashboard
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.estaciones.Estacion
import groovy.sql.Sql


class PruebasController {
    def dataSource_erp
    def links(){

        def usuario = Persona.findByLogin("OROZCOP")
        def perfil = Perfil.findByCodigo("1")
        println "usuario "+usuario.nombre
        def token =""
        token+= new Date().format("ddMMyyyy").encodeAsMD5()
        token=usuario.login+"|"+perfil.codigo.encodeAsMD5()+"|"+token+"|"+usuario.password
        def linkUsu = "" +g.createLink(action: 'remoteLogin',controller: 'login')+"?token="+token
        def estacion = Dashboard.list().pop().estacion
        perfil = Perfil.findByCodigo("28")
        token=""
        token+= new Date().format("ddMMyyyy").encodeAsMD5()
        token=estacion.ruc+"|"+perfil.codigo.encodeAsMD5()+"|"+token+"|"+estacion.codigo
        def linkEstacion = g.createLink(action: 'remoteLogin',controller: 'login')+"?token="+token
        println "estacion "+estacion.nombre
        [linkUsu:linkUsu,linkEstacion:linkEstacion]

    }

    def listado(){


        Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1").each {estacion->
            def dash = DashBoardContratos.findByEstacion(estacion)
            if(!dash){
                dash = new DashBoardContratos()
                dash.estacion=estacion
            }
            def contratos = Adendum.findAllByCliente(estacion.codigo,[sort:"fin",order:"desc"])
            println "contratos para la estacion ${estacion.codigo} --> "+contratos
            if(contratos.size()>0) {
                dash.ultimoContrato = contratos.first().fin
            }else{
                println "no adendums verificando en cliente"
                def sql =  new Sql(dataSource_erp)
                sql.eachRow("select * from CLIENTE where TIPO_CLIENTE=1 and ESTADO_CLIENTE='A' and CODIGO_CLIENTE='${estacion.codigo}'".toString()) { r ->
                    println "termina contrato "+r["FECHA_TERMINA_CONTRATO"]
                    if(r["FECHA_TERMINA_CONTRATO"]!=null){
                        dash.ultimoContrato=r["FECHA_TERMINA_CONTRATO"]
                    }
                }
            }
            dash.save(flush: true)


        }


        render "ok"
    }

    def cargarSupervisores(){
        def sql =  new Sql(dataSource_erp)
        sql.eachRow("select * from SUPERVISORES".toString()){r->
            println "row "+r
            def sup = new Inspector()
            sup.codigo=r["CODIGO_SUPERVISOR"]
            sup.mail=r["EMAIL_SUPERVISOR"]
            sup.nombre=r["NOMBRE_SUPERVISOR"]
            sup.telefono=r["CELULAR_SUPERVISOR"]
            sup.save(flush: true)
        }
        Dashboard.list().each {ds->
            def supEst = InspectorEstacion.findByEstacion(ds.estacion)
            if(!supEst){
                supEst=new InspectorEstacion()
            }
            supEst.estacion=ds.estacion
            supEst.inspector = Inspector.findByCodigo(ds.estacion.codigoSupervisor)
            supEst.save(flush: true)
        }
        render "ok"
    }

}
