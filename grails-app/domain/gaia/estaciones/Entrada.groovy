package gaia.estaciones

import gaia.erp.Mangueras
import gaia.seguridad.Persona

class Entrada {

    Estacion estacion
    Date fecha = new Date()
    Persona persona
    String texto
    String path
    String tipo /*P-> pdf I->imagen*/
    Entrada entrada
/**
 * Define los campos que se van a ignorar al momento de hacer logs
 */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'entr'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort fecha: "desc"
        columns {
            id column: 'entr__id'
            estacion column: 'estn__id'
            fecha column: 'entrfcha'
            persona column: 'prsn__id'
            texto column: 'entrtxto'
            texto type: 'text'
            path column: 'entrpath'
            entrada column: 'entrpdre'
            tipo column: 'entrtipo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        persona(nullable: true, blank: true)
        texto(nullable: true, blank: true)
        path(nullable: true, blank: true, size: 1..100)
        entrada(nullable: true, blank: true)
        tipo(nullable: true, blank: true, size: 1..1)
    }
}
