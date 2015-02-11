<%@ page import="gaia.documentos.TipoDocumento" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoDocumentoInstance}">
    <elm:notFound elem="TipoDocumento" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmTipoDocumento" id="${tipoDocumentoInstance?.id}"
            role="form" controller="tipoDocumento" action="save_ajax" method="POST">

        
        <elm:fieldRapido claseLabel="col-sm-2" label="Nombre" claseField="col-sm-6">
            <g:textField name="nombre" maxlength="150" required="" class="form-control  required" value="${tipoDocumentoInstance?.nombre}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Tipo" claseField="col-sm-6">
            <g:select name="tipo" from="${tipoDocumentoInstance.constraints.tipo.inList}" required="" class="form-control  required" value="${tipoDocumentoInstance?.tipo}" valueMessagePrefix="tipoDocumento.tipo"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Caduca" claseField="col-sm-6">
            <g:select name="caduca" from="${tipoDocumentoInstance.constraints.caduca.inList}" required="" class="form-control  required" value="${tipoDocumentoInstance?.caduca}" valueMessagePrefix="tipoDocumento.caduca"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Codigo" claseField="col-sm-6">
            <g:textField name="codigo" maxlength="5" required="" class="form-control  required unique noEspacios" value="${tipoDocumentoInstance?.codigo}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Entidad" claseField="col-sm-6">
            <g:select id="entidad" name="entidad.id" from="${gaia.documentos.Entidad.list()}" optionKey="id" value="${tipoDocumentoInstance?.entidad?.id}" class="many-to-one form-control " noSelection="['null': '']"/>
        </elm:fieldRapido>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmTipoDocumento").validate({
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
                        url: "${createLink(controller:'tipoDocumento', action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${tipoDocumentoInstance?.id}"
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
                submitFormTipoDocumento();
                return false;
            }
            return true;
        });
    </script>

</g:else>