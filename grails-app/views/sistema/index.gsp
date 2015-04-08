
<%@ page import="gaia.seguridad.Sistema" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'sistema.label', default: 'Sistema')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-sistema" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-sistema" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="nombre" title="${message(code: 'sistema.nombre.label', default: 'Nombre')}" />
					
						<g:sortableColumn property="descripcion" title="${message(code: 'sistema.descripcion.label', default: 'Descripcion')}" />
					
						<g:sortableColumn property="codigo" title="${message(code: 'sistema.codigo.label', default: 'Codigo')}" />
					
						<g:sortableColumn property="imagen" title="${message(code: 'sistema.imagen.label', default: 'Imagen')}" />
					
						<th><g:message code="sistema.controlador.label" default="Controlador" /></th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${sistemaInstanceList}" status="i" var="sistemaInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${sistemaInstance.id}">${fieldValue(bean: sistemaInstance, field: "nombre")}</g:link></td>
					
						<td>${fieldValue(bean: sistemaInstance, field: "descripcion")}</td>
					
						<td>${fieldValue(bean: sistemaInstance, field: "codigo")}</td>
					
						<td>${fieldValue(bean: sistemaInstance, field: "imagen")}</td>
					
						<td>${fieldValue(bean: sistemaInstance, field: "controlador")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${sistemaInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
