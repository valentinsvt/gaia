package gaia.financiero

import gaia.Contratos.Cliente

class EstadoDeCuenta {


    Date registro = new Date()
    Date envio
    String path
    Cliente cliente
    String codigoSupervisor
    String mes
    Date ultimaEjecucion
    String mensaje
    Integer intentos = 0
    Integer generaciones = 0
    String usuario
    String copiaEmail
    static auditable = false

    static mapping = {
        datasource 'erp'
        table 'ESTADO_DE_CUENTA'
        cache usage: 'read-write', include: 'non-lazy'
        id column:'ID',sqlType: "int"
        id generator: "increment"
        version false
        columns {
            cliente column: 'CODIGO_CLIENTE'
            registro column: 'FECHA_REGISTRO'
            envio column: 'FECHA_ENVIO'
            path column: 'PATH'
            codigoSupervisor column: 'CODIGO_SUPERVISOR'
            mes column: 'MES'
            ultimaEjecucion column: 'ULTIMA_EJECUCION'
            mensaje column: 'MENSAJE'
            intentos column: 'INTENTOS'
            generaciones column: 'GENERACIONES'
            usuario column: 'USUARIO'
            copiaEmail column: 'COPIA_EMAIL'
        }
    }
    static constraints = {
        cliente(size:1..8,nullable: false,blank:false)
        codigoSupervisor(size: 1..5)
        envio(nullable: true,blank:true)
        path(nullable: true,blank: true,size: 1..150)
        mes(size: 1..10)
        ultimaEjecucion(nullable: true)
        mensaje(nullable: true,blank: true,size: 1..1024)
        intentos(nullable: true)
        generaciones(nullable: true)
        usuario(size: 1..20,nullable: true,blank: true)
        copiaEmail(size: 1..100,nullable: true,blank: true)
    }
}
