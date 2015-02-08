<%@ page import="gaia.estaciones.Estacion" %>



<div class="fieldcontain ${hasErrors(bean: estacionInstance, field: 'direccion', 'error')} ">
    <label for="direccion">
        <g:message code="estacion.direccion.label" default="Direccion"/>

    </label>
    <g:textField name="direccion" class="form-control " value="${estacionInstance?.direccion}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: estacionInstance, field: 'mail', 'error')} ">
    <label for="mail">
        <g:message code="estacion.mail.label" default="Mail"/>

    </label>

    <div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field type="email"
                                                                                                           name="mail"
                                                                                                           class="form-control  unique noEspacios"
                                                                                                           value="${estacionInstance?.mail}"/>
    </div>
</div>

<div class="fieldcontain ${hasErrors(bean: estacionInstance, field: 'telefono', 'error')} ">
    <label for="telefono">
        <g:message code="estacion.telefono.label" default="Telefono"/>

    </label>
    <g:textField name="telefono" class="form-control " value="${estacionInstance?.telefono}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: estacionInstance, field: 'propetario', 'error')} ">
    <label for="propetario">
        <g:message code="estacion.propetario.label" default="Propetario"/>

    </label>
    <g:textField name="propetario" class="form-control " value="${estacionInstance?.propetario}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: estacionInstance, field: 'representante', 'error')} ">
    <label for="representante">
        <g:message code="estacion.representante.label" default="Representante"/>

    </label>
    <g:textField name="representante" class="form-control " value="${estacionInstance?.representante}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: estacionInstance, field: 'aplicacion', 'error')} required">
    <label for="aplicacion">
        <g:message code="estacion.aplicacion.label" default="Aplicacion"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="aplicacion" value="${estacionInstance.aplicacion}" class="digits form-control  required"
                 required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: estacionInstance, field: 'codigo', 'error')} required">
    <label for="codigo">
        <g:message code="estacion.codigo.label" default="Codigo"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="codigo" required="" class="form-control  required unique noEspacios"
                 value="${estacionInstance?.codigo}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: estacionInstance, field: 'estado', 'error')} required">
    <label for="estado">
        <g:message code="estacion.estado.label" default="Estado"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="estado" required="" class="form-control  required" value="${estacionInstance?.estado}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: estacionInstance, field: 'nombre', 'error')} required">
    <label for="nombre">
        <g:message code="estacion.nombre.label" default="Nombre"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="nombre" required="" class="form-control  required" value="${estacionInstance?.nombre}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: estacionInstance, field: 'ruc', 'error')} required">
    <label for="ruc">
        <g:message code="estacion.ruc.label" default="Ruc"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="ruc" required="" class="form-control  required" value="${estacionInstance?.ruc}"/>
</div>

