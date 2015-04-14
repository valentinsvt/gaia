
<%@ page import="gaia.parametros.ProgramacionDotacion" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'programacionDotacion.label', default: 'ProgramacionDotacion')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-programacionDotacion" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-programacionDotacion" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list programacionDotacion">
			
				<g:if test="${programacionDotacionInstance?.fecha2}">
				<li class="fieldcontain">
					<span id="fecha2-label" class="property-label"><g:message code="programacionDotacion.fecha2.label" default="Fecha2" /></span>
					
						<span class="property-value" aria-labelledby="fecha2-label"><g:formatDate date="${programacionDotacionInstance?.fecha2}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${programacionDotacionInstance?.anio}">
				<li class="fieldcontain">
					<span id="anio-label" class="property-label"><g:message code="programacionDotacion.anio.label" default="Anio" /></span>
					
						<span class="property-value" aria-labelledby="anio-label"><g:link controller="anio" action="show" id="${programacionDotacionInstance?.anio?.id}">${programacionDotacionInstance?.anio?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${programacionDotacionInstance?.fecha1}">
				<li class="fieldcontain">
					<span id="fecha1-label" class="property-label"><g:message code="programacionDotacion.fecha1.label" default="Fecha1" /></span>
					
						<span class="property-value" aria-labelledby="fecha1-label"><g:formatDate date="${programacionDotacionInstance?.fecha1}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${programacionDotacionInstance?.numero}">
				<li class="fieldcontain">
					<span id="numero-label" class="property-label"><g:message code="programacionDotacion.numero.label" default="Numero" /></span>
					
						<span class="property-value" aria-labelledby="numero-label"><g:fieldValue bean="${programacionDotacionInstance}" field="numero"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:programacionDotacionInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${programacionDotacionInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
