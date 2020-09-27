<%@ page contentType="text/html;charset=UTF-8" %>
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
        <div class="panel-heading">Solicitar dotación de uniformes</div>
        <div class="panel-body" style="padding:0px">
            <div class="header-flow">
                <div class="header-flow-item active">
                    <span class="badge active">1</span> Requisitos previos
                    <span class="arrow"></span>
                </div>
                <div class="header-flow-item disabled">
                    <span class="badge disabled">2</span>
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
                <g:if test="${errores}">
                    <elm:message tipo="error" clase="">
                        <ul style="margin-top: -20px;margin-left: 10px">
                            <h3>Errores</h3>
                            <g:if test="${!certificado}">
                                <li>
                                    La estación no cuenta con un certificado del IESS. Para continuar con el proceso registre
                                    un certificado actualizado.
                                </li>
                            </g:if>
                            <g:if test="${nomina.size()==0}">
                                <li>
                                    La estación no tiene empleados registrados. Para continuar ingrese la nómina de la estación y las tallas de sus empleados.
                                </li>
                            </g:if>
                            <g:if test="${erroresTalla!=''}">
                                <li>${erroresTalla}</li>
                            </g:if>
                        </ul>
                        <p style="margin-top: 10px;font-weight: bold">
                            Por favor, antes de continuar con la solicitud corrija los errores detallados previamente
                            <a href="${g.createLink(controller: 'uniformes',action: 'empleados',id: estacion.codigo)}"
                               class="btn btn-danger btn-sm">
                                <i class="fa fa-warning" style="margin-right: 6px"></i> Aquí</a>
                        </p>
                    </elm:message>
                </g:if>
                <g:else>
                    <elm:message tipo="info" clase="">
                        Por favor, revise el certificado del IESS y la lista de empleados.
                        Si es necesario actualizar la información hágalo
                        <a href="${g.createLink(controller: 'uniformes',action: 'empleados',id: estacion.codigo)}"
                           class="btn btn-warning btn-sm">
                            <i class="fa fa-warning" style="margin-right: 6px"></i> Aquí</a>
                    </elm:message>
                </g:else>
                <div class="row">
                    <div class="col-md-2">
                        <label>Cerfiticado IESS</label>
                    </div>
                    <g:if test="${certificado}">
                        <div class="col-md-2">
                            <a href="#" data-file="${certificado?.path}"
                               data-ref="Certificado del IESS"
                               data-codigo=""
                               data-tipo="Certificado del IESS"
                               target="_blank" class="btn btn-info ver-doc btn-sm" title="${certificado?.path}" >
                                <i class="fa fa-search"></i> Ver
                            </a>
                            <g:link controller="uniformes" action="empleados" id="${estacion.codigo}" class="btn btn-info cambiar btn-sm" iden="tdr">
                                <i class="fa fa-refresh"></i> Actualizar
                            </g:link>
                        </div>
                    </g:if>
                    <g:else>
                        <a href="${g.createLink(controller: 'uniformes',action: 'empleados',id: estacion.codigo)}"
                           class="btn btn-warning btn-sm">
                            <i class="fa fa-warning" style="margin-right: 6px"></i> Registrar</a>
                    </g:else>
                </div>
                <div class="row">
                    <div class="col-md-8">
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
                                </tr>
                                </thead>
                                <tbody>
                                <g:each in="${nomina}" var="emp">
                                    <tr>
                                        <td>${emp.cedula}</td>
                                        <td>${emp.nombre}</td>
                                        <td style="text-align: center">${emp.sexo}</td>
                                    </tr>
                                </g:each>
                                </tbody>
                            </table>
                        </g:if>
                    </div>
                </div>
                <g:if test="${!errores}">
                    <div class="row">
                        <div class="col-md-4">
                            <label>Si todos los datos son correctos, haga clic en:</label>
                            <g:link controller="solicitudes" action="detalle" id="${estacion.codigo}" class="btn btn-success">
                                Continuar <i class="fa fa-arrow-right"></i>
                            </g:link>
                        </div>
                    </div>
                </g:if>
            </div>
        </div>
    </div>
</elm:container>
<script type="text/javascript">
    function showPdf(div){
        $("#msgNoPDF").show();
        $("#doc").html("")
        var pathFile = div.data("file")
        $("#referencia-pdf").html(div.data("ref"))
        $("#codigo").html(div.data("codigo"))
        $("#tipo").html(div.data("tipo"))
        var path = "${resource()}/" + pathFile;
        var myPDF = new PDFObject({
            url           : path,
            pdfOpenParams : {
                navpanes: 1,
                statusbar: 0,
                view: "FitW"
            }
        }).embed("doc");
        $(".pdf-viewer").show("slide",{direction:'right'})
        $("#data").show()
    }
    $(".ver-doc").click(function(){
        showPdf($(this))
        return false
    })
    $(".pdf-handler").click(function(){
        $(".pdf-viewer").hide("slide",{direction:'right'})
        $("#data").hide()
    })
</script>
</body>
</html>