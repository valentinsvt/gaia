package gaia.documentos

class Reponsable {

    String cedula
    String login
    String nombre
    String mail
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'responsable'
        sort 'nombre'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "cedula", generator: 'assigned', type:"string"
        version false
        columns {
            cedula column: 'cedula', insertable: false, updateable: false
            nombre column: 'nombre_responsable'
            mail column: 'direcion_electronica'
            login column: 'login_user'
        }
    }
    static constraints = {
    }
}
