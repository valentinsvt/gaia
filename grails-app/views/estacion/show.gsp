<%@ page import="gaia.estaciones.Estacion" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'estacion.label', default: 'Estacion')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body>
<a href="#show-estacion" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                               default="Skip to content&hellip;"/></a>

<div class="nav" role="navigation">
    <ul>
        <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
        <li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]"/></g:link></li>
        <li><g:link class="create" action="create"><g:message code="default.new.label"
                                                              args="[entityName]"/></g:link></li>
    </ul>
</div>

<div id="show-estacion" class="content scaffold-show" role="main">
    <h1><g:message code="default.show.label" args="[entityName]"/></h1>
    <g:if test="${flash.message}">
        <div class="message" role="status">${flash.message}</div>
    </g:if>
    <ol class="property-list estacion">

        <g:if test="${estacionInstance?.direccion}">
            <li class="fieldcontain">
                <span id="direccion-label" class="property-label"><g:message code="estacion.direccion.label"
                                                                             default="Direccion"/></span>

                <span class="property-value" aria-labelledby="direccion-label"><g:fieldValue bean="${estacionInstance}"
                                                                                             field="direccion"/></span>

            </li>
        </g:if>

        <g:if test="${estacionInstance?.mail}">
            <li class="fieldcontain">
                <span id="mail-label" class="property-label"><g:message code="estacion.mail.label"
                                                                        default="Mail"/></span>

                <span class="property-value" aria-labelledby="mail-label"><g:fieldValue bean="${estacionInstance}"
                                                                                        field="mail"/></span>

            </li>
        </g:if>

        <g:if test="${estacionInstance?.telefono}">
            <li class="fieldcontain">
                <span id="telefono-label" class="property-label"><g:message code="estacion.telefono.label"
                                                                            default="Telefono"/></span>

                <span class="property-value" aria-labelledby="telefono-label"><g:fieldValue bean="${estacionInstance}"
                                                                                            field="telefono"/></span>

            </li>
        </g:if>

        <g:if test="${estacionInstance?.propetario}">
            <li class="fieldcontain">
                <span id="propetario-label" class="property-label"><g:message code="estacion.propetario.label"
                                                                              default="Propetario"/></span>

                <span class="property-value" aria-labelledby="propetario-label"><g:fieldValue bean="${estacionInstance}"
                                                                                              field="propetario"/></span>

            </li>
        </g:if>

        <g:if test="${estacionInstance?.representante}">
            <li class="fieldcontain">
                <span id="representante-label" class="property-label"><g:message code="estacion.representante.label"
                                                                                 default="Representante"/></span>

                <span class="property-value" aria-labelledby="representante-label"><g:fieldValue
                        bean="${estacionInstance}" field="representante"/></span>

            </li>
        </g:if>

        <g:if test="${estacionInstance?.aplicacion}">
            <li class="fieldcontain">
                <span id="aplicacion-label" class="property-label"><g:message code="estacion.aplicacion.label"
                                                                              default="Aplicacion"/></span>

                <span class="property-value" aria-labelledby="aplicacion-label"><g:fieldValue bean="${estacionInstance}"
                                                                                              field="aplicacion"/></span>

            </li>
        </g:if>

        <g:if test="${estacionInstance?.codigo}">
            <li class="fieldcontain">
                <span id="codigo-label" class="property-label"><g:message code="estacion.codigo.label"
                                                                          default="Codigo"/></span>

                <span class="property-value" aria-labelledby="codigo-label"><g:fieldValue bean="${estacionInstance}"
                                                                                          field="codigo"/></span>

            </li>
        </g:if>

        <g:if test="${estacionInstance?.estado}">
            <li class="fieldcontain">
                <span id="estado-label" class="property-label"><g:message code="estacion.estado.label"
                                                                          default="Estado"/></span>

                <span class="property-value" aria-labelledby="estado-label"><g:fieldValue bean="${estacionInstance}"
                                                                                          field="estado"/></span>

            </li>
        </g:if>

        <g:if test="${estacionInstance?.nombre}">
            <li class="fieldcontain">
                <span id="nombre-label" class="property-label"><g:message code="estacion.nombre.label"
                                                                          default="Nombre"/></span>

                <span class="property-value" aria-labelledby="nombre-label"><g:fieldValue bean="${estacionInstance}"
                                                                                          field="nombre"/></span>

            </li>
        </g:if>

        <g:if test="${estacionInstance?.ruc}">
            <li class="fieldcontain">
                <span id="ruc-label" class="property-label"><g:message code="estacion.ruc.label" default="Ruc"/></span>

                <span class="property-value" aria-labelledby="ruc-label"><g:fieldValue bean="${estacionInstance}"
                                                                                       field="ruc"/></span>

            </li>
        </g:if>

    </ol>
    <g:form url="[resource: estacionInstance, action: 'delete']" method="DELETE">
        <fieldset class="buttons">
            <g:link class="edit" action="edit" resource="${estacionInstance}"><g:message
                    code="default.button.edit.label" default="Edit"/></g:link>
            <g:actionSubmit class="delete" action="delete"
                            value="${message(code: 'default.button.delete.label', default: 'Delete')}"
                            onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/>
        </fieldset>
    </g:form>
</div>
</body>
</html>
