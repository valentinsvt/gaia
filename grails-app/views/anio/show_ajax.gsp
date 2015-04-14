
<%@ page import="gaia.parametros.Anio" %>

<g:if test="${!anioInstance}">
    <elm:notFound elem="Anio" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${anioInstance?.anio}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Anio
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${anioInstance}" field="anio"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>