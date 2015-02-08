<%@ page import="gaia.estaciones.Estacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!estacionInstance}">
    <elm:notFound elem="Estacion" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmEstacion" id="${estacionInstance?.id}"
                role="form" controller="estacion" action="save_ajax" method="POST">

            <elm:fieldRapido claseLabel="col-sm-2" label="Direccion" claseField="col-sm-7">
                <g:textField name="direccion" class="form-control " value="${estacionInstance?.direccion}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Mail" claseField="col-sm-7">
                <div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field
                        type="email" name="mail" class="form-control  unique noEspacios"
                        value="${estacionInstance?.mail}"/></div>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Telefono" claseField="col-sm-7">
                <g:textField name="telefono" class="form-control " value="${estacionInstance?.telefono}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Propetario" claseField="col-sm-7">
                <g:textField name="propetario" class="form-control " value="${estacionInstance?.propetario}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Representante" claseField="col-sm-7">
                <g:textField name="representante" class="form-control " value="${estacionInstance?.representante}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Aplicacion" claseField="col-sm-3">
                <g:textField name="aplicacion" value="${estacionInstance.aplicacion}"
                             class="digits form-control  required" required=""/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Codigo" claseField="col-sm-7">
                <g:textField name="codigo" required="" class="form-control  required unique noEspacios"
                             value="${estacionInstance?.codigo}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Estado" claseField="col-sm-7">
                <g:textField name="estado" required="" class="form-control  required"
                             value="${estacionInstance?.estado}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Nombre" claseField="col-sm-7">
                <g:textField name="nombre" required="" class="form-control  required"
                             value="${estacionInstance?.nombre}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Ruc" claseField="col-sm-7">
                <g:textField name="ruc" required="" class="form-control  required" value="${estacionInstance?.ruc}"/>
            </elm:fieldRapido>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmEstacion").validate({
            errorClass: "help-block",
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

            , rules: {

                mail: {
                    remote: {
                        url: "${createLink(controller:'estacion', action: 'validar_unique_mail_ajax')}",
                        type: "post",
                        data: {
                            id: "${estacionInstance?.id}"
                        }
                    }
                },

                codigo: {
                    remote: {
                        url: "${createLink(controller:'estacion', action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${estacionInstance?.id}"
                        }
                    }
                }

            },
            messages: {

                mail: {
                    remote: "Ya existe Mail"
                },

                codigo: {
                    remote: "Ya existe Codigo"
                }

            }

        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormEstacion();
                return false;
            }
            return true;
        });
    </script>

</g:else>