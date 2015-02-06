package gaia.estaciones

class Estacion {



    /**
     * Código del perfil
     */
    String codigo

    String nombre

    int aplicacion

    String direccion

    String telefono

    String ruc

    String propetario

    String representante

    String mail

    int estado = 0

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]



    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'cliente'
        sort 'nombre'
        cache usage: 'read-write', include: 'non-lazy'
        id name: "codigo", generator: 'assigned', type:"string"
        version false
        columns {
            codigo column: 'codigo_cliente', insertable: false, updateable: false
            estado column: 'estado_cliente'
            nombre column: 'nombre_cliente'
            aplicacion column: 'codigo_aplicacion'
            direccion column: 'direccion_cliente'
            telefono column: 'felefono_cliente'
            ruc column: 'ruc_cliente'
            propetario column: 'propietario_1'
            representante column: 'representante_legal'
            mail column: 'mail_cliente'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        direccion(nullable: true,blank: true)
        mail(nullable: true,blank: true)
        telefono(nullable: true,blank: true)
        propetario(nullable: true,blank: true)
        representante(nullable: true,blank: true)
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return "${this.nombre}"
    }

}
