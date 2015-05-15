package gaia.uniformes

import gaia.Contratos.esicc.Tallas
import gaia.estaciones.Estacion

class NominaEstacion {

    Estacion estacion
    String nombre
    String cedula
    String sexo
    String estado = "A" /*A-> activo*/
    Date registro = new Date()

    static mapping = {
        table 'nmes'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort nombre: "asc"
        columns {
            id column: 'pdun__id'
            estacion column: 'estn__id'
            nombre column: 'nmesnmbr'
            cedula column: 'nmescdla'
            estado column: 'nmesetdo'
            registro column: 'nmesfcrg'
            sexo column: 'nmessexo'

        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        estado(size: 1..1)
        nombre(size: 1..100)
        cedula(size: 1..10)
        sexo(inList: ["M","F"],size: 1..1)
    }
}
