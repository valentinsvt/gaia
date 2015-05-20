package gaia.uniformes

import gaia.Contratos.esicc.PeriodoDotacion
import gaia.Contratos.esicc.Tallas
import gaia.Contratos.esicc.Uniforme
import gaia.documentos.Inspector
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.seguridad.Shield

class SolicitudesController extends Shield {

    def mailService

    def solicitar(){
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
        def certificado = Certificado.findAllByEstacion(estacion,[sort: "fecha",order: "desc",max:2])
        def errores = false
        if(certificado.size()>0)
            certificado=certificado.first()
        else {
            errores=true
            certificado = null
        }
        def nomina = NominaEstacion.findAllByEstacionAndEstado(estacion,"A")
        if(nomina.size()==0)
            errores=true
        def erroresTallas=""
        nomina.each {
            def tallas =  EmpleadoTalla.findAllByEmpleado(it)
            if(tallas.size()==0){
                errores=true
                erroresTallas+="El empleado(a) ${it.nombre} no tiene tallas registradas<br>"
            }
            tallas.each {et->
                if(et.talla==null){
                    errores=true
                    erroresTallas+="El empleado(a) ${et.empleado.nombre} no tiene registrado(a) una talla para ${et.uniforme.descripcion}<br>"
                }
            }
        }

        [estacion:estacion,certificado:certificado,nomina:nomina,errores:errores,erroresTalla:erroresTallas]
    }

    def detalle(){
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
        def nomina = NominaEstacion.findAllByEstacionAndEstado(estacion,"A")
        def pedido
        if(params.pedido && params.pedido!="")
            pedido=PedidoUniformes.get(params.pedido)
        else{
            pedido = PedidoUniformes.findByEstado("P")
        }
        if(nomina.size()==0){
            redirect(action: "solicitar",id: estacion.codigo)
        }
        [nomina:nomina,estacion: estacion,solicitud:pedido]
    }

    def verKit(){
        def kit = Kit.get(params.id)
        def detalle = DetalleKit.findAllByKit(kit)
        def solicitud = null
        [detalle:detalle,kit:kit]
    }

    def guardarSolicitud(){
        println "save sol "+params
        def sol
        def responsable = Responsable.findByLogin(session.usuario.login)
        def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
        if(params.id && params.id!=""){
            sol = PedidoUniformes.get(params.id)
        }else{
            sol = new PedidoUniformes()
        }
        sol.periodo=PeriodoDotacion.findByCodigo(params.periodo)
        sol.estacion=Estacion.findByCodigoAndAplicacion(params.estacion,1)
        sol.supervisor = supervisor
        sol.estado="P"
        if(!sol.save(flush: true))
            println "error save detalle "+sol.errors
        else{
            def data = params.data.split("W")
            data.each {
                if(it!="" && it.size()>2){
                    def datos = it.split(";")
//                    println "datos "+datos
                    def empleado = NominaEstacion.get(datos[0])
                    def detalle = DetallePedido.findByEmpleadoAndPedido(empleado,sol)
                    if(!detalle)
                        detalle=new DetallePedido()
                    detalle.empleado=empleado
                    detalle.kit=Kit.get(datos[1])
                    detalle.pedido=sol
                    if(!detalle.save(flush: true))
                        println "error save detalle "+detalle.errors
                }
            }
        }

        redirect(action: "enviar",id: sol.id)
    }

    def enviar(){
        def sol = PedidoUniformes.get(params.id)
        if(!sol)
            response.sendError(403)
        def estacion = sol.estacion
        def detalle = DetallePedido.findAllByPedido(sol)
        [sol:sol,estacion: estacion,detalle: detalle]
    }

    def enviarSolicitud(){
//        println "enviar "+params
        def sol = PedidoUniformes.get(params.id)
        sol.observaciones=params.observaciones
        sol.estado="S"
        sol.save(flush: true)
//        mailService.sendMail {
//            to "valentinsvt@hotmail.com"
////            to "diego.perez@petroleosyservicios.com"
//            subject "Nueva solicitud de dotación"
//            body( view:"/mailSolicitudes",
//                    model:[sol: sol])
//        }
        /*Todo aqui enviar email.. generar alerta*/
        redirect(action: "listaSolicitudesEstacion",id: sol.estacion.codigo)
    }

    def listaSolicitudesEstacion(){
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
        def solicitudes= PedidoUniformes.findAllByEstacion(estacion,[sort: "registro",order:"desc"])
        [estacion:estacion,solicitudes:solicitudes ]
    }

    def verSolicitud(){
        def sol = PedidoUniformes.get(params.pedido)
        def detalle = DetallePedido.findAllByPedido(sol)
        def subdetalle = SubDetallePedido.findAllByPedido(sol)
        mailService.sendMail {
            multipart true
            to "valentinsvt@hotmail.com"
//            to "diego.perez@petroleosyservicios.com"
            subject "Nueva solicitud de dotación"
            body( view:"mailSolicitudes",
                    controller:"solicitudes",
                    model:[sol: sol])
            inline 'logo','image/png', new File('./web-app/images/logo-login.png').readBytes()
        }
        [sol:sol,detalle: detalle,subdetalle:subdetalle]
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
        def detalle = DetallePedido.findAllByPedido(sol)
        [sol:sol,detalle: detalle,certificado: certificado]
    }

    def aprobarSolicitud(){
//        println "aprobar "+params
        if(session.usuario.password!=params.auth.encodeAsMD5()) {
            flash.message = "Contraseña incorrecta "
//            redirect(action: "revisar",params:[pedido:params.id])
//            return
        }
        def sol = PedidoUniformes.get(params.id)
        if(sol.estado!="S")
            response.sendError(403)
        else{
            sol.estado="A"
            if(sol.save(flush: true)){
                def data = params.datos.split("W")
                data.each {d->
                    if(d.size()>4){
//                        data+=""+uniforme+";"+talla+";"+empleado+";"+cantidad+"W"
                        def datos = d.split(";")
//                        println "datos "+datos
                        def sub = new SubDetallePedido()
                        def unfirme = Uniforme.findByCodigo(datos[0])
                        sub.pedido=sol
                        sub.cantidad=datos[3].toInteger()
                        sub.empleado=NominaEstacion.get(datos[2])
                        sub.uniforme = unfirme
                        sub.talla=Tallas.findByCodigo(datos[1])
                        sub.precio = Uniforme.findByCodigo(datos[0]).precio
                        sub.estacion=sol.estacion
                        if(!sub.save(flush: true))
                            println "error save subdetalle "+sub.errors
                    }
                }
                flash.message="Solicitud aprobada"
                redirect(action: "listaPendientes")
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

}
