<%@ page import="gaia.documentos.Dependencia" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!dependenciaInstance}">
    <elm:notFound elem="Dependencia" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmDependencia" id="${dependenciaInstance?.id}"
            role="form" controller="dependencia" action="save_ajax" method="POST">

        
        <elm:fieldRapido claseLabel="col-sm-2" label="Nombre" claseField="col-sm-6">
            <g:textField name="nombre" maxlength="150" required="" class="form-control  required" value="${dependenciaInstance?.nombre}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Codigo" claseField="col-sm-6">
            <g:textField name="codigo" maxlength="5" required="" class="form-control  required unique noEspacios" value="${dependenciaInstance?.codigo}"/>
        </elm:fieldRapido>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmDependencia").validate({
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
            
            , rules          : {
                
                codigo: {
                    remote: {
                        url: "${createLink(controller:'dependencia', action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${dependenciaInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                codigo: {
                    remote: "Ya existe Codigo"
                }
                
            }
            
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormDependencia();
                return false;
            }
            return true;
        });
    </script>

</g:else>