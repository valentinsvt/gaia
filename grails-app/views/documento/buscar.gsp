<table class="table table-bordered table-hover table-striped" style="font-size: 11px">
    <thead>
        <tr>
            <th>Estación</th>
            <th>Tipo</th>
            <th>Consultor</th>
            <th>Referencia</th>
            <th>Descripción</th>
            <th style="width: 90px">Registro</th>
            <th style="width: 90px">Emitido</th>
            <th style="width: 90px">Vence</th>
            <th style="width: 30px"></th>
            <th style="width:60px;">Ver</th>
        </tr>
    </thead>
    <tbody>
        <g:if test="${documentos.size() > 0}">
            <g:each in="${documentos}" var="docu">
                <tr class="tr-info ${docu.tipo.id}">
                    <td>${docu.estacion.nombre}</td>
                    <td>${docu.tipo.nombre}</td>
                    <td>${docu.consultor?.nombre}</td>
                    <td>
                        <elm:textoBusqueda busca="${params.search}">
                            ${docu.referencia}
                        </elm:textoBusqueda>
                    </td>
                    <td>
                        <elm:textoBusqueda busca="${params.search}">
                            ${docu.descripcion}
                        </elm:textoBusqueda>
                    </td>
                    <td style="width: 90px;text-align: center">${docu.fechaRegistro.format("dd-MM-yyyy")}</td>
                    <td style="width: 90px;text-align: center">${docu.inicio?.format("dd-MM-yyyy")}</td>
                    <td style="width: 90px;text-align: center">${docu.fin?.format("dd-MM-yyyy")}</td>
                    <td style="width: 30px;text-align: center">
                        <g:if test="${docu.estado == 'A'}">
                            <span class="text-success" title="Aprobado">
                                <i class="fa fa-check"></i>
                            </span>
                        </g:if>
                        <g:else>
                            <span class="text-danger" title="No aprobado">
                                <i class="fa fa-times"></i>
                            </span>
                        </g:else>
                    </td>
                    <td style="text-align: center;width: 80px">
                        <a href="#" data-file="${docu.path}"
                           data-ref="${docu.referencia}"
                           data-codigo="${docu.codigo}"
                           data-tipo="${docu.tipo.nombre}"
                           target="" class="btn btn-info ver-doc btn-sm" title="Ver" style="display: inline-block">
                            <i class="fa fa-search"></i>
                        </a>
                        <g:link controller="documento" action="arbolEstacion" id="${docu.id}" style="display: inline-block"
                                class="btn btn-primary btn-sm" title="Visor de documentos" target="_blank">
                            <i class="fa fa-file-pdf-o"></i>
                        </g:link>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr>
                <td colspan="10">
                    No hay documentos registrados
                </td>
            </tr>
        </g:else>
    </tbody>
</table>
<script type="text/javascript">
    $(".ver-doc").click(function () {
        showPdf($(this))
        return false
    })
</script>