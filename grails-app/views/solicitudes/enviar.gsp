<%@ page import="gaia.uniformes.Kit" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Solicitudes de dotación de uniforme</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <style type="text/css">
    label{
        padding-top: 5px;
    }
    .alert{
        padding-bottom: 4px !important;
    }
    .header-flow-item{
        width: 33%;
    }
    </style>
</head>
<body>
<div class="pdf-viewer">
    <div class="pdf-content" >
        <div class="pdf-container" id="doc"></div>
        <div class="pdf-handler" >
            <i class="fa fa-arrow-right"></i>
        </div>
        <div class="pdf-header" id="data">
            N. Referencia: <span id="referencia-pdf" class="data"></span>
            Código: <span id="codigo" class="data"></span>
            Tipo: <span id="tipo" class="data"></span>



        </div>
        <div id="msgNoPDF">
            <p>No tiene configurado el plugin de lectura de PDF en este navegador.</p>

            <p>
                Puede
                <a class="text-info" target="_blank" style="color: white" href="http://get.adobe.com/es/reader/">
                    <u>descargar Adobe Reader aquí</u>
                </a>
            </p>
        </div>
    </div>
</div>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <a href="${g.createLink(controller: 'uniformes',action: 'listaSemaforos')}" class="btn btn-default ">
            Estaciónes
        </a>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Estación: ${estacion.nombre}" >
    <div class="panel panel-info" style="margin-top: 20px">
        <div class="panel-heading">Solcitar dotación de uniformes</div>
        <div class="panel-body" style="padding:0px">
            <div class="header-flow">
                <g:link action="solicitar" id="${estacion.codigo}">
                    <div class="header-flow-item before">
                        <span class="badge before">1</span> Requisitos previos
                        <span class="arrow"></span>
                    </div>
                </g:link>
                <g:link action="detalle" params="[id:estacion.codigo,pedido:sol?.id]" >
                    <div class="header-flow-item before">
                        <span class="badge before">2</span>
                        Detalle
                        <span class="arrow"></span>
                    </div>
                </g:link>
                <div class="header-flow-item active">
                    <span class="badge active">3</span>
                    Enviar
                    <span class="arrow"></span>
                </div>
            </div>
            <div class="flow-body">

                <div class="row">
                    <div class="col-md-1">
                        <label>Observaciones: </label>
                    </div>
                    <div class="col-md-9">
                        <input type="text" id="obs" value="${sol?.observaciones}" class="form-control input-sm">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-10">

                        <g:if test="${detalle.size()>0}">
                            <table class="table table-striped table-bordered">
                                <thead>
                                <tr>
                                    <th colspan="7">
                                        Detalle del pedido
                                    </th>
                                </tr>
                                <tr>
                                    <th>Cédula</th>
                                    <th>Nombre</th>
                                    <th>Sexo</th>
                                    <th>Kit</th>
                                </tr>
                                </thead>
                                <tbody>
                                <g:each in="${detalle}" var="d">
                                    <tr>
                                        <td>${d.empleado.cedula}</td>
                                        <td>${d.empleado.nombre}</td>
                                        <td style="text-align: center">${d.empleado.sexo}</td>
                                        <td>
                                            ${d.kit.nombre}
                                        </td>
                                    </tr>
                                </g:each>
                                </tbody>
                            </table>
                        </g:if>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1">
                        <a href="#" class="btn btn-success" id="Guardar">
                            <i class="fa fa-save"></i>   Guardar y enviar
                        </a>
                    </div>
                </div>

            </div>
        </div>
    </div>
</elm:container>
<script type="text/javascript">
    function verKit(id) {
        openLoader()
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'solicitudes', action:'verKit')}",
            data: {
                id: id
            },
            success: function (msg) {
                closeLoader()
                bootbox.dialog({
                    title: "Detalle del kit",
                    message: msg,
                    buttons: {
                        ok: {
                            label: "Cerrar",
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
    $(".ver").click(function(){
        var id = $(""+$(this).attr("kit")).val()
        verKit(id)
    })
    $("#guardar").click(function(){

    });
</script>
</body>
</html>