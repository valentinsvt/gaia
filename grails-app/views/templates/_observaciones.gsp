<fieldset>
    <legend>Oficio de observaciones</legend>
    <g:form class="frm-subir-obs" controller="licencia" action="upload" enctype="multipart/form-data" >
        <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
        <input type="hidden" name="proceso" value="${proceso?.id}" >
        <input type="hidden" name="id" value="${detalleObs?.id}" >
        <input type="hidden" name="tipo" value="obs" >
        <input type="hidden" name="paso" value="${paso}" >
        <input type="hidden" name="origen" value="${origen}">
        <input type="hidden" name="padre" value="${padre?.id}">
        <div class="row" style="margin-top: 0px">
            <div class="col-md-2">
                <label>
                    Oficio
                </label>
            </div>
            <div class="col-md-4">
                <g:if test="${detalleObs?.documento}">
                    <div id="botones-obs_${detalleObs?.id}">
                        ${detalleObs.documento.codigo}
                        <a href="#" data-file="${detalleObs.documento.path}"
                           data-ref="${detalleObs.documento.referencia}"
                           data-codigo="${detalleObs.documento.codigo}"
                           data-tipo="${detalleObs.documento.tipo.nombre}"
                           target="_blank" class="btn btn-info ver-doc" >
                            <i class="fa fa-search"></i> Ver
                        </a>
                        <a href="#" class="btn btn-info cambiar" iden="obs_${detalleObs?.id}">
                            <i class="fa fa-refresh"></i> Cambiar
                        </a>
                    </div>
                    <div id="div-file-obs_${detalleObs?.id}" style="display: none">
                        <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                    </div>
                </g:if>
                <g:else>
                    <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                </g:else>
            </div>
            <div class="col-md-1">
                <label>
                    Plazo
                </label>
            </div>
            <div class="col-md-2">
                <input type="text" value="${detalleObs?.plazo}" name="plazo" class="form-control required" style="text-align: right">
            </div>
            <div class="col-md-3">
                Vence: ${detalleObs?.documento?.fin?.format("dd-MM-yyyy")}
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    N. referencia
                </label>
            </div>
            <div class="col-md-4">
                <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detalleObs?.documento?.referencia}">
            </div>
            <div class="col-md-1">
                <label>
                    Emisión
                </label>
            </div>
            <div class="col-md-3">
                <elm:datepicker name="inicio" id="obs_${detalleObs?.id}" class="required form-control input-sm" value="${detalleObs?.documento?.inicio}"/>
            </div>
        </div>

        <div class="row">
            <div class="col-md-1">
                <a href="#" class="btn btn-primary guardar-obs">
                    <i class="fa fa-save"></i>
                    Guardar
                </a>
            </div>
        </div>
    </g:form>
</fieldset>
<g:if test="${detalleObs}">
    <util:displayChain detalle="${gaia.documentos.Detalle.findByDetalle(detalleObs)}" paso="${paso}" origen="${origen}" padre="${padre?.id}"/>
</g:if>