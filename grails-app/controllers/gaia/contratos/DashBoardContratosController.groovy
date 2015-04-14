package gaia.contratos

import gaia.Contratos.DashBoardContratos
import gaia.parametros.Parametros
import gaia.seguridad.Shield

class DashBoardContratosController extends Shield {
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
            def pinturaWarning = 0
            def equipo = 0
            def equipoWarning = 0
            def colorContrato
            def colorPintura
            def colorEquipo
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
                switch (d.getColorSemaforoUniforme()[0]){
                    case colores[0]:
                        equipo++
                        break;
                    case colores[1]:
                        equipoWarning++
                        break;
                    case colores[2]:
                        break;
                }
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


            [contrato: contrato, contratoWarning:contratoWarning,pintura:pintura,pinturaWarning:pinturaWarning,equipo:equipo,equipoWarning:equipoWarning,total: total, colores: colores]
        }
    }


}
