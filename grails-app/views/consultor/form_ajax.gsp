<%@ page import="gaia.documentos.Consultor" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!consultorInstance}">
    <elm:notFound elem="Consultor" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmConsultor" id="${consultorInstance?.id}"
            role="form" controller="consultor" action="save_ajax" method="POST">

        
        <elm:fieldRapido claseLabel="col-sm-2" label="Nombre" claseField="col-sm-6">
            <g:textField name="nombre" maxlength="150" required="" class="form-control  required" value="${consultorInstance?.nombre}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Ruc" claseField="col-sm-6">
            <g:textField name="ruc" maxlength="20" required="" class="form-control  required" value="${consultorInstance?.ruc}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Telefono" claseField="col-sm-6">
            <g:textField name="telefono" maxlength="15" required="" class="form-control  required" value="${consultorInstance?.telefono}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Direccion" claseField="col-sm-6">
            <g:textField name="direccion" maxlength="150" class="form-control " value="${consultorInstance?.direccion}"/>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Mail" claseField="col-sm-6">
            <div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field type="email" name="mail" maxlength="150" required="" class="form-control  required unique noEspacios" value="${consultorInstance?.mail}"/></div>
        </elm:fieldRapido>
        
        <elm:fieldRapido claseLabel="col-sm-2" label="Calificación Arch" claseField="col-sm-6">
            <g:textField name="calificacionArch" maxlength="50" class="form-control " value="${consultorInstance?.calificacionArch}"/>
        </elm:fieldRapido>

        <elm:fieldRapido claseLabel="col-sm-2" label="Observaciones" claseField="col-sm-12">
            <textarea name="observaciones" class="form-control " style="height: 160px">${consultorInstance?.observaciones}</textarea>
        </elm:fieldRapido>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmConsultor").validate({
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
                
                mail: {
                    remote: {
                        url: "${createLink(controller:'consultor', action: 'validar_unique_mail_ajax')}",
                        type: "post",
                        data: {
                            id: "${consultorInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                mail: {
                    remote: "Ya existe Mail"
                }
                
            }
            
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormConsultor();
                return false;
            }
            return true;
        });
    </script>

</g:else>