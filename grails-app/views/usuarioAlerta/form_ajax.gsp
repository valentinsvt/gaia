<%@ page import="gaia.alertas.UsuarioAlerta" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!usuarioAlertaInstance}">
    <elm:notFound elem="UsuarioAlerta" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmUsuarioAlerta" id="${usuarioAlertaInstance?.id}"
            role="form" controller="usuarioAlerta" action="save_ajax" method="POST">

        
        <elm:fieldRapido claseLabel="col-sm-2" label="Estado" claseField="col-sm-6">
            <g:textField name="estado" maxlength="1" required="" class="form-control  required" value="${usuarioAlertaInstance?.estado}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Persona" claseField="col-sm-6">
            <g:select id="persona" name="persona.id" from="${gaia.seguridad.Persona.list()}" optionKey="login" required="" value="${usuarioAlertaInstance?.persona?.id}" class="many-to-one form-control "/>
        </elm:fieldRapido>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmUsuarioAlerta").validate({
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
                submitFormUsuarioAlerta();
                return false;
            }
            return true;
        });
    </script>

</g:else>