<%@ page import="gaia.parametros.Anio" %>



<div class="fieldcontain ${hasErrors(bean: anioInstance, field: 'anio', 'error')} required">
	<label for="anio">
		<g:message code="anio.anio.label" default="Anio" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="anio" required="" class="form-control  required" value="${anioInstance?.anio}"/>
</div>

