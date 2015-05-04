package gaia.nomina

class Empleado {

    String cedula
    Integer contrato
    EstadoCivil estadoCivil
    String codigoContable
    Date ingreso
    Date salida
    String nombre
    String apellido
    String direccion
    String telefono
    Date fechaNacimiento
    String lugar
    String pais
    String nacionalidad
    String afiliacionIess
    String cargo/*revisar*/
    String sexo
    String estado
    String tipoSangre
    String codigoSectorial
    String ciudadTrabajo
    Date antiguedad
    String cuenta
    String codigo
    String email
    Integer fondosDeReserva
    String  decimos



    static auditable = false
    static mapping = {
        datasource 'nomina'
        table 'EMPLEADO'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "cedula", generator: 'assigned', type:"string"
        version false
        columns {
             cedula column: "NUMERO_CEDULA"
             contrato column: "CODIGO_CONTRATO"
             estadoCivil column: "CODIGO_ESTADO_CIVIL"
             codigoContable column: "CODIGO_CONTABLE"
             ingreso column: "FECHA_INGRESO"
             salida column: "FECHA_SALIDA"
             nombre column: "NOMBRE"
             apellido column: "APELLLIDO"
             direccion column: "DIRECCION"
             telefono column: "TELEFONO"
             fechaNacimiento column: "FECHA_NACIMIENTO"
             lugar column: "LUGAR"
             pais column: "PAIS"
             nacionalidad column: "NACIONALIDAD"
             afiliacionIess column: "AFILIACION_IESS"
             cargo/*revisar*/ column: "CARGO"
             sexo column: "SEXO"
             estado column: "ESTADO_EMPLEADO"
             tipoSangre column: "TIPO_SANGRE"
             codigoSectorial column: "CODIGO_SECTORIAL"
             ciudadTrabajo column: "CIUDAD_TRABAJO"
             antiguedad column: "FECHA_ANTIGUEDAD"
             cuenta column: "CTA_CUENTA"
             codigo column: "EMP_CODIGO"
             email column: "DIRECCION_ELECTRONICA"
             fondosDeReserva column: "DESEA_FONDORESERVA"
             decimos column: "EMP_DESEADECIMOS"

        }
    }
    String toString(){
        return "${this.nombre}"
    }



}
