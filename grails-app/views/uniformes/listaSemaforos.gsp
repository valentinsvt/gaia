<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Dotaciones por estación</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight',file: 'jquery-highlight1.js')}"></imp:js>
    <style>
    .td-semaforo{
        text-align: center;
        width: 80px;
    }
    .circle-card{
        width: 22px ;
        height: 22px;
    }
    .circle-btn{
        cursor: pointer;
    }
    .table{
        font-size: 10px !important;
    }
    .highlight { background-color: yellow; }
    </style>
</head>
<body>
<elm:container tipo="horizontal" titulo="Dotaciones por estación">

    <table class="table table-striped table-hover table-bordered" style="margin-top: 15px;font-size: 12px">
        <thead>
        <tr>
            <th style="width: 50%">
                <div class="row" style="margin-top: 0px">
                    <div class="col-md-5">
                        <div class="input-group" >
                            <input type="text" class="form-control input-sm" id="txt-buscar" placeholder="Buscar">
                            <span class="input-group-addon svt-bg-primary " id="btn-buscar" style="cursor: pointer" >
                                <i class="fa fa-search " ></i>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <g:select name="sup" id="sup" class="form-control input-sm"
                                  noSelection="['':'Supervisor']" from="${supervisores}"
                                  optionKey="id" optionValue="nombre" value="${sup}"
                        />
                    </div>
                    <div class="col-md-1" style="text-align: left">
                        <a href="#" class="btn btn-primary btn-sm" id="reset" title="Resetear filtros"><i class="fa fa-refresh"></i></a>
                    </div>
                </div>
            </th>
            <th style="width: 40px">
                Solicitud<br/>
                enviada?
            </th>
            <th class="td-semaforo">
                Dotación de unfirmes<br>
                <div class="circle-card card-bg-green circle-btn equipo-green" title="Filtrar por color verde" mostrar="green-equipo"></div>
                <div class="circle-card svt-bg-warning circle-btn equipo-orange" title="Filtrar por color naranja" mostrar="orange-equipo"></div>
                <div class="circle-card svt-bg-danger circle-btn equipo-red" title="Filtrar por color rojo" mostrar="red-equipo"></div>
            </th>

            <th style="width: 40px">Ver</th>
            <th style="width: 40px">Empleados</th>
            <th style="width: 40px">Solicitar</th>
            <th style="width: 50px">Solicitudes</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${dash}" var="d" status="">

            <g:set var="colorUniforme" value="${d.getColorSemaforoUniforme()}"></g:set>
            <g:set var="enviada" value="${d.getSolEnivada()}"></g:set>

            <tr data-id="${d.estacion.codigo}" class=" tr-info   ${colorUniforme[1]} ">
                <td class="desc">${d.estacion}</td>
                <td class="" style="text-align: center;width: 40px">
                    <div class="circle-card ${enviada}" ></div>
                </td>
                <td class="td-semaforo" style="text-align: left">
                    <div class="circle-card ${colorUniforme[0]}" ></div>
                    ${d.ultimoUniforme?d.ultimoUniforme?.format("dd-MM-yyyy"):'N.A.'}
                </td>
                <td style="text-align: center">
                    <a href="${g.createLink(controller: 'uniformes',action: 'showEstacion',id: d.estacion.codigo)}" class="btn btn-primary btn-sm" title="Ver"><i class="fa fa-search"></i></a>
                </td>
                <td style="text-align: center">
                    <g:link action="empleados" id="${d.estacion.codigo}" class="btn btn-info btn-sm" title="Empleados">
                        <i class="fa fa-group"></i>
                    </g:link>
                </td>
                <td style="text-align: center">
                    <g:link action="solicitar" controller="solicitudes" id="${d.estacion.codigo}" class="btn btn-info btn-sm" title="Solicitar">
                        <i class="fa fa-file-archive-o"></i>
                    </g:link>
                </td>
                <td style="text-align: center">
                    <g:link action="listaSolicitudesEstacion" controller="solicitudes" id="${d.estacion.codigo}" class="btn btn-info btn-sm" title="Historial de solicitudes">
                        <i class="fa fa-folder"></i>
                    </g:link>
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
    function verEstacion(id) {
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'contratos', action:'show_ajax')}",
            data: {
                id: id
            },
            success: function (msg) {
                bootbox.dialog({
                    title: "Datos de la estación",
                    class:"modal-lg",
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
    function verEstacionMapa(id) {
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'estacion', action:'showMap_ajax')}",
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
    $("#sup").change(function(){
        location.href="${g.createLink(action: 'listaSemaforos')}/?sup="+$(this).val()
    })
</script>
</body>
</html>