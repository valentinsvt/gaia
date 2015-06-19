<%@ page contentType="text/html;charset=UTF-8" %>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta name="layout" content="main"/>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <title>Registrar documentos</title>
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

    </style>
</head>
<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0px;margin-left: -20px">
    <div class="btn-group">
        <a href="${g.createLink(controller: 'estacion',action: 'showEstacion',id: estacion.codigo)}" class="btn btn-default detalles">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
</div>

<g:form class="frm-subir" controller="documento" action="upload" enctype="multipart/form-data" >
    <input type="hidden" name="estacion_codigo" value="${estacion.codigo}">
    <input type="hidden" name="id" value="${doc?.id}">
    <div class="panel panel-info" style="margin-top: 20px">
        <div class="panel-heading">Nuevo documento para la estación: ${estacion.nombre}</div>
        <div class="panel-body" style="padding: 20px">
            <fieldset style="margin-top: 0px">
                <legend>Datos del documento</legend>
                <div class="row">
                    <div class="col-md-1">
                        <label>
                            Estación
                        </label>
                    </div>
                    <div class="col-md-2">
                        ${estacion.nombre}
                    </div>
                    <div class="col-md-1">
                        <label>
                            Documento padre
                        </label>
                    </div>
                    <div class="col-md-7">
                        <g:select name="padre.id" from="${gaia.documentos.Documento.findAllByEstacion(estacion)}"
                                  optionKey="id" noSelection="['':'Seleccione']" class="form-control input-sm"></g:select>
                    </div>
                </div>
                <div class="row" style="">
                    <div class="col-md-1">
                        <label>
                            Tipo
                        </label>
                    </div>
                    <div class="col-md-5">
                        <g:select name="tipo.id" from="${tipos}" optionValue="nombre" optionKey="id" id="tipo" class="form-control input-sm" value="${(doc)?doc?.tipo.id:tipo}"></g:select>
                    </div>
                    <div class="col-md-2">
                        <label>
                            Número de referencia
                        </label>
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${doc?.referencia}">
                    </div>
                </div>
                <div class="row" style="">
                    <div class="col-md-1">
                        <label>
                            PDF
                        </label>
                    </div>
                    <div class="col-md-5">
                        <input type="file" name="file" id="file" class="form-control ${doc?'':'required'}"  style="border-right: none" accept=".pdf">
                    </div>
                    <div class="col-md-2">
                        <label>
                            Consultor
                        </label>
                    </div>
                    <div class="col-md-3">
                        <g:select name="consultor.id" from="${gaia.documentos.ConsultorEstacion.findAllByEstacion(estacion)?.consultor}" optionKey="id" optionValue="nombre" class="form-control input-sm" noSelection="['':'Seleccione....']" value="${doc?.consultor?.id}"/>
                    </div>
                </div>
                <div class="row" style="margin-top: 20px;">
                    <div class="col-md-1">
                        <label>
                            Descripción
                        </label>
                    </div>
                    <div class="col-md-10">
                        <input type="text" name="descripcion" class="form-control input-sm required" required="" maxlength="512" value="${doc?.descripcion}">
                    </div>
                </div>
            </fieldset>

            <fieldset>
                <legend>Vigencia</legend>
                <div style="width: 100%;padding: 5px;margin-top: 5px;padding-bottom: 10px;height: 70px;background: white">

                    <div class="row">
                        <div class="col-md-1">
                            <label>
                                Emisión
                            </label>
                        </div>
                        <div class="col-md-3">
                            <elm:datepicker name="inicio" class="required form-control input-sm" value="${doc?.inicio?.format('dd-MM-yyyy')}"/>
                        </div>
                        <div class="col-md-1">
                            <label>
                                Caduca
                            </label>
                        </div>
                        <div class="col-md-3">
                            <elm:datepicker name="fin" class=" form-control input-sm" value="${doc?.fin?.format('dd-MM-yyyy')}"/>
                        </div>
                    </div>
                </div>
            </fieldset>
            <fieldset style="margin-top: 0px">
                <legend>Observaciones</legend>
                <div style="width: 100%;margin-top: 5px;padding-bottom: 10px;;background: white">
                    <div class="row">
                        <div class="col-md-1">
                            <label>
                                Observaciones
                            </label>
                        </div>
                        <div class="col-md-10">
                            <textarea name="observacines" class="form-control"></textarea>
                        </div>
                    </div>
                </div>
            </fieldset>
            <div class="row" style="margin-left: 10px">
                <a href="#" id="guardar" class="btn btn-primary">
                    <i class="fa fa-save"></i> Guardar
                </a>
            </div>
        </div>
    </div>
</g:form>
<script type="text/javascript">
    var okContents = {
        'application/pdf' : 'pdf',
        'application/download' : 'pdf'
    };
    var _validFileExtensions = [".pdf"];
    $("#file").change(function(){
        var sFileName = $(this).val();
        if (sFileName.length > 0) {
            var blnValid = false;
            for (var j = 0; j < _validFileExtensions.length; j++) {
                var sCurExtension = _validFileExtensions[j];
                if (sFileName.substr(sFileName.length - sCurExtension.length, sCurExtension.length).toLowerCase() == sCurExtension.toLowerCase()) {
                    blnValid = true;
                    break;
                }
            }

            if (!blnValid) {
                bootbox.alert({
                    message:"El archivo "+sFileName+" es invalido, los tipos de archivos permitidos son: "+ _validFileExtensions.join(", "),
                    title:"Error",
                    class:"modal-error"

                })
                $("#file").replaceWith( $("#file").val('').clone(true));
                return false;

            }
        }
    })
    var caducan = ${caducan}

            $(function () {


                var validator = $(".frm-subir").validate({
                    errorClass: "help-block",
                    ignore:[],
                    errorPlacement: function (error, element) {
                        if (element.parent().hasClass("input-group")) {
                            error.insertAfter(element.parent());
                        } else {
                            error.insertAfter(element);
                        }
                        element.parents(".grupo").addClass('has-error');
                    },
                    success: function (label) {
                        label.parents(".grupo").removeClass('has-error');
                        label.remove();
                    }

                });

                $("#guardar").click(function(){

                    if($.inArray($("#tipo").val(), caducan)>-1){
                        if($("#fin_input").val()!=""){
                            $(".frm-subir").submit()
                        }else{
                            bootbox.alert({
                                        message : "Para el tipo de documento seleccionado es necesario ingresar una fecha de caducidad del documento",
                                        title   : "Error",
                                        class   : "modal-error"
                                    }
                            );
                        }
                    }else{
                        $("#fin_input").val("")
                        $("#fin_day").val("")
                        $("#fin_month").val("")
                        $("#fin_year").val("")
                        $("#fin").val("")
                        $(".frm-subir").submit()
                    }

                })

            });
</script>
</body>
</html>