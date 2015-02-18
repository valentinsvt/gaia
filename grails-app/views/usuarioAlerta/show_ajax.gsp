
<%@ page import="gaia.alertas.UsuarioAlerta" %>

<g:if test="${!usuarioAlertaInstance}">
    <elm:notFound elem="UsuarioAlerta" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${usuarioAlertaInstance?.estado}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Estado
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${usuarioAlertaInstance}" field="estado"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${usuarioAlertaInstance?.persona}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Persona
                </div>
                
                <div class="col-sm-4">
                    ${usuarioAlertaInstance?.persona?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>