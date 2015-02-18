<%@ page import="gaia.documentos.Consultor" %>



<div class="fieldcontain ${hasErrors(bean: consultorInstance, field: 'nombre', 'error')} required">
	<label for="nombre">
		<g:message code="consultor.nombre.label" default="Nombre" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="nombre" maxlength="150" required="" class="form-control  required" value="${consultorInstance?.nombre}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: consultorInstance, field: 'ruc', 'error')} required">
	<label for="ruc">
		<g:message code="consultor.ruc.label" default="Ruc" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="ruc" maxlength="20" required="" class="form-control  required" value="${consultorInstance?.ruc}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: consultorInstance, field: 'telefono', 'error')} required">
	<label for="telefono">
		<g:message code="consultor.telefono.label" default="Telefono" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="telefono" maxlength="15" required="" class="form-control  required" value="${consultorInstance?.telefono}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: consultorInstance, field: 'direccion', 'error')} ">
	<label for="direccion">
		<g:message code="consultor.direccion.label" default="Direccion" />
		
	</label>
	<g:textField name="direccion" maxlength="150" class="form-control " value="${consultorInstance?.direccion}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: consultorInstance, field: 'mail', 'error')} required">
	<label for="mail">
		<g:message code="consultor.mail.label" default="Mail" />
		<span class="required-indicator">*</span>
	</label>
	<div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field type="email" name="mail" maxlength="150" required="" class="form-control  required unique noEspacios" value="${consultorInstance?.mail}"/></div>
</div>

