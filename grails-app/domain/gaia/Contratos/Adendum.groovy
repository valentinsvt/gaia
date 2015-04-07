package gaia.Contratos

import gaia.estaciones.Estacion

class Adendum implements Serializable{
    int secuencial
    String cliente
    TipoContrato tipo
    Date inicio
    int anios
    Date fin

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'ADENDUM'
        cache usage: 'read-write', include: 'non-lazy'
        id composite:['secuencial', 'cliente']
        version false
        columns {
            secuencial column: 'SECUENCIAL'
            cliente column: 'CODIGO_CLIENTE'
            tipo column: 'CODIGO_TIPO_CONTRATO'
            inicio column: 'FECHA_ADENDUM'
            anios column: 'NUMERO_ANOS'
            fin column: 'FECHA_NUEVA_CULMINACION'
        }
    }
    static constraints = {

    }

    String toString(){
        return "${this.secuencial} - Inicio: ${inicio.format('dd-MM-yyyy')} - fin: ${fin.format('dd-MM-yyyy')}"
    }
}
