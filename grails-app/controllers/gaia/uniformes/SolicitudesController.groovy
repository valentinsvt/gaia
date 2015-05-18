package gaia.uniformes

import gaia.Contratos.esicc.Pedido
import gaia.Contratos.esicc.PeriodoDotacion
import gaia.documentos.Inspector
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.seguridad.Shield

class SolicitudesController extends Shield {

    def solicitar(){
        println "wtf"
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
            println "error save detalle "+detalle.errors
        else{
            def data = params.data.split("W")
            data.each {
                if(it!="" && it.size()>2){
                    def datos = it.split(";")
                    def empleado = NominaEstacion.get(datos[1])
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
        def estacion = sol.estacion
        def detalle = DetallePedido.findAllByPedido(sol)
        [sol:sol,estacion: estacion,detalle: detalle]
    }
}
