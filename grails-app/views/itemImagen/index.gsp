
<%@ page import="gaia.pintura.ItemImagen" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'itemImagen.label', default: 'ItemImagen')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-itemImagen" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-itemImagen" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<th><g:message code="itemImagen.padre.label" default="Padre" /></th>
					
						<g:sortableColumn property="descripcion" title="${message(code: 'itemImagen.descripcion.label', default: 'Descripcion')}" />
					
						<g:sortableColumn property="estado" title="${message(code: 'itemImagen.estado.label', default: 'Estado')}" />
					
						<g:sortableColumn property="tipo" title="${message(code: 'itemImagen.tipo.label', default: 'Tipo')}" />
					
						<g:sortableColumn property="tipoItem" title="${message(code: 'itemImagen.tipoItem.label', default: 'Tipo Item')}" />
					
						<g:sortableColumn property="unidad" title="${message(code: 'itemImagen.unidad.label', default: 'Unidad')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${itemImagenInstanceList}" status="i" var="itemImagenInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${itemImagenInstance.id}">${fieldValue(bean: itemImagenInstance, field: "padre")}</g:link></td>
					
						<td>${fieldValue(bean: itemImagenInstance, field: "descripcion")}</td>
					
						<td>${fieldValue(bean: itemImagenInstance, field: "estado")}</td>
					
						<td>${fieldValue(bean: itemImagenInstance, field: "tipo")}</td>
					
						<td>${fieldValue(bean: itemImagenInstance, field: "tipoItem")}</td>
					
						<td>${fieldValue(bean: itemImagenInstance, field: "unidad")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${itemImagenInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
