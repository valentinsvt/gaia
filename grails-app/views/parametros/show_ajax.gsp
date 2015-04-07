
<%@ page import="gaia.parametros.Parametros" %>

<g:if test="${!parametrosInstance}">
    <elm:notFound elem="Parametros" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${parametrosInstance?.diasAlertaContratos}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Dias Alerta Contratos
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${parametrosInstance}" field="diasAlertaContratos"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>