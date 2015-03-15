package gaia

import gaia.alertas.Alerta
import gaia.seguridad.Permiso

class MenuTagLib {
//    static defaultEncodeAs = 'html'
    //static encodeAsForTags = [tagName: 'raw']

    static namespace = 'mn'

    def stickyFooter = { attrs ->
        def html = ""
        html += "<footer class='footer ${attrs['class']}'>"
        html += "<div class='container text-center'>"
        html += "Petróleos y servicios - 2015 Todos los derechos reservados"
        html += "</div>"
        html += "</footer>"
        out << html
    }

    def bannerTop = { attrs ->

        def large = attrs.large ? "banner-top-lg" : ""

        def html = ""
        html += "<div class='banner-top ${large}'>"
        html += "<div class='banner-esquina'>"
        html += "</div>"
        html += "<div class='banner-title'>PETRÓLEOS Y SERVICIOS - Sistema documental de gestión ambiental integral</div>"
        html += "<div class='banner-logo'>"
        html += "</div>"
        html += "<div class='banner-esquina der'>"
        html += "</div>"

        html += "</div>"

        out << html
    }

    def menu = { attrs ->

        def items = [:]
        def usuario, perfil, dpto
        if (session.usuario) {
            usuario = session.usuario
            perfil = session.perfil
            dpto = session.departamento
        }
        def strItems = ""
        if (!attrs.title) {
            attrs.title = "Sistema de documentación ambiental"
        }
        if (usuario) {
            def acciones = Permiso.withCriteria {
                eq("perfil", perfil)
                accion {
                    modulo {
                        order("orden", "asc")
                    }
                    order("orden", "asc")
                }
            }.accion

            acciones.each { ac ->
                if (ac.tipo.codigo == 'M' && ac.modulo.nombre != 'noAsignado') {
                    if (!items[ac.modulo.id]) {
                        items[ac.modulo.id] = [
                                label: ac.modulo.nombre,
                                icon : ac.modulo.icono,
                                items: [:]
                        ]
                    }
                    def acc = [
                            controller: ac.control.nombre,
                            action    : ac.nombre,
                            label     : ac.descripcion,
                            icon      : ac.icono
                    ]
                    items[ac.modulo.id]["items"][ac.id] = acc
                }
            }

            items.each { k, v ->
                if (v.items.size() == 1) {
                    v.items.each { ki, vi ->
                        if (vi.label == v.label) {
                            v.controller = vi.controller
                            v.action = vi.action
                            if (!v.icon) {
                                v.icon = vi.icon
                            }
                            v.items = null
                        }
                    }
                }
            }

        } else {
            items = [
                    "Inicio": [
                            controller: "inicio",
                            action    : "index",
                            label     : "Inicio",
                            icon      : "fa-home"
                    ],
                    admin   : [
                            label: "Administración",
                            icon : "fa-cog",
                            items: [
                                    alergia: [
                                            controller: "test1",
                                            action    : "list",
                                            label     : "Test 1",
                                            icon      : "fa-stethoscope"
                                    ],
                                    clinica: [
                                            controller: "test2",
                                            action    : "list",
                                            label     : "Test 2",
                                            icon      : "fa-hospital"
                                    ]
                            ]
                    ]
            ]
        }

        items.each { k, item ->
            strItems += renderItem(item)
        }

        def alertas = "("
        def count
        if(session.tipo=="usuario")
            count= Alerta.countByPersonaAndFechaRecibidoIsNull(usuario)
        else
            count= Alerta.countByEstacionAndFechaRecibidoIsNull(usuario)

        alertas += count
        alertas += ")"

        def html = "<nav class=\"navbar navbar-default navbar-fixed-top\" role=\"navigation\">"

        html += "<div class=\"container-fluid\">"

        // Brand and toggle get grouped for better mobile display
        html += '<div class="navbar-header">'
        html += '<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">'
        html += '<span class="sr-only">Toggle navigation</span>'
        html += '<span class="icon-bar"></span>'
        html += '<span class="icon-bar"></span>'
        html += '<span class="icon-bar"></span>'
        html += '</button>'
        html += '<a class="navbar-brand navbar-logo" href="#">'
        html += '<img src="' + resource(dir: 'images/barras', file: 'logo-menu.png') + '" />'
        html += '</a>'
        html += '</div>'

        // Collect the nav links, forms, and other content for toggling
        html += '<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">'
        html += '<ul class="nav navbar-nav">'
        html += strItems
        html += '</ul>'

        html += '<ul class="nav navbar-nav navbar-right">'
        html += '<li><a href="' + g.createLink(controller: 'alerta', action: 'list') + '" ' + ((count > 0) ? ' style="color:#ab623a" class="annoying"' : "") + '><i class="fa fa-exclamation-triangle"></i> Alertas ' + alertas + '</a></li>'
        html += '<li class="dropdown">'
        html += '<a href="#" class="dropdown-toggle" data-toggle="dropdown">' + session.usuario + ' (' + session.perfil + ')' + ' <b class="caret"></b></a>'
        html += '<ul class="dropdown-menu">'
        html += '<li><a href="' + g.resource(file: 'manual.pdf') + '" target="_blank"><i class="fa fa-file-pdf-o"></i> Manual de usuario</a></li>'
        html += '<li class="divider"></li>'
        html += '<li><a href="' + g.createLink(controller: 'login', action: 'logout') + '"><i class="fa fa-power-off"></i> Salir</a></li>'
        html += '</ul>'
        html += '</li>'
        html += '</ul>'

        html += '</div><!-- /.navbar-collapse -->'

        html += "</div>"

        html += "</nav>"

        out << html
    }

    /**
     * Función que genera una porción de un item del menú
     * @param item
     * @return String con el elemento "<li>" del item
     */
    def renderItem(item) {
        def str = "", clase = ""
        if (session.cn == item.controller && session.an == item.action) {
            clase = "active"
        }
        if (item.items) {
            clase += " dropdown"
        }
        str += "<li class='" + clase + "'>"
        if (item.items) {
            str += "<a href='#' class='dropdown-toggle' data-toggle='dropdown'>"
            if (item.icon) {
                str += "<i class='fa ${item.icon}'></i>"
                str += " "
            }
            str += item.label
            str += "<b class=\"caret\"></b></a>"
            str += '<ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">'
            item.items.each { t, i ->
                str += renderItem(i)
            }
            str += "</ul>"
        } else {
            str += "<a href='" + createLink(controller: item.controller, action: item.action, params: item.params) + "'>"
            if (item.icon) {
                str += "<i class='fa ${item.icon}'></i>"
                str += " "
            }
            str += item.label
            str += "</a>"
        }
        str += "</li>"

        return str
    }

}
