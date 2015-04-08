<%@ page import="gaia.seguridad.Sistema" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!sistemaInstance}">
    <elm:notFound elem="Sistema" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmSistema" id="${sistemaInstance?.id}"
            role="form" controller="sistema" action="save_ajax" method="POST">

        
        <elm:fieldRapido claseLabel="col-sm-2" label="Nombre" claseField="col-sm-6">
            <g:textField name="nombre" maxlength="128" required="" class="form-control  required" value="${sistemaInstance?.nombre}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Descripcion" claseField="col-sm-6">
            <g:textArea name="descripcion" cols="40" rows="5" maxlength="511" required="" class="form-control  required" value="${sistemaInstance?.descripcion}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Codigo" claseField="col-sm-6">
            <g:textField name="codigo" maxlength="4" required="" class="form-control  required unique noEspacios" value="${sistemaInstance?.codigo}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Imagen" claseField="col-sm-6">
            <g:textField name="imagen" maxlength="30" class="form-control " value="${sistemaInstance?.imagen}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Controlador" claseField="col-sm-6">
            <g:select id="controlador" name="controlador.id" from="${gaia.seguridad.Controlador.list()}" optionKey="id" value="${sistemaInstance?.controlador?.id}" class="many-to-one form-control " noSelection="['null': '']"/>
        </elm:fieldRapido>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmSistema").validate({
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
                        url: "${createLink(controller:'sistema', action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${sistemaInstance?.id}"
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
                submitFormSistema();
                return false;
            }
            return true;
        });
    </script>

</g:else>