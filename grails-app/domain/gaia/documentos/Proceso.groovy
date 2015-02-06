package gaia.documentos

import gaia.estaciones.Estacion

class Proceso {

    TipoDocumento tipo
    Estacion estacion
    Date inicio
    Date fin /*nullable blank*/
    String completado /*S--> si N--> no*/
    Documento documento /*nullable blank*/


    static constraints = {
    }
}
