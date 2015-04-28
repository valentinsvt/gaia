package gaia.contratos

import gaia.Contratos.DashBoardContratos
import gaia.Contratos.DetallePintura
import gaia.Contratos.SubDetallePintura
import gaia.seguridad.Shield

class PinturaController extends Shield {
    static final sistema="CNTR"

    def lista(){
        def estaciones
        def dash
        dash = DashBoardContratos.list([sort: "id"])
        def now = new Date()
        def inicio = new Date().parse("dd-MM-yyyy","01-01-"+now.format("yyyy"))
        def fin = new Date().parse("dd-MM-yyyy","31-12-"+now.format("yyyy"))
        [dash:dash,now:now,inicio:inicio,fin:fin]
    }

    def verDetalles(){
        def now = new Date()
        def inicio = new Date().parse("dd-MM-yyyy","01-01-"+now.format("yyyy"))
        def fin = new Date().parse("dd-MM-yyyy","31-12-"+now.format("yyyy"))
        def pintura = DetallePintura.findByClienteAndFinBetween(params.id,inicio,fin,[sort: "fin",order: "desc"])
        def detalle = SubDetallePintura.findAllBySecuencialAndCliente(pintura.secuencial,params.id)



        [detalle:detalle,pintura:pintura]
    }

}
