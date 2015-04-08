
<%@ page import="gaia.seguridad.Sistema" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'sistema.label', default: 'Sistema')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-sistema" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-sistema" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list sistema">
			
				<g:if test="${sistemaInstance?.nombre}">
				<li class="fieldcontain">
					<span id="nombre-label" class="property-label"><g:message code="sistema.nombre.label" default="Nombre" /></span>
					
						<span class="property-value" aria-labelledby="nombre-label"><g:fieldValue bean="${sistemaInstance}" field="nombre"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${sistemaInstance?.descripcion}">
				<li class="fieldcontain">
					<span id="descripcion-label" class="property-label"><g:message code="sistema.descripcion.label" default="Descripcion" /></span>
					
						<span class="property-value" aria-labelledby="descripcion-label"><g:fieldValue bean="${sistemaInstance}" field="descripcion"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${sistemaInstance?.codigo}">
				<li class="fieldcontain">
					<span id="codigo-label" class="property-label"><g:message code="sistema.codigo.label" default="Codigo" /></span>
					
						<span class="property-value" aria-labelledby="codigo-label"><g:fieldValue bean="${sistemaInstance}" field="codigo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${sistemaInstance?.imagen}">
				<li class="fieldcontain">
					<span id="imagen-label" class="property-label"><g:message code="sistema.imagen.label" default="Imagen" /></span>
					
						<span class="property-value" aria-labelledby="imagen-label"><g:fieldValue bean="${sistemaInstance}" field="imagen"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${sistemaInstance?.controlador}">
				<li class="fieldcontain">
					<span id="controlador-label" class="property-label"><g:message code="sistema.controlador.label" default="Controlador" /></span>
					
						<span class="property-value" aria-labelledby="controlador-label"><g:link controller="controlador" action="show" id="${sistemaInstance?.controlador?.id}">${sistemaInstance?.controlador?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:sistemaInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${sistemaInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
