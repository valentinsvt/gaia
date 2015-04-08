<%@ page import="gaia.seguridad.Sistema" %>



<div class="fieldcontain ${hasErrors(bean: sistemaInstance, field: 'nombre', 'error')} required">
	<label for="nombre">
		<g:message code="sistema.nombre.label" default="Nombre" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="nombre" maxlength="128" required="" class="form-control  required" value="${sistemaInstance?.nombre}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: sistemaInstance, field: 'descripcion', 'error')} required">
	<label for="descripcion">
		<g:message code="sistema.descripcion.label" default="Descripcion" />
		<span class="required-indicator">*</span>
	</label>
	<g:textArea name="descripcion" cols="40" rows="5" maxlength="511" required="" class="form-control  required" value="${sistemaInstance?.descripcion}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: sistemaInstance, field: 'codigo', 'error')} required">
	<label for="codigo">
		<g:message code="sistema.codigo.label" default="Codigo" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="codigo" maxlength="4" required="" class="form-control  required unique noEspacios" value="${sistemaInstance?.codigo}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: sistemaInstance, field: 'imagen', 'error')} ">
	<label for="imagen">
		<g:message code="sistema.imagen.label" default="Imagen" />
		
	</label>
	<g:textField name="imagen" maxlength="30" class="form-control " value="${sistemaInstance?.imagen}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: sistemaInstance, field: 'controlador', 'error')} ">
	<label for="controlador">
		<g:message code="sistema.controlador.label" default="Controlador" />
		
	</label>
	<g:select id="controlador" name="controlador.id" from="${gaia.seguridad.Controlador.list()}" optionKey="id" value="${sistemaInstance?.controlador?.id}" class="many-to-one form-control " noSelection="['null': '']"/>
</div>

