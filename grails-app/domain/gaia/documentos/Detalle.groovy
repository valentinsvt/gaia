package gaia.documentos

class Detalle {
    TipoDocumento tipo
    Proceso proceso
    Documento documento /*nullable blank*/
    int plazo = 0
    Date fechaRegistro = new Date()
    Date fechaMaxima /*nullable blank*/
    Detalle detalle

    static constraints = {
    }
}
