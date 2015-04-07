<%@ page import="gaia.parametros.Parametros" %>



<div class="fieldcontain ${hasErrors(bean: parametrosInstance, field: 'diasAlertaContratos', 'error')} required">
	<label for="diasAlertaContratos">
		<g:message code="parametros.diasAlertaContratos.label" default="Dias Alerta Contratos" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="diasAlertaContratos" value="${parametrosInstance.diasAlertaContratos}" class="digits form-control  required" required=""/>
</div>

