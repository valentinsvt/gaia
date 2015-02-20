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
                Licencia<br>
                <div class="circle-card card-bg-green circle-btn licencia-green" title="Filtrar por color verde" mostrar="green-lic"></div>
                <div class="circle-card svt-bg-danger circle-btn licencia-red" title="Filtrar por color rojo" mostrar="red-lic"></div>
            </th>
            <th class="td-semaforo">
                Auditoría<br>
                <div class="circle-card card-bg-green circle-btn auditoria-green" title="Filtrar por color verde" mostrar="green-audt"></div>
                <div class="circle-card svt-bg-danger circle-btn auditoria-red" title="Filtrar por color rojo" mostrar="red-audt"></div>
            </th>
            <th class="td-semaforo">
                Monitoreo<br>
                <div class="circle-card card-bg-green circle-btn auditoria-green" title="Filtrar por color verde" mostrar="green-moni"></div>
                <div class="circle-card svt-bg-danger circle-btn auditoria-red" title="Filtrar por color rojo" mostrar="red-moni"></div>
            </th>
            <th class="td-semaforo">Doc. Soporte<br>
                <div class="circle-card card-bg-green circle-btn doc-green" title="Filtrar por color verde" mostrar="green-doc"></div>
                <div class="circle-card svt-bg-danger circle-btn doc-red" title="Filtrar por color rojo" mostrar="red-doc"></div>
            </th>

            <th>Ver</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${dash}" var="d" status="">
            <tr data-id="${d.estacion.codigo}" class=" tr-info ${d.monitoreo==1?'green-moni':'red-moni'} ${d.auditoria==1?'green-audt':'red-audt'} ${d.licencia==1?'green-lic':'red-lic'} ${d.docs==1?'green-doc':(d.docs==0)?'red-doc':'orange-doc'}">
                <td class="desc">${d.estacion}</td>
                <td class="td-semaforo">
                    <div class="circle-card ${d.licencia==1?'card-bg-green':'svt-bg-danger'}"></div>
                </td>
                <td class="td-semaforo">
                    <div class="circle-card ${d.auditoria==1?'card-bg-green':'svt-bg-danger'}"></div>
                </td>
                <td class="td-semaforo">
                    <div class="circle-card ${d.monitoreo==1?'card-bg-green':'svt-bg-danger'}"></div>
                </td>
                <td class="td-semaforo">
                    <div class="circle-card ${d.docs==1?'card-bg-green':(d.docs==0)?'svt-bg-danger':'svt-bg-warning'}"></div>
                </td>
                <td class="td-semaforo">
                    <a href="${g.createLink(controller: 'estacion',action: 'showEstacion',id: d.estacion.codigo)}" class="btn btn-primary btn-sm" title="Ver"><i class="fa fa-search"></i></a>
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