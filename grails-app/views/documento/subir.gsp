<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Registrar documentos</title>
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
    <elm:container tipo="vertical" titulo="Documento" style="border-color: #3A5DAA;border-right: 1px solid  #3A5DAA">
        <div style="width: 100%;padding: 5px;margin-top: 5px;padding-bottom: 10px">
            <div class="row">
                <div class="col-md-1">
                    <label>
                        Estación
                    </label>
                </div>
                <div class="col-md-3">
                    ${estacion.nombre}
                </div>
                <div class="col-md-2">
                    <label>
                        Fecha de registro
                    </label>
                </div>
                <div class="col-md-3">
                    ${new java.util.Date().format("dd-MM-yyyy")}
                </div>
            </div>
            <div class="row" style="">
                <div class="col-md-1">
                    <label>
                        PDF
                    </label>
                </div>
                <div class="col-md-7">
                    <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                </div>

            </div>
            <div class="row" style="">
                <div class="col-md-1">
                    <label>
                        Tipo
                    </label>
                </div>
                <div class="col-md-3">
                    <g:select name="tipo.id" from="${tipos}" optionValue="nombre" optionKey="id" id="tipo" class="form-control input-sm"></g:select>
                </div>
                <div class="col-md-2">
                    <label>
                        Número de referencia
                    </label>
                </div>
                <div class="col-md-2">
                    <input type="text" name="referencia" class="form-control input-sm required" maxlength="20">
                </div>
            </div>
            <div class="row" style="margin-top: 20px;">
                <div class="col-md-1">
                    <label>
                        Descripción
                    </label>
                </div>
                <div class="col-md-10">
                    <input type="text" name="descripcion" class="form-control input-sm required" required="" maxlength="512">
                </div>
            </div>

        </div>
    </elm:container>
    <elm:container tipo="vertical" titulo="Vigencia" style="border-color: #3A5DAA;border-right: 1px solid  #3A5DAA">
        <div style="width: 100%;padding: 5px;margin-top: 5px;padding-bottom: 10px;height: 100px">
            <div class="row"></div>
            <div class="row">
                <div class="col-md-1">
                    <label>
                        Inicio
                    </label>
                </div>
                <div class="col-md-3">
                    <elm:datepicker name="inicio" class="required form-control input-sm"/>
                </div>
                <div class="col-md-1">
                    <label>
                        Caduca
                    </label>
                </div>
                <div class="col-md-3">
                    <elm:datepicker name="fin" class=" form-control input-sm"/>
                </div>
            </div>
        </div>
    </elm:container>
    <elm:container tipo="vertical" titulo="Obs." style="border-color: #3A5DAA;border-right: 1px solid  #3A5DAA">
        <div style="width: 100%;margin-top: 5px;padding-bottom: 10px;">
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
    </elm:container>
    <div class="row">
        <a href="#" id="guardar" class="btn btn-primary">
            <i class="fa fa-save"></i> Guardar
        </a>
    </div>
</g:form>
<script type="text/javascript">
    var okContents = {
        'application/pdf' : 'pdf',
        'application/download' : 'pdf'
    };

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