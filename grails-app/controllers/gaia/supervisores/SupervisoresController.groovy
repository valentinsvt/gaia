package gaia.supervisores

import gaia.Contratos.Cliente
import gaia.documentos.Dashboard
import gaia.documentos.Documento
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.facturacion.Factura
import gaia.facturacion.Producto
import gaia.seguridad.Shield
import groovy.sql.Sql
import groovy.time.TimeCategory

class SupervisoresController  extends Shield{
    static sistema="SPVS"
    def dataSource_erp
    def index() {
        if(session.tipo=="cliente") {
            redirect(action: "dashSupervisor")
        }else{
            redirect(action: "dash")
        }
    }

    def dash(){
        def supervisores = getSupervisores()
        supervisores=supervisores.sort{it.nombre}
        def objetivos = ObjetivoSupervisores.list([sort: "periocidad",order: "desc"])
        def meses = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
        def colores = ["#CE464A","#BB594D","#A86C50","#FFA324","#e8ff61","#9feb87","#5CB85C"]
//        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        def mes
        use( TimeCategory ) {
            mes = new Date() - 1.months

        }
        def anio =  mes.format("yyyy")
        def fecha = mes
        def mesString = mes.format("MMyyyy")
        [supervisores:supervisores,objetivos:objetivos,meses: meses,colores:colores,mes:mes.format("MM"),mesint:mes.format("MM").toInteger(),anio:anio,fecha:fecha,mesString:mesString]
    }
    def dashSupervisor(){
        def responsable = Responsable.findByLogin(session.usuario.login)
        def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
        if(!supervisor)
            response.sendError(403)
        def supervisores = [supervisor]
        def objetivos = ObjetivoSupervisores.list([sort: "periocidad",order: "desc"])
        def meses = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
        def colores = ["#CE464A","#BB594D","#A86C50","#FFA324","#e8ff61","#9feb87","#5CB85C"]
//        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        def mes
        use( TimeCategory ) {
            mes = new Date() - 1.months

        }
        def anio =  mes.format("yyyy")
        def fecha = mes
        def mesString = mes.format("MMyyyy")
        def obj = ObjetivoSupervisores.findAllByTipo("C")
        [supervisores:supervisores,supervisor: supervisor,obj:obj,objetivos:objetivos,meses: meses,colores:colores,mes:mes.format("MM"),mesint:mes.format("MM").toInteger(),anio:anio,fecha:fecha,mesString:mesString]
    }

    def listaSemaforos() {
        def estaciones
        def dash
        if(session.tipo=="cliente"){
//            def estacion = Estacion.findByCodigo(session.usuario.codigo)
            def responsable = Responsable.findByLogin(session.usuario.login)
            def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
            estaciones=InspectorEstacion.findAllByInspector(supervisor)
//            println "supervisor "+supervisor.nombre
//            println "estaciones- "+estaciones.estacion+"  "
            dash = Dashboard.findAllByEstacionInList(estaciones.estacion,[sort: "id"])
//            println "dash "+dash
        }else{
            dash = Dashboard.list([sort: "id"])
        }



        [dash: dash, search: params.search]
    }

    def analisisVentas(){
        def now = new Date()
        def lastMonth
        def lastYear
        use( TimeCategory ) {
            lastMonth = now - 1.months
            lastYear = lastMonth - 1.years
        }

        def cliente = Cliente.findByCodigoAndTipo(params.codigo,1)
        def estacion = Estacion.findByCodigoAndAplicacion(params.codigo,1)
        def responsable = Responsable.findByLogin(session.usuario.login)
        def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
        def analisis
        def fecha1 = new Date().parse("dd-MM-yyyy","01-"+lastMonth.format("MM-yyyy"))
        def fecha2 = new Date().parse("dd-MM-yyyy","31-"+lastMonth.format("MM-yyyy"))
        def fecha3 = new Date().parse("dd-MM-yyyy","01-"+lastYear.format("MM-yyyy"))
        def fecha4 = new Date().parse("dd-MM-yyyy","31-"+lastYear.format("MM-yyyy"))
        println "fecha 1 "+fecha1
        println "fecha 2 "+fecha2
        println "fecha 3 "+fecha3
        println "fecha 4 "+fecha4
        analisis=Analisis.withCriteria {
            eq("supervisor",supervisor)
            between("fecha",fecha1,fecha2)
            eq("estacion",estacion)
        }
        if(analisis.size()>0)
            analisis=analisis.first()
        else
            analisis=null
        def ventasActual = ['0101':0,'0103':0,'0121':0,'0174':0]
        def ventasAnterior = ['0101':0,'0103':0,'0121':0,'0174':0]
        def totalActual = 0
        def totalAnterior = 0

        Factura.findAllByClienteAndFechaBetween(cliente,fecha1,fecha2).each {f->
            if(f.condicion=='1'){
                totalActual+=f.pago
                switch (f.producto.codigo){
                    case '0101':
                        ventasActual['0101']+=f.pago
                        break;
                    case '0103':
                        ventasActual['0103']+=f.pago
                        break;
                    case '0121':
                        ventasActual['0121']+=f.pago
                        break;
                    case '0174':
                        ventasActual['0174']+=f.pago
                        break;
                }
            }

        }
        Factura.findAllByClienteAndFechaBetween(cliente,fecha3,fecha4).each {f->
            if(f.condicion=='1'){
                totalAnterior+=f.pago
                switch (f.producto.codigo){
                    case '0101':
                        ventasAnterior['0101']+=f.pago
                        break;
                    case '0103':
                        ventasAnterior['0103']+=f.pago
                        break;
                    case '0121':
                        ventasAnterior['0121']+=f.pago
                        break;
                    case '0174':
                        ventasAnterior['0174']+=f.pago
                        break;
                }
            }
        }
        println "ventas "+ventasActual+" anterior "+ventasAnterior


        [cliente:cliente,lastMonth:lastMonth,lastYear:lastYear,ventasActual:ventasActual,ventasAnterior:ventasAnterior,analisis:analisis,supervisor:supervisor,totalActual:totalActual,totalAnterior:totalAnterior]
    }

    def saveAnalisis(){
        println "params "+params
        def responsable = Responsable.findByLogin(session.usuario.login)
        def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
        if(supervisor){
            def analisis
            if(params.id && params.id!=""){
                analisis=Analisis.get(params.id)
            }else{
                analisis = new Analisis()
                analisis.fecha = new Date().parse("dd-MM-yyyy",params.fecha)
                analisis.supervisor = supervisor
                analisis.ventasMes=params.ventasMes.toDouble()
                analisis.ventasAnio=params.ventasAnio.toDouble()
                analisis.diferencia=params.diferencia.toDouble()
                analisis.porcentaje=params.porcentaje.toDouble()
                analisis.estacion=Estacion.findByCodigoAndAplicacion(params.estacion,1)
            }
            analisis.comentario=params.comentario
            analisis.save(flush: true)
            redirect(action: "listaSemaforos")
        }else{
            flash.message="El usuario ${session.usuario} no es supervisor"
            response.sendError(403)
        }

    }

    def historial(){
        def estacion = Estacion.findByCodigoAndAplicacion(params.codigo,1)
        def responsable = Responsable.findByLogin(session.usuario.login)
        def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
        def analisis = Analisis.findAllByEstacionAndSupervisor(estacion,supervisor)
        [analisis:analisis,estacion:estacion]
    }

    def editarAnalisis(){
        def analisis = Analisis.get(params.id)
        def lastMonth = analisis.fecha
        def lastYear
        use( TimeCategory ) {
            lastYear = lastMonth - 1.years
        }

        def cliente = Cliente.findByCodigoAndTipo(analisis.estacion.codigo,1)
        def supervisor = analisis.supervisor

        def ventasActual = 0
        def ventasAnterior = 0
        Factura.findAllByClienteAndFechaBetween(cliente,new Date().parse("dd-MM-yyyy","01-"+lastMonth.format("MM-yyyy")),new Date().parse("dd-MM-yyyy","31-"+lastMonth.format("MM-yyyy"))).each {f->
            if(f.condicion=='1')
                ventasActual+=f.pago
        }
        Factura.findAllByClienteAndFechaBetween(cliente,new Date().parse("dd-MM-yyyy","01-"+lastYear.format("MM-yyyy")),new Date().parse("dd-MM-yyyy","31-"+lastYear.format("MM-yyyy"))).each {f->
            if(f.condicion=='1')
                ventasAnterior+=f.pago
        }

        [cliente:cliente,lastMonth:lastMonth,lastYear:lastYear,ventasActual:ventasActual,ventasAnterior:ventasAnterior,analisis:analisis,supervisor:supervisor]
    }


    def listaRevision(){
        def supervisores = getSupervisores()
        supervisores=supervisores.sort{it.nombre}
        [supervisores: supervisores]
    }

    def tablaRevision(){
        //select codigo_cliente, nombre_cliente,codigo_supervisor from cliente  where codigo_supervisor is not null and codigo_aplicacion=1 and codigo_supervisor!='' and estado_cliente='A' and tipo_cliente=1;
        def supervisor = Inspector.findByCodigo(params.supervisor)
        def meses = ["Enero":"01","Febrero":"02","Marzo":"03","Abril":"04","Mayo":"05","Junio":"06","Julio":"07","Agosto":"08","Septiembre":"09","Octubre":"10","Noviembre":"11","Diciembre":"11"]
        def estaciones=InspectorEstacion.findAllByInspector(supervisor).estacion
//        def actual =12
        def actual = new Date().format("MM").toInteger()
        if(actual==12)
            actual++
        def anio = new Date().format("yyyy")
        def totales=[0,0,0,0,0,0,0,0,0,0,0,0]
        [estaciones:estaciones,supervisor: supervisor,meses:meses,actual:actual,anio:anio,totales:totales]
    }

    def verAnalisis(){
        def an = Analisis.get(params.id)
        def lastMonth = an.fecha
        def lastYear
        use( TimeCategory ) {
            lastYear = lastMonth - 1.years
        }

        [an:an,lastMonth: lastMonth,lastYear: lastYear]
    }

    def tablaRegistro(){
        def supervisores = getSupervisores()
        supervisores=supervisores.sort{it.nombre}
        def objetivos = ObjetivoSupervisores.list([sort: "periocidad",order: "desc"])
        def meses = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
        def colores = ["#CE464A","#BB594D","#A86C50","#FFA324","#e8ff61","#9feb87","#7AAB3A"]
//        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        def mes
        use( TimeCategory ) {
            mes = new Date() - 1.months

        }
        def anio =  mes.format("yyyy")
        def fecha = mes
        def mesString = mes.format("MMyyyy")
        [supervisores:supervisores,objetivos:objetivos,meses: meses,colores:colores,mes:mes.format("MM"),mesint:mes.format("MM").toInteger(),anio:anio,fecha:fecha,mesString:mesString]

    }

    def cumplirObjetivo(){
        println "params "+params
        def cump = new CumplimientoSupervisor()
        cump.fecha=new Date()
        cump.mes=params.mes
        cump.objetivo=ObjetivoSupervisores.get(params.objetivo)
        cump.supervisor = Inspector.findByCodigo(params.supervisor)
        if(!cump.save(flush: true))
            println "error save cump "+cump.errors
        render "ok"
    }


    def getSupervisores(){
        def sql = "select distinct c.CODIGO_SUPERVISOR,s.NOMBRE_SUPERVISOR\n" +
                "from CLIENTE c,SUPERVISORES s \n" +
                "where   c.CODIGO_SUPERVISOR=s.CODIGO_SUPERVISOR \n" +
                "and  TIPO_CLIENTE=1 \n" +
                "and ESTADO_CLIENTE = 'A' \n" +
                "order by 2"
        def cn = new Sql(dataSource_erp)
        def sups = []
        cn.eachRow(sql.toString()){r->
            sups.add(Inspector.findByCodigo(r["CODIGO_SUPERVISOR"]))
        }
        return sups
    }



    def registrarCumplimiento(){
        def objetivos = ObjetivoSupervisores.findAllByTipoAndCodigoNotEqual('S','VTES',[sort: 'periocidad',order: 'desc'])
        def responsable = Responsable.findByLogin(session.usuario.login)
        def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
        if(!supervisor)
            response.sendError(403)
        def meses = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
        def mes
        use( TimeCategory ) {
            mes = new Date() - 1.months

        }
        def anio =  mes.format("yyyy")
        def fecha = mes
        def mesString = mes.format("MMyyyy")
        [objetivos: objetivos,mesString: mesString,anio: anio,meses: meses,fecha: fecha,mesint: mes.format("MM").toInteger(),supervisor: supervisor]
    }

    def uploadObjetivo(){
        println "params "+params
        def objetivo = ObjetivoSupervisores.get(params.objetivo)
        def sup = Inspector.get(params.supervisor)
        def cump = null
        def pathPart = "supervisores/${sup.codigo}/"
        def path = servletContext.getRealPath("/") + pathPart
        new File(path).mkdirs()
        def f = request.getFile('file')
        if (f && !f.empty) {
            def parts = f.getOriginalFilename().split("\\.")
            //println "parts "+parts
            def ext = parts[1]
            def nombre = objetivo.codigo+ new Date().format("ddMMyyHHmmss")+"."+ext
            println "nombre "+nombre+" path "+path
            def pathFile = path + nombre
            try {
                f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                if(params.id){
                    cump=CumplimientoSupervisor.get(params.id)
                }else {
                    cump = new CumplimientoSupervisor()
                }
                cump.supervisor=sup
                cump.objetivo=objetivo
                cump.path=pathPart+nombre
                cump.observaciones=params.observaciones
                cump.fecha=new Date()
                if(objetivo.periocidad=="A"){
                    cump.mes = params.anio
                }else{
                    cump.mes = params.mes
                }
                if(!cump.save(flush: true))
                    println "error save cump "+cump.errors

            } catch (e) {
                flash.message = "Ha ocurrido un error al guardar"
                redirect(action: 'registrarCumplimiento')
                return
            }
        }else{
            if(params.id){
                cump=CumplimientoSupervisor.get(params.id)
                cump.observaciones=params.observaciones
                if(!cump.save(flush: true))
                    println "error save cump "+cump.errors
            }
        }


        redirect(action: 'registrarCumplimiento')
    }

    def listaObjetivos(){
        def supervisores = getSupervisores()
        supervisores=supervisores.sort{it.nombre}
        [supervisores: supervisores]
    }

    def tablaObjetivos(){
        def supervisor = Inspector.findByCodigo(params.supervisor)
        def enero = new Date().parse("dd-MM-yyy",'01-01-'+new Date().format("yyyy"))
        def diciembre = new Date().parse("dd-MM-yyy",'31-12-'+new Date().format("yyyy"))
        def objetivos = CumplimientoSupervisor.findAllBySupervisorAndFechaBetween(supervisor,enero,diciembre,[sort:"fecha"])
        [objetivos:objetivos,supervisor: supervisor]
    }


}
