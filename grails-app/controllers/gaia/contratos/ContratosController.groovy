package gaia.contratos

import gaia.Contratos.Adendum
import gaia.Contratos.Cliente
import gaia.Contratos.DashBoardContratos
import gaia.Contratos.DetalleEgreso
import gaia.Contratos.DetallePintura
import gaia.Contratos.Egreso
import gaia.Contratos.SubDetallePintura
import gaia.Contratos.esicc.Dotacion
import gaia.Contratos.esicc.Pedido
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.parametros.Parametros
import gaia.seguridad.Shield
import groovy.sql.Sql


class ContratosController extends Shield {
    static final sistema="CNTR"


    def index(){
        if(session.tipo=="cliente"){
            redirect(action: 'listaSemaforos')
        }else{
            redirect(controller: 'dashBoardContratos',action: 'dash')
        }
    }

    def listaSemaforos(){
        def estaciones
        def dash
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        if(session.tipo=="cliente"){
            def responsable = Responsable.findByLogin(session.usuario.login)
            def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
            estaciones=InspectorEstacion.findAllByInspector(supervisor)
            dash = DashBoardContratos.findAllByEstacionInList(estaciones.estacion,[sort: "id"])
        }else{
            dash = DashBoardContratos.list([sort: "id"])
        }

        [dash: dash, search: params.search,check:check]
    }

    def showEstacion(){
        def estacion
//        if (session.tipo == "cliente") {
//            estacion = session.usuario
//        } else {
        estacion = Estacion.findByCodigoAndAplicacion(params.id, 1)
//        }
        def dash = DashBoardContratos.findByEstacion(estacion)
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        def contratos= Adendum.findAllByCliente(estacion.codigo,[sort:"fin",order:"desc"])
        def cliente = Cliente.findByCodigoAndTipo(params.id,1)
        def inicial = [:]
        inicial["tipo"] = "INICIAL"
        inicial["inicio"] = cliente.fechaPrimerContrato
        inicial["fin"] = cliente.fechaTerminaContrato


        def uniformes = Pedido.findAllByEstacion(estacion,[sort:"fecha",order: "desc"])
        def pinturas = DetallePintura.findAllByCliente(estacion.codigo,[sort: "fin",order: "desc"])



        [estacion: estacion, contratos: contratos, params: params,dash:dash,inicial:inicial,check:check,uniformes:uniformes,pinturas:pinturas,cliente:cliente]

    }

    def verUniforme(){

        def pedido = Pedido.findByCodigo(params.dotacion)
        def detalle = Dotacion.findAllByPedido(pedido)
        [pedido:pedido,detalle:detalle]

    }

    def verPintura(){
        def detalle = SubDetallePintura.findAllBySecuencialAndCliente(params.secuencial,params.cliente)
        [detalle:detalle]
    }

    def show_ajax() {

        if (params.id) {
            def estacionInstance = Estacion.findByCodigoAndAplicacion(params.id, 1)
            def cliente = Cliente.findByCodigoAndTipo(params.id, 1)
            if (!estacionInstance) {
                render "ERROR*No se encontró Estacion."
                return
            }
            return [estacionInstance: estacionInstance,cliente: cliente]
        } else {
            render "ERROR*No se encontró Estacion."
        }
    } //show para cargar con ajax en un dialog
}
