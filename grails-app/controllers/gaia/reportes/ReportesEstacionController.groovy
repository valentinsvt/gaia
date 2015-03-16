package gaia.reportes

import gaia.documentos.Consultor
import gaia.documentos.Documento
import gaia.documentos.Entidad
import gaia.documentos.TipoDocumento
import gaia.estaciones.Estacion
import org.springframework.dao.DataIntegrityViolationException
import gaia.seguridad.Shield


/**
 * Controlador de las pantallas de reportes por estación
 */
class ReportesEstacionController {
    def diasLaborablesService

    def index() {}

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
            def c = Estacion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("direccion", "%" + params.search + "%")
                    ilike("estado", "%" + params.search + "%")
                    ilike("mail", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("propetario", "%" + params.search + "%")
                    ilike("representante", "%" + params.search + "%")
                    ilike("ruc", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Estacion.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    def supervisores() {

        def estaciones = Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1")
        def estacionInstanceCount = getList(params, true).size()

        return [estaciones: estaciones, estacionInstanceCount: estacionInstanceCount]
    }

    def reporteSupervisores () {

        def estaciones = Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1")
        def estacionInstanceCount = getList(params, true).size()

        return [estaciones: estaciones, estacionInstanceCount: estacionInstanceCount]
    }

    def vencidos() {

        def estaciones = Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1")
        def estacionInstanceCount = getList(params, true).size()

        return [estaciones: estaciones, estacionInstanceCount: estacionInstanceCount]
    }

    def reporteVencidos() {
        println "reporte vencidos:!! " + params
       def estaciones = Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1")
//        println "estaciones: " + estaciones
//        return [estaciones: estaciones]
        return [estaciones:estaciones]
    }

    def documentos() {

        def estaciones = Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1")
        def estacionInstanceCount = getList(params, true).size()

        def tiposDocumentos = TipoDocumento.list(sort: "id")


        return [estaciones: estaciones, estacionInstanceCount: estacionInstanceCount, tiposDocumentos: tiposDocumentos]
    }

    def reporteDocumentosEstacion () {

        def estaciones = Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1")
        def estacionInstanceCount = getList(params, true).size()

        def tiposDocumentos = TipoDocumento.list(sort: "id")


        return [estaciones: estaciones, estacionInstanceCount: estacionInstanceCount, tiposDocumentos: tiposDocumentos]
    }

    def entidad() {

        def mae = Entidad.findByCodigo("MAE");
        def arch = Entidad.findByCodigo("ARCH");

        def tiposDocumentosMae = TipoDocumento.findAllByEntidad(mae);
        def tiposDocumentosArch = TipoDocumento.findAllByEntidad(arch);

        def estaciones = Estacion.findAll("from Estacion where aplicacion = 1 and estado='A' and tipo=1")

        def entidades = Entidad.list()

        def documentos = Documento.list()
        def otros = []

        tiposDocumentosMae.each {
            otros += Documento.findAllByTipo(it)
        }

//        print("-->" + otros)

        return [tiposDocumentosMae: tiposDocumentosMae, tiposDocumentosArch: tiposDocumentosArch, estaciones: estaciones, entidades: entidades]

    }

    def reporteEntidad () {

//        println("params " + params)

        def tiposDocumentos
        def documentos
        def tipos = []
        def estacion

        //todos


        if(params.entidadId == "-1"){
            println("entrof")
//            def estacion = Estacion.findByNombre(params.estacion)
            estacion = Estacion.findByCodigo(params.estacionId)
            def entidades = Entidad.list()
            tipos = Documento.findAllByEstacion(estacion)
        }else{
            //estacion - entidad

            def entidad = Entidad.get(params.entidadId)
//            def estacion = Estacion.findByNombre(params.estacion)
            estacion = Estacion.findByCodigo(params.estacionId)
            tiposDocumentos = TipoDocumento.findAllByEntidad(entidad)
            documentos = Documento.findAllByEstacion(estacion)

            documentos.each {
                if(it.tipo.entidad.id == entidad.id){
                    tipos += it
                }
            }
        }

//        println("res " + tipos)

        return [tipos: tipos, estacion: estacion]

    }


    def tablaEntidad () {

//        println("params " + params)

        def tiposDocumentos
        def documentos
        def tipos = []

        //todos


        if(params.entidad == "-1"){

//            def estacion = Estacion.findByNombre(params.estacion)
            def estacion = Estacion.findByCodigo(params.estacion)
            def entidades = Entidad.list()
            tipos = Documento.findAllByEstacion(estacion)
        }else{
            //estacion - entidad

            def entidad = Entidad.get(params.entidad)
//            def estacion = Estacion.findByNombre(params.estacion)
            def estacion = Estacion.findByCodigo(params.estacion)
            tiposDocumentos = TipoDocumento.findAllByEntidad(entidad)
            documentos = Documento.findAllByEstacion(estacion)

            documentos.each {
                if(it.tipo.entidad.id == entidad.id){
                    tipos += it
                }
            }
        }




//        println("res " + tipos)

        return [tipos: tipos]

    }

    def documentosConsultor () {
        def consultores = Consultor.list()
        def documentos = Documento.list()
//        def documentos = []

        return [consultores: consultores, documentos: documentos]

    }

    def docConsultor_ajax () {
        def consultores = Consultor.list()

        return [consultores: consultores]
    }

    def reporteDocumentosConsultor () {

        println("paramsdc " + params)

        def fInicio
        def fFin

        if(params.fechaInicio){
            fInicio = new Date().parse("dd-MM-yyyy", params.fechaInicio)
        }
        if(params.fechaFin){
            fFin = new Date().parse("dd-MM-yyyy", params.fechaFin)
        }
            def consultor = Consultor.findById(params.consultorId)

            def documentos

        if(params.consultorId == '-1'){
            println("entro -1")

            if(fFin != null && fInicio != null){
                println("entro 1")
                documentos = Documento.findAllByFinLessThanEqualsAndInicioGreaterThanEquals(fFin, fInicio)
            }
            else if(fInicio && !fFin) {
                println("entro 2")
                documentos = Documento.findAllByInicioGreaterThanEquals(fInicio)
            }
            else if(fFin && !fInicio){
                documentos = Documento.findAllByFinLessThanEquals(fFin)
            }
            else{
                println("list")
                documentos = Documento.list()
            }


        }else{
            if(fFin != null && fInicio != null){
                documentos = Documento.findAllByConsultorAndFinLessThanEqualsAndInicioGreaterThanEquals(consultor,fFin, fInicio)
            }
            else if(fInicio && !fFin) {
                documentos = Documento.findAllByConsultorAndInicioGreaterThanEquals(consultor,fInicio)
            }
            else if(fFin && !fInicio){
                documentos = Documento.findAllByConsultorAndFinLessThanEquals(consultor, fFin)
            }
            else{
                documentos = Documento.findAllByConsultor(consultor)
            }


        }

            return [documentos: documentos, consultor: consultor]

    }

    def tablaDocumentosConsultor () {

        println("paramsdc " + params)

        def fInicio
        def fFin

        if(params.fechaInicio){
            fInicio = new Date().parse("dd-MM-yyyy", params.fechaInicio)
        }
        if(params.fechaFin){
            fFin = new Date().parse("dd-MM-yyyy", params.fechaFin)
        }
        def consultor = Consultor.findById(params.consultorId)

        def documentos

        if(params.consultorId == '-1'){
            if(fFin != null && fInicio != null){
                documentos = Documento.findAllByFinLessThanEqualsAndInicioGreaterThanEquals(fFin, fInicio)
            }
            else if(fInicio && !fFin) {
                documentos = Documento.findAllByInicioGreaterThanEquals(fInicio)
            }
            else if(fFin && !fInicio){
                documentos = Documento.findAllByFinLessThanEquals(fFin)
            }
            else{
                documentos = Documento.list()
            }


        }else{
            if(fFin != null && fInicio != null){
                documentos = Documento.findAllByConsultorAndFinLessThanEqualsAndInicioGreaterThanEquals(consultor,fFin, fInicio)
            }
            else if(fInicio && !fFin) {
                documentos = Documento.findAllByConsultorAndInicioGreaterThanEquals(consultor,fInicio)
            }
            else if(fFin && !fInicio){
                documentos = Documento.findAllByConsultorAndFinLessThanEquals(consultor, fFin)
            }
            else{
                documentos = Documento.findAllByConsultor(consultor)
            }


        }

        return [documentos: documentos, consultor: consultor]

    }
}
