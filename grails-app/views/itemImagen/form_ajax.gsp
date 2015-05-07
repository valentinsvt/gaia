<%@ page import="gaia.pintura.ItemImagen" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!itemImagenInstance}">
    <elm:notFound elem="ItemImagen" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmItemImagen" id="${itemImagenInstance?.id}"
            role="form" controller="itemImagen" action="save_ajax" method="POST">

        
        <elm:fieldRapido claseLabel="col-sm-2" label="Padre" claseField="col-sm-6">
            <g:select id="padre" name="padre.id" from="${gaia.pintura.ItemImagen.list()}" optionKey="id" value="${itemImagenInstance?.padre?.id}" class="many-to-one form-control " noSelection="['null': '']"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Descripcion" claseField="col-sm-6">
            <g:textField name="descripcion" required="" class="form-control  required" value="${itemImagenInstance?.descripcion}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Estado" claseField="col-sm-6">
            <g:textField name="estado" required="" class="form-control  required" value="${itemImagenInstance?.estado}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Tipo" claseField="col-sm-6">
            <g:textField name="tipo" required="" class="form-control  required" value="${itemImagenInstance?.tipo}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Tipo Item" claseField="col-sm-6">
            <g:textField name="tipoItem" required="" class="form-control  required" value="${itemImagenInstance?.tipoItem}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Unidad" claseField="col-sm-6">
            <g:textField name="unidad" required="" class="form-control  required" value="${itemImagenInstance?.unidad}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Valor" claseField="col-sm-2">
            <g:textField name="valor" value="${fieldValue(bean: itemImagenInstance, field: 'valor')}" class="number form-control   required" required=""/>
        </elm:fieldRapido>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmItemImagen").validate({
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
                submitFormItemImagen();
                return false;
            }
            return true;
        });
    </script>

</g:else>