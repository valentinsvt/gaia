
<%@ page import="gaia.documentos.TipoDocumento" %>

<g:if test="${!tipoDocumentoInstance}">
    <elm:notFound elem="TipoDocumento" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${tipoDocumentoInstance?.nombre}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Nombre
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${tipoDocumentoInstance}" field="nombre"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${tipoDocumentoInstance?.tipo}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Tipo
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${tipoDocumentoInstance}" field="tipo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${tipoDocumentoInstance?.caduca}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Caduca
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${tipoDocumentoInstance}" field="caduca"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${tipoDocumentoInstance?.codigo}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Codigo
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${tipoDocumentoInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${tipoDocumentoInstance?.entidad}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Entidad
                </div>
                
                <div class="col-sm-4">
                    ${tipoDocumentoInstance?.entidad?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>