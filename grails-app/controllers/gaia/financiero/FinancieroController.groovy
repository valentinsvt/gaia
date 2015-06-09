package gaia.financiero

import gaia.seguridad.Shield

class FinancieroController extends Shield {
    static sistema="FNCR"
    def index() {
        redirect(action: "dash")
    }

    def dash(){

    }
}
