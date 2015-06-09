package gaia.supervisores


import gaia.Contratos.Cliente
import gaia.EstadoDeCuenta.EstadoDeCuenta
import gaia.documentos.Inspector
import org.quartz.Scheduler
import org.quartz.Trigger

import static org.quartz.impl.matchers.GroupMatcher.jobGroupEquals

class EstadoDeCuentaController {

    Scheduler quartzScheduler
    def mailService
    def estadosDeCuentaService
    def index() {
        def supervisores = estadosDeCuentaService.getSupervisores()
        //estadosDeCuentaService.generaPdf(EstadoDeCuenta.get(35))
        def mes = new Date().format("MM").toInteger()
        def anio = new Date().format("yyyy").toInteger()
        def meses = [:]
        (mes-1).times {m->
            if(m<9)
                meses.put("0"+(m+1)+new Date().format("YYYY"),g.formatDate(date: new Date().parse("dd-MM-yyyy","01-0"+(m+1)+"-"+anio),format: "MMMM",locale: "es"))
            else
                meses.put(""+(m+1)+new Date().format("YYYY"),g.formatDate(date:new Date().parse("dd-MM-yyyy","01-"+(m+1)+"-"+anio),format: "MMMM",locale: "es"))
        }
        [supervisores:supervisores,meses:meses]

    }


    def estadosPorSupervisor(){
        //println "params "+params
        def nextEstado
        def nextEmail
        def listJobGroups = quartzScheduler.jobGroupNames
        listJobGroups?.each {jobGroup ->
            quartzScheduler.getJobKeys(jobGroupEquals(jobGroup))?.each {jobKey ->
                def jobName = jobKey.name
                if(jobName=="gaia.EstadoDeCuentaJob"){
                    List<Trigger> triggers = quartzScheduler.getTriggersOfJob(jobKey)
                    nextEstado = triggers.first().nextFireTime
                }
                if(jobName=="gaia.EmailEstadosDeCuentaJob"){
                    List<Trigger> triggers = quartzScheduler.getTriggersOfJob(jobKey)
                    nextEmail = triggers.first().nextFireTime
                }
            }
        }
        def mes = params.mes
        def supervisor = Inspector.findByCodigo(params.supervisor)
        def now = new Date().parse("ddMMyyyy","01"+mes)
        def anio = now.format("yyyy")
        Calendar calendar = GregorianCalendar.instance
        calendar.set(now.format("yyyy").toInteger(), now.format("MM").toInteger()-1, now.format("dd").toInteger())
        def ldom = calendar.getActualMaximum(GregorianCalendar.DAY_OF_MONTH)
        def c = Cliente.findAllBySupervisorAndTipo(params.supervisor,1)
        def estados = EstadoDeCuenta.findAllByClienteInListAndMes(c,params.mes,[sort: "registro"])
        [estados:estados,supervisor:supervisor,mes:ldom,nextEstado:nextEstado,nextEmail:nextEmail]

    }


    def generarEstados(){
        def registro = new Date()
        def c = Cliente.findAllBySupervisorAndTipo(params.supervisor,1)

        c.each {
            if(it.estado=="A"){
                def  estado=new EstadoDeCuenta()
                estado.cliente=it
                estado.registro=registro
                estado.codigoSupervisor=params.supervisor
                estado.path=null
                estado.mes=params.mes
                estado.usuario=session.usuario.login
                if(!estado.save(flush: true))
                    println "error save estado "+estado.errors

            }

        }
        flash.message="El sistema procesara los estados de cuenta conforme son registrados, " +
                "los estados de cuenta estarán listos para enviarse en aproximadamente 15 minutos"
        redirect(action: "estadosPorSupervisor",params: params)
    }



    def pruebaHtml(){

    }

    def enviar (){
        println "params "+params
        def data = params.data?.split(";")
        data.each {d->
            if(d!=""){
                def estado = EstadoDeCuenta.get(d)
                if(estado.path && estado.envio==null){
                    estado.mensaje="Programado para envío"
                    if(params.copia)
                        estado.copiaEmail=params.copia
                    estado.save(flush: true)
                }

            }
        }
        redirect(action: "estadosPorSupervisor",params: params)

    }


    def consultaEstado(){
        def clientes = Cliente.findAll("from Cliente  where tipo=1 and estado = 'A'")
        def mes = new Date().format("MM").toInteger()
        def anio = new Date().format("yyyy").toInteger()
        def meses = [:]
        (mes-1).times {m->
            if(m<9)
                meses.put("0"+(m+1)+new Date().format("YYYY"),g.formatDate(date: new Date().parse("dd-MM-yyyy","01-0"+(m+1)+"-"+anio),format: "MMMM",locale: "es"))
            else
                meses.put(""+(m+1)+new Date().format("YYYY"),g.formatDate(date:new Date().parse("dd-MM-yyyy","01-"+(m+1)+"-"+anio),format: "MMMM",locale: "es"))
        }
        [clientes:clientes,meses: meses]
    }

    def estadosPorEstacion(){

        def cliente = Cliente.findByCodigoAndTipo(params.cliente,1)
        def estados = EstadoDeCuenta.findAllByClienteAndMes(cliente,params.mes)
        [estados:estados,cliente:cliente]


    }

    def generarEstadoEstacion(){
        def cliente = Cliente.findByCodigoAndTipo(params.cliente,1)
        def registro = new Date()
        if(cliente.estado=="A"){
            def estado=new EstadoDeCuenta()
            estado.cliente=cliente
            estado.registro=registro
            estado.codigoSupervisor=cliente.supervisor
            estado.path=null
            estado.mes=params.mes
            estado.usuario=session.usuario.login
            estado.intentos=100
            if(!estado.save(flush: true))
                println "error save estado "+estado.errors
        }
        redirect(action: "estadosPorEstacion",controller: "estadoDeCuenta",params: params)
    }

    def generarPdf(){
        def estado = EstadoDeCuenta.get(params.estado)
        estadosDeCuentaService.generaPdf(estado)
        redirect(action: "estadosPorEstacion",controller: "estadoDeCuenta",params: params)
    }

    def enviarEstado(){
        def e = EstadoDeCuenta.get(params.estado)
        try{
            def file=grailsApplication.mainContext.getResource(e.path).getFile()
            def parts = e.cliente.email
            if(parts)
                parts=e.cliente.email.split(",")
            def emails = []
            parts.each {p->
                if(p!=""){
                    emails.add(p)
                }
            }
            if(e.copiaEmail){
                parts=e.copiaEmail.split(",")
                parts.each {p->
                    if(p!=""){
                        emails.add(p)
                    }

                }
            }
            def pruebas = ["valentinsvt@hotmail.com"]
            println "email estacion "+e.cliente.codigo+"  "+emails
            Byte[] pdfData = file.readBytes()
            mailService.sendMail {
                multipart true
                to pruebas
//                    to emails
                subject "Estado de cuenta PyS";
                attachBytes "Estado-de-cuenta-${e.mes}.pdf", "application/x-pdf", pdfData
                body( view:"/estadoDeCuenta/estadoDeCuenta")
                inline 'logo','image/png', new File('./web-app/images/logo-login.png').readBytes()
            }
            e.envio=new Date()
            e.mensaje="Correo enviado"
            e.save(flush: true)
        }catch (ex){
            e.mensaje="Falló el envío: "+ex
            e.envio=null
            e.save(flush: true)
            println "error mail "+ex
        }
        redirect(action: "estadosPorEstacion",controller: "estadoDeCuenta",params: params)
    }


}
