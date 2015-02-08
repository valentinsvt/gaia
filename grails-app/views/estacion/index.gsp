<%@ page import="gaia.estaciones.Estacion" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'estacion.label', default: 'Estacion')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<a href="#list-estacion" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                               default="Skip to content&hellip;"/></a>

<div class="nav" role="navigation">
    <ul>
        <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
        <li><g:link class="create" action="create"><g:message code="default.new.label"
                                                              args="[entityName]"/></g:link></li>
    </ul>
</div>

<div id="list-estacion" class="content scaffold-list" role="main">
    <h1><g:message code="default.list.label" args="[entityName]"/></h1>
    <g:if test="${flash.message}">
        <div class="message" role="status">${flash.message}</div>
    </g:if>
    <table>
        <thead>
        <tr>

            <g:sortableColumn property="direccion"
                              title="${message(code: 'estacion.direccion.label', default: 'Direccion')}"/>

            <g:sortableColumn property="mail" title="${message(code: 'estacion.mail.label', default: 'Mail')}"/>

            <g:sortableColumn property="telefono"
                              title="${message(code: 'estacion.telefono.label', default: 'Telefono')}"/>

            <g:sortableColumn property="propetario"
                              title="${message(code: 'estacion.propetario.label', default: 'Propetario')}"/>

            <g:sortableColumn property="representante"
                              title="${message(code: 'estacion.representante.label', default: 'Representante')}"/>

            <g:sortableColumn property="aplicacion"
                              title="${message(code: 'estacion.aplicacion.label', default: 'Aplicacion')}"/>

        </tr>
        </thead>
        <tbody>
        <g:each in="${estacionInstanceList}" status="i" var="estacionInstance">
            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">

                <td><g:link action="show"
                            id="${estacionInstance.id}">${fieldValue(bean: estacionInstance, field: "direccion")}</g:link></td>

                <td>${fieldValue(bean: estacionInstance, field: "mail")}</td>

                <td>${fieldValue(bean: estacionInstance, field: "telefono")}</td>

                <td>${fieldValue(bean: estacionInstance, field: "propetario")}</td>

                <td>${fieldValue(bean: estacionInstance, field: "representante")}</td>

                <td>${fieldValue(bean: estacionInstance, field: "aplicacion")}</td>

            </tr>
        </g:each>
        </tbody>
    </table>

    <div class="pagination">
        <g:paginate total="${estacionInstanceCount ?: 0}"/>
    </div>
</div>
</body>
</html>
