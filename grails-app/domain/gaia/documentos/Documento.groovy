package gaia.documentos

import gaia.estaciones.Estacion

class Documento {

    TipoDocumento tipo
    Estacion estacion
    Date fechaRegistro = new Date()
    Date inicio
    Date fin /*nullable blank*/
    Documento padre /*nullable blank*/
    String descripcion
    String path
    String codigo


    static constraints = {
    }
}
