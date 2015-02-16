package gaia.documentos

class Ubicacion {

    String codigo
    String nombre
    String padre


    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'ubicacion'
        sort 'nombre'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "codigo", generator: 'assigned', type:"string"
        version false
        columns {
            codigo column: 'codigo_ubicacion', insertable: false, updateable: false
            nombre column: 'descripcion'
            padre column: 'codigo_padre'
        }
    }

    static constraints = {
    }
}
