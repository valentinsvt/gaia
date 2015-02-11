<%@ page import="gaia.documentos.TipoDocumento" %>



<div class="fieldcontain ${hasErrors(bean: tipoDocumentoInstance, field: 'nombre', 'error')} required">
	<label for="nombre">
		<g:message code="tipoDocumento.nombre.label" default="Nombre" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="nombre" maxlength="150" required="" class="form-control  required" value="${tipoDocumentoInstance?.nombre}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: tipoDocumentoInstance, field: 'tipo', 'error')} required">
	<label for="tipo">
		<g:message code="tipoDocumento.tipo.label" default="Tipo" />
		<span class="required-indicator">*</span>
	</label>
	<g:select name="tipo" from="${tipoDocumentoInstance.constraints.tipo.inList}" required="" class="form-control  required" value="${tipoDocumentoInstance?.tipo}" valueMessagePrefix="tipoDocumento.tipo"/>
</div>

<div class="fieldcontain ${hasErrors(bean: tipoDocumentoInstance, field: 'caduca', 'error')} required">
	<label for="caduca">
		<g:message code="tipoDocumento.caduca.label" default="Caduca" />
		<span class="required-indicator">*</span>
	</label>
	<g:select name="caduca" from="${tipoDocumentoInstance.constraints.caduca.inList}" required="" class="form-control  required" value="${tipoDocumentoInstance?.caduca}" valueMessagePrefix="tipoDocumento.caduca"/>
</div>

<div class="fieldcontain ${hasErrors(bean: tipoDocumentoInstance, field: 'codigo', 'error')} required">
	<label for="codigo">
		<g:message code="tipoDocumento.codigo.label" default="Codigo" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="codigo" maxlength="5" required="" class="form-control  required unique noEspacios" value="${tipoDocumentoInstance?.codigo}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: tipoDocumentoInstance, field: 'entidad', 'error')} ">
	<label for="entidad">
		<g:message code="tipoDocumento.entidad.label" default="Entidad" />
		
	</label>
	<g:select id="entidad" name="entidad.id" from="${gaia.documentos.Entidad.list()}" optionKey="id" value="${tipoDocumentoInstance?.entidad?.id}" class="many-to-one form-control " noSelection="['null': '']"/>
</div>

