<%@ page import="gaia.seguridad.Perfil; gaia.parametros.Departamento; gaia.seguridad.Persona" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<style type="text/css">
.scroll {
    height        : 100px;
    overflow-y    : auto;
    overflow-x    : hidden;
    border-bottom : solid 1px #ddd;
    border-left   : solid 1px #ddd;
    border-right  : solid 1px #ddd;
}

.noMargin {
    margin-top : 0;
    padding    : 3px;
}
</style>

<g:if test="${!personaInstance}">
    <elm:notFound elem="Persona" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmPersona" id="${personaInstance?.id}"
                role="form" action="save_ajax" method="POST">

            <elm:fieldRapidoDoble claseLabel1="col-sm-4" label1="Departamento" claseField1="col-sm-8"
                                  claseLabel2="col-sm-4" label2="Usuario" claseField2="col-sm-8">
                <g:select id="departamento" name="departamento.id" from="${Departamento.list()}" optionKey="id" value="${personaInstance?.departamento?.id}" class="many-to-one form-control " noSelection="['null': '']"/>
                <hr/>
                <g:textField name="login" maxlength="15" class="form-control required unique noEspacios" value="${personaInstance?.login}"/>
            </elm:fieldRapidoDoble>

            <elm:fieldRapidoDoble claseLabel1="col-sm-4" label1="Cédula" claseField1="col-sm-8"
                                  claseLabel2="col-sm-4" label2="Activo" claseField2="col-sm-8">
                <g:textField name="cedula" maxlength="10" required="" class="form-control  required" value="${personaInstance?.cedula}"/>
                <hr/>
                <g:select name="activo" from="[1: 'Sí', 0: 'No']" optionKey="key" optionValue="value" value="${personaInstance?.activo}"
                          class="form-control "/>
            </elm:fieldRapidoDoble>

            <elm:fieldRapidoDoble claseLabel1="col-sm-4" label1="Nombre" claseField1="col-sm-8"
                                  claseLabel2="col-sm-4" label2="Apellido" claseField2="col-sm-8">
                <g:textField name="nombre" maxlength="40" required="" class="form-control  required" value="${personaInstance?.nombre}"/>
                <hr/>
                <g:textField name="apellido" maxlength="40" required="" class="form-control  required" value="${personaInstance?.apellido}"/>
            </elm:fieldRapidoDoble>

            <elm:fieldRapidoDoble claseLabel1="col-sm-4" label1="Fecha Nacimiento" claseField1="col-sm-8"
                                  claseLabel2="col-sm-4" label2="Sexo" claseField2="col-sm-8">
                <elm:datepicker name="fechaNacimiento" class="datepicker form-control " value="${personaInstance?.fechaNacimiento}"/>
                <hr/>
                <g:select name="sexo" from="${personaInstance.constraints.sexo.inList}" required="" class="form-control  required" value="${personaInstance?.sexo}" valueMessagePrefix="persona.sexo"/>
            </elm:fieldRapidoDoble>

            <elm:fieldRapidoDoble claseLabel1="col-sm-4" label1="E-mail" claseField1="col-sm-8"
                                  claseLabel2="col-sm-4" label2="Teléfono" claseField2="col-sm-8">
                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="fa fa-envelope"></i>
                    </span>
                    <g:field type="email" name="mail" maxlength="40" class="form-control  unique noEspacios" value="${personaInstance?.mail}"/>
                </div>
                <hr/>

                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="fa fa-phone"></i>
                    </span>
                    <g:textField name="telefono" maxlength="10" class="form-control " value="${personaInstance?.telefono}"/>
                </div>
            </elm:fieldRapidoDoble>

            <elm:fieldRapido claseLabel="col-sm-2" label="Dirección" claseField="col-sm-10">
                <g:textField name="direccion" maxlength="127" class="form-control " value="${personaInstance?.direccion}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Observaciones" claseField="col-sm-10">
                <g:textField name="observaciones" maxlength="127" class="form-control " value="${personaInstance?.observaciones}"/>
            </elm:fieldRapido>

            <elm:fieldRapido claseLabel="col-sm-2" label="Perfiles" claseField="col-sm-10">
                <div class="row noMargin bg-success">
                    <div class="col-sm-5">
                        <g:select name="perfil" from="${Perfil.list([sort: 'nombre'])}" class="form-control input-sm"
                                  optionKey="id" optionValue="nombre"/>
                    </div>

                    <div class="col-sm-2">
                        <a href="#" class="btn btn-success btn-sm" id="btn-addPerfil" title="Agregar perfil">
                            <i class="fa fa-plus"></i>
                        </a>
                    </div>
                </div>

                <div class="row noMargin scroll">
                    <div class="col-md-6">
                        <table id="tblPerfiles" class="table table-hover table-bordered table-condensed">
                            <g:each in="${perfiles.perfil}" var="perfil">
                                <tr class="perfiles" data-id="${perfil.id}">
                                    <td>
                                        ${perfil.nombre}
                                    </td>
                                    <td width="35">
                                        <a href="#" class="btn btn-danger btn-xs btn-deletePerfil">
                                            <i class="fa fa-trash-o"></i>
                                        </a>
                                    </td>
                                </tr>
                            </g:each>
                        </table>
                    </div>
                </div>
            </elm:fieldRapido>

        </g:form>
    </div>

    <script type="text/javascript">

        $("#btn-addPerfil").click(function () {
            var $perfil = $("#perfil");
            var idPerfilAdd = $perfil.val();
            $(".perfiles").each(function () {
                if ($(this).data("id") == idPerfilAdd) {
                    $(this).remove();
                }
            });
            var $tabla = $("#tblPerfiles");

            var $tr = $("<tr>");
            $tr.addClass("perfiles");
            $tr.data("id", idPerfilAdd);
            var $tdNombre = $("<td>");
            $tdNombre.text($perfil.find("option:selected").text());
            var $tdBtn = $("<td>");
            $tdBtn.attr("width", "35");
            var $btnDelete = $("<a>");
            $btnDelete.addClass("btn btn-danger btn-xs");
            $btnDelete.html("<i class='fa fa-trash-o'></i> ");
            $tdBtn.append($btnDelete);

            $btnDelete.click(function () {
                $tr.remove();
                return false;
            });

            $tr.append($tdNombre).append($tdBtn);

            $tabla.prepend($tr);
            $tr.effect("highlight");

            return false;
        });
        $(".btn-deletePerfil").click(function () {
            $(this).parents("tr").remove();
            return false;
        });

        var validator = $("#frmPersona").validate({
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
            , rules        : {
                mail  : {
                    remote : {
                        url  : "${createLink(controller:'persona', action: 'validar_unique_mail_ajax')}",
                        type : "post",
                        data : {
                            id : "${personaInstance?.id}"
                        }
                    }
                },
                login : {
                    remote : {
                        url  : "${createLink(controller:'persona', action: 'validar_unique_login_ajax')}",
                        type : "post",
                        data : {
                            id : "${personaInstance?.id}"
                        }
                    }
                }
            },
            messages       : {
                mail  : {
                    remote : "Ya existe Mail"
                },
                login : {
                    remote : "Ya existe Login"
                }
            }
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormPersona();
                return false;
            }
            return true;
        });
    </script>

</g:else>