<div class="row" style="margin: 20px">
    <g:select name="tipos" id="tipos-audt" from="${tipos}" optionKey="id" optionValue="nombre" class="form-control input-sm" style="width:280px;display: inline-table"/>
    <a href="#" class="btn btn-sm btn-success" id="nuevo-proceso">
        <i class="fa fa-file"></i> Crear nuevo
    </a>
</div>
<div class="row" style="margin: 20px">
    <table class="table table-striped table-bordered table-hover">
        <thead>
        <tr>
            <th>Tipo de documento</th>
            <th>Consultor</th>
            <th>Registro</th>
            <th>Documento final</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${procesos}" var="p">
            <tr>
                <td>${p.tipo.nombre}</td>
                <td>${p.consultor?.nombre}</td>
                <td>${p.inicio?.format("dd-MM-yyyy")}</td>
                <td>
                    <g:if test="${p.documento}">
                        ${p.documento.referencia}
                        <g:if test="${p.documento.estado=='A'}">
                            <span class="text-success"><i class="fa fa-check"></i></span>
                        </g:if>
                        <g:else>
                            <span class="text-danger"><i class="fa fa-times"></i></span>
                        </g:else>
                    </g:if>
                    <g:else>
                        Incompleto
                    </g:else>

                </td>
                <td style="text-align: center">
                    <a href="${g.createLink(controller: 'auditoriaAmbiental',action: 'registrarAuditoria',id: p.id)}" class="editar btn btn-sm btn-info">
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
                    location.href = "${g.createLink(controller: 'auditoriaAmbiental',action: 'nuevoProceso')}?id=${estacion.codigo}&tipo="+$("#tipos-audt").val()
                }
            }
        })
    })
</script>
