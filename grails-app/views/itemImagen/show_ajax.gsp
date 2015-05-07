
<%@ page import="gaia.pintura.ItemImagen" %>

<g:if test="${!itemImagenInstance}">
    <elm:notFound elem="ItemImagen" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${itemImagenInstance?.padre}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Padre
                </div>
                
                <div class="col-sm-4">
                    ${itemImagenInstance?.padre?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${itemImagenInstance?.descripcion}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${itemImagenInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${itemImagenInstance?.estado}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Estado
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${itemImagenInstance}" field="estado"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${itemImagenInstance?.tipo}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Tipo
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${itemImagenInstance}" field="tipo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${itemImagenInstance?.tipoItem}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Tipo Item
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${itemImagenInstance}" field="tipoItem"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${itemImagenInstance?.unidad}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Unidad
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${itemImagenInstance}" field="unidad"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${itemImagenInstance?.valor}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Valor
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${itemImagenInstance}" field="valor"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>