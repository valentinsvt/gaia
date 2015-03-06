<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!moduloInstance}">
    <elm:notFound elem="Modulo" genero="o"/>
</g:if>
<g:else>

    <style type="text/css">
    #divIcono {
        cursor : pointer;
    }
    </style>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmModulo" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${moduloInstance?.id}"/>


            <div class="form-group keeptogether ${hasErrors(bean: moduloInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripción
                    </label>

                    <div class="col-md-6">
                        <g:textField name="descripcion" required="" class="form-control input-sm required" value="${moduloInstance?.descripcion}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: moduloInstance, field: 'nombre', 'error')} required">
                <span class="grupo">
                    <label for="nombre" class="col-md-2 control-label">
                        Nombre
                    </label>

                    <div class="col-md-6">
                        <g:textField name="nombre" required="" class="form-control input-sm required" value="${moduloInstance?.nombre}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: moduloInstance, field: 'orden', 'error')} required">
                <span class="grupo">
                    <label for="orden" class="col-md-2 control-label">
                        Orden
                    </label>

                    <div class="col-md-2">
                        <g:field name="orden" type="number" value="${moduloInstance.orden}" class="digits form-control input-sm required" required=""/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether required">
                <span class="grupo">
                    <label class="col-md-2 control-label">
                        Icono
                        <g:hiddenField name="icono" value="${moduloInstance.icono}"/>
                    </label>

                    <div class="col-md-2" id="divIcono">
                        <p class="form-control-static">
                            <g:if test="${!moduloInstance.icono}">
                                Seleccionar
                            </g:if>
                            <g:else>
                                <i class="${moduloInstance.icono}"></i>
                            </g:else>
                        </p>
                    </div>
                </span>
            </div>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmModulo").validate({
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
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitForm();
                return false;
            }
            return true;
        });
        $("#divIcono").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'icono', action:'dlgIconos_ajax')}",
                data    : {
                    selected : "${moduloInstance.icono}"
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgIconos",
                        title   : "Cambiar ícono de ${moduloInstance.nombre}",
                        message : msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            guardar  : {
                                id        : "btnSave",
                                label     : "<i class='fa fa-check'></i> Aceptar",
                                className : "btn-success",
                                callback  : function () {
                                    var icono = $(".ic.selected").data("str");
                                    $("#divIcono").html("<p class='form-control-static'><i class='" + icono + "'></i></p>");
                                    $("#icono").val(icono);
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                    setTimeout(function () {
                        b.find(".form-control").first().focus()
                    }, 500);
                } //success
            }); //ajax
        });
    </script>

</g:else>