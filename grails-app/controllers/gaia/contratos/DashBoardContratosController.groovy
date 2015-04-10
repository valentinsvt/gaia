package gaia.contratos

import gaia.Contratos.DashBoardContratos
import gaia.parametros.Parametros

class DashBoardContratosController {
    static final sistema="CNTR"
    def dash(){
        if(session.tipo=="cliente") {
            redirect(controller: "contratos", action: "listaSemaforos")
        }else {
            def dash = DashBoardContratos.list([sort: "id"])
            def now = new Date()
            def dias = Parametros.getDiasContrato()
            def check = new Date().plus(dias)
            //println "check "+check.format("dd-MM-yyyy")
            def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
            def contrato = 0
            def contratoWarning = 0
            def pintura = 0
            def equipo = 0
            def colorContrato
            def colorPintura
            def colorEquipo
            def total = 0
            dash.each { d ->
                if (d.ultimoContrato) {
                    if (d.ultimoContrato > now) {
                        if(d.ultimoContrato<check){
                            contratoWarning++
                        }else{
                            contrato++
                        }

                    }
                }
                total++
            }


            [contrato: contrato, contratoWarning:contratoWarning,total: total, colores: colores]
        }
    }


}
