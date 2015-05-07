<%@ page import="gaia.pintura.ItemImagen" %>



<div class="fieldcontain ${hasErrors(bean: itemImagenInstance, field: 'padre', 'error')} ">
	<label for="padre">
		<g:message code="itemImagen.padre.label" default="Padre" />
		
	</label>
	<g:select id="padre" name="padre.id" from="${gaia.pintura.ItemImagen.list()}" optionKey="id" value="${itemImagenInstance?.padre?.id}" class="many-to-one form-control " noSelection="['null': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: itemImagenInstance, field: 'descripcion', 'error')} required">
	<label for="descripcion">
		<g:message code="itemImagen.descripcion.label" default="Descripcion" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="descripcion" required="" class="form-control  required" value="${itemImagenInstance?.descripcion}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: itemImagenInstance, field: 'estado', 'error')} required">
	<label for="estado">
		<g:message code="itemImagen.estado.label" default="Estado" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="estado" required="" class="form-control  required" value="${itemImagenInstance?.estado}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: itemImagenInstance, field: 'tipo', 'error')} required">
	<label for="tipo">
		<g:message code="itemImagen.tipo.label" default="Tipo" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="tipo" required="" class="form-control  required" value="${itemImagenInstance?.tipo}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: itemImagenInstance, field: 'tipoItem', 'error')} required">
	<label for="tipoItem">
		<g:message code="itemImagen.tipoItem.label" default="Tipo Item" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="tipoItem" required="" class="form-control  required" value="${itemImagenInstance?.tipoItem}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: itemImagenInstance, field: 'unidad', 'error')} required">
	<label for="unidad">
		<g:message code="itemImagen.unidad.label" default="Unidad" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="unidad" required="" class="form-control  required" value="${itemImagenInstance?.unidad}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: itemImagenInstance, field: 'valor', 'error')} required">
	<label for="valor">
		<g:message code="itemImagen.valor.label" default="Valor" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="valor" value="${fieldValue(bean: itemImagenInstance, field: 'valor')}" class="number form-control   required" required=""/>
</div>

