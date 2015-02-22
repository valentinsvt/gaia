
<%@ page import="gaia.documentos.Consultor" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'consultor.label', default: 'Consultor')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-consultor" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-consultor" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="nombre" title="${message(code: 'consultor.nombre.label', default: 'Nombre')}" />
					
						<g:sortableColumn property="ruc" title="${message(code: 'consultor.ruc.label', default: 'Ruc')}" />
					
						<g:sortableColumn property="telefono" title="${message(code: 'consultor.telefono.label', default: 'Telefono')}" />
					
						<g:sortableColumn property="direccion" title="${message(code: 'consultor.direccion.label', default: 'Direccion')}" />
					
						<g:sortableColumn property="mail" title="${message(code: 'consultor.mail.label', default: 'Mail')}" />
					
						<g:sortableColumn property="observaciones" title="${message(code: 'consultor.observaciones.label', default: 'Observaciones')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${consultorInstanceList}" status="i" var="consultorInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${consultorInstance.id}">${fieldValue(bean: consultorInstance, field: "nombre")}</g:link></td>
					
						<td>${fieldValue(bean: consultorInstance, field: "ruc")}</td>
					
						<td>${fieldValue(bean: consultorInstance, field: "telefono")}</td>
					
						<td>${fieldValue(bean: consultorInstance, field: "direccion")}</td>
					
						<td>${fieldValue(bean: consultorInstance, field: "mail")}</td>
					
						<td>${fieldValue(bean: consultorInstance, field: "observaciones")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${consultorInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
