package gaia.administracion

import gaia.seguridad.Perfil
import gaia.seguridad.Permiso

class AdministracionController {

    static sistema= "ADMN"
    def index() {

    }

    def listaUsuarios(){
        def perfiles = Perfil.list([sort:"descripcion"])
        [perfiles:perfiles]
    }

    def detallesPerfil_ajax(){
        def perfil = Perfil.findByCodigo(params.id)
        def acciones = Permiso.findAllByPerfil(perfil).accion
        acciones.sort{
            it.sistema.nombre
        }
        [acciones:acciones]
    }

}
