package gaia.supervisores

import gaia.Contratos.Cliente
import gaia.documentos.Dashboard
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.facturacion.Factura
import gaia.seguridad.Shield
import groovy.time.TimeCategory

class SupervisoresController  extends Shield{
    static sistema="SPVS"
    def index() {
        if(session.tipo=="cliente") {
            redirect(action: "listaSemaforos")
        }else{
            redirect(action: "dash")
        }
    }

    def dash(){
        def supervisores = Inspector.list([sort: "nombre"])
        def objetivos = ObjetivoSupervisores.list([sort: "periocidad",order: "desc"])
        def meses = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        def mes = new java.util.Date().format("MM")
        def anio =  new java.util.Date().format("yyyy")
        [supervisores:supervisores,objetivos:objetivos,meses: meses,colores:colores,mes:mes,mesint:mes.toInteger(),anio:anio]
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
        def responsable = Responsable.findByLogin(session.usuario.login)
        def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
        def analisis
        analisis=Analisis.withCriteria {
            eq("supervisor",supervisor)
            between("fecha",new Date().parse("dd-MM-yyyy","01-"+lastMonth.format("MM-yyyy")),new Date().parse("dd-MM-yyyy","31-"+lastMonth.format("MM-yyyy")))
            eq("estacion",cliente)
        }
        if(analisis.size()>0)
            analisis=analisis.first()
        else
            analisis=null
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
        def supervisores = Inspector.list([sort: "nombre"])

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

}
