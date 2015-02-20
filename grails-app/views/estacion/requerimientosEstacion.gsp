<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Documentación requeridas</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight',file: 'jquery-highlight1.js')}"></imp:js>
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <style>
    .td-semaforo{
        text-align: center;
        width: 110px;
    }
    .circle-card{
        width: 22px ;
        height: 22px;
    }
    .circle-btn{
        cursor: pointer;
    }
    .highlight { background-color: yellow; }
    </style>
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
<elm:container tipo="horizontal" titulo="Documentación requerida para la estación: ${estacion.nombre}">
    <div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
        <div class="btn-group">
            <g:link action="showEstacion" id="${estacion.codigo}" class="btn btn-default">
                <i class="fa fa-university"></i>
                Estacion
            </g:link>
            <a href="${g.createLink(controller: 'documento', action: 'arbolEstacion', params: [codigo: estacion.codigo])}" class="btn btn-default mapa">
                <i class="fa fa-file-pdf-o"></i> Visor de documentos
            </a>
        </div>
    </div>
    <table class="table table-striped table-hover table-bordered" style="margin-top: 15px;">
        <thead>
        <tr>
            <th>Entidad</th>
            <th style="width: 40%">Tipo de documento</th>
            <th class="td-semaforo">Estado</th>
            <th style="width: 100px">Documento</th>
            <th></th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${reqs}" var="r">
            <tr>
                <g:set var="doc" value="${estacion.getLastDoc(r.tipo)}"/>
                <td style="text-align: center">${r.tipo.entidad.codigo}</td>
                <td>${r.tipo.nombre}</td>
                <td class="td-semaforo"><div class="circle-card ${doc?(doc.estado=='A'?'card-bg-green':'svt-bg-danger'):'svt-bg-danger'}"></div></td>
                <td style="text-align: center">
                    <g:if test="${doc}">
                        ${doc.referencia}
                        <a href="#" data-file="${doc.path}"
                           data-ref="${doc.referencia}"
                           data-codigo="${doc.codigo}"
                           data-tipo="${doc.tipo.nombre}"
                           target="" class="btn btn-info ver-doc">
                            <i class="fa fa-search"></i> Ver
                        </a>

                    </g:if>
                    <g:else>
                        <g:link controller="documento" action="subir" params="[tipo:r.tipo.id,id:estacion.codigo]" target="_blank" class="btn btn-info btn-sm">
                            <i class="fa fa-upload"></i> Registrar
                        </g:link>
                    </g:else>
                </td>
                <td style="text-align: center;width: 150px">
                    <util:displayEstadoDocumento documento="${doc}"/>
                </td>
                <td style="text-align: center">
                    <g:if test="${session.tipo=='usuario'}">
                        <a href="#" class="borrar btn btn-danger btn-sm" id="${r.id}" >
                            <i class="fa fa-trash"></i> No necesario
                        </a>
                    </g:if>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</elm:container>
<script type="text/javascript">
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
    $(".borrar").click(function(){
        var id = $(this).attr("id")
        bootbox.confirm({
            message:"Está seguro?",
            title   : "Atención",
            class   : "modal-error",
            callback:function(res){
                if(res){
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller:'estacion', action:'borrarReq')}",
                        data: {
                            id: id
                        },
                        success: function (msg) {
                            window.location.reload(true)
                        }
                    });
                }
            }
        })
    })
    $(".ver-doc").click(function(){
        showPdf($(this))
        return false
    })
    $(".pdf-handler").click(function(){
        $(".pdf-viewer").hide("slide",{direction:'right'})
        $("#data").hide()
    })

    $(".pdf-viewer").resizable();

</script>
</body>
</html>