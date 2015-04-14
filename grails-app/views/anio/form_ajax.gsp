<%@ page import="gaia.parametros.Anio" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!anioInstance}">
    <elm:notFound elem="Anio" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmAnio" id="${anioInstance?.id}"
            role="form" controller="anio" action="save_ajax" method="POST">

        
        <elm:fieldRapido claseLabel="col-sm-2" label="Anio" claseField="col-sm-6">
            <g:textField name="anio" required="" class="form-control  required" value="${anioInstance?.anio}"/>
        </elm:fieldRapido>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmAnio").validate({
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
                submitFormAnio();
                return false;
            }
            return true;
        });
    </script>

</g:else>