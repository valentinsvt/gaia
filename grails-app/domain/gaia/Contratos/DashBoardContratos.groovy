package gaia.Contratos

import gaia.estaciones.Estacion
import gaia.parametros.Parametros

class DashBoardContratos {

    Estacion estacion
    Date ultimoContrato
    Date ultimaPintura
    Double porcentajeComercializacion

    static mapping = {
        table 'dhcn'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'dash__id'
            estacion column: 'stcn__id'
            ultimoContrato column: 'dhcnfccn'
            ultimaPintura column: 'dhcnfcpn'
            porcentajeComercializacion column: 'prctcmlz'
        }
    }
    static constraints = {
        ultimaPintura(nullable: true,blank:true)
        ultimoContrato(nullable: true,blank:true)
        porcentajeComercializacion(nullable: true,blank:true)
    }

    def getColorSemaforoContrato(fecha){
        def now = new Date()
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]

        if (this.ultimoContrato > now) {
            if(this.ultimoContrato<fecha){
                return [colores[1],"orange-contrato"]
            }else{
                return [colores[0],"green-contrato"]
            }

        }
        return [colores[2],"red-contrato"]
    }
}
