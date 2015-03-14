<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Documentación requeridas</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight', file: 'jquery-highlight1.js')}"></imp:js>
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <style>
    .td-semaforo {
        text-align : center;
        width      : 110px;
    }

    .circle-card {
        width  : 22px;
        height : 22px;
    }

    .circle-btn {
        cursor : pointer;
    }

    .highlight {
        background-color : yellow;
    }
    </style>
</head>

<body>
<div class="pdf-viewer">
    <div class="pdf-content">
        <div class="pdf-container" id="doc"></div>

        <div class="pdf-handler">
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
        <g:link action="showEstacion" id="${estacion.codigo}" class="btn btn-default">
            <i class="flaticon-fuel2"></i>
            Estación
        </g:link>
        <a href="${g.createLink(controller: 'documento', action: 'arbolEstacion', params: [codigo: estacion.codigo])}" class="btn btn-default mapa">
            <i class="fa fa-file-pdf-o"></i> Visor de documentos
        </a>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Documentación por aprobar de la estación: ${estacion.nombre}">

    <table class="table table-striped table-hover table-bordered" style="margin-top: 15px;font-size: 11px">
        <thead>
        <tr>
            <th>Entidad</th>
            <th>Tipo de documento</th>
            <th>Descripción</th>
            <th>Referencia</th>
            <th>Emisión</th>
            <th>Vence</th>
            <th>Ver</th>
            <th>Editar</th>
            <th>Aprobar</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${docs}" var="d">
            <tr>
                <td title="${d.tipo.entidad.nombre}">${d.tipo.entidad.codigo}</td>
                <td>${d.tipo.nombre}</td>
                <td>${d.descripcion}</td>
                <td>${d.referencia}</td>
                <td style="width: 72px;text-align: center">${d.inicio?.format("dd-MM-yyyy")}</td>
                <td style="width: 72px;text-align: center">${d.fin?.format("dd-MM-yyyy")}</td>
                <td style="text-align: center">
                    <a href="#" data-file="${d.path}"
                       data-ref="${d.referencia}"
                       data-codigo="${d.codigo}"
                       data-tipo="${d.tipo.nombre}"
                       target="" class="btn btn-info ver-doc btn-sm">
                        <i class="fa fa-search"></i> Ver
                    </a>
                </td>
                <td>
                    <g:if test="${d.tipo.tipo!='P'}">
                        <g:link controller="documento" action="subir" params="[id:estacion.codigo,doc:d.id]" title="Editar" class="btn btn-sm btn-info">
                            <i class="fa fa-pencil"></i>
                        </g:link>
                    </g:if>

                </td>
                <td style="width: 135px;text-align: center">
                    <util:displayEstadoDocumento documento="${d}"/>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</elm:container>
<script type="text/javascript">
    function showPdf(div) {
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
                navpanes  : 1,
                statusbar : 0,
                view      : "FitW"
            }
        }).embed("doc");
        $(".pdf-viewer").show("slide", {direction : 'right'})
        $("#data").show()
    }
    $(".borrar").click(function () {
        var id = $(this).attr("id")
        bootbox.confirm({
            message  : "Está seguro?",
            title    : "Atención",
            class    : "modal-error",
            callback : function (res) {
                if (res) {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:'estacion', action:'borrarReq')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            window.location.reload(true)
                        }
                    });
                }
            }
        })
    })
    $(".ver-doc").click(function () {
        showPdf($(this))
        return false
    })
    $(".pdf-handler").click(function () {
        $(".pdf-viewer").hide("slide", {direction : 'right'})
        $("#data").hide()
    })

    $(".pdf-viewer").resizable();

</script>
</body>
</html>