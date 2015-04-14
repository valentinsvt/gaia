<%@ page import="gaia.parametros.ProgramacionDotacion" %>



<div class="fieldcontain ${hasErrors(bean: programacionDotacionInstance, field: 'fecha2', 'error')} ">
	<label for="fecha2">
		<g:message code="programacionDotacion.fecha2.label" default="Fecha2" />
		
	</label>
	<elm:datepicker name="fecha2"  class="datepicker form-control " value="${programacionDotacionInstance?.fecha2}" />
</div>

<div class="fieldcontain ${hasErrors(bean: programacionDotacionInstance, field: 'anio', 'error')} required">
	<label for="anio">
		<g:message code="programacionDotacion.anio.label" default="Anio" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="anio" name="anio.id" from="${gaia.parametros.Anio.list()}" optionKey="id" required="" value="${programacionDotacionInstance?.anio?.id}" class="many-to-one form-control "/>
</div>

<div class="fieldcontain ${hasErrors(bean: programacionDotacionInstance, field: 'fecha1', 'error')} required">
	<label for="fecha1">
		<g:message code="programacionDotacion.fecha1.label" default="Fecha1" />
		<span class="required-indicator">*</span>
	</label>
	<elm:datepicker name="fecha1"  class="datepicker form-control  required" value="${programacionDotacionInstance?.fecha1}" />
</div>

<div class="fieldcontain ${hasErrors(bean: programacionDotacionInstance, field: 'numero', 'error')} required">
	<label for="numero">
		<g:message code="programacionDotacion.numero.label" default="Numero" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="numero" value="${programacionDotacionInstance.numero}" class="digits form-control  required" required=""/>
</div>

