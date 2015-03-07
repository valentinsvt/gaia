<%--
  Created by IntelliJ IDEA.
  User: Luz
  Date: 2/11/2015
  Time: 9:32 PM
--%>

<table class="table table-bordered table-condensed table-hover">
    <thead>
    <tr>
        <th>R.U.C.</th>
        <th>Nombre</th>
        <th>Teléfono</th>
        <th>Dirección</th>
        <th>E-Mail</th>
        <th style="width: 30px;">Oae</th>
        <th style="width: 30px;"></th>
        <th style="width: 30px;"></th>
    </tr>
    </thead>
    <tbody id="tbCons">
    <g:if test="${consultores.size() > 0}">
        <g:each in="${consultores}" var="consultor">
            <g:set var="cons" value="${consultor.consultor}"/>
            <tr data-cons="${cons.id}" data-id="${consultor.id}">
                <td>
                    ${cons.ruc}
                </td>
                <td>
                    ${cons.nombre}
                </td>
                <td>
                    ${cons.telefono}
                </td>
                <td>
                    ${cons.direccion}
                </td>
                <td>
                    ${cons.mail}
                </td>
                <td>
                    <g:if test="${cons.pathOae && cons.pathOae!=''}" >
                        <a href="${resource()}/consultores/${cons.ruc}/${cons.pathOae}" class="btn btn-info btn-sm " id="${cons.id}" title="Descargar" target="_blank">
                            <i class="fa fa-download"></i>
                        </a>
                    </g:if>
                </td>
                <td>
                    <a href="#" class="btn btn-info btn-sm btn-edit" id="${cons.id}">
                        <i class="fa fa-pencil"></i>
                    </a>
                </td>
                <td>
                    <a href="#" class="btn btn-danger btn-sm btnDeleteCons">
                        <i class="fa fa-trash-o"></i>
                    </a>
                </td>
            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr>
            <td colspan="5" class="info text-center">
                No se encontraron consultores
            </td>
        </tr>
    </g:else>
    </tbody>
</table>

<script type="text/javascript">
    $(function () {
        $(".btnDeleteCons").click(function () {
            var id = $(this).parents("tr").data("id");
            bootbox.confirm("¿Está seguro que desea eliminar este consultor?", function (res) {
                if (res) {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:'consultor', action:'deleteConsultor_ajax')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0].toLowerCase());
                            if (parts[0] == "SUCCESS") {
                                loadConsultores();
                            }
                        }
                    });
                }
            });
        });
        $(".btn-edit").click(function () {
            var id = $(this).attr("id");
            createEditConsultor(id)
        });
    });
</script>