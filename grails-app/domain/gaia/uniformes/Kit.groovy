package gaia.uniformes



class Kit {

    String nombre
    String estado="A"
    String genero

    static mapping = {
        table 'kit'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        sort nombre: "asc"
        columns {
            id column: 'kit__id'
            nombre column: 'kit_nmbr'
            estado column: 'kit_etdo'
            genero column: 'kit_gnro'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        nombre(size: 1..100)
        estado(size: 1..1)
        genero(size: 1..1,inList: ["M","F","U"])
    }

    def getListaUiformes(NominaEstacion empleado){
        def html ="<ul style='font-size:10px'>"
        DetalleKit.findAllByKit(this).each {
            def talla = EmpleadoTalla.findByEmpleadoAndUniforme(empleado,it.uniforme)
            if(!talla)
                talla="N.A."
            else
                talla=talla.talla
            html+="<li>"+it.cantidad+" "+it.uniforme.descripcion+" Talla: ${talla} </li>"

        }
        html+="</ul>"
        return html
    }
}
