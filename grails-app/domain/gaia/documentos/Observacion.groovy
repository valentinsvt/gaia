package gaia.documentos

import gaia.seguridad.Persona

class Observacion {

    Documento documento
    String observacion /*type text*/
    Date fecha = new Date()
    Persona persona

    static constraints = {
    }
}
