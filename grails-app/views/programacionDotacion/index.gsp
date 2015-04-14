
<%@ page import="gaia.parametros.ProgramacionDotacion" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'programacionDotacion.label', default: 'ProgramacionDotacion')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-programacionDotacion" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-programacionDotacion" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="fecha2" title="${message(code: 'programacionDotacion.fecha2.label', default: 'Fecha2')}" />
					
						<th><g:message code="programacionDotacion.anio.label" default="Anio" /></th>
					
						<g:sortableColumn property="fecha1" title="${message(code: 'programacionDotacion.fecha1.label', default: 'Fecha1')}" />
					
						<g:sortableColumn property="numero" title="${message(code: 'programacionDotacion.numero.label', default: 'Numero')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${programacionDotacionInstanceList}" status="i" var="programacionDotacionInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${programacionDotacionInstance.id}">${fieldValue(bean: programacionDotacionInstance, field: "fecha2")}</g:link></td>
					
						<td>${fieldValue(bean: programacionDotacionInstance, field: "anio")}</td>
					
						<td><g:formatDate date="${programacionDotacionInstance.fecha1}" /></td>
					
						<td>${fieldValue(bean: programacionDotacionInstance, field: "numero")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${programacionDotacionInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
