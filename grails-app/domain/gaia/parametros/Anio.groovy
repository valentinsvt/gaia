package gaia.parametros

class Anio {

    String anio

    static auditable = true
    static mapping = {
        table 'anio'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'anio__id'
        id generator: 'identity'
        version false
        columns {
            anio column: 'anioanio'
        }
    }
    static constraints = {
        anio(nullable: false,blank: false)
    }

    String toString(){
        return "${this.anio}"
    }


}
