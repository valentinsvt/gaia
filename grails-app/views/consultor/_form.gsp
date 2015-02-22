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

<div class="fieldcontain ${hasErrors(bean: consultorInstance, field: 'observaciones', 'error')} ">
	<label for="observaciones">
		<g:message code="consultor.observaciones.label" default="Observaciones" />
		
	</label>
	<g:textField name="observaciones" class="form-control " value="${consultorInstance?.observaciones}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: consultorInstance, field: 'calificacionArch', 'error')} ">
	<label for="calificacionArch">
		<g:message code="consultor.calificacionArch.label" default="Calificacion Arch" />
		
	</label>
	<g:textField name="calificacionArch" maxlength="50" class="form-control " value="${consultorInstance?.calificacionArch}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: consultorInstance, field: 'pathOae', 'error')} ">
	<label for="pathOae">
		<g:message code="consultor.pathOae.label" default="Path Oae" />
		
	</label>
	<g:textField name="pathOae" maxlength="100" class="form-control " value="${consultorInstance?.pathOae}"/>
</div>

