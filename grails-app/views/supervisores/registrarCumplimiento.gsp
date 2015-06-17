<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Objetivos asesores de servicio al cliente, mes de ${meses[mesint-1]}</title>
</head>
<body>
<elm:container titulo="Objetivos asesores de servicio al cliente, mes de ${meses[mesint-1]}">
    <div class="row">
        <g:each in="${objetivos}" var="o">
            <g:if test="${o.periocidad=='A'}">
                <g:set var="cump" value="${gaia.supervisores.CumplimientoSupervisor.findAll('from CumplimientoSupervisor where objetivo=\''+o.id+'\' and mes=\''+anio+'\' and supervisor=\''+supervisor.id+'\'')}"></g:set>
            </g:if>
            <g:else>
                <g:set var="cump" value="${gaia.supervisores.CumplimientoSupervisor.findAll('from CumplimientoSupervisor where objetivo=\''+o.id+'\' and mes=\''+mesString+'\' and supervisor=\''+supervisor.id+'\'')}"></g:set>
            </g:else>
            <g:if test="${cump.size()>0}">
                <g:set var="cump" value="${cump.pop()}"></g:set>
            </g:if>
            <g:else>
                <g:set var="cump" value="${null}"></g:set>
            </g:else>

            <div class="col-md-6">
                <div class="panel ${cump?'panel-info':'panel-warning'}">
                    <div class="panel-heading">${o.nombre} - ${o.meta}</div>
                    <div class="panel-body">
                        <g:form class="frm_ob_${o.id}" controller="supervisores" action="uploadObjetivo" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="${cump?.id}">
                            <input type="hidden" name="objetivo" value="${o.id}">
                            <input type="hidden" name="supervisor" value="${supervisor.id}">
                            <input type="hidden" name="mes" value="${mesString}">
                            <input type="hidden" name="anio" value="${anio}">
                            <div class="row">
                                <div class="col-md-3">
                                    <label>Fecha registro</label>
                                </div>
                                <div class="col-md-9">
                                    ${cump?.fecha?.format("dd-MM-yyyy")}
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label>Archivo</label>
                                </div>
                                <div class="col-md-9">
                                    <g:if test="${!cump}">
                                        <input type="file" name="file" id="file" class="form-control ob_${o.id} required "  style="border-right: none" >
                                    </g:if>
                                    <g:else>
                                        <a href="${resource()+'/'+ cump.path}" class="descargar btn btn-info" target="_blank">
                                            <i class="fa fa-download"></i> Descargar
                                        </a>
                                        <a href="#" class="btn btn-info cambiar" file=".ob_${o.id}">
                                            <i class="fa fa-refresh"></i> Cambiar
                                        </a>
                                        <input type="file" name="file" id="file" class="form-control ob_${o.id} oculto required "  style="border-right: none;display: none" >
                                    </g:else>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label>Observaciones</label>
                                </div>
                                <div class="col-md-9">
                                    <textarea name="observaciones" class="form-control input-sm" style="height: 100px;resize: vertical">${cump?.observaciones}</textarea>
                                </div>
                            </div>
                        </g:form>
                    </div>
                    <div class="panel-footer">
                        <a href="#" class="guardar btn btn-info " ob=".ob_${o.id}" form=".frm_ob_${o.id}">
                            <i class="fa fa-save"></i> Guardar
                        </a>
                    </div>
                </div>
            </div>
        </g:each>
    </div>
</elm:container>
<script type="text/javascript">
    $(".guardar").click(function(){
        var file = $($(this).attr("ob")).val()
        if($($(this).attr("ob")).hasClass("oculto")){
            $($(this).attr("form")).submit()
        }else{
            if(file==''){
                bootbox.alert("Por favor seleccione un archivo")
            }else{
                $($(this).attr("form")).submit()
            }
        }
        return false

    })
    $(".cambiar").click(function(){
        $($(this).attr("file")).show()
        $(this).hide()
        $(this).parent().find(".descargar").hide()
        return false
    })
</script>
</body>
</html>