package gaia

class ReportesTagLib {
    static namespace = 'rep'

//    static defaultEncodeAs = [taglib: 'html']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]

    /**
     * genera los estilos básicos para los reportes según la orientación deseada
     */
    def estilos = { attrs ->
        def logoW = 5
        def pags = false
        if (attrs.pags == 1 || attrs.pags == "1" || attrs.pags == "true" || attrs.pags == true || attrs.pags == "si") {
            pags = true
        }
        if (!pags && attrs.pagTitle) {
            pags = true
        }

        if (!attrs.orientacion) {
            attrs.orientacion = "p"
        }
        def headerW = 21.0
        def pOrientacion = attrs.orientacion.toString().toLowerCase()
        def orientacion = "portrait"
        def margenes = [
                top   : 3,
                right : 2,
                bottom: 3,
                left  : 2
        ]
        switch (pOrientacion) {
            case "l":
            case "landscape":
            case "horizontal":
            case "h":
                orientacion = "landscape"
                headerW = 29.7
                break;
        }
        headerW = headerW - margenes.right - margenes.left - logoW

        def css = "<style type='text/css'>"
        css += "* {\n" +
                "    font-family   : 'PT Sans Narrow';\n" +
                "    font-size     : 11pt;\n" +
                "}"
        css += " @page {\n" +
                "    size          : A4 ${orientacion};\n" +
                "    margin-top    : ${margenes.top}cm;\n" +
                "    margin-right  : ${margenes.right}cm;\n" +
                "    margin-bottom : ${margenes.bottom}cm;\n" +
                "    margin-left   : ${margenes.left}cm;\n" +
                "}"
        css += "@page {\n" +
                "    @top-center {\n" +
                "        content : element(header);\n" +
                "    }\n" +
                "}"
        css += "@page {\n" +
                "    @top-left {\n" +
                "        content : element(headerLogo);\n" +
                "    }\n" +
                "}"
        css += "@page {\n" +
                "    @bottom-right {\n" +
                "        content : element(footer);\n" +
                "    }\n" +
                "}"
        if (pags) {
            css += "@page {\n" +
                    "    @bottom-left { \n" +
                    "        content     : '${attrs.pagTitle ?: ''} pág.' counter(page) ' de ' counter(pages);\n" +
                    "        font-family : 'PT Sans Narrow';\n" +
                    "        font-size   : 8pt;" +
                    "        font-style  : italic\n" +
                    "    }\n" +
                    "}"
        }
        css += "#header{\n" +
//                "    width      : ${headerW}cm;\n" +
                "    position   : running(header);\n" +
                "}"
        css += "#headerLogo{\n" +
                "    position   : running(headerLogo);\n" +
                "}"
        css += "#footer{\n" +
                "    text-align : right;\n" +
                "    position   : running(footer);\n" +
                "    color      : #7D807F;\n" +
                "}"
        css += "@page{\n" +
                "    orphans    : 4;\n" +
                "    widows     : 2;\n" +
                "}"
        css += "table {\n" +
                "    page-break-inside : avoid;\n" +
                "}"
        css += ".tituloReporte{\n" +
                "    text-align     : center;\n" +
                "    text-transform : uppercase;\n" +
//                "    font-family    : 'PT Sans';\n" +
                "    font-size      : 15pt;\n" +
                "    font-weight    : bold;\n" +
                "    color          : #006eb7;\n" +
                "    border-bottom  : solid 2px #e3452a;\n" +
                "}"
        css += "</style>"

        out << raw(css)
    }

    /**
     * Muestra el header para los reportes
     * @param title el título del reporte
     */
    def headerReporte = { attrs ->
        def title = attrs.title ?: ""

        def h = 55

        def logoPath = resource(dir: 'images', file: 'logo-pdf-header.png')
        def html = ""

        html += '<div id="headerLogo">'
        html += "<img src='${logoPath}' style='height:${h}px;'/>"
        html += '</div>'

        html += '<div id="header">'
        html += "<div class='tituloReporte'>"
        html += title
        html += '</div>'
        html += '</div>'
        out << raw(html)
    }

    /**
     * Muestra el footer para los reportes
     */
    def footerReporte = { attrs ->
        def html = ""
//        def h = 75
//        def logoPath = resource(dir: 'images', file: 'logo-pdf-footer.png')
//
        html += '<div id="footer">'
        html += 'Impreso el ' + new Date().format("dd-MM-yyyy HH:mm")
        html += "</div>"
        out << raw(html)
    }

    def headerFooter = { attrs ->
        attrs.title = attrs.title ?: ""
        def header = headerReporte(attrs)
        def footer = footerReporte(attrs)

        out << header << footer
    }

}