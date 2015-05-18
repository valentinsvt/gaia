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
                <div class="header-flow-item active">
                    <span class="badge active">2</span>
                    Detalle
                    <span class="arrow"></span>
                </div>
                <div class="header-flow-item disabled">
                    <span class="badge disabled">3</span>
                    Enviar
                    <span class="arrow"></span>
                </div>
            </div>
            <div class="flow-body">
                <g:form class="frmPedido" action="guardarSolicitud">
                    <input type="hidden" name="id" value="${solicitud?.id}">
                    <input type="hidden" name="estacion" value="${estacion.codigo}">
                    <input type="hidden" name="data" value="" id="datos">
                    <elm:message tipo="info" clase="">
                        Seleccione el tipo de Kit para cada empleado y cuando haya finalizado de un clic en el botón guardar
                    </elm:message>
                    <div class="row">
                        <div class="col-md-2">
                            <label>Periodo de dotación: </label>
                        </div>
                        <div class="col-md-3">
                            <g:select name="periodo" from="${gaia.Contratos.esicc.PeriodoDotacion.list([sort: 'codigo',order: 'desc'])}"
                                      optionKey="codigo" optionValue="descripcion" class="form-control input-sm periodo"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10">

                            <g:if test="${nomina.size()>0}">
                                <table class="table table-striped table-bordered">
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
                                        <th>Kit</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <g:each in="${nomina}" var="emp">
                                        <tr>
                                            <td>${emp.cedula}</td>
                                            <td>${emp.nombre}</td>
                                            <td style="text-align: center">${emp.sexo}</td>
                                            <td style="width: 300px">
                                                <div class="input-group">
                                                    <g:select name="kit" from="${Kit.findAllByGenero(emp.sexo)}" optionKey="id" emp="${emp.id}"
                                                              optionValue="nombre" class="form-control kit input-sm" id="cmb_${emp.id}"/>
                                                    <span class="input-group-addon ver" style="cursor: pointer" kit="#cmb_${emp.id}"  id="basic-addon2">
                                                        <i class="fa fa-search"></i> Ver kit
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                    </g:each>
                                    </tbody>
                                </table>
                            </g:if>
                        </div>
                    </div>
                    <g:if test="${!errores}">
                        <div class="row">
                            <div class="col-md-1">
                                <a href="#" class="btn btn-success" id="guardar">
                                    <i class="fa fa-save"></i>   Guardar
                                </a>
                            </div>
                        </div>
                    </g:if>
                </g:form>
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
        var data = ""
        $(".kit").each(function(){
            data+=$(this).attr("emp")+";"+$(this).val()+"W"
        })
        $("#datos").val(data)
        $(".frmPedido").submit()
    });
</script>
</body>
</html>