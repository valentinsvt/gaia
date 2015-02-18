
<%@ page import="gaia.documentos.Entidad" %>

<g:if test="${!entidadInstance}">
    <elm:notFound elem="Entidad" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${entidadInstance?.nombre}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Nombre
                </div>
                
                <div class="col-sm-6">
                    <g:fieldValue bean="${entidadInstance}" field="nombre"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${entidadInstance?.codigo}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Código
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${entidadInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>