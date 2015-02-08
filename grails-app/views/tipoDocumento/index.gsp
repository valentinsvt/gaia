
<%@ page import="gaia.documentos.TipoDocumento" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'tipoDocumento.label', default: 'TipoDocumento')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-tipoDocumento" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-tipoDocumento" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="nombre" title="${message(code: 'tipoDocumento.nombre.label', default: 'Nombre')}" />
					
						<g:sortableColumn property="tipo" title="${message(code: 'tipoDocumento.tipo.label', default: 'Tipo')}" />
					
						<g:sortableColumn property="caduca" title="${message(code: 'tipoDocumento.caduca.label', default: 'Caduca')}" />
					
						<g:sortableColumn property="codigo" title="${message(code: 'tipoDocumento.codigo.label', default: 'Codigo')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${tipoDocumentoInstanceList}" status="i" var="tipoDocumentoInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${tipoDocumentoInstance.id}">${fieldValue(bean: tipoDocumentoInstance, field: "nombre")}</g:link></td>
					
						<td>${fieldValue(bean: tipoDocumentoInstance, field: "tipo")}</td>
					
						<td>${fieldValue(bean: tipoDocumentoInstance, field: "caduca")}</td>
					
						<td>${fieldValue(bean: tipoDocumentoInstance, field: "codigo")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${tipoDocumentoInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
