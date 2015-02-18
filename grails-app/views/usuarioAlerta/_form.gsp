<%@ page import="gaia.alertas.UsuarioAlerta" %>



<div class="fieldcontain ${hasErrors(bean: usuarioAlertaInstance, field: 'estado', 'error')} required">
	<label for="estado">
		<g:message code="usuarioAlerta.estado.label" default="Estado" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="estado" maxlength="1" required="" class="form-control  required" value="${usuarioAlertaInstance?.estado}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: usuarioAlertaInstance, field: 'persona', 'error')} required">
	<label for="persona">
		<g:message code="usuarioAlerta.persona.label" default="Persona" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="persona" name="persona.id" from="${gaia.seguridad.Persona.list()}" optionKey="id" required="" value="${usuarioAlertaInstance?.persona?.id}" class="many-to-one form-control "/>
</div>

