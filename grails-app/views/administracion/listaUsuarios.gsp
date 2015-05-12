<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Lista de usuarios por perfíl</title>
    <style type="text/css">
    .info-row td{
        background: #7fac35;
        color: #ffffff;
        font-weight: bold;
        padding-left: 10px !important;
    }
    .highlight { background-color: yellow; }
    </style>
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight',file: 'jquery-highlight1.js')}"></imp:js>
</head>
<body>
<elm:container tipo="horizontal" titulo="Lista de usuarios por perfíl">
    <div class="row">
        <div class="col-md-3">
            <div class="input-group" >
                <input type="text" class="form-control input-sm" id="txt-buscar" placeholder="Buscar">
                <span class="input-group-addon svt-bg-primary " id="btn-buscar" style="cursor: pointer" >
                    <i class="fa fa-search " ></i>
                </span>
            </div>
        </div>
        <div class="col-md-1 ">
            <a href="#" class="btn btn-primary btn-sm" id="reset"><i class="fa fa-refresh"></i> Resetear filtros</a>
        </div>
    </div>
    <div class="row">
        <div class="col-md-10">
            <table class="table table-condensed table-hover table-striped">
                <thead>
                <tr>
                    <th>Usuario</th>
                    <th>Nombre</th>
                    <th>Estado<br>
                        <i class="fa fa-check filtro" style="color: #7fac35;font-size: 18;cursor: pointer;margin-right: 10px" title="Filtrar activos" show="1" ></i>
                        <i class="fa fa-times filtro" style="color: red;font-size: 18;cursor: pointer" title="Filtrar inactivo" show="0"></i>
                    </th>
                </tr>
                </thead>
                <tbody>
                    <g:each in="${perfiles}" var="perfil">
                        <tr class="info-row tr-info" id="${perfil.codigo}">
                            <td colspan="2"> ${perfil.descripcion}</td>
                            <td style="text-align: center">
                            <a href="#" class="detalles btn btn-info btn-sm" title="Ver permisos" iden="${perfil.codigo}">
                                <i class="fa fa-list"></i>
                            </a>
                            </td>
                        </tr>
                        <g:each in="${gaia.seguridad.Sesion.findAllByPerfil(perfil).usuario}" var="u">
                            <tr class="tr-info ${u.estado} dato" >
                                <td class="desc" perfil="${perfil.codigo}">${u.login}</td>
                                <td class="desc" perfil="${perfil.codigo}">${u.nombre}</td>
                                <td style="text-align: center">
                                    <g:if test="${u.estado==1}">
                                        <i class="fa fa-check" style="color: #7fac35" title="Activo"></i>
                                    </g:if>
                                    <g:else>
                                        <i class="fa fa-times" style="color: red" title="Inactivo"></i>
                                    </g:else>
                                </td>
                            </tr>
                        </g:each>
                    </g:each>
                </tbody>
            </table>
        </div>
    </div>

</elm:container>
<script type="text/javascript">
    function verDetalles(id) {
        openLoader()
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'administracion', action:'detallesPerfil_ajax')}",
            data: {
                id: id
            },
            success: function (msg) {
                closeLoader()
                bootbox.dialog({
                    title: "Acciones del perfíl",
                    message: msg,
                    class:"modal-lg",
                    buttons: {
                        ok: {
                            label: "Aceptar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        }
                    }
                });
            }
        });
        return false
    }
    $("#btn-buscar").click(function(){
        var buscar = $("#txt-buscar").val().trim()
        $(".desc").removeHighlight();
        $(".tr-info").hide()
        if(buscar!=""){
            $(".desc").highlight(buscar, true);
            $(".highlight").parents("tr").show()
            $(".highlight").each(function(){
               $("#"+$(this).parent().attr("perfil")).show()
            });
        }else{
            $(".tr-info").show()
        }

    });
    $("#reset").click(function () {
        $(".tr-info").show()
        $(".desc").removeHighlight();
    })
    $(".filtro").click(function(){
        $(".dato").hide()
       $("."+$(this).attr("show")).show()
    });
    $(".detalles").click(function(){
        verDetalles($(this).attr("iden"))
        return false
    })
</script>
</body>
</html>