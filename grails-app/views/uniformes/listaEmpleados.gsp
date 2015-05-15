<table class="table table-striped table-bordered table-condensed">
    <thead>
    <tr>
        <th colspan="7">
            Lista de empleados de la estación ${estacion.nombre}
        </th>
    </tr>
    <tr>
        <th>Cédula</th>
        <th>Nombre</th>
        <th>Sexo</th>
        <th>Estado</th>
        <th style="width: 40px"></th>
        <th style="width: 40px"></th>
        <th style="width: 40px"></th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${nomina}" var="emp">
        <tr>
            <td>${emp.cedula}</td>
            <td>${emp.nombre}</td>
            <td style="text-align: center">${emp.sexo}</td>
            <td style="text-align: center">${emp.estado=="A"?"Activo":"Inactivo"}</td>
            <td style="text-align: center">
                <a href="#" title="Editar" class="btn btn-info btn-sm edit" cedula="${emp.cedula}" nombre="${emp.nombre}" sexo="${emp.sexo}">
                    <i class="fa fa-pencil"></i>
                </a>
            </td>
            <td style="text-align: center">
                <a href="#" title="Activar / desactivar" iden="${emp.id}" class="btn btn-warning btn-sm estado">
                    <i class="fa fa-toggle-on"></i>
                </a>
            </td>
            <td style="text-align: center">
                <a href="#" title="Tallas" class="btn btn-info btn-sm tallas" iden="${emp.id}">
                    <i class="fa fa-user"></i>
                </a>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>
<script type="text/javascript">
    $(".edit").click(function(){
        $("#nombre").val($(this).attr("nombre"))
        $("#cedula").val($(this).attr("cedula"))
        $("#sexo").val($(this).attr("sexo"))
    });
    $(".estado").click(function(){
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'uniformes', action:'cambiarEstado')}",
            data: {
                id:$(this).attr("iden")
            },
            success: function (msg) {
                $("#detalles").html(msg)

            }
        });
        return false
    });
    $(".tallas").click(function(){
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'uniformes', action:'tallas_ajax')}",
            data: {
                id: $(this).attr("iden")
            },
            success: function (msg) {
                bootbox.dialog({
                    title: "Tallas",
                    message: msg,
                    buttons: {
                        close:{
                            label: "Cerrar",
                            className: "btn-default",
                            callback: function () {
                            }
                        },
                        ok: {
                            label: "Guardar",
                            className: "btn-primary",
                            callback: function () {
                                var data = ""
                                var empleado = $("#emp").val()
                                $(".talla").each(function(){
                                    data+=$(this).parent().attr("uniforme")+";"+$(this).val()+"W"
                                });

                                $.ajax({
                                    type: "POST",
                                    url: "${createLink(controller:'uniformes', action:'saveTallas_ajax')}",
                                    data: {
                                        empleado:empleado,
                                        data:data
                                    },
                                    success: function (msg) {
                                        $(".modal").modal("hide")
                                    }
                                });


                            }
                        }

                    }
                });
            }
        });
        return false
    })



</script>