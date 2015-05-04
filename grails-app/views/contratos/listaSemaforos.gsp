<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Estado documentación por estación</title>
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
<elm:container tipo="horizontal" titulo="Estado de la documentación por estación">

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
                        Estación
                    </div>
                    <div class="col-md-3 col-md-offset-2">
                        <a href="#" class="btn btn-primary btn-sm" id="reset"><i class="fa fa-refresh"></i> Resetear filtros</a>
                    </div>
                </div>
            </th>
            <th class="td-semaforo">
                <br>
                Contrato<br>
                <div class="circle-card card-bg-green circle-btn licencia-green" title="Filtrar por color verde" mostrar="green-contrato"></div>
                <div class="circle-card svt-bg-warning circle-btn licencia-orange" title="Filtrar por color naranja" mostrar="orange-contrato"></div>
                <div class="circle-card svt-bg-danger circle-btn licencia-red" title="Filtrar por color rojo" mostrar="red-contrato"></div>
            </th>
            <th class="td-semaforo">
                Dotación de unfirmes<br>
                <div class="circle-card card-bg-green circle-btn equipo-green" title="Filtrar por color verde" mostrar="green-equipo"></div>
                <div class="circle-card svt-bg-warning circle-btn equipo-orange" title="Filtrar por color naranja" mostrar="orange-equipo"></div>
                <div class="circle-card svt-bg-danger circle-btn equipo-red" title="Filtrar por color rojo" mostrar="red-equipo"></div>
            </th>
            <th class="td-semaforo">
                Pintura y mantenimiento<br>
                <div class="circle-card card-bg-green circle-btn pintura-green" title="Filtrar por color verde" mostrar="green-pintura"></div>
                <div class="circle-card svt-bg-warning circle-btn pintura-orange" title="Filtrar por color naranja" mostrar="orange-pintura"></div>
                <div class="circle-card svt-bg-danger circle-btn pintura-red" title="Filtrar por color rojo" mostrar="red-pintura"></div>
            </th>
            <th>Ver</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${dash}" var="d" status="">
            <g:set var="color" value="${d.getColorSemaforoContrato(check)}"></g:set>
            <g:set var="colorUniforme" value="${d.getColorSemaforoUniforme()}"></g:set>
            <g:set var="colorPintura" value="${d.getColorSemaforoPintura()}"></g:set>
            <tr data-id="${d.estacion.codigo}" class=" tr-info  ${color[1]} ${colorPintura[1]}  ${colorUniforme[1]} ">
                <td class="desc">${d.estacion}</td>
                <td class="td-semaforo" style="text-align: left">
                    <div class="circle-card ${color[0]}" ></div>
                    ${d.ultimoContrato?d.ultimoContrato?.format("dd-MM-yyyy"):'N.A.'}
                </td>
                <td class="td-semaforo" style="text-align: left">
                    <div class="circle-card ${colorUniforme[0]}" ></div>
                    ${d.ultimoUniforme?d.ultimoUniforme?.format("dd-MM-yyyy"):'N.A.'}
                </td>
                <td class="td-semaforo" style="text-align: left">
                    <div class="circle-card ${colorPintura[0]}" ></div>
                    ${d.ultimaPintura?d.ultimaPintura?.format("dd-MM-yyyy"):'N.A.'}
                </td>
                <td class="td-semaforo">
                    <a href="${g.createLink(controller: 'contratos',action: 'showEstacion',id: d.estacion.codigo)}" class="btn btn-primary btn-sm" title="Ver"><i class="fa fa-search"></i></a>
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
</script>
</body>
</html>