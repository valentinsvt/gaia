<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Industrias</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight',file: 'jquery-highlight1.js')}"></imp:js>
    <style>
    .td-semaforo{
        text-align: center;
        width: 110px;
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
<elm:container tipo="horizontal" titulo="Industrias">

    <table class="table table-striped table-hover table-bordered" style="margin-top: 15px;font-size: 12px">
        <thead>
        <tr>
            <th>
                <div class="row" style="margin-top: 0px">
                    <div class="col-md-5">
                        <div class="input-group" >
                            <input type="text" class="form-control input-sm" id="txt-buscar" placeholder="Buscar">
                            <span class="input-group-addon svt-bg-primary " id="btn-buscar" style="cursor: pointer" >
                                <i class="fa fa-search " ></i>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-2">
                        Cliente
                    </div>
                    <div class="col-md-3 col-md-offset-2">
                        <a href="#" class="btn btn-primary btn-sm" id="reset"><i class="fa fa-refresh"></i> Resetear filtros</a>
                    </div>
                </div>
            </th>
            <th class="td-semaforo">

                Activa<br>
                <div class="circle-card card-bg-green circle-btn licencia-green" title="Filtrar por color verde" mostrar="A"></div>
            </th>
            <th class="td-semaforo">
                Suspendida<br>
                <div class="circle-card svt-bg-warning circle-btn equipo-orange" title="Filtrar por color naranja" mostrar="S"></div>
            </th>
            <th class="td-semaforo">
                Cesante<br>
                <div class="circle-card svt-bg-danger circle-btn pintura-red" title="Filtrar por color rojo" mostrar="C"></div>
            </th>
            %{--<th>Ver</th>--}%
        </tr>
        </thead>
        <tbody>
        <g:each in="${industrias}" var="d" status="">

            <tr data-id="${d.codigo}" class=" tr-info  ${d.estado.trim()} ">
                <td class="desc">${d.nombre}</td>
                <td class="td-semaforo" >
                    <g:if test="${d.estado=='A'}">
                        <div class="circle-card ${colores[0]}" ></div>
                    </g:if>
                </td>
                <td class="td-semaforo">
                    <g:if test="${d.estado=='S'}">
                        <div class="circle-card ${colores[1]}" ></div>
                    </g:if>
                </td>
                <td class="td-semaforo" >
                    <g:if test="${d.estado=='C'}">
                        <div class="circle-card ${colores[2]}" ></div>
                    </g:if>
                </td>
                %{--<td class="td-semaforo">--}%
                    %{--<a href="${g.createLink(controller: 'Agenda',action: 'showEstacion',params: [id: d.codigo,tipo:1])}" class="btn btn-primary btn-sm" title="Ver"><i class="fa fa-search"></i></a>--}%
                %{--</td>--}%

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
    function verEstacion(id) {
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'estacion', action:'show_ajax')}",
            data: {
                id: id
            },
            success: function (msg) {
                bootbox.dialog({
                    title: "Datos de la estación",
                    message: msg,
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
                        verEstacion(id);
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
    });
</script>
</body>
</html>