package gaia.legal

import gaia.Contratos.Adendum
import gaia.Contratos.Cliente
import gaia.Contratos.DashBoardContratos
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.parametros.Parametros

class LegalController {
    static sistema="LGAL"
    def index() {
        redirect(action: 'dash')
    }

    def dash(){
        def dash = DashBoardContratos.list([sort: "id"])
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        def contrato = 0
        def contratoWarning = 0
        def total = 0
        dash.each { d ->

            switch (d.getColorSemaforoContrato(check)[0]){
                case colores[0]:
                    contrato++
                    break;
                case colores[1]:
                    contratoWarning++
                    break;
                case colores[2]:
                    break;
            }
            total++
        }


        [contrato: contrato, contratoWarning:contratoWarning,total: total, colores: colores]

    }

    def listaSemaforos() {
        def estaciones
        def dash
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        if (session.tipo == "cliente") {
            def responsable = Responsable.findByLogin(session.usuario.login)
            def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
            estaciones = InspectorEstacion.findAllByInspector(supervisor)
            dash = DashBoardContratos.findAllByEstacionInList(estaciones.estacion, [sort: "id"])
        } else {
            dash = DashBoardContratos.list([sort: "id"])
        }

        [dash: dash, search: params.search, check: check]
    }

    def showEstacion(){
        def estacion
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        estacion = Estacion.findByCodigoAndAplicacion(params.id, 1)//        }
        def dash = DashBoardContratos.findByEstacion(estacion)
        def contratos= Adendum.findAllByCliente(estacion.codigo,[sort:"fin",order:"desc"])
        def cliente = Cliente.findByCodigoAndTipo(params.id,1)
        def inicial = [:]
        inicial["tipo"] = "INICIAL"
        inicial["inicio"] = cliente.fechaPrimerContrato
        inicial["fin"] = cliente.fechaTerminaContrato

        [estacion: estacion, params: params,dash:dash,contratos: contratos,inicial:inicial,cliente:cliente,check: check]

    }


}
