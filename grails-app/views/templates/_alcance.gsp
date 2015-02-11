<fieldset>
    <legend>Oficio de alcance a las observaciones</legend>
    <g:form class="frm-subir-obs" controller="licencia" action="upload" enctype="multipart/form-data" >
        <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
        <input type="hidden" name="proceso" value="${proceso?.id}" >
        <input type="hidden" name="id" value="${detalleAlc?.id}" >
        <input type="hidden" name="tipo" value="obs" >
        <input type="hidden" name="paso" value="2" >
        <input type="hidden" name="origen" value="licenciaTdr" >
        <input type="hidden" name="padre" value="${padre?.id}" >
        <div class="row" style="margin-top: 0px">
            <div class="col-md-2">
                <label>
                    Oficio
                </label>
            </div>
            <div class="col-md-4">
                <g:if test="${detalleAlc?.documento}">
                    <div id="botones-obs_${detalleAlc?.id}">
                        ${detalleAlc.documento.codigo}
                        <a href="${g.createLink(controller: 'documento',action: 'ver',id: detalleAlc.documento.id)}" target="_blank" class="btn btn-info" id="ver">
                            <i class="fa fa-search"></i> Ver
                        </a>
                        <a href="#" class="btn btn-info cambiar" iden="obs_${detalleAlc?.id}">
                            <i class="fa fa-refresh"></i> Cambiar
                        </a>
                    </div>
                    <div id="div-file-obs_${detalleAlc?.id}" style="display: none">
                        <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                    </div>
                </g:if>
                <g:else>
                    <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                </g:else>
            </div>

        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    N. referencia
                </label>
            </div>
            <div class="col-md-4">
                <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detalleAlc?.documento?.referencia}">
            </div>
            <div class="col-md-1">
                <label>
                    Emisión
                </label>
            </div>
            <div class="col-md-3">
                <elm:datepicker name="inicio" id="obs_${detalleAlc?.id}" class="required form-control input-sm" value="${detalleAlc?.documento?.inicio}"/>
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
<g:if test="${detalleAlc}">
    <util:displayChain detalle="${gaia.documentos.Detalle.findByDetalle(detalleAlc)}" paso="${paso}" origen="${origen}" padre="${padre?.id}"/>
</g:if>