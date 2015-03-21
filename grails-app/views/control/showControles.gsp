<div class="row" style="margin: 20px">
    <g:select name="tipos" id="tipos-audt" from="${tipos}" optionKey="id" optionValue="nombre" class="form-control input-sm" style="width:280px;display: inline-table"/>
    <a href="#" class="btn btn-sm btn-success" id="nuevo-proceso">
        <i class="fa fa-file"></i> Crear nuevo
    </a>
</div>
<div class="row" style="margin: 20px">
    <table class="table table-striped table-bordered table-hover" style="font-size: 11px">
        <thead>
        <tr>
            <th>Tipo de<br> documento</th>
            <th>Consultor</th>
            <th>Registro</th>
            <th>Documento <br>final</th>
            <th>Emisión</th>
            <th>Vence</th>
            <th>Estado</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${procesos}" var="p">
            <tr>
                <td>${p.tipo.nombre}</td>
                <td>${p.consultor?.nombre}</td>
                <td style="text-align: center">${p.inicio?.format("dd-MM-yyyy")}</td>
                <td style="text-align: center">
                    <g:if test="${p.documento}">
                        <g:if test="${p.documento.estado=='A'}">
                            <span class="text-success"><i class="fa fa-check"></i></span>
                        </g:if>
                        <g:else>
                            <span class="text-danger"><i class="fa fa-times"></i></span>
                        </g:else>
                        <g:link class="btn btn-info btn-sm" controller="documento" action="ver" id="${p.documento?.id}" title="Ver">
                            <i class="fa fa-search"></i>
                            ${p.documento.referencia}
                        </g:link>
                    </g:if>
                </td>
                <td style="text-align: center">${p.documento?.inicio?.format("dd-MM-yyyy")}</td>
                <td style="text-align: center">${p.documento?.fin?.format("dd-MM-yyyy")}</td>
                <td style="text-align: center">
                    ${p.completado!="S"?"Incompleto":"Completo"}
                </td>
                <td style="text-align: center">
                    <a href="${g.createLink(controller: 'control',action: 'registrarControl',id: p.id)}" class="editar btn btn-sm btn-info">
                        <i class="fa fa-pencil"></i> Ver / Editar
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>
<script type="text/javascript">
    $("#nuevo-proceso").click(function(){
        bootbox.confirm({
            message  : "Está seguro?",
            title    : "Atención",
            class    : "modal-error",
            callback : function (res) {
                if (res) {
                    location.href = "${g.createLink(controller: 'control',action: 'nuevoProceso')}?id=${estacion.codigo}&tipo="+$("#tipos-audt").val()
                }
            }
        })
    })
</script>
