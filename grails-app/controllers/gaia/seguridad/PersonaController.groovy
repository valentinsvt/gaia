package gaia.seguridad

import groovy.json.JsonBuilder
import org.springframework.dao.DataIntegrityViolationException

import javax.imageio.ImageIO
import java.awt.image.BufferedImage

import static java.awt.RenderingHints.KEY_INTERPOLATION
import static java.awt.RenderingHints.VALUE_INTERPOLATION_BICUBIC

/**
 * Controlador que muestra las pantallas de manejo de Persona
 */
class PersonaController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action: "list", params: params)
    }

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    def getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if (all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if (params.search) {
            def c = Persona.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("apellido", "%" + params.search + "%")
                    ilike("autorizacion", "%" + params.search + "%")
                    ilike("cedula", "%" + params.search + "%")
                    ilike("direccion", "%" + params.search + "%")
                    ilike("discapacitado", "%" + params.search + "%")
                    ilike("fax", "%" + params.search + "%")
                    ilike("login", "%" + params.search + "%")
                    ilike("mail", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("sexo", "%" + params.search + "%")
                    ilike("sigla", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Persona.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return personaInstanceList: la lista de elementos filtrados, personaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def personaInstanceList = getList(params, false)
        def personaInstanceCount = getList(params, true).size()
        return [personaInstanceList: personaInstanceList, personaInstanceCount: personaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return personaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }
            def perfiles = Sesion.withCriteria {
                eq("usuario", personaInstance)
                perfil {
                    order("nombre", "asc")
                }
            }
            return [personaInstance: personaInstance, perfiles: perfiles]
        } else {
            render "ERROR*No se encontró Persona."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return personaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def personaInstance = new Persona()
        def perfiles = []
        if (params.id) {
            personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }
            perfiles = Sesion.withCriteria {
                eq("usuario", personaInstance)
                perfil {
                    order("nombre", "asc")
                }
            }
        }
        personaInstance.properties = params
       // if (params.dep) {
         //   def dep = Departamento.get(params.dep.toLong())
           // personaInstance.departamento = dep
        //}
        return [personaInstance: personaInstance, perfiles: perfiles]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def personaInstance = new Persona()
        if (params.id) {
            personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }
        }
        personaInstance.properties = params
        if (!params.id) {
            personaInstance.password = personaInstance.cedula.encodeAsMD5()
        }
        if (!personaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Persona: " + renderErrors(bean: personaInstance)
            return
        }

        def perfiles = params.perfiles
//        println params
//        println "PERFILES: " + perfiles
        if (perfiles) {
            def perfilesOld = Sesion.findAllByUsuario(personaInstance)
            def perfilesSelected = []
            def perfilesInsertar = []
            (perfiles.split("_")).each { perfId ->
                def perf = Perfil.get(perfId.toLong())
                if (!perfilesOld.perfil.id.contains(perf.id)) {
                    perfilesInsertar += perf
                } else {
                    perfilesSelected += perf
                }
            }
            def commons = perfilesOld.perfil.intersect(perfilesSelected)
            def perfilesDelete = perfilesOld.perfil.plus(perfilesSelected)
            perfilesDelete.removeAll(commons)

//            println "perfiles old      : " + perfilesOld
//            println "perfiles selected : " + perfilesSelected
//            println "perfiles insertar : " + perfilesInsertar
//            println "perfiles delete   : " + perfilesDelete

            def errores = ""

            perfilesInsertar.each { perfil ->
                def sesion = new Sesion()
                sesion.usuario = personaInstance
                sesion.perfil = perfil
                if (!sesion.save(flush: true)) {
                    errores += renderErrors(bean: sesion)
                    println "error al guardar sesion: " + sesion.errors
                }
            }
            perfilesDelete.each { perfil ->
                def sesion = Sesion.findAllByPerfilAndUsuario(perfil, personaInstance)
                try {
                    if (sesion.size() == 1) {
                        sesion.first().delete(flush: true)
                    } else {
                        errores += "Existen ${sesion.size()} registros del permiso " + perfil.nombre
                    }
                } catch (Exception e) {
                    errores += "Ha ocurrido un error al eliminar el perfil " + perfil.nombre
                    println "error al eliminar perfil: " + e
                }
            }
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Persona exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite activar/desactivar una persona
     */
    def cambiarActivo_ajax() {
        def per = Persona.get(params.id)
        per.activo = params.activo.toInteger()
        if (per.save(flush: true)) {
            render "SUCCESS*Usuario " + (per.activo == 1 ? "activado" : "desactivado") + " exitosamente"
        } else {
            render "ERROR*" + renderErrors(bean: per)
        }
    }
    /**
     * Acción llamada con ajax que permite modificar el departamento de una persona
     */
    /* def cambiarDepartamento_ajax() {
         def per = Persona.get(params.id.toLong())
         def dep = Departamento.get(params.padre.toLong())
         if (dep) {
             per.departamento = dep
         } else {
             per.departamento = null
         }
         if (per.save(flush: true)) {
             render "SUCCESS*Usuario reubicado exitosamente"
         } else {
             render "ERROR*" + renderErrors(bean: dep)
         }
     }
 */
     /**
      * Acción llamada con ajax que permite eliminar un elemento
      * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
      */
    def delete_ajax() {
        if (params.id) {
            def personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }
            try {
                personaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Persona exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Persona"
                return
            }
        } else {
            render "ERROR*No se encontró Persona."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que modifica la contraseña o la autorización de un usuario
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def savePass_ajax() {
        println "save pass     " + params
        def persona = Persona.get(params.id)
        if (!params.id) {
            persona = Persona.get(session.usuario.id)
        }
        def str = params.tipo == "pass" ? "contraseña" : "autorización"
        params.input2 = params.input2.trim()
        params.input3 = params.input3.trim()
        if (params.input2 == params.input3) {
            if (params.tipo == "pass") {
                persona.password = params.input2.encodeAsMD5()
            } else {
                if (persona.autorizacion == params.input1.trim().encodeAsMD5()) {
                    persona.autorizacion = params.input2.encodeAsMD5()
                } else {
                    render "ERROR*La autorización actual es incorrecta"
                    return
                }
            }
        } else {
            render "ERROR*La ${str} y la verificación no coinciden"
            return
        }
        render "SUCCESS*La ${str} ha sido modificada exitosamente"
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad login
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_login_ajax() {
        params.login = params.login.toString().trim()
        if (params.id) {
            def obj = Persona.get(params.id)
            if (obj.login.toLowerCase() == params.login.toLowerCase()) {
                render true
                return
            } else {
                render Persona.countByLoginIlike(params.login) == 0
                return
            }
        } else {
            render Persona.countByLoginIlike(params.login) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad mail
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_mail_ajax() {
        params.mail = params.mail.toString().trim()
        if (params.id) {
            def obj = Persona.get(params.id)
            if (obj.mail.toLowerCase() == params.mail.toLowerCase()) {
                render true
                return
            } else {
                render Persona.countByMailIlike(params.mail) == 0
                return
            }
        } else {
            render Persona.countByMailIlike(params.mail) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que el valor ingresado corresponda con el valor almacenado de la autorización
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_aut_previa_ajax() {
        params.input1 = params.input1.trim()
        def obj = Persona.get(params.id)
        if (obj.autorizacion == params.input1.encodeAsMD5()) {
            render true
        } else {
            render false
        }
    }

    /**
     * Acción que muestra una pantalla de configuración para el usuario
     */
    def personal() {
        def usuario = Persona.get(session.usuario.id)
        return [usuario: usuario]
    }

    /**
     * Acción llamada con ajax que valida la validez del password de una persona
     */
    def validarPass_ajax() {
        def usuario = Persona.get(session.usuario.id)
        render usuario.password == params.password_actual.toString().trim().encodeAsMD5()
    }

    /**
     * Acción llamada con ajax que valida la validez de la autoriación de una persona
     */
    def validarAuth_ajax() {
        def usuario = Persona.get(session.usuario.id)
        render usuario.autorizacion == params.auth_actual.toString().trim().encodeAsMD5()
    }

    /**
     * Acción que carga la foto de un usuario
     * @return
     */
    def loadFoto() {
        def usuario = Persona.get(session.usuario.id)
        def path = servletContext.getRealPath("/") + "images/perfiles/" //web-app/archivos
        def img
        def w
        def h
        if (usuario.foto) {
            img = ImageIO.read(new File(path + usuario.foto));
            w = img.getWidth();
            h = img.getHeight();
        } else {
            w = 0
            h = 0
        }
        return [usuario: usuario, w: w, h: h]
    }

    /**
     * Acción que permite subir una foto para la persona
     * @return
     */
    def uploadFile() {
        def usuario = Persona.get(session.usuario.id)
        def path = servletContext.getRealPath("/") + "images/perfiles/"    //web-app/archivos
        new File(path).mkdirs()

        def f = request.getFile('file')  //archivo = name del input type file

        def okContents = ['image/png': "png", 'image/jpeg': "jpeg", 'image/jpg': "jpg"]

        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext

            if (okContents.containsKey(f.getContentType())) {
                ext = okContents[f.getContentType()]
                fileName = usuario.id + "." + ext
                def pathFile = path + fileName
                def nombre = fileName
                try {
                    f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                } catch (e) {
                    println "????????\n" + e + "\n???????????"
                }
                /* RESIZE */
                def img = ImageIO.read(new File(pathFile))
                def scale = 0.5
                def minW = 300 * 0.7
                def minH = 400 * 0.7
                def maxW = minW * 3
                def maxH = minH * 3
                def w = img.width
                def h = img.height

                if (w > maxW || h > maxH || w < minW || h < minH) {
                    def newW = w * scale
                    def newH = h * scale
                    def r = 1
                    if (w > h) {
                        if (w > maxW) {
                            r = w / maxW
                            newW = maxW
                            println "w>maxW:    r=" + r + "   newW=" + newW
                        }
                        if (w < minW) {
                            r = minW / w
                            newW = minW
                            println "w<minW:    r=" + r + "   newW=" + newW
                        }
                        newH = h / r
                        println "newH=" + newH
                    } else {
                        if (h > maxH) {
                            r = h / maxH
                            newH = maxH
                            println "h>maxH:    r=" + r + "   newH=" + newH
                        }
                        if (h < minH) {
                            r = minH / h
                            newH = minH
                            println "h<minxH:    r=" + r + "   newH=" + newH
                        }
                        newW = w / r
                        println "newW=" + newW
                    }
                    println newW + "   " + newH

                    newW = Math.round(newW.toDouble()).toInteger()
                    newH = Math.round(newH.toDouble()).toInteger()

                    println newW + "   " + newH

                    new BufferedImage(newW, newH, img.type).with { j ->
                        createGraphics().with {
                            setRenderingHint(KEY_INTERPOLATION, VALUE_INTERPOLATION_BICUBIC)
                            drawImage(img, 0, 0, newW, newH, null)
                            dispose()
                        }
                        ImageIO.write(j, ext, new File(pathFile))
                    }
                }

                /* fin resize */

                if (!usuario.foto || usuario.foto != nombre) {
                    def fotoOld = usuario.foto
                    if (fotoOld) {
                        def file = new File(path + fotoOld)
                        file.delete()
                    }
                    usuario.foto = nombre
                    if (usuario.save(flush: true)) {
                        def data = [
                                files: [
                                        [
                                                name: nombre,
                                                url : resource(dir: 'images/perfiles/', file: nombre),
                                                size: f.getSize(),
                                                url : pathFile
                                        ]
                                ]
                        ]
                        def json = new JsonBuilder(data)
                        render json
                        return
                    } else {
                        def data = [
                                files: [
                                        [
                                                name : nombre,
                                                size : f.getSize(),
                                                error: "Ha ocurrido un error al guardar"
                                        ]
                                ]
                        ]
                        def json = new JsonBuilder(data)
                        render json
                        return
                    }
                } else {
                    def data = [
                            files: [
                                    [
                                            name: nombre,
                                            url : resource(dir: 'images/perfiles/', file: nombre),
                                            size: f.getSize(),
                                            url : pathFile
                                    ]
                            ]
                    ]
                    def json = new JsonBuilder(data)
                    render json
                    return
                }
            } else {
                def data = [
                        files: [
                                [
                                        name : fileName + "." + ext,
                                        size : f.getSize(),
                                        error: "Extensión no permitida"
                                ]
                        ]
                ]

                def json = new JsonBuilder(data)
                render json
                return
            }
        }
        render "OK"
    }

    /**
     * Acción que redimensiona una imagen
     * @return
     */
    def resizeCropImage() {
        def usuario = Persona.get(session.usuario.id)
        def path = servletContext.getRealPath("/") + "images/perfiles/"    //web-app/archivos
        def fileName = usuario.foto
        def ext = fileName.split("\\.").last()
        def pathFile = path + fileName
        /* RESIZE */
        def img = ImageIO.read(new File(pathFile))

        def oldW = img.getWidth()
        def oldH = img.getHeight()

        int newW = 300 * 0.7
        int newH = 400 * 0.7
        int newX = params.x.toInteger()
        int newY = params.y.toInteger()
        def rx = newW / (params.w.toDouble())
        def ry = newH / (params.h.toDouble())

        int resW = oldW * rx
        int resH = oldH * ry
        int resX = newX * rx * -1
        int resY = newY * ry * -1

        new BufferedImage(newW, newH, img.type).with { j ->
            createGraphics().with {
                setRenderingHint(KEY_INTERPOLATION, VALUE_INTERPOLATION_BICUBIC)
                drawImage(img, resX, resY, resW, resH, null)
                dispose()
            }
            ImageIO.write(j, ext, new File(pathFile))
        }
        /* fin resize */
        render "OK"
    }
}
