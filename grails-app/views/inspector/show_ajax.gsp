<%@ page import="gaia.documentos.Inspector" %>

<g:if test="${!inspectorInstance}">
    <elm:notFound elem="Inspector" genero="o"/>
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${inspectorInstance?.nombre}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Nombre
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${inspectorInstance}" field="nombre"/>
                </div>

            </div>
        </g:if>

        <g:if test="${inspectorInstance?.telefono}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Teléfono
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${inspectorInstance}" field="telefono"/>
                </div>

            </div>
        </g:if>

        <g:if test="${inspectorInstance?.mail}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Mail
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${inspectorInstance}" field="mail"/>
                </div>

            </div>
        </g:if>

    </div>
</g:else>