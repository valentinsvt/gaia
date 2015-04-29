<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <title>
        Registrar auditoría ambiental
    </title>
    <style type="text/css">
    label{
        padding-top: 5px;
    }
    fieldset{
        margin-top: 15px;
        padding: 10px;
        padding-top: 0px;
        margin-left: -10px;
    }
    legend{
        border-color: #3A87AD;
        color: #3A87AD;
    }
    .header-flow-item{
        width: 33%;
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
    <div class="panel-heading">${proceso.tipo.nombre}</div>
    <div class="panel-body" style="padding:0px">
        <div class="header-flow">

            <div class="header-flow-item active">
                <span class="badge active">1</span>
                Términos de referencia
                <span class="arrow"></span>
            </div>

            <g:link controller="auditoriaAmbiental" action="auditoria" id="${proceso.id}" style="text-decoration: none">
                <div class="header-flow-item disabled">
                    <span class="badge disabled">2</span>
                    Auditoría ambiental
                    <span class="arrow"></span>
                </div>
            </g:link>

            <div class="header-flow-item disabled">
                <span class="badge disabled">3</span>
                Pago
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
            <g:form class="frm-subir-tdr" controller="auditoriaAmbiental" action="upload" enctype="multipart/form-data" >
                <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
                <input type="hidden" name="proceso" value="${proceso?.id}" >
                <input type="hidden" name="id" value="${detalleTdr?.id}" >
                <input type="hidden" name="tipo" value="tdr" >
                <input type="hidden" name="paso" value="1" >
                <input type="hidden" name="origen" value="registrarAuditoria" >
                <div class="row">
                    <div class="col-md-2">
                        <label>
                            Términos de referencia
                        </label>
                    </div>
                    <div class="col-md-4">
                        <g:if test="${detalleTdr?.documento}">
                            <div id="botones-tdr">
                                ${detalleTdr.documento.codigo}
                                <a href="#" data-file="${detalleTdr.documento.path}"
                                   data-ref="${detalleTdr.documento.referencia}"
                                   data-codigo="${detalleTdr.documento.codigo}"
                                   data-tipo="${detalleTdr.documento.tipo.nombre}"
                                   target="_blank" class="btn btn-info ver-doc" >
                                    <i class="fa fa-search"></i> Ver
                                </a>
                                <a href="#" class="btn btn-info cambiar" iden="tdr">
                                    <i class="fa fa-refresh"></i> Cambiar
                                </a>
                                <util:displayEstadoDocumento documento="${detalleTdr.documento}"/>
                            </div>
                            <div id="div-file-tdr" style="display: none">
                                <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                            </div>
                        </g:if>
                        <g:else>
                            <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                        </g:else>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">
                        <label>
                            N. referencia
                        </label>
                    </div>
                    <div class="col-md-4">
                        <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detalleTdr?.documento?.referencia}">
                    </div>
                    <div class="col-md-1">
                        <label>
                            Emisión
                        </label>
                    </div>
                    <div class="col-md-3">
                        <elm:datepicker name="inicio" class="required form-control input-sm" value="${detalleTdr?.documento?.inicio}"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">
                        <label>
                            Observaciones
                        </label>
                    </div>
                    <div class="col-md-8">
                        <input type="text" name="descripcion" class="form-control input-sm required" required="" value="${detalleTdr?.documento?.descripcion}" maxlength="512">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-1">
                        <a href="#" class="btn btn-primary" id="guardar-tdr">
                            <i class="fa fa-save"></i>
                            Guardar
                        </a>
                    </div>
                </div>
            </g:form>
            <g:if test="${detalleTdr?.documento}">
                <util:displayChain detalle="${detalleObs}" paso="1" origen="registrarAuditoria" padre="${detalleTdr?.id}" controller="auditoriaAmbiental"></util:displayChain>


                <fieldset>
                    <legend>Oficio de aprobación</legend>
                    <g:form class="frm-subir-apb" controller="auditoriaAmbiental" action="upload" enctype="multipart/form-data" >
                        <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
                        <input type="hidden" name="proceso" value="${proceso?.id}" >
                        <input type="hidden" name="id" value="${detalleApb?.id}" >
                        <input type="hidden" name="tipo" value="apbTdr" >
                        <input type="hidden" name="paso" value="1" >
                        <input type="hidden" name="origen" value="registrarAuditoria" >
                        <div class="row" style="margin-top: 0px">
                            <div class="col-md-2">
                                <label>
                                    Oficio
                                </label>
                            </div>
                            <div class="col-md-4" style="">
                                <g:if test="${detalleApb?.documento}">
                                    <div id="botones-apb_${detalleApb?.id}">
                                        ${detalleApb.documento.codigo}
                                        <a href="#" data-file="${detalleApb.documento.path}"
                                           data-ref="${detalleApb.documento.referencia}"
                                           data-codigo="${detalleApb.documento.codigo}"
                                           data-tipo="${detalleApb.documento.tipo.nombre}"
                                           target="_blank" class="btn btn-info ver-doc" >
                                            <i class="fa fa-search"></i> Ver
                                        </a>
                                        <a href="#" class="btn btn-info cambiar" iden="apb_${detalleApb?.id}">
                                            <i class="fa fa-refresh"></i> Cambiar
                                        </a>
                                        <util:displayEstadoDocumento documento="${detalleApb.documento}"/>
                                    </div>
                                    <div id="div-file-apb_${detalleApb?.id}" style="display: none">
                                        <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                                    </div>
                                </g:if>
                                <g:else>
                                    <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                                </g:else>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-2">
                                <label>
                                    N. referencia
                                </label>
                            </div>
                            <div class="col-md-4">
                                <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detalleApb?.documento?.referencia}">
                            </div>
                            <div class="col-md-1">
                                <label>
                                    Emisión
                                </label>
                            </div>
                            <div class="col-md-3">
                                <elm:datepicker name="inicio" id="apb__${detalleApb?.id}" class="required form-control input-sm" value="${detalleApb?.documento?.inicio}"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-2">
                                <label>
                                    Observaciones
                                </label>
                            </div>
                            <div class="col-md-8">
                                <input type="text" name="descripcion" class="form-control input-sm required" required="" value="${detalleApb?.documento?.descripcion}" maxlength="512">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-1">
                                <a href="#" class="btn btn-primary" id="guardar-apb">
                                    <i class="fa fa-save"></i>
                                    Guardar
                                </a>
                            </div>
                        </div>
                    </g:form>
                </fieldset>
            </g:if>
        </div>
    </div>
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

    var validator = $(".frm-subir-tdr").validate({
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
    var validator = $(".frm-subir-obs").validate({
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
    var validator = $(".frm-subir-apb").validate({
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
    $(".ver-doc").click(function(){
        showPdf($(this))
        return false
    })
    $(".pdf-handler").click(function(){
        $(".pdf-viewer").hide("slide",{direction:'right'})
        $("#data").hide()
    })

    $("#guardar-tdr").click(function(){
        $(".frm-subir-tdr").submit()
        return false
    })
    $(".cambiar").click(function(){
        var id = $(this).attr("iden")
        $("#botones-"+id).hide()
        $("#div-file-"+id).show()
        return false
    })
    $(".guardar-obs").click(function(){
        $(this).parents("form").submit()
        return false
    })
    $("#guardar-apb").click(function(){
        $(this).parents("form").submit()
        return false
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