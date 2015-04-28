package gaia.pintura

import gaia.Contratos.Cliente
import gaia.Contratos.DashBoardContratos
import gaia.Contratos.DetallePintura
import gaia.Contratos.SubDetallePintura
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.parametros.Parametros
import gaia.seguridad.Shield

class ModuloPinturaController extends Shield {
    static final sistema="PNTR"
    def index() {

        redirect(action: 'dash')
    }

    def dash(){

        def dash = DashBoardContratos.list([sort: "id"])
        def now = new Date()
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        //println "check "+check.format("dd-MM-yyyy")
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]

        def pintura = 0
        def pinturaWarning = 0

        def total = 0
        dash.each { d ->


            switch (d.getColorSemaforoPintura()[0]){
                case colores[0]:
                    pintura++
                    break;
                case colores[1]:
                    pinturaWarning++
                    break;
                case colores[2]:
                    break;
            }
            total++
        }


        [pintura:pintura,pinturaWarning:pinturaWarning,total: total, colores: colores]
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

        def cliente = Cliente.findByCodigoAndTipo(params.id,1)

        def pinturas = DetallePintura.findAllByCliente(estacion.codigo,[sort: "fin",order: "desc"])



        [estacion: estacion, params: params,dash:dash,check:check,pinturas:pinturas,cliente:cliente]

    }



    def verPintura(){
        def detalle = SubDetallePintura.findAllBySecuencialAndCliente(params.secuencial,params.cliente)
        [detalle:detalle]
    }


}
