<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <title>Licencia ambiental de la estación: ${estacion.nombre}</title>
</head>
<body>
<div class="pdf-viewer">
    <div class="pdf-content" >
        <div class="pdf-container" id="doc"></div>
        <div class="pdf-handler" >
            <i class="fa fa-arrow-right"></i>
        </div>
        <div class="pdf-header" id="data">
            N. Referencia: <span id="referencia-pdf" class="data"></span>
            Código: <span id="codigo" class="data"></span>
            Tipo: <span id="tipo" class="data"></span>



        </div>
        <div id="msgNoPDF">
            <p>No tiene configurado el plugin de lectura de PDF en este navegador.</p>

            <p>
                Puede
                <a class="text-info" target="_blank" style="color: white" href="http://get.adobe.com/es/reader/">
                    <u>descargar Adobe Reader aquí</u>
                </a>
            </p>
        </div>
    </div>
</div>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <a href="${g.createLink(controller: 'estacion',action: 'showEstacion',id: estacion.codigo)}" class="btn btn-default ">
            Estación
        </a>
        <a href="${g.createLink(controller: 'documento', action: 'arbolEstacion', params: [codigo: estacion.codigo])}" class="btn btn-default mapa">
            <i class="fa fa-file-pdf-o"></i> Visor de documentos
        </a>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Licencia ambiental de la estación: ${estacion.nombre}" >
    <div class="row">
        <div class="col-md-1">
            <label>
                Consultor:
            </label>
        </div>
        <div class="col-md-4">
            <g:if test="${proceso.consultor}">
                <a href="#" class="btn btn-info btn-sm" iden="${proceso.consultor?.id}" id="consultor">
                    <i class="fa fa-users"></i>
                    ${proceso.consultor?.nombre}
                </a>
            </g:if>
            <g:else>
                No hay un consultor asignado
            </g:else>
        </div>
    </div>
    <table class="table table-hover table-striped table-bordered" style="margin-top: 10px">
        <thead>
        <tr>
            <th>Tipo de documento</th>
            <th>Referencia</th>
            <th>Observaciones</th>
            <th>Emisión</th>
            <th>Código</th>
            <th>Ver</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${detalles}" var="d" status="i">
            <tr style="${(d.tipo.codigo!='TP07' && d.tipo.codigo!='TP05' && d.tipo.codigo!='TP14' && d.tipo.codigo!='TP06')?'font-weight: bold':''}">
                <td>${d.tipo.nombre} </td>
                <td style="text-align: center">${d.documento.referencia}</td>
                <td>${d.documento.descripcion}</td>
                <td style="text-align: center">${d.documento.inicio.format("dd-MM-yyyy")}</td>
                <td style="text-align: center">${d.documento.codigo}</td>
                <td style="text-align: center">
                    <a href="#" data-file="${d.documento.path}"
                       data-ref="${d.documento.referencia}"
                       data-codigo="${d.documento.codigo}"
                       data-tipo="${d.documento.tipo.nombre}"
                       class="btn btn-info ver-doc btn-sm" >
                        <i class="fa fa-search"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</elm:container>
<script type="text/javascript">
    function verConsultor(id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'consultor', action:'show_ajax')}",
            data    : {
                id : id
            },
            success : function (msg) {
                bootbox.dialog({
                    title   : "Ver Consultor",

                    message : msg,
                    buttons : {
                        ok : {
                            label     : "Aceptar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        });
    }
    $("#consultor").click(function(){
        verConsultor($(this).attr("iden"))
    })
    function showPdf(div){
        $("#msgNoPDF").show();
        $("#doc").html("")
        var pathFile = div.data("file")
        $("#referencia-pdf").html(div.data("ref"))
        $("#codigo").html(div.data("codigo"))
        $("#tipo").html(div.data("tipo"))
        var path = "${resource()}/" + pathFile;
        var myPDF = new PDFObject({
            url           : path,
            pdfOpenParams : {
                navpanes: 1,
                statusbar: 0,
                view: "FitW"
            }
        }).embed("doc");
        $(".pdf-viewer").show("slide",{direction:'right'})
        $("#data").show()
    }
    $(".ver-doc").click(function(){
        showPdf($(this))
        return false
    })
    $(".pdf-handler").click(function(){
        $(".pdf-viewer").hide("slide",{direction:'right'})
        $("#doc").html("")
        $("#data").hide()
    })
</script>
</body>
</html>