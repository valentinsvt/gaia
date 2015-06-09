package gaia.uniformes

import gaia.Contratos.esicc.PeriodoDotacion
import gaia.Contratos.esicc.Tallas
import gaia.Contratos.esicc.Uniforme
import gaia.Contratos.esicc.UniformeTalla
import gaia.documentos.Inspector
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.seguridad.Shield

class SolicitudesController extends Shield {

    def mailService
    def pdfService

    def solicitar() {
        def estacion = Estacion.findByCodigoAndAplicacion(params.id, 1)
        def certificado = Certificado.findAllByEstacion(estacion, [sort: "fecha", order: "desc", max: 2])
        def errores = false
        if (certificado.size() > 0)
            certificado = certificado.first()
        else {
            errores = true
            certificado = null
        }
        def nomina = NominaEstacion.findAllByEstacionAndEstado(estacion, "A")
        if (nomina.size() == 0)
            errores = true
        def erroresTallas = ""
        nomina.each {
            def tallas = EmpleadoTalla.findAllByEmpleado(it)
            if (tallas.size() == 0) {
                errores = true
                erroresTallas += "El empleado(a) ${it.nombre} no tiene tallas registradas<br>"
            }
            tallas.each { et ->
                if (et.talla == null) {
                    errores = true
                    erroresTallas += "El empleado(a) ${et.empleado.nombre} no tiene registrado(a) una talla para ${et.uniforme.descripcion}<br>"
                }
            }
        }

        [estacion: estacion, certificado: certificado, nomina: nomina, errores: errores, erroresTalla: erroresTallas]
    }

    def detalle() {
        def estacion = Estacion.findByCodigoAndAplicacion(params.id, 1)
        def nomina = NominaEstacion.findAllByEstacionAndEstado(estacion, "A")
        def pedido
        def maximos = ["9": 2, "1": 2, "10": 4, "11": 4, "2": 1, "3": 1, "6": 4, "5": 4, "4": 2, "7": 2]

        if (params.pedido && params.pedido != "")
            pedido = PedidoUniformes.get(params.pedido)
        else {
            pedido = PedidoUniformes.findByEstado("P")
            if (!pedido) {
                def periodo = PeriodoDotacion.list([sort: "codigo", order: "desc"])?.first()
                pedido=PedidoUniformes.findByPeriodoAndEstacion(periodo,estacion)

                if(pedido) {
                    if(pedido.estado=="A" || pedido.estado=="S"){
                        flash.message="Ya existe una solicitud aprobada o pendiente de aprobación para el último perido de dotación (${periodo.descripcion})"
                        redirect(action: "listaSolicitudesEstacion",id: estacion.codigo)
                        return
                    }
                }
                pedido = new PedidoUniformes()
                def responsable = Responsable.findByLogin(session.usuario.login)
                def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
                pedido.periodo =periodo
                pedido.estacion = estacion
                pedido.supervisor = supervisor
                if (!pedido.save(flush: true))
                    println "error save pedido " + pedido.errors

            }
        }
        if(pedido?.estado!="P")
            response.sendError(403)
        if (nomina.size() == 0) {
            redirect(action: "solicitar", id: estacion.codigo)
        }




        [nomina: nomina, estacion: estacion, solicitud: pedido, maximos: maximos]
    }

    def saveDetalle(){
        //println "params "+params
//        data+=$(this).attr("empleado")+";"+$(this).attr("uniforme")+";"+$(this).attr("talla")+";"+$(this).val()+"W"

        def sol = PedidoUniformes.get(params.id)
        def data = params.data.split("W")
        def lastEmpleado = null
        data.each {d->
            if(d.size()>5){
                def datos = d.split(";")
                def empleado = NominaEstacion.get(datos[0])
                if(!lastEmpleado || lastEmpleado!=empleado){
                    def subdetalles = SubDetallePedido.findAll("from SubDetallePedido where pedido=${sol.id} and empleado=${empleado.id}")
                    subdetalles.each {
                        it.delete(flush: true)
                    }
                }
                lastEmpleado=empleado
                def uniforme = Uniforme.findByCodigo(datos[1])
                def talla = Tallas.findByCodigo(datos[2])
                def cantidad = datos[3].toInteger()
                if(cantidad>0){
                    def sb=new SubDetallePedido()
                    sb.pedido=sol
                    sb.empleado=empleado
                    sb.uniforme=uniforme
                    sb.talla=talla
                    sb.estacion=sol.estacion
                    sb.cantidad=cantidad
                    if(!sb.save(flush: true))
                        println "error save sub detalle"
                }



            }
        }

        render "ok"
    }

    def detallePedido(){
        //println "detalle "+params
        def pedido=PedidoUniformes.get(params.id)
        def estacion = pedido.estacion
        def error = false
        def detalle = SubDetallePedido.findAllByPedido(pedido)
        def nomina = NominaEstacion.findAllByEstacionAndEstado(estacion,"A")
        if(detalle.size()==0){
            def gorra = Uniforme.findByCodigo(2)
            def bota = Uniforme.findByCodigo(3)
            nomina.each {n->
                def tallaGorra = n.getTalla(gorra)
                def tallaBota = n.getTalla(bota)
                if(tallaGorra && tallaBota){
                    def dBota = new SubDetallePedido()
                    dBota.pedido=pedido
                    dBota.estacion=estacion
                    dBota.empleado=n
                    dBota.cantidad=1
                    dBota.talla=tallaBota
                    dBota.uniforme=bota
                    if(!dBota.save(flush: true))
                        println "error save bota "+dBota.errors
                    def dGorra = new SubDetallePedido()
                    dGorra.pedido=pedido
                    dGorra.estacion=estacion
                    dGorra.empleado=n
                    dGorra.cantidad=1
                    dGorra.talla=tallaGorra
                    dGorra.uniforme=gorra
                    if(!dGorra.save(flush: true))
                        println "error save gorra "+dGorra.errors
                    detalle.add(dBota)
                    detalle.add(dGorra)
                }else{
                    error = true
                    return
                }
            }
        }
        [detalle:detalle,pedido: pedido]
    }


    def enviar(){
        def sol = PedidoUniformes.get(params.id)
        if(!sol)
            response.sendError(403)
        if(sol?.estado!="P")
            response.sendError(403)
        def estacion = sol.estacion
        def nomina = NominaEstacion.findAllByEstacionAndEstado(estacion,"A")
        def detalle = []
        def error=false
        if(nomina.size()==0){
            redirect(action: "detalle",params: [id:estacion.codigo,pedido: sol])
            return
        }
        nomina.each {n->
            def sub = SubDetallePedido.findAllByPedidoAndEmpleado(sol,n)
            if(sub.size()==0){
                error=true
                return
            }else{
                detalle+=sub
            }
        }
        if(error) {
            redirect(action: "detalle", params: [id: estacion.codigo, pedido: sol])
            return
        }
        [sol:sol,estacion: estacion,detalle: detalle]
    }

    def enviarSolicitud(){
//        println "enviar "+params
        def sol = PedidoUniformes.get(params.id)
        sol.observaciones=params.observaciones
        sol.estado="S"
        sol.save(flush: true)
        mailService.sendMail {
            multipart true
//            to "valentinsvt@hotmail.com"
            to "diego.perez@petroleosyservicios.com"
            subject "Nueva solicitud de dotación"
            body( view:"mailSolicitudes",
                    model:[sol: sol])
            inline 'logo','image/png', new File('images/logo-login.png').readBytes()
//            inline 'logo','image/png', new File('./web-app/images/logo-login.png').readBytes()
        }

        redirect(action: "listaSolicitudesEstacion",id: sol.estacion.codigo)
    }

    def listaSolicitudesEstacion(){
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
        def solicitudes= PedidoUniformes.findAllByEstacion(estacion,[sort: "registro",order:"desc"])
        [estacion:estacion,solicitudes:solicitudes ]
    }

    def verSolicitud(){
        def sol = PedidoUniformes.get(params.pedido)
        def subdetalle
        if(sol.estado=="A"){
            subdetalle = SubDetallePedido.findAllByPedidoAndPrecioGreaterThan(sol,0)
        }else{
            subdetalle = SubDetallePedido.findAllByPedido(sol)
        }

        [sol:sol,subdetalle:subdetalle]
    }

    def listaPendientes(){
        def sols = PedidoUniformes.findAllByEstado("S")
        [sols:sols]
    }
    def revisar(){
        def sol = PedidoUniformes.get(params.pedido)
        def certificado = Certificado.findAllByEstacion(sol.estacion,[sort: "fecha",order: "desc",max:2])
        if(certificado.size()>0)
            certificado=certificado.first()
        def detalle = SubDetallePedido.findAllByPedido(sol)
        detalle=detalle.sort{it.uniforme.descripcion}
        def tablaResumida = ["Botas":["cantidad":0,"detalle":[]],"Gorras":["cantidad":0,"detalle":["Única"]],"Overoles":["cantidad":0,"detalle":[]],"Pantalones":["cantidad":0,"detalle":[]],"Camisetas":["cantidad":0,"detalle":[]]]
        def overoles = [1,4]
        def camisetas = [10,11,5,6]
        def pantalones =[9,7]
        detalle.each {d->
            switch (d.uniforme.codigo){
                case 3:
                    tablaResumida["Botas"]["cantidad"]+=d.cantidad
                    tablaResumida["Botas"]["detalle"].add(""+d.talla.talla)
                    break;
                case 2:
                    tablaResumida["Gorras"]["cantidad"]+=d.cantidad
                    break;
                default:
                    if(overoles.contains(d.uniforme.codigo)){
                        tablaResumida["Overoles"]["cantidad"]+=d.cantidad
                        tablaResumida["Overoles"]["detalle"].add("${d.cantidad} X "+d.talla.talla)
                    }
                    if(pantalones.contains(d.uniforme.codigo)){
                        tablaResumida["Pantalones"]["cantidad"]+=d.cantidad
                        tablaResumida["Pantalones"]["detalle"].add("${d.cantidad} X "+d.talla.talla)
                    }
                    if(camisetas.contains(d.uniforme.codigo)){
                        tablaResumida["Camisetas"]["cantidad"]+=d.cantidad
                        tablaResumida["Camisetas"]["detalle"].add("${d.cantidad} X ${d.uniforme.descripcion} - "+d.talla.talla)
                    }
                    break;
            }
        }
        [sol:sol,detalle: detalle,certificado: certificado,resumen:tablaResumida]
    }

    def aprobarSolicitud(){
//        println "aprobar "+params
        if(session.usuario.password!=params.auth.encodeAsMD5()) {
            flash.message = "Contraseña incorrecta "
//            redirect(action: "revisar",params:[pedido:params.id])
//            return
        }
        def sol = PedidoUniformes.get(params.id)
        def mail = sol.supervisor.mail

        if(sol.estado!="S")
            response.sendError(403)
        else{
            sol.estado="A"
            if(sol.save(flush: true)){
                def data = params.datos.split(";")
                data.each {d->
                    if(d.size()>0){
                        def sub =SubDetallePedido.get(d)
                        sub.precio=sub.uniforme.precio
                        if(!sub.save(flush: true))
                            println "error save subdetalle "+sub.errors
                    }
                }
                mailService.sendMail {
                    multipart true
//                    to "valentinsvt@hotmail.com"
                     to mail
                    subject "Solicitud aprobada"
                    body( view:"solicitudAprobada",
                            model:[sol: sol])
                    inline 'logo','image/png', new File('images/logo-login.png').readBytes()
//                    inline 'logo','image/png', new File('./web-app/images/logo-login.png').readBytes()
                }
                flash.message="Solicitud aprobada"
                redirect(action: "verSolicitud",params: ["pedido":sol.id])
                return
            }else{
                println "error save sol "+sol.errors
                flash.message="Error interno"
                redirect(action: "revisar",params:[pedido:params.id])
                return
            }

        }

    }
    def negarSolicitud(){
        def sol = PedidoUniformes.get(params.id)
        if(sol.estado!="S")
            response.sendError(403)
        else{
            sol.estado="N"
            sol.save(flush: true)
            flash.message="Solicitud negada"
            redirect(action: "listaPendientes")
        }
    }

    def reporteResumido(){

    }

    def dotacionesPorItem(){

        def periodo = PeriodoDotacion.findByCodigo(params.periodo)
        def supervisores = []
        if(params.supervisor=="-1")
            supervisores=Inspector.list([sort: "nombre"])
        else
            supervisores.add(Inspector.findByCodigo(params.supervisor))
        def datos = [:]
        def uniformes = Uniforme.list()
        supervisores.each {
            datos.put(it.nombre,[:])
            uniformes.each {u->
                datos[it.nombre].put(u.descripcion,0)
            }
        }
        datos.put("TOTAL GENERAL",[:])
        uniformes.each {u->
            datos["TOTAL GENERAL"].put(u.descripcion,0)
        }
        def dotaciones = PedidoUniformes.findAllBySupervisorInListAndPeriodo(supervisores,periodo)
        dotaciones.each {d->
            if(d.estado=="A"){
                SubDetallePedido.findAllByPedido(d).each {sd->
                    datos[d.supervisor.nombre][sd.uniforme.descripcion]+=sd.cantidad
                    datos["TOTAL GENERAL"][sd.uniforme.descripcion]+=sd.cantidad
                }

            }
        }
        println "datos "+datos
        [datos:datos,uniformes:uniformes]
    }


    def reportePorItem(){

    }


    def dotacionesPorUniforme(){
        def periodo = PeriodoDotacion.findByCodigo(params.periodo)
        def uniforme = Uniforme.findByCodigo(params.uniforme)
        def pedidos = PedidoUniformes.findAllByPeriodoAndEstado(periodo,"A")
        def tallas =  Tallas.findAllByCodigoInList(UniformeTalla.findAllByUniforme(uniforme).codigo)
        def datos = [:]
        def supervisores = Inspector.list([sort: "nombre"])
        def total = 0
        supervisores.each {
            datos.put(it.nombre,[:])
            tallas.each {t->
                datos[it.nombre].put(t.talla,0)
            }
        }
        datos.put("TOTAL GENERAL",[:])
        tallas.each {u->
            datos["TOTAL GENERAL"].put(u.talla,0)
        }

        SubDetallePedido.findAllByPedidoInListAndUniforme(pedidos,uniforme).each {sd->
            datos[sd.pedido.supervisor.nombre][sd.talla.talla]+=sd.cantidad
            datos["TOTAL GENERAL"][sd.talla.talla]+=sd.cantidad
            total+=sd.cantidad
        }
        [datos:datos,tallas:tallas,total:total,uniforme:uniforme]
    }

    def reportePorSupervisor(){

    }

    def dotacionesPorSupervisor(){
        def periodo = PeriodoDotacion.findByCodigo(params.periodo)
        def supervisor =Inspector.findByCodigo(params.supervisor)

        def pedidos = PedidoUniformes.findAll("from PedidoUniformes where supervisor=${supervisor.id} and periodo=${periodo.codigo} and estado='A'")
        pedidos=pedidos.sort{it.estacion.codigo}
        def datos = [:]
        pedidos.each {p->
            def sd = SubDetallePedido.findAllByPedido(p)
            sd=sd.sort{it.uniforme.descripcion}
            datos.put(p.estacion.nombre,[:])
            def actual = datos[p.estacion.nombre]
            sd.each {s->
                if(!actual[s.uniforme.descripcion]){
                    def tmp = [:]
                    tmp.put([s.talla.talla,s.cantidad])
                    actual.put(s.uniforme.descripcion,tmp)
                }else{
                    if(!actual[s.uniforme.descripcion][s.talla.talla]){
                        def tmp = [:]
                        tmp.put(s.talla.talla,s.cantidad)
                        actual[s.uniforme.descripcion].put(s.talla.talla,s.cantidad)
                    }else{
                        actual[s.uniforme.descripcion][s.talla.talla]+=s.cantidad
                    }
                }
            }
        }

        [supervisor:supervisor,datos: datos]
    }

}
