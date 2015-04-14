<%@ page import="gaia.parametros.ProgramacionDotacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!programacionDotacionInstance}">
    <elm:notFound elem="ProgramacionDotacion" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmProgramacionDotacion" id="${programacionDotacionInstance?.id}"
            role="form" controller="programacionDotacion" action="save_ajax" method="POST">

        

        
        <elm:fieldRapido claseLabel="col-sm-3" label="Año" claseField="col-sm-6">
            <g:select id="anio" name="anio.id" from="${gaia.parametros.Anio.list()}" optionKey="id" required="" value="${programacionDotacionInstance?.anio?.id}" class="many-to-one form-control "/>
        </elm:fieldRapido>
        <elm:fieldRapido claseLabel="col-sm-3" label="# Dotaciones" claseField="col-sm-2">
            <input type="number" name="numero" value="${programacionDotacionInstance.numero}" class="digits form-control  required" required="" max="2" min="1"/>
        </elm:fieldRapido>
        <elm:fieldRapido claseLabel="col-sm-3" label="Primera dotación" claseField="col-sm-4">
            <elm:datepicker name="fecha1"  class="datepicker form-control  required" value="${programacionDotacionInstance?.fecha1}" />
        </elm:fieldRapido>
        <elm:fieldRapido claseLabel="col-sm-3" label="Segunda dotacion" claseField="col-sm-4">
            <elm:datepicker name="fecha2"  class="datepicker form-control " value="${programacionDotacionInstance?.fecha2}" />
        </elm:fieldRapido>

        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmProgramacionDotacion").validate({
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
                submitFormProgramacionDotacion();
                return false;
            }
            return true;
        });
    </script>

</g:else>