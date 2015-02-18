<%@ page import="gaia.documentos.Entidad" %>



<div class="fieldcontain ${hasErrors(bean: entidadInstance, field: 'nombre', 'error')} required">
	<label for="nombre">
		<g:message code="entidad.nombre.label" default="Nombre" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="nombre" maxlength="150" required="" class="form-control  required" value="${entidadInstance?.nombre}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: entidadInstance, field: 'codigo', 'error')} required">
	<label for="codigo">
		<g:message code="entidad.codigo.label" default="Codigo" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="codigo" maxlength="5" required="" class="form-control  required unique noEspacios" value="${entidadInstance?.codigo}"/>
</div>

