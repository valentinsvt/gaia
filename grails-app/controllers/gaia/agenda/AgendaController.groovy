package gaia.agenda

import gaia.seguridad.Shield

class AgendaController extends Shield {

    def index(){

        redirect(action: 'dash')

    }

    def dash(){

    }
}
