<%@ page import="gaia.documentos.Inspector" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!inspectorInstance}">
    <elm:notFound elem="Inspector" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmInspector" id="${inspectorInstance?.id}"
                role="form" controller="inspector" action="save_ajax" method="POST">

            <elm:fieldRapido claseLabel="col-sm-2" label="Nombre" claseField="col-sm-6">
                <g:textField name="nombre" maxlength="150" required="" class="form-control  required" value="${inspectorInstance?.nombre}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Telefono" claseField="col-sm-6">
                <g:textField name="telefono" maxlength="15" required="" class="form-control  required" value="${inspectorInstance?.telefono}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Mail" claseField="col-sm-6">
                <div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i>
                </span><g:field type="email" name="mail" maxlength="150" required="" class="form-control  required unique noEspacios" value="${inspectorInstance?.mail}"/>
                </div>
            </elm:fieldRapido>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmInspector").validate({
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
            }, rules       : {

                mail : {
                    remote : {
                        url  : "${createLink(controller:'inspector', action: 'validar_unique_mail_ajax')}",
                        type : "post",
                        data : {
                            id : "${inspectorInstance?.id}"
                        }
                    }
                }

            },
            messages       : {

                mail : {
                    remote : "Ya existe Mail"
                }

            }

        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormInspector();
                return false;
            }
            return true;
        });
    </script>

</g:else>