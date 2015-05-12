package gaia.supervisores

import gaia.documentos.Inspector
import gaia.estaciones.Estacion

class Analisis {

    Inspector supervisor
    Date fecha
    Date registro =  new Date()
    String comentario
    Estacion estacion
    Double ventasMes
    Double ventasAnio
    Double diferencia
    Double porcentaje

    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'anls'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort fecha: "asc"
        columns {
            id column: 'anls__id'
            supervisor column: 'insp__id'
            fecha column: 'anlsfcha'
            comentario column: 'anlscmtr'
            comentario type: "text"
            estacion column: 'estn__id'
            registro column: 'anlsrgst'
            ventasMes column: 'anlsvtme'
            ventasAnio column: 'anlsvtan'
            diferencia column: 'anlsdifr'
            porcentaje column: 'anlsprct'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {


    }
}
