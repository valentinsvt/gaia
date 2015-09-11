package gaia.seguridad

import gaia.Contratos.Adendum
import gaia.Contratos.Cliente
import gaia.Contratos.DashBoardContratos
import gaia.facturacion.Factura
import gaia.pintura.DetallePintura
import gaia.Contratos.esicc.Pedido
import gaia.Contratos.esicc.PeriodoDotacion
import gaia.documentos.Dashboard
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.estaciones.Estacion
import groovy.sql.Sql


class PruebasController{
    def dataSource_erp
    def dataSource
    def mailService
    def links(){

        def usuario = Persona.findByLogin("OROZCOP")
        def perfil = Perfil.findByCodigo("1")
        println "usuario "+usuario.nombre
        def token =""
        token+= new Date().format("ddMMyyyy").encodeAsMD5()
        token=usuario.login+"|"+perfil.codigo.encodeAsMD5()+"|"+token+"|"+usuario.password
        def linkUsu = "" +g.createLink(action: 'remoteLogin',controller: 'login')+"?token="+token
        def linkEstacion
        usuario = Persona.findByLogin("MOLINAJ")
        perfil = Perfil.findByCodigo("2")
        println "usuario "+usuario.nombre
        token =""
        token+= new Date().format("ddMMyyyy").encodeAsMD5()
        token=usuario.login+"|"+perfil.codigo.encodeAsMD5()+"|"+token+"|"+usuario.password
        linkEstacion = "" +g.createLink(action: 'remoteLogin',controller: 'login')+"?token="+token
//        mailService.sendMail {
//            to "valentinsvt@hotmail.com"
//            subject "Hello Fred"
//            body 'How are you?'
//        }
        [linkUsu:linkUsu,linkEstacion:linkEstacion]

    }


    def cargaDash(){
        Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1").each {
            def dash = Dashboard.findByEstacion(it)
            if(!dash){
                dash=new Dashboard()
                dash.estacion=it
                if(!dash.save(flush: true))
                    println "error save dash "+dash.errors
                else
                    println " add dash "+it.codigo+"  "+it.nombre
            }
        }
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
            def sup
            sup = Inspector.findByMail(r["EMAIL_SUPERVISOR"])
            if(!sup)
                sup= new Inspector()
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

    def pruebaStres(){
        def clientes = Cliente.findAllByTipo(1)
        def ventasActual = 0
        def ventasAnterior = 0
        def cliente = Cliente.findByCodigoAndTipo("01010008",1)
        def fecha1 = new Date().parse("dd-MM-yyyy","01-04-2015")
        def fecha2 = new Date().parse("dd-MM-yyyy","31-04-2015")
        def fecha3 = new Date().parse("dd-MM-yyyy","01-04-2014")
        def fecha4 = new Date().parse("dd-MM-yyyy","31-04-2014")
        Factura.findAllByClienteAndFechaBetween(cliente,fecha1,fecha2).each {f->
            if(f.condicion=='1')
                ventasActual+=f.pago
        }
        Factura.findAllByClienteAndFechaBetween(cliente,fecha3,fecha4).each {f->
            if(f.condicion=='1')
                ventasAnterior+=f.pago
        }
        println "prueba ${cliente} "+clientes.size()+" "+ventasActual+" "+ventasAnterior
        render "ventas  "+ventasActual+"  "+ventasAnterior
    }


    def migra3(){
        def sql =  new Sql(dataSource_erp)
        def band = false
        def co
        sql.eachRow("sp_tables".toString()){r->
            if(r["table_type"]=="TABLE") {
                try{
                    sql.eachRow("select count(*) as co from PYS_2..${r['table_name']}".toString()){rd->
                        co=rd["co"]
                    }
                    if(band){
                        def s = "insert into PYS..${r['table_name']} select * from PYS_2..${r['table_name']}"
                        println "ejecutando "+s
                        sql.execute(s.toString());
                    }
                }catch (e){

                }

            }
        }
    }


    def migracion(){
        def sql =  new Sql(dataSource_erp)
        def cont = 0
        def tables = []
        def hechas=[]
        def error = []
        def sp=[]
        def co=0
        def cd=0
        def band = false

        sql.eachRow("sp_tables".toString()){r->
            sp.add(r['table_name'])

            if(r["table_type"]=="TABLE") {

                try{
                    sql.eachRow("select count(*) as co,(select count(*) as cd from PYS..${r['table_name']}) as ca  from PYS_3..${r['table_name']}".toString()){rd->
                        co=rd["co"]
                        cd=rd["ca"]
                    }
                    println "table "+r['table_name']+"  "+co+" -- "+cd
                    if(cd<co){
                        def s = "insert into PYS..${r['table_name']} select * from PYS_3..${r['table_name']}"
                        println "ejecutando "+s
                        sql.execute(s.toString());
                        println "ejecuto "
                    }
                }catch (e){
                    println "error "+e
                }

            }
        }

        sql.eachRow("sp_helpconstraint"){r->
            tables.add(0,r["name"])
        }
        println "sp "+sp.size()+"   "+tables.size()
        def inserto = []
        while(tables.size()!=(hechas.size()+error.size())){
            println "iteracion "+cont
            cont++
            tables.each {t->
                band = false
                inserto=[]
                co=0
                cd=0
                // println "tabla "+t
                if(!hechas.contains(t) && !error.contains(t)){
                    // println "no esta copiada"
                    try{
                        sql.eachRow("select count(*) as co,(select count(*) as cd from PYS..${t}) as ca  from PYS_3..${t}".toString()){r->
                            co=r["co"]
                            cd=r["ca"]
                        }
//                        println "registros en PYS2 "+co+" ----  PYS "+cd
                    }catch (e){
                        band=true
                        error.add(t)
                    }
                    if(!band){
                        if(cd<co){
                            try{
                                def s = "insert into PYS..${t} select * from PYS_3..${t}"
                                println "TIENE QUE INSERTAR   "+t+"  "+s
                                sql.execute(s.toString());
                                hechas.add(t)
                                inserto.add(t)
                            }catch (e){
                                println "catch ${t}--> "+e
                            }
                        }else{
                            hechas.add(t)
                        }
                    }

                }

            }
            println "----------------- fin iter!!! ---${tables.size()}  Hechas "+hechas.size()+" error  "+error.size()
            println "inserto  "+inserto
            if(cont>5)
                break;
        }

        println "-------------->>>> fin "+cont+" "+tables.size()
        sql.close()
        render "termino"

    }

    def checkTablas(){
        def sql =  new Sql(dataSource_erp)
        def tables= [:]

        sql.eachRow("sp_tables".toString()){r->
            if(r["table_type"]=="TABLE") {
                tables.put(r['table_name'],[])
                try{
                    sql.eachRow("select count(*) as co,(select count(*) as cd from PYS..${r['table_name']}) as ca  from PYS_3..${r['table_name']}".toString()){rd->
                        tables[r['table_name']][0]=rd["co"]
                        tables[r['table_name']][1]=rd["ca"]
                    }

                }catch (e){
                    println "error "+e
                }

            }
        }

        [tables:tables]

    }

    def borrarTablas(){
        response.sendError(403)
        return

//        def sql =  new Sql(dataSource_erp)
//        def tables= []
//        def borradas = []
//        def cont = 0
//        def delete=""
//        sql.eachRow("sp_tables".toString()){r->
//            if(r["table_type"]=="TABLE") {
//                tables.add(r["table_name"])
//                delete = "delete from " + r["table_name"]
//                try {
//                    println "ejecutando " + delete
//                    sql.execute(delete.toString())
//                    borradas.add(r["table_name"])
//                    println "borradas " + r["table_name"]
//                } catch (e) {
//                    println "error detele"
//                }
//            }
//        }
//        println "entra al while!!! "
//        while (borradas.size()<tables.size()){
//            println "iteracion "+cont+"  "+borradas.size()+"  "+tables.size()
//            tables.each {t->
//                if(!borradas.contains(t)){
//                    try {
//                        delete="delete from "+t
//                       // println "ejecutando "+delete
//                        sql.execute(delete.toString())
//                        borradas.add(t)
//                        //println "borradas "+t
//                    }catch (e){
//                        //println "error detele"
//                    }
//                }
//            }
//            if(cont>5)
//                break
//            cont++
//        }

    }



    def migrar2(){
        def sql =  new Sql(dataSource_erp)
        def cont = 0
        def tables = []
        def hechas=[]
        def error = []
        def sp=[]
        def co=0
        def cd=0
        def band = false

        sql.eachRow("sp_tables".toString()){r->
            sp.add(r['table_name'])

            if(r["table_type"]=="TABLE") {

                try{
                    sql.eachRow("select count(*) as co,(select count(*) as cd from PYS..${r['table_name']}) as ca  from PYS_3..${r['table_name']}".toString()){rd->
                        co=rd["co"]
                        cd=rd["ca"]
                    }
                    println "table "+r['table_name']+"  "+co+" -- "+cd
                    if(cd<co){
                        def s = "insert into PYS..${r['table_name']} select * from PYS_3..${r['table_name']}"
                        println "ejecutando "+s
                        sql.execute(s.toString());
                        println "ejecuto "
                    }
                }catch (e){
                    tables.add(r["table_type"])
                    println "error "+e
                }

            }
        }
        def inserto = []
        while(tables.size()<(hechas.size()+error.size())){
            println "iteracion "+cont
            cont++
            tables.each {t->
                band = false
                inserto=[]
                co=0
                cd=0
                // println "tabla "+t
                if(!hechas.contains(t) && !error.contains(t)){
                    // println "no esta copiada"
                    try{
                        sql.eachRow("select count(*) as co,(select count(*) as cd from PYS..${t}) as ca  from PYS_3..${t}".toString()){r->
                            co=r["co"]
                            cd=r["ca"]
                        }
//                        println "registros en PYS2 "+co+" ----  PYS "+cd
                    }catch (e){
                        band=true
                        error.add(t)
                    }
                    if(!band){
                        if(cd<co){
                            try{
                                def s = "insert into PYS..${t} select * from PYS_3..${t}"
                                println "TIENE QUE INSERTAR   "+t+"  "+s
                                sql.execute(s.toString());
                                hechas.add(t)
                                inserto.add(t)
                            }catch (e){
                                println "catch ${t}--> "+e
                            }
                        }else{
                            hechas.add(t)
                        }
                    }

                }

            }
            println "----------------- fin iter!!! ---${tables.size()}  Hechas "+hechas.size()+" error  "+error.size()
            println "inserto  "+inserto
            if(cont>2)
                break;
        }

        println "-------------->>>> fin "+cont+" "+tables.size()
        sql.close()
        render "termino"
    }


}
