package gaia.seguridad

import gaia.documentos.Dashboard
import gaia.estaciones.Estacion

class PruebasController {

    def links(){

        def usuario = Persona.findByLogin("OROZCOP")
        def perfil = Perfil.findByCodigo("1")
        println "usuario "+usuario.nombre
        def token =""
        token+= new Date().format("ddMMyyyy").encodeAsMD5()
        token=usuario.login+"|"+perfil.codigo.encodeAsMD5()+"|"+token+"|"+usuario.password
        def linkUsu = "" +g.createLink(action: 'remoteLogin',controller: 'login')+"?token="+token
        def estacion = Dashboard.list().pop().estacion
        perfil = Perfil.findByDescripcion("Cliente")
        token=""
        token+= new Date().format("ddMMyyyy").encodeAsMD5()
        token=estacion.ruc+"|"+perfil.codigo.encodeAsMD5()+"|"+token+"|"+estacion.codigo
        def linkEstacion = g.createLink(action: 'remoteLogin',controller: 'login')+"?token="+token
        println "estacion "+estacion.nombre
        [linkUsu:linkUsu,linkEstacion:linkEstacion]

    }
}
