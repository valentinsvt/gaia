package gaia.seguridad

class PruebasController {

    def links(){

        def usuarios = Persona.list()
        usuarios.each {
            println "usu-> "+it.nombre+" "+it.login+" "+it.password
            println "perfiles"
            def perf = Sesion.findAllByUsuario(it)
            perf.each {p->
                print " -----> "+p.perfil
            }
        }

    }
}
