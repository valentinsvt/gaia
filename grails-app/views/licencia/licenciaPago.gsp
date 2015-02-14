<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <title>
        Registrar licencia ambiental
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
    .pdf-viewer{
        height: 535px;
        width: 50%;
        background-color: #006699;
        position: fixed;
        top: 75px;
        right: 0px;
        z-index: 500;
        padding: 0px;
        border-left: 2px solid #006699;
        border-bottom: 2px solid #006699;
        display: none;

    }
    .pdf-content{
        width: 100%;
        height: 100%;
        margin: 0px;
        position: relative;
    }
    .pdf-container{
        width: 100%;
        height: 95%;
        margin: 0px;
        position: absolute;
        top: 5%;
        left: 0px;
        z-index: 502;
    }
    .pdf-handler{
        position: absolute;
        top: 49%;
        left: 0px;
        padding: 5px;
        height: 40px;
        line-height: 30px;
        background-color: #006699;
        color: #eee;
        cursor: pointer;
        z-index: 510;
    }
    .pdf-header{
        position: absolute;
        top: 5px;
        left: 5px;
        width: 100%;
        background:transparent;
        height: 5%;
        line-height: 20px;
        padding-left: 10px;
        color: white;
        font-weight: bold;
        display: none;
    }
    .data{
        font-weight: normal;
        margin-right: 10px;
    }
    #msgNoPDF{
        margin: 10px;
        height: 40px;
        color: #eee;
        font-weight: bold;
        width: 100%;
        position: absolute;
        top: 60px;
        left: 10px;
        z-index: 501;
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
<elm:container tipo="horizontal" titulo="Estación: ${estacion.nombre}" >
    <div class="panel panel-info" style="margin-top: 20px">
        <div class="panel-heading">Licencia ambiental</div>
        <div class="panel-body" style="padding:0px">
            <div class="header-flow">
                <g:link action="registrarLicencia" id="${estacion.codigo}" style="text-decoration: none">
                    <div class="header-flow-item before">
                        <span class="badge before">1</span> Certificado de intersección
                        <span class="arrow"></span>
                    </div>
                </g:link>
                <g:link action="licenciaTdr" id="${proceso.id}" style="text-decoration: none">
                    <div class="header-flow-item before">
                        <span class="badge before">2</span>
                        Terminos de referencia
                        <span class="arrow"></span>
                    </div>
                </g:link>
                <g:link action="licenciaEia" id="${proceso.id}" style="text-decoration: none">
                    <div class="header-flow-item before">
                        <span class="badge before">2</span>
                        Estudio de impacto ambiental
                        <span class="arrow"></span>
                    </div>
                </g:link>
                <div class="header-flow-item active">
                    <span class="badge active">4</span>
                    Pago y licencia
                    <span class="arrow"></span>
                </div>
            </div>
            <div class="flow-body">
                <g:form class="frm-subir-eia" controller="licencia" action="upload" enctype="multipart/form-data" >
                    <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
                    <input type="hidden" name="proceso" value="${proceso?.id}" >
                    <input type="hidden" name="id" value="${detallePago?.id}" >
                    <input type="hidden" name="tipo" value="pago" >
                    <input type="hidden" name="paso" value="4" >
                    <input type="hidden" name="origen" value="licenciaPago" >
                    <input type="hidden" name="descripcion"  value="Pago de licencia ambiental" maxlength="512">
                    <div class="row">
                        <div class="col-md-2">
                            <label>
                                Pago
                            </label>
                        </div>
                        <div class="col-md-4">
                            <g:if test="${detallePago?.documento}">
                                <div id="botones-tdr">
                                    ${detallePago.documento.codigo}
                                    <a href="#" data-file="${detallePago.documento.path}"
                                       data-ref="${detallePago.documento.referencia}"
                                       data-codigo="${detallePago.documento.codigo}"
                                       data-tipo="${detallePago.documento.tipo.nombre}"
                                       target="_blank" class="btn btn-info ver-doc" >
                                        <i class="fa fa-search"></i> Ver
                                    </a>
                                    <a href="#" class="btn btn-info cambiar" iden="tdr">
                                        <i class="fa fa-refresh"></i> Cambiar
                                    </a>
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
                            <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detallePago?.documento?.referencia}">
                        </div>
                        <div class="col-md-1">
                            <label>
                                Emisión
                            </label>
                        </div>
                        <div class="col-md-3">
                            <elm:datepicker name="inicio" class="required form-control input-sm" value="${detallePago?.documento?.inicio}"/>
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

                <fieldset>
                    <legend>Licencia ambiental</legend>
                    <g:form class="frm-subir-apb" controller="licencia" action="uploadLicencia" enctype="multipart/form-data" >
                        <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
                        <input type="hidden" name="proceso" value="${proceso?.id}" >
                        <input type="hidden" name="id" value="${detalleLicencia?.id}" >
                        <input type="hidden" name="paso" value="4" >
                        <input type="hidden" name="origen" value="licenciaPago" >
                        <div class="row" style="margin-top: 0px">
                            <div class="col-md-2">
                                <label>
                                    Licencia ambiental
                                </label>
                            </div>
                            <div class="col-md-4">
                                <g:if test="${detalleLicencia?.documento}">
                                    <div id="botones-obs_${detalleLicencia?.id}">
                                        ${detalleLicencia.documento.codigo}
                                        <a href="#" data-file="${detalleLicencia.documento.path}"
                                           data-ref="${detalleLicencia.documento.referencia}"
                                           data-codigo="${detalleLicencia.documento.codigo}"
                                           data-tipo="${detalleLicencia.documento.tipo.nombre}"
                                           target="_blank" class="btn btn-info ver-doc" >
                                            <i class="fa fa-search"></i> Ver
                                        </a>
                                        <a href="#" class="btn btn-info cambiar" iden="">
                                            <i class="fa fa-refresh"></i> Cambiar
                                        </a>
                                    </div>
                                    <div id="div-file-obs_${detalleLicencia?.id}" style="display: none">
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
                                <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detalleLicencia?.documento?.referencia}">
                            </div>
                            <div class="col-md-1">
                                <label>
                                    Emisión
                                </label>
                            </div>
                            <div class="col-md-3">
                                <elm:datepicker name="inicio" id="obs__${detalleLicencia?.id}" class="required form-control input-sm" value="${detalleLicencia?.documento?.inicio}"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-2">
                                <label>
                                    Observaciones
                                </label>
                            </div>
                            <div class="col-md-8">
                                <input type="text" name="descripcion" class="form-control input-sm required" required="" value="${detalleLicencia?.documento?.descripcion}" maxlength="512">
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

            </div>
        </div>
    </div>
</elm:container>
<script type="text/javascript">

    function showPdf(div){
        $("#msgNoPDF").show();

        var pathFile = div.data("file")
        $("#referencia-pdf").html(div.data("ref"))
        $("#codigo").html(div.data("codigo"))
        $("#tipo").html(div.data("tipo"))
        var path = "${resource()}/" + pathFile;
        var myPDF = new PDFObject({
            url           : path,
            pdfOpenParams : {
                zoom : 10
//                            navpanes  : 0,
//                            statusbar : 1,
//                            view      : "FitBH",
//                            pagemode  : "thumbs"
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
        $(".frm-subir-eia").submit()
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
</script>
</body>
</html>