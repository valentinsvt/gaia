package gaia.seguridad

import gaia.alertas.Alerta
import gaia.documentos.Dashboard
import gaia.documentos.Documento
import gaia.estaciones.Estacion

class InicioController extends Shield {
    static final sistema="T"
    def index() {
        session.sistema = Sistema.findByCodigo("T")

    }

    def modulos(){

        def sistema = Sistema.findByCodigo(params.sistema)
        session.sistema=sistema
//        println "controlador "+sistema.controlador.nombre
        redirect(controller: sistema.controlador.nombre)


    }


    def demoUI() {

    }

    def parametros() {

    }
}


