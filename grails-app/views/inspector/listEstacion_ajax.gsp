<%--
  Created by IntelliJ IDEA.
  User: Luz
  Date: 2/11/2015
  Time: 9:32 PM
--%>

<table class="table table-bordered table-condensed table-hover">
    <thead>
        <tr>
            <th>Nombre</th>
            <th>Teléfono</th>
            <th>E-Mail</th>
            <th style="width: 30px;"></th>
        </tr>
    </thead>
    <tbody id="tbIns">
        <g:if test="${inspectores.size() > 0}">
            <g:each in="${inspectores}" var="inspector">
                <g:set var="ins" value="${inspector.inspector}"/>
                <tr data-cons="${ins.id}" data-id="${inspector.id}">
                    <td>
                        ${ins.nombre}
                    </td>
                    <td>
                        ${ins.telefono}
                    </td>
                    <td>
                        ${ins.mail}
                    </td>
                    <td>
                        <a href="#" class="btn btn-danger btn-sm btnDeleteIns">
                            <i class="fa fa-trash-o"></i>
                        </a>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr>
                <td colspan="5" class="info text-center">
                    No se encontraron supervisores
                </td>
            </tr>
        </g:else>
    </tbody>
</table>

<script type="text/javascript">
    $(function () {
        $(".btnDeleteIns").click(function () {
            var id = $(this).parents("tr").data("id");
            bootbox.confirm("¿Está seguro que desea eliminar este supervisor?", function (res) {
                if (res) {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:'inspector', action:'deleteInspector_ajax')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0].toLowerCase());
                            if (parts[0] == "SUCCESS") {
                                loadInspectores();
                            }
                        }
                    });
                }
            });
        });
    });
</script>