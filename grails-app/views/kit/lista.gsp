<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Kits</title>
    <meta name="layout" content="main"/>
</head>
<body>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <g:link controller="kit" action="nuevoKit" class="btn btn-default">
            <i class="fa fa-shopping-cart"></i> Crear nuevo kit
        </g:link>
    </div>
</div>
<elm:container titulo="Kits">
    <div class="row">
        <div class="col-md-10">
            <table class="table table-striped table-condensed table-hover table-bordered">
                <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Detalle</th>
                    <th>Estado</th>
                    <th style="width: 40px;"></th>
                    <th style="width: 40px;"></th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${kits}" var="k">
                    <tr>
                        <td>${k.nombre}</td>
                        <td>
                            <ul>
                                <g:each in="${gaia.uniformes.DetalleKit.findAllByKit(k)}" var="d">
                                  <li>${d.cantidad} ${d.uniforme}</li>
                                </g:each>
                            </ul>
                        </td>
                        <td style="text-align: center">${k.estado=='A'?'Activo':'Inanctivo'}</td>
                        <td style="text-align: center">
                            <g:link class="btn btn-info btn-sm" action="nuevoKit" id="${k.id}" title="Editar">
                                <i class="fa fa-pencil"></i>
                            </g:link>
                        </td>
                        <td style="text-align: center">
                            <a href="#" class="btn btn-sm btn-warning estado" iden="${k.id}" title="Cambiar estado">
                                <i class="fa fa-toggle-on"></i>
                            </a>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>

</elm:container>
<script type="text/javascript">
    $(".estado").click(function(){
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'kit', action:'cambiarEstado')}",
            data: {
                id: $(this).attr("iden")
            },
            success: function (msg) {
                window.location.reload(true)
            }
        });
    })
</script>
</body>
</html>