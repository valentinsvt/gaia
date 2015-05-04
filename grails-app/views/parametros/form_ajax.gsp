<%@ page import="gaia.parametros.Parametros" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!parametrosInstance}">
    <elm:notFound elem="Parametros" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmParametros" id="${parametrosInstance?.id}"
            role="form" controller="administracion" action="save_ajax" method="POST">

        
        <elm:fieldRapido claseLabel="col-sm-2" label="Dias Alerta Contratos" claseField="col-sm-2">
            <g:textField name="diasAlertaContratos" value="${parametrosInstance.diasAlertaContratos}" class="digits form-control  required" required=""/>
        </elm:fieldRapido>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmParametros").validate({
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
                submitFormParametros();
                return false;
            }
            return true;
        });
    </script>

</g:else>