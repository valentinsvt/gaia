package gaia.Contratos

class Cliente {

    String codigo
    String ubicaicon
    Integer tipo
    String supervisor
    String filial
    String nombre
    String propietario
    String direccion
    Integer tipoVenta
    String nombreRepresentante
    String telefono
    Date fechaInscripcion
    String cedula
    String ruc
    String estado
    String fax
    String plazo
    String codigoContable
    String codigoListaPrecio
    String arrendatario
    Date fechaInicioSeg
    Date fechaFinSeg
    String codigoDnh
    String clinteFactura
    Date fechaTerminaContrato
    Date fechaRegistroDnh
    Date fechaPrimerContrato
    String nombreAdministrador
    String cedulaRepresentante
    String email
    String correspondencia


    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'CLIENTE'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "codigo", generator: 'assigned', type:"string"
        version false
        columns {
             codigo column: "CODIGO_CLIENTE"
             ubicaicon column: "CODIGO_UBICACION"
             tipo column: "TIPO_CLIENTE"
             supervisor column: "CODIGO_SUPERVISOR"
             filial column: "CODIGO_FILIAL"
             nombre column: "NOMBRE_CLIENTE"
             propietario column: "NOMBRE_PROPIETARIO"
             direccion column: "DIRECCION_CLIENTE"
             tipoVenta column: "TIPO_VENTA"
             nombreRepresentante column: "NOMBRE_REPRESENTANTE"
             telefono column: "TELEFONO_CLIENTE"
             fechaInscripcion column: "FECHA_INS_CLIENTE"
             cedula column: "CEDULA_CLIENTE"
             ruc column: "RUC_CLIENTE"
             estado column: "ESTADO_CLIENTE"
             fax column: "FAX_CLIENTE"
             plazo column: "PLAZO_VENTA"
             codigoContable column: "CODIGO_CONTABLE"
             codigoListaPrecio column: "CODIGO_LISTA_PRECIO"
             arrendatario column: "ARRENDATARIO"
             fechaInicioSeg column: "FECHA_INICIO_SEG"
             fechaFinSeg column: "FECHA_FIN_SEG"
             codigoDnh column: "CODIGO_DNH"
             clinteFactura column: "CLIENTE_FACTURA"
             fechaTerminaContrato column: "FECHA_TERMINA_CONTRATO"
             fechaRegistroDnh column: "FECHA_REGISTRO_DNH"
             fechaPrimerContrato column: "FECHA_PRIMER_CONTRATO"
             nombreAdministrador column: "NOMBRE_ADMINISTRADOR"
             cedulaRepresentante column: "CEDULA_REPRESENTANTE"
             email column: "DIRECCION_ELECTRONICA"
             correspondencia column: "ENVIO_CORRESPONDENCIA"
        }
    }
    static constraints = {

    }

    String toString(){
        return "${this.codigo} - ${this.nombre}"
    }
}
