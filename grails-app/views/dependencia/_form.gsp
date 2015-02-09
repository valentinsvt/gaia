<%@ page import="gaia.documentos.Dependencia" %>



<div class="fieldcontain ${hasErrors(bean: dependenciaInstance, field: 'nombre', 'error')} required">
	<label for="nombre">
		<g:message code="dependencia.nombre.label" default="Nombre" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="nombre" maxlength="150" required="" class="form-control  required" value="${dependenciaInstance?.nombre}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: dependenciaInstance, field: 'codigo', 'error')} required">
	<label for="codigo">
		<g:message code="dependencia.codigo.label" default="Codigo" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="codigo" maxlength="5" required="" class="form-control  required unique noEspacios" value="${dependenciaInstance?.codigo}"/>
</div>

