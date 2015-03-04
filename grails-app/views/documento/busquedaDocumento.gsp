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
<elm:container tipo="horizontal" titulo="Busqueda de documentos" style="margin-top: 0px">
    <div class="row">
        <div class="col-md-1">
            <label>
                Estación:
            </label>
        </div>
        <div class="col-md-4">
            <g:select name="estacion" id="estacion" from="${estaciones}" class="form-control input-sm" optionKey="codigo" optionValue="nombre" noSelection="['-1':'Todos']"></g:select>
        </div>
        <div class="col-md-1">
            <label>
                Tipo:
            </label>
        </div>
        <div class="col-md-4">
            <g:select name="tipo" id="tipo_doc" from="${tipos}" class="form-control input-sm" optionKey="id" optionValue="nombre" noSelection="['-1':'Todos']"></g:select>
        </div>

    </div>
    <div class="row">
        <div class="col-md-1">
            <label>
                Registrado:
            </label>
        </div>
        <div class="col-md-2">
            <elm:datepicker name="inicio"  class="form-control input-sm inicio " placeHolder="Desde" />
        </div>
        <div class="col-md-2">
            <elm:datepicker name="fin"  class="form-control input-sm fin " placeHolder="Hasta"  />
        </div>
        <div class="col-md-1">
            <label>
                Consultor:
            </label>
        </div>
        <div class="col-md-4">
            <g:select name="consultor" id="consultor" from="${consultores}" class="form-control input-sm" optionKey="id" optionValue="nombre" noSelection="['-1':'Todos']"></g:select>
        </div>
    </div>
    <div class="row">
        <div class="col-md-1">
            <label>
                Emitido:
            </label>
        </div>
        <div class="col-md-2">
            <elm:datepicker name="inicio_emitido"  class="form-control input-sm inicio_emitido " placeHolder="Desde" />
        </div>
        <div class="col-md-2">
            <elm:datepicker name="fin_emitido"  class="form-control input-sm fin_emitido " placeHolder="Hasta"  />
        </div>
        <div class="col-md-1">
            <label>
                Vence:
            </label>
        </div>
        <div class="col-md-2">
            <elm:datepicker name="inicio_vence"  class="form-control input-sm inicio_vence " placeHolder="Desde" />
        </div>
        <div class="col-md-2">
            <elm:datepicker name="fin_vence"  class="form-control input-sm fin_vence " placeHolder="Hasta"  />
        </div>
        <div class="col-md-1">
            <a href="#" class="btn btn-info btn-sm" id="buscar">
                <i class="fa fa-search"></i> Buscar
            </a>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12" id="lista"></div>
    </div>

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


    $(".pdf-handler").click(function(){
        $(".pdf-viewer").hide("slide",{direction:'right'})
        $("#data").hide()
    })

    $(".pdf-viewer").resizable();
    $("#buscar").click(function(){
        openLoader()
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'documento', action:'buscar')}",
            data    : {
                estacion:$("#estacion").val(),
                tipo:$("#tipo_doc").val(),
                consultor:$("#consultor").val(),
                registro_desde:$("#inicio_input").val(),
                registro_hasta:$("#fin_input").val(),
                emitido_desde:$("#inicio_emitido_input").val(),
                emitido_hasta:$("#fin_emitido_input").val(),
                vence_desde:$("#inicio_vence_input").val(),
                vence_hasta:$("#fin_vence_input").val()
            },
            success : function (msg) {
               $("#lista").html(msg)
                closeLoader()
            }
        });
    })
</script>
</body>