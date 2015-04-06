<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <title>
        Registrar licencia ambiental
    </title>
    <style type="text/css">
    label{
        padding-top: 5px;
    }
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
<elm:container tipo="horizontal" titulo="Estación: ${estacion.nombre}" >
    <div class="panel panel-info" style="margin-top: 20px">
        <div class="panel-heading">Licencia ambiental</div>
        <div class="panel-body" style="padding:0px">
            <div class="header-flow">
                <div class="header-flow-item active">
                    <span class="badge active">1</span> Certificado de intersección
                    <span class="arrow"></span>
                </div>
                %{--<g:if test="${detalle?.documento}">--}%
                    <g:link controller="licencia" action="licenciaTdr" id="${proceso.id}">
                        <div class="header-flow-item disabled">
                            <span class="badge disabled">2</span>
                            Términos de referencia
                            <span class="arrow"></span>
                        </div>
                    </g:link>
                %{--</g:if>--}%
                %{--<g:else>--}%
                    %{--<div class="header-flow-item disabled">--}%
                        %{--<span class="badge disabled">2</span>--}%
                        %{--Términos de referencia--}%
                        %{--<span class="arrow"></span>--}%
                    %{--</div>--}%
                %{--</g:else>--}%
                <div class="header-flow-item disabled">
                    <span class="badge disabled">3</span>
                    Estudio de impacto ambiental
                    <span class="arrow"></span>
                </div>
                <div class="header-flow-item disabled">
                    <span class="badge disabled">4</span>
                    Pago y licencia
                </div>
            </div>
            <div class="flow-body">
                <div class="row" style="border-bottom: 1px solid #3A5DAA;width: 99%;padding-bottom: 10px;margin-bottom: 5px">
                    <div class="col-md-3">
                        <label>
                            Consultor encargado del proceso:
                        </label>
                    </div>
                    <div class="col-md-4">
                        <g:select name="consultor"  id="consultor" class="form-control input-sm" from="${gaia.documentos.ConsultorEstacion.findAllByEstacion(estacion)?.consultor}" optionKey="id" optionValue="nombre" value="${proceso?.consultor?.id}"/>
                    </div>
                    <div class="col-md-1">
                        <a href="#" class="btn btn-success" id="consultor-btn">
                            <i class="fa fa-disk"></i> Guardar
                        </a>
                    </div>
                </div>

                <g:form class="frm-subir" controller="licencia" action="saveCertificado" enctype="multipart/form-data" >
                    <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
                    <input type="hidden" name="proceso" value="${proceso?.id}" >
                    <input type="hidden" name="id" value="${detalle?.id}" >
                    <div class="row">
                        <div class="col-md-2">
                            <label>
                                Certificado
                            </label>
                        </div>
                        <div class="col-md-4">
                            <g:if test="${detalle?.documento}">
                                <div id="botones">
                                    ${detalle.documento.codigo}
                                    <a href="#" data-file="${detalle.documento.path}"
                                       data-ref="${detalle.documento.referencia}"
                                       data-codigo="${detalle.documento.codigo}"
                                       data-tipo="${detalle.documento.tipo.nombre}"
                                       class="btn btn-info ver-doc" >
                                        <i class="fa fa-search"></i> Ver
                                    </a>

                                    <a href="#" class="btn btn-info" id="cambiar">
                                        <i class="fa fa-refresh"></i> Cambiar
                                    </a>

                                    <util:displayEstadoDocumento documento="${detalle.documento}"/>
                                </div>
                                <div id="div-file" style="display: none">
                                    <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                                </div>
                            </g:if>
                            <g:else>
                                <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                            </g:else>

                        </div>
                        <div class="col-md-1">
                            <label>
                                Dependencia
                            </label>
                        </div>
                        <div class="col-md-3">
                            <g:select name="dependencia" from="${gaia.documentos.Dependencia.list()}" optionKey="id" optionValue="nombre"
                                      class="form-control input-sm required" value="${detalle?.dependencia?.id}"></g:select>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-2">
                            <label>
                                N. referencia
                            </label>
                        </div>
                        <div class="col-md-4">
                            <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detalle?.documento?.referencia}">
                        </div>
                        <div class="col-md-1">
                            <label>
                                Emisión
                            </label>
                        </div>
                        <div class="col-md-3">
                            <elm:datepicker name="inicio" class="required form-control input-sm" value="${detalle?.documento?.inicio}"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2">
                            <label>
                                Observaciones
                            </label>
                        </div>
                        <div class="col-md-8">
                            <input type="text" name="descripcion" class="form-control input-sm required" required="" maxlength="512" value="${detalle?.documento?.descripcion}">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-1">
                            <a href="#" class="btn btn-primary" id="guardar">
                                <i class="fa fa-save"></i>
                                Guardar
                            </a>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</elm:container>
<script type="text/javascript">
    var validator = $(".frm-subir").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        }
    });
    function warning(){
        var msg="La estación ${estacion.nombre} ya tiene una licencia ambiental vigente, si decide continuar dicha licencia será anulada. Continuar?"
        bootbox.confirm({
            message:msg,
            title   : "Atención",
            class   : "modal-error",
            callback:function(res){
                if(res){
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller:'licencia', action:'caducarLic')}",
                        data: {
                            id: "${estacion.codigo}"
                        },
                        success: function (msg) {
                            window.location.reload(true)
                        }
                    });
                }
            }
        })
    }

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


    $("#guardar").click(function(){
        $(".frm-subir").submit()
    })
    $("#cambiar").click(function(){
        $("#botones").hide()
        $("#div-file").show()
    })
    $(".ver-doc").click(function(){
        showPdf($(this))
        return false
    })
    $(".pdf-handler").click(function(){
        $(".pdf-viewer").hide("slide",{direction:'right'})
        $("#doc").html("")
        $("#data").hide()
    })
    $("#consultor-btn").click(function(){
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'licencia', action:'cambiarConsultor')}",
            data: {
                id: $("#consultor").val(),
                proceso : "${proceso?.id}"
            },
            success: function (msg) {
               log("Datos guardados")
            }
        });
    })
</script>
</body>
</html>