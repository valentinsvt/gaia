package gaia.agenda

import gaia.Contratos.Cliente
import gaia.seguridad.Shield

class AgendaController extends Shield {
    static sistema ="AGND"
    def index(){

        redirect(action: 'dash')

    }

    def dash(){
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        def activas = 0
        def suspendidas = 0
        def cesantes = 0
        def activasI = 0
        def suspendidasI = 0
        def cesantesI = 0
        def total=0
        Cliente.list().each{c->
            total++
            switch (c.estado){
                case "A":
                    if(c.tipo==1)
                        activas++
                    if(c.tipo==2)
                        activasI++
                    break;
                case "S":
                    if(c.tipo==1)
                        suspendidas++
                    if(c.tipo==2)
                        suspendidasI++
                    break;
                case "C":
                    if(c.tipo==1)
                        cesantes++
                    if(c.tipo==2)
                        cesantesI++
                    break;
                default:
                    println "default "+c.codigo+"  "+c.nombre+" "+c.estado
                    break;
            }
        }

        [activas:activas,activasI:activasI,suspendidas:suspendidas,suspendidasI:suspendidasI,cesantes:cesantes,cesantesI:cesantesI,total:total,colores:colores]
    }

    def listaIndustrias(){
        def industrias =  Cliente.findAllByTipoAndEstadoInList(2,["A","S","C"],[sort:"codigo"])
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        [industrias:industrias,colores: colores,search:params.search]
    }
    def listaEstacion(){
        def estaciones =  Cliente.findAllByTipoAndEstadoInList(1,["A","S","C"],[sort:"codigo"])
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]
        [estaciones:estaciones,colores: colores,search:params.search]
    }

}
