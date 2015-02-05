<%@ page import="gaia.seguridad.Persona" %>

<g:if test="${!personaInstance}">
    <elm:notFound elem="Persona" genero="o"/>
</g:if>
<g:else>
    <div class="modal-contenido">

        <div class="row">
            <g:if test="${personaInstance?.departamento}">
                <div class="col-sm-2 show-label">
                    Departamento
                </div>

                <div class="col-sm-4">
                    ${personaInstance?.departamento?.encodeAsHTML()}
                </div>
            </g:if>

            <g:if test="${personaInstance?.login}">
                <div class="col-sm-2 show-label">
                    Login
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${personaInstance}" field="login"/>
                </div>
            </g:if>
        </div>

        <div class="row">
            <g:if test="${personaInstance?.cedula}">
                <div class="col-sm-2 show-label">
                    Cédula
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${personaInstance}" field="cedula"/>
                </div>
            </g:if>

            <div class="col-sm-2 show-label">
                Activo
            </div>

            <div class="col-sm-4">
                <g:formatBoolean boolean="${personaInstance.activo == 1}" true="Sí" false="No"/>
            </div>
        </div>

        <div class="row">
            <g:if test="${personaInstance?.nombre}">
                <div class="col-sm-2 show-label">
                    Nombre
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${personaInstance}" field="nombre"/>
                </div>
            </g:if>

            <g:if test="${personaInstance?.apellido}">
                <div class="col-sm-2 show-label">
                    Apellido
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${personaInstance}" field="apellido"/>
                </div>
            </g:if>
        </div>

        <div class="row">
            <g:if test="${personaInstance?.fechaNacimiento}">
                <div class="col-sm-2 show-label">
                    Fecha Nacimiento
                </div>

                <div class="col-sm-4">
                    <g:formatDate date="${personaInstance?.fechaNacimiento}" format="dd-MM-yyyy"/>
                </div>
            </g:if>

            <g:if test="${personaInstance?.sexo}">
                <div class="col-sm-2 show-label">
                    Sexo
                </div>

                <div class="col-sm-4">
                    <g:message code="persona.sexo.${personaInstance.sexo}"/>
                </div>
            </g:if>
        </div>

        <div class="row">
            <g:if test="${personaInstance?.mail}">
                <div class="col-sm-2 show-label">
                    E-mail
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${personaInstance}" field="mail"/>
                </div>
            </g:if>

            <g:if test="${personaInstance?.telefono}">
                <div class="col-sm-2 show-label">
                    Teléfono
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${personaInstance}" field="telefono"/>
                </div>
            </g:if>
        </div>

        <g:if test="${personaInstance?.direccion}">
            <div class="row">
                <div class="col-sm-2 show-label">
                    Dirección
                </div>

                <div class="col-sm-10">
                    <g:fieldValue bean="${personaInstance}" field="direccion"/>
                </div>
            </div>
        </g:if>

        <g:if test="${personaInstance?.observaciones}">
            <div class="row">
                <div class="col-sm-2 show-label">
                    Observaciones
                </div>

                <div class="col-sm-10">
                    <g:fieldValue bean="${personaInstance}" field="observaciones"/>
                </div>
            </div>
        </g:if>

        <g:if test="${perfiles.size() > 0}">
            <div class="row">
                <div class="col-sm-2 show-label">
                    Perfiles
                </div>

                <div class="col-sm-10">
                    ${perfiles.join(", ")}
                </div>
            </div>
        </g:if>

    </div>
</g:else>