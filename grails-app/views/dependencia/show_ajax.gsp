
<%@ page import="gaia.documentos.Dependencia" %>

<g:if test="${!dependenciaInstance}">
    <elm:notFound elem="Dependencia" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${dependenciaInstance?.nombre}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Nombre
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${dependenciaInstance}" field="nombre"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${dependenciaInstance?.codigo}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Codigo
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${dependenciaInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>