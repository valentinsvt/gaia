package gaia.seguridad

import gaia.Contratos.Adendum
import gaia.Contratos.DashBoardContratos
import gaia.Contratos.DetallePintura
import gaia.Contratos.Egreso
import gaia.Contratos.TipoContrato
import gaia.Contratos.esicc.Pedido
import gaia.Contratos.esicc.PeriodoDotacion
import gaia.documentos.Dashboard
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.estaciones.Estacion
import groovy.sql.Sql


class PruebasController {
    def dataSource_erp
    def dataSource
    def links(){

        def usuario = Persona.findByLogin("OROZCOP")
        def perfil = Perfil.findByCodigo("1")
        println "usuario "+usuario.nombre
        def token =""
        token+= new Date().format("ddMMyyyy").encodeAsMD5()
        token=usuario.login+"|"+perfil.codigo.encodeAsMD5()+"|"+token+"|"+usuario.password
        def linkUsu = "" +g.createLink(action: 'remoteLogin',controller: 'login')+"?token="+token
        def linkEstacion
        usuario = Persona.findByLogin("ZAPATAV")
        perfil = Perfil.findByCodigo("2")
        println "usuario "+usuario.nombre
        token =""
        token+= new Date().format("ddMMyyyy").encodeAsMD5()
        token=usuario.login+"|"+perfil.codigo.encodeAsMD5()+"|"+token+"|"+usuario.password
        linkEstacion = "" +g.createLink(action: 'remoteLogin',controller: 'login')+"?token="+token
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

    def cargarDatosEstaciones(){
        def sql =  new Sql(dataSource_erp)
        def sqlCli = new Sql(dataSource)
        sql.eachRow("select  * from CLIENTE where TIPO_CLIENTE=1 and ESTADO_CLIENTE='A'".toString()) { r ->
            println("update cliente set representante_legal='${r['NOMBRE_REPRESENTANTE']?r['NOMBRE_REPRESENTANTE']:''}', cedula_representante='${r['CEDULA_REPRESENTANTE']?r['CEDULA_REPRESENTANTE']:''}',arrendatario='${r['ARRENDATARIO']?r['ARRENDATARIO']:''}',representante_arrendatario='${r['REPRESENTANTE_ARRENDATARIO']?r['REPRESENTANTE_ARRENDATARIO']:''}',provincia='${r['CODIGO_UBICACION'].substring(0,2)}' ,canton='${r['CODIGO_UBICACION'].substring(0,4)}',parroquia='${r['CODIGO_UBICACION']}'  where codigo_cliente = '${r['CODIGO_CLIENTE']}' and codigo_aplicacion=1 and estado_cliente='A' ")
            println "update ${r['CODIGO_CLIENTE']}"+sqlCli.execute("update cliente set representante_legal=${r['NOMBRE_REPRESENTANTE']}, cedula_representante=${r['CEDULA_REPRESENTANTE']},arrendatario=${r['ARRENDATARIO']},representante_arrendatario=${r['REPRESENTANTE_ARRENDATARIO']},provincia=${r['CODIGO_UBICACION'].substring(0,2)} ,canton=${r['CODIGO_UBICACION'].substring(0,4)},parroquia=${r['CODIGO_UBICACION']}  where codigo_cliente = ${r['CODIGO_CLIENTE']} and codigo_aplicacion=1 and estado_cliente='A' ")

        }
        render "ok"
    }


    def checkDashboards(){
        Dashboard.list().each {d->
            if(d.estacion.estado!='A'){
                println "borrando dashboard "+d.id+"  "+d.estacion
                d.delete(flush: true)
            }
        }
        DashBoardContratos.list().each {d->
            if(d.estacion.estado!='A'){
                println "borrando dashboard "+d.id+"  "+d.estacion
                d.delete(flush: true)
            }
        }
        Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1").each {
            def dash = new Dashboard()
            dash.estacion=it
            dash.save(flush: true)
            dash = new DashBoardContratos()
            dash.estacion=it
            dash.save(flush: true)
        }
    }

    def cargarPorcentaje(){
        def sql =  new Sql(dataSource_erp)
        def select = "select  c.CODIGO_CLIENTE as codigo,l.MARGEN_LISTA_PRECIO as margen \n" +
                "from CLIENTE c,LISTA_PRECIO l,CLIENTE_LISTA_PRECIO cl \n" +
                " where c.TIPO_CLIENTE=1 and c.ESTADO_CLIENTE='A' \n" +
                "and cl.CODIGO_LISTA_PRECIO = \tl.CODIGO_LISTA_PRECIO\n" +
                "and c.CODIGO_CLIENTE = cl.CODIGO_CLIENTE\n" +
                "and cl.VIGENTE='S'"
        sql.eachRow(select.toString()) { r ->
            def estacion = Estacion.findByCodigoAndAplicacion(r["codigo"],1)
            def dash = DashBoardContratos.findByEstacion(estacion)
            dash.porcentajeComercializacion=r["margen"]
            dash.save(flush: true)
        }
        render "ok"
    }


    def cargarCodigoArch(){
        def sql =  new Sql(dataSource_erp)
        def sqlCli = new Sql(dataSource)
        sql.eachRow("select  * from CLIENTE where TIPO_CLIENTE=1 and ESTADO_CLIENTE='A'".toString()) { r ->
            println("update cliente set codigo_dnh='${r['CODIGO_DNH']}' where codigo_cliente = '${r['CODIGO_CLIENTE']}' and codigo_aplicacion=1 and estado_cliente='A' and tipo_cliente=1 ")
            println "update ${r['CODIGO_CLIENTE']} "+sqlCli.execute("update cliente set codigo_dnh='${r['CODIGO_DNH']}' where codigo_cliente = '${r['CODIGO_CLIENTE']}' and codigo_aplicacion=1 and estado_cliente='A' and tipo_cliente=1 ".toString())

        }
        render "ok"
    }


    def cargaUniforme(){
        def periodo = PeriodoDotacion.findByEstado("A")
        Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1").each { estacion ->
            def dash = DashBoardContratos.findByEstacion(estacion)

            if (!dash) {
                dash = new DashBoardContratos()
                dash.estacion = estacion
            }
            dash.ultimoUniforme=null
            def pedido = Pedido.findAllByEstacionAndPeriodo(estacion,periodo)
            println "pedido "+pedido
            if(pedido.size()>0){
                pedido.each {p->
                    if(p.estado=="A")
                        dash.ultimoUniforme=periodo.fecha
                }

            }

            dash.save(flush: true)

        }
        render "ok"
    }

    def cargarPintura(){
        Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1").each { estacion ->
            def dash = DashBoardContratos.findByEstacion(estacion)
            if (!dash) {
                dash = new DashBoardContratos()
                dash.estacion = estacion
            }

            def detalles = DetallePintura.findAllByCliente(estacion.codigo,[sort: "fin",order: "desc"])
            println "detalles "+detalles
            if(detalles.size()>0){
                dash.ultimaPintura=detalles.first().fin
            }
            dash.save(flush: true)
        }
        render "ok"
    }

}
