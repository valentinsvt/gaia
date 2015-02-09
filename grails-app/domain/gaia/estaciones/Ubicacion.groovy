package gaia.estaciones

class Ubicacion {

    Estacion estacion

    double longitud = 0
    double latitud = 0
    int zoom = 0

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: ['fechaEnvio', 'fechaRecibido']]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'ubcc'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'ubcc__id'
            estacion column: 'esta__id'
            longitud column: 'ubcclong'
            latitud column: 'ubcclatt'
            zoom column: 'ubcczoom'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

    }
}
