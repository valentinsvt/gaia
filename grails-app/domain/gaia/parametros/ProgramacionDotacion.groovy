package gaia.parametros

class ProgramacionDotacion {

    Anio anio
    Integer numero
    Date fecha1
    Date fecha2

    static auditable = true
    static mapping = {
        table 'prdt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prdt__id'
        id generator: 'identity'
        version false
        columns {
            anio column: 'anio__id'
            numero column: 'prdtnmro'
            fecha1 column: 'prdtfch1'
            fecha2 column: 'prdtfch2'
        }
    }
    static constraints = {
        fecha2(nullable: true,blank:true)
    }

    String toString(){
        return "${this.anio} ${this.numero} ${this.fecha1?.format('dd-MM-yyyy') ${this.fecha2.format('dd-MM-yyyy')}}"
    }
}
