package gaia.parametros

class Parametros {

    Integer diasAlertaContratos

    static auditable = true
    static mapping = {
        table 'prmt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prmt__id'
        id generator: 'identity'
        version false
        columns {
            diasAlertaContratos column: 'prmtdact'
        }
    }
    static constraints = {

    }

    static int getDiasContrato(){
        def par = Parametros.list()
        if(par.size()>0){
            return par.first().diasAlertaContratos
        }else{
            return 182 //aprox 6 meses
        }
    }
}
