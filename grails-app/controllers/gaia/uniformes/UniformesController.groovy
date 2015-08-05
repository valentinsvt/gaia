package gaia.uniformes

import gaia.Contratos.Cliente
import gaia.Contratos.DashBoardContratos

import gaia.Contratos.esicc.Pedido
import gaia.Contratos.esicc.Tallas
import gaia.Contratos.esicc.Uniforme
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.parametros.Parametros

class UniformesController {

    static sistema="UNFR"

    def index() {
        redirect(action: "dash")
    }

    def dash(){
        def dash = DashBoardContratos.list([sort: "id"])
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        //println "check "+check.format("dd-MM-yyyy")
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]

        def equipo = 0
        def equipoWarning = 0
        def total = 0
        dash.each { d ->

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

            total++
        }


        [equipo:equipo,equipoWarning:equipoWarning,total: total, colores: colores]
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
//        if (session.tipo == "cliente") {
//            estacion = session.usuario
//        } else {
        estacion = Estacion.findByCodigoAndAplicacion(params.id, 1)//        }
        def dash = DashBoardContratos.findByEstacion(estacion)
        def uniformes = Pedido.findAllByEstacion(estacion,[sort:"fecha",order: "desc"])

        def cliente = Cliente.findByCodigoAndTipo(params.id,1)

        [estacion: estacion, params: params,dash:dash,uniformes:uniformes,cliente:cliente]

    }

    def empleados(){
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
        def certificado = Certificado.findAllByEstacion(estacion,[sort: "fecha",order: "desc",max:2])
        if(certificado.size()>0)
            certificado=certificado.first()
        else
            certificado=null
        def nomina = NominaEstacion.findAllByEstacion(estacion)
        if(!certificado){
            flash.message = 'La estación no tiene registrado ningún certificado del IESS. Por favor, registrelo seleccionando un archivo (PDF) y posteriormente dando clic en el botón  <a href="#"  class=" btn btn-success btn-sm" style="display: inline-block;margin-top: -5px">\n' +
                    '                            <i  class="fa fa-upload"></i> Subir\n' +
                    '                        </a>'
            flash.tipo = "error"
            flash.icon = "alert"
        }
        [estacion:estacion,certificado:certificado,nomina:nomina]
        /*select u.uni_codigo,n.uni_descripcion,t.tal_talla from uniforme_talla u,tallas t,uniforme n where u.tal_codigo=t.tal_codigo and n.uni_codigo=u.uni_codigo;*/
    }

    def addEmpleado(){
        def nombre = params.nombre
        def cedula = params.cedula
        def sexo = params.sexo
        def estacion = Estacion.findByCodigoAndAplicacion(params.estacion,1)
        def empleado = NominaEstacion.findByCedula(params.cedula)
        if(!empleado)
            empleado=new NominaEstacion()
        empleado.nombre=params.nombre
        empleado.sexo=params.sexo
        empleado.cedula=params.cedula
        empleado.estacion=estacion
        if(!empleado.save(flush: true)){
            println "error save empleado "+params
        }
        redirect(action: "listaEmpleados",id:estacion.codigo)
    }

    def listaEmpleados(){
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)
        def nomina = NominaEstacion.findAllByEstacion(estacion)
        [nomina:nomina,estacion: estacion]
    }

    def cambiarEstado(){
//        println "params "+params
        def empleado = NominaEstacion.get(params.id)
        if(empleado.estado=="A")
            empleado.estado="D"
        else
            empleado.estado="A"
        empleado.save(flush: true)
        redirect(action: "listaEmpleados",id:empleado.estacion.codigo)
    }

    def subirCertificado(){
        def f = request.getFile('file')
        def estacion = Estacion.findByCodigoAndAplicacion(params.id,1)

        byte b
        def ext2
        def msg = ""

        if(f && !f.empty){
            println "no es empty "+f
            def nombre = f.getOriginalFilename()
            def parts2 = nombre.split("\\.")
            nombre = ""
            parts2.eachWithIndex { obj, i ->
                if (i < parts2.size() - 1) {
                    nombre += obj
                } else {
                    ext2 = obj
                }
            }
            def path = servletContext.getRealPath("/") + "certificados/" + estacion.codigo + "/"
            def pathLocal = "certificados/" + estacion.codigo + "/"
            if(ext2 == 'pdf' || ext2 == 'PDF'){
                /* upload */
                new File(path).mkdirs()
                if (f && !f.empty) {

                    def fileName = f.getOriginalFilename()
                    def ext

                    def parts = fileName.split("\\.")
                    fileName = ""
                    parts.eachWithIndex { obj, i ->
                        if (i < parts.size() - 1) {
                            fileName += obj
                        }
                    }
                    def name = "certIess_" + estacion.codigo+"_"+new Date().format("ddMMyyyyHHssmm")+"."+ext2
                    def pathFile = path + name
                    def fn = fileName
                    def src = new File(pathFile)
                    def i = 1
                    while (src.exists()) {
                        nombre = fn + "_" + i + "." + ext2
                        pathFile = path + nombre
                        src = new File(pathFile)
                        i++
                    }
                    try {
                        f.transferTo(new File(pathFile))
                        def cert = new Certificado()
                        cert.estacion=estacion
                        cert.fecha=new Date()
                        cert.path=pathLocal+name
                        cert.save(flush: true)

                    } catch (e) {
                        println "????????\n" + e + "\n???????????"
                    }
                }
                flash.message = 'El archivo cargado correctamente'
                flash.estado = "success"
                flash.icon = "alert"
                redirect(action: 'empleados',id: estacion.codigo)
                return

            }else{
                flash.message = 'El archivo a cargar debe ser del tipo PDF'
                flash.estado = "error"
                flash.icon = "alert"
                redirect(action: 'empleados',id: estacion.codigo)
                return
            }
        }else{
            flash.message = 'No se ha seleccionado ningun archivo para cargar'
            flash.estado = "error"
            flash.icon = "alert"
            redirect(action: 'empleados',id: estacion.codigo)
            return
        }
    }

    def tallas_ajax(){
        def empleado = NominaEstacion.get(params.id)
        def tallas = EmpleadoTalla.findAllByEmpleado(empleado)
        if(tallas.size()==0){
            Uniforme.findAllByTipoInList([empleado.sexo,"U"]).each {
                def et = new EmpleadoTalla()
                et.empleado=empleado
                et.uniforme=it
                et.save(flush: true)
                tallas.add(et)
            }
        }
        [tallas:tallas,empleado:empleado]
    }
    def saveTallas_ajax(){
//        println "params "+params
        def empleado = NominaEstacion.get(params.empleado)
        def data = params.data.split("W")
        data.each {
            if(it && it !=""){
                def datos = it.split(";")
                def talla = EmpleadoTalla.findByEmpleadoAndUniforme(empleado,Uniforme.findByCodigo(datos[0]))
                if(talla){
                    talla.talla=Tallas.findByCodigo(datos[1])
                    talla.save(flush: true)
                }else{
                    println "no hay talla "+datos
                }
            }
        }
        render("ok")

    }

}
