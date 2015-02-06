package gaia.seguridad



/*Usuario del sistema*/
/**
 * Clase para conectar con la tabla 'prsn' de la base de datos<br/>
 * Usuario del sistema
 */
class Persona {

    /**
     * Nombre de la persona
     */
    String nombre

    String password

    String login

    int estado = 0


    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'usuario'
        sort 'nombre'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "login", generator: 'assigned', type:"string"
        version false
        columns {
            login column: 'login_user', insertable: false, updateable: false
            password column: 'password_user'
            nombre column: 'nombre_user'
            estado column: 'estado_user'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

    }

    /**
     * Genera un string para mostrar
     * @return el nombre y el apellido concatenado
     */
    String toString() {
        return "${this.nombre}"
    }
}