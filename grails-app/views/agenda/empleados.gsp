<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Empleados</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight',file: 'jquery-highlight1.js')}"></imp:js>
    <style>
    .td-semaforo{
        text-align: center;
        width: 90px;
    }
    .circle-card{
        width: 22px ;
        height: 22px;
    }
    .circle-btn{
        cursor: pointer;
    }
    .highlight { background-color: yellow; }
    </style>
</head>
<body>
<elm:container tipo="horizontal" titulo="Empleados">

    <table class="table table-striped table-hover table-bordered" style="margin-top: 15px;font-size: 12px">
        <thead>
        <tr>
            <th>
                <div class="row" style="margin-top: 0px">
                    <div class="col-md-6">
                        <div class="input-group" >
                            <input type="text" class="form-control input-sm" id="txt-buscar" placeholder="Buscar">
                            <span class="input-group-addon svt-bg-primary " id="btn-buscar" style="cursor: pointer" >
                                <i class="fa fa-search " ></i>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-1">
                        Empleado
                    </div>
                    <div class="col-md-3 col-md-offset-1">
                        <a href="#" class="btn btn-primary btn-sm" id="reset"><i class="fa fa-refresh"></i> Resetear filtros</a>
                    </div>
                </div>
            </th>
            <th>Email</th>
            <th>Telefono</th>
            <th>Ubicación</th>
            <th class="td-semaforo">
                Activo<br>
                <div class="circle-card card-bg-green circle-btn licencia-green" title="Filtrar por color verde" mostrar="1"></div>
            </th>
            <th class="td-semaforo">
                Cesante<br>
                <div class="circle-card svt-bg-danger circle-btn pintura-red" title="Filtrar por color rojo" mostrar="0"></div>
            </th>
            <th style="width: 60px">Ver</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${empleados}" var="d" status="">

            <tr data-id="${d.cedula}" class=" tr-info  ${d.estado.trim()} ">
                <td class="desc">${d.apellido} ${d.nombre} </td>
                <td>${d.email}</td>
                <td>${d.telefono}</td>
                <td>${d.ciudadTrabajo}</td>
                <td class="td-semaforo" >
                    <g:if test="${d.estado=='1'}">
                        <div class="circle-card ${colores[0]}" ></div>
                    </g:if>
                </td>
                <td class="td-semaforo" >
                    <g:if test="${d.estado=='0'}">
                        <div class="circle-card ${colores[2]}" ></div>
                    </g:if>
                </td>
                <td  style="width: 60px;text-align: center">
                    <a href="#" class="btn btn-primary btn-sm detalles" title="Ver" iden="${d.cedula}"><i class="fa fa-search"></i></a>
                </td>

            </tr>
        </g:each>
        </tbody>
    </table>
</elm:container>
<script type="text/javascript">
    function search(clase){
        $(".tr-info").hide()
        $("."+clase).show()
    }
    function verEmpleado(id) {

        $.ajax({
            type: "POST",
            url: "${createLink(controller:'agenda', action:'show_empleado_ajax')}",
            data: {
                id: id
            },
            success: function (msg) {
                bootbox.dialog({
                    title: "Datos del empleado",
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

    $(function () {
        <g:if test="${search}">
        openLoader();
        search("${search}")
        closeLoader()
        </g:if>
        $(".circle-btn").click(function () {
            $(".tr-info").hide()
            $("." + $(this).attr("mostrar")).show()
        });
        $("#reset").click(function () {
            $(".tr-info").show()
            $(".desc").removeHighlight();
        })

        $("#btn-buscar").click(function(){
            var buscar = $("#txt-buscar").val().trim()
            $(".desc").removeHighlight();
            $(".tr-info").hide()
            if(buscar!=""){
                $(".desc").highlight(buscar, true);
                $(".highlight").parents("tr").show()
            }else{
                $(".tr-info").show()
            }

        });
        $("tbody>tr").contextMenu({
            items: {
                header: {
                    label: "Acciones",
                    header: true
                },
                ver: {
                    label: "Detalles",
                    icon: "fa fa-search",
                    action: function ($element) {
                        var id = $element.data("id");
                        verEmpleado(id);
                        return false;
                    }
                }
            },
            onShow: function ($element) {
                $element.addClass("success");
            },
            onHide: function ($element) {
                $(".success").removeClass("success");
            }
        });
        $(".detalles").click(function(){
            verEmpleado($(this).attr("iden"))
            return false
        });
    });
</script>
</body>
</html>