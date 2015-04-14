
<%@ page import="gaia.parametros.ProgramacionDotacion" %>

<g:if test="${!programacionDotacionInstance}">
    <elm:notFound elem="ProgramacionDotacion" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${programacionDotacionInstance?.fecha2}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Fecha2
                </div>
                
                <div class="col-sm-4">
                    <g:formatDate date="${programacionDotacionInstance?.fecha2}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${programacionDotacionInstance?.anio}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Anio
                </div>
                
                <div class="col-sm-4">
                    ${programacionDotacionInstance?.anio?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${programacionDotacionInstance?.fecha1}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Fecha1
                </div>
                
                <div class="col-sm-4">
                    <g:formatDate date="${programacionDotacionInstance?.fecha1}" format="dd-MM-yyyy" />
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${programacionDotacionInstance?.numero}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Numero
                </div>
                
                <div class="col-sm-4">
                    <g:fieldValue bean="${programacionDotacionInstance}" field="numero"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>