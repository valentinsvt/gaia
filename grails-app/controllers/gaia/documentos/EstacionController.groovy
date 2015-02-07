package gaia.documentos

import gaia.estaciones.Estacion
import gaia.seguridad.Shield

class EstacionController extends Shield {

    def showEstacion(){
        def estacion
        if(session.tipo=="cliente"){
            estacion = session.usuario
        }else{
            estacion = Estacion.findByRuc(params.estacion)
        }
        [estacion:estacion]
    }

    def listaSemaforos(){
        def dash = Dashboard.list([sort: "id"])

        [dash:dash,search:params.search]
    }
}
