package gaia

class ReportesTagLib {
   // static defaultEncodeAs = [taglib: 'html']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]
    static encodeAsForTags = [tagName:"raw"]

    def header = { attrs->
        def titulo = attrs.titulo
        out<<"<div class='titulo'>${titulo}</div>"
    }
}
