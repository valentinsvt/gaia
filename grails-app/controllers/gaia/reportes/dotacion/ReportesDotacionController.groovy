package gaia.reportes.dotacion

import gaia.Contratos.DashBoardContratos
import gaia.Contratos.esicc.Pedido
import gaia.Contratos.esicc.PeriodoDotacion

class ReportesDotacionController {

    def reporteDotaciones(){

    }

    def dotaciones(){
        def periodo = PeriodoDotacion.findByCodigo(params.periodo)
        def dash = DashBoardContratos.list([sort: "id"])
        def dotaciones = []
        def sinDotacion = [:]
        dash.each {d->
            def dotacion = Pedido.findByEstacionAndPeriodo(d.estacion,periodo)
            if(dotacion){
                if(dotacion.estado=="A")
                    dotaciones.add(dotacion)
                else
                    sinDotacion.put(d,dotacion)
            }else{
                sinDotacion.put(d,"N.A.")
            }


        }
       return  [dotaciones:dotaciones,periodo:periodo,sinDotacion:sinDotacion]
    }
    def dotacionesPdf(){
        def periodo = PeriodoDotacion.findByCodigo(params.periodo)
        def dash = DashBoardContratos.list([sort: "id"])
        def dotaciones = []
        def sinDotacion = [:]
        dash.each {d->
            def dotacion = Pedido.findByEstacionAndPeriodo(d.estacion,periodo)
            if(dotacion){
                if(dotacion.estado=="A")
                    dotaciones.add(dotacion)
                else
                    sinDotacion.put(d,dotacion)
            }else{
                sinDotacion.put(d,"N.A.")
            }


        }
        return  [dotaciones:dotaciones,periodo:periodo,sinDotacion:sinDotacion]
    }
}
