
<%@ page import="gaia.seguridad.Sistema" %>

<g:if test="${!sistemaInstance}">
    <elm:notFound elem="Sistema" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${sistemaInstance?.nombre}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Nombre
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${sistemaInstance}" field="nombre"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${sistemaInstance?.descripcion}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${sistemaInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${sistemaInstance?.codigo}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Codigo
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${sistemaInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${sistemaInstance?.imagen}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Imagen
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${sistemaInstance}" field="imagen"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${sistemaInstance?.controlador}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Controlador
                </div>
                
                <div class="col-sm-4">
                    ${sistemaInstance?.controlador?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>