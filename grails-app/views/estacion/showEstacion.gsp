<%--
  Created by IntelliJ IDEA.
  User: svt
  Date: 06/02/2015
  Time: 18:52
--%>

<%@ page import="gaia.documentos.TipoDocumento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Estación ${estacion.nombre}</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">

    <imp:js src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"/>
    <imp:css src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.min.css')}"/>

    <style>
    .td-semaforo {
        text-align : center;
        width      : 110px;
    }

    .circle-card {
        width        : 40px;
        height       : 40px;
        margin-right : 30px;
    }

    .circle-btn {
        cursor : pointer;
    }

    .btn-header {

        margin-top : -30px;

    }

    .dibujo {
        width         : 100px;
        height        : 100px;
        border-radius : 5px;
        line-height   : 80px;
        display       : inline-block;
        margin        : 0;
        padding       : 10px;
    }

    .cardContent {
        width       : 57%;
        display     : inline-block;
        margin      : 0;
        height      : 100px;
        line-height : 80px;
        padding     : 10px;
        font-weight : bold;
        font-size   : 20px;
        text-align  : center;
    }
    </style>
</head>

<body>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <a href="#" class="btn btn-default detalles">
            <i class="fa fa-file-o"></i> Ver detalles
        </a>
        <a href="${g.createLink(controller: 'estacion', action: 'requerimientosEstacion', id: estacion.codigo)}" class="btn btn-default">
            <i class="fa fa-folder-open"></i> Documentación requerida
        </a>
        <a href="${g.createLink(controller: 'documento', action: 'arbolEstacion', params: [codigo: estacion.codigo])}" class="btn btn-default mapa">
            <i class="fa fa-file-pdf-o"></i> Visor de documentos
        </a>
        <g:if test="${session.tipo=='usuario'}">
            <g:link controller="estacion" action="documentosPorAprobar" class="btn btn-default" id="${estacion.codigo}">
                <i class="fa fa-check"></i> Documentos por aprobar <span class="badge" style="line-height: 100%;background: #CE464A">${docsN}</span>
            </g:link>
        </g:if>
        <a href="#" class="btn btn-default consultores">
            <i class="fa fa-users"></i> Consultores
        </a>
        <a href="#" class="btn btn-default supervisor">
            <i class="fa fa-user-plus"></i> Supervisor
        </a>
        <a href="${g.createLink(controller: 'estacion',action: 'calibracion',id:estacion.codigo)}" class="btn btn-default ">
            <i class="fa fa-gears"></i> Calibración diaria
        </a>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Estación: ${estacion.nombre}">
    <g:set var="licencia" value="${estacion.getColorLicencia()}"/>
    <g:set var="auditoria" value="${estacion.getColorAuditoria()}"/>
    <g:set var="docs" value="${estacion.getColorDocs()}"/>
    <g:set var="monitoreo" value="${estacion.getColorMonitoreoSinEstado()}"/>

    <div class="row" style="margin-top: 0">
        <div class="header-panel">
            <div class="header-item">
                <div class="titulo-card" style="text-align: left;padding-left: 15px">
                    Licencia
                </div>

                <div class="header-content">
                    <div class="circle-card ${licencia[0]}"></div>
                    <g:if test="${licencia[1]}">
                        <a href="${g.createLink(controller: 'licencia', action: 'verLicencia', id: estacion.codigo)}" class="btn btn-info btn-header btn-sm " style="display: inline-table">
                            <i class="fa fa-newspaper-o"></i> Ver
                        </a>
                        <a href="#" class="btn btn-info btn-header btn-sm " style="display: inline-table" id="nueva-lic">
                            <i class="fa fa-pencil"></i> Editar
                        </a>
                    </g:if>
                    <g:else>
                        <a href="${g.createLink(controller: 'licencia', action: 'registrarLicencia', id: estacion.codigo)}" class="btn btn-info btn-header btn-sm">
                            <i class="fa fa-newspaper-o"></i> Registrar
                        </a>
                    </g:else>
                </div>
            </div>

            <div class="header-item">
                <div class="titulo-card" style="text-align: left;padding-left: 15px">
                    Auditoría ambiental
                </div>

                <div class="header-content">
                    <div class="circle-card ${auditoria[0]}"></div>
                    <a href="#" class="btn btn-info btn-header btn-sm" id="detalles-audt">
                        <i class="fa fa-street-view"></i> Detalles
                    </a>
                </div>
            </div>

            <div class="header-item">
                <div class="titulo-card" style="text-align: left;padding-left: 15px">
                    Monitoreo
                </div>

                <div class="header-content">
                    <div class="circle-card ${(monitoreo[1])?(monitoreo[1].estado=='A'?'card-bg-green':'svt-bg-danger'):monitoreo[0]}"></div>
                    <g:if test="${monitoreo[1]}">
                        <a href="${g.createLink(controller: 'documento',action: 'ver',id: monitoreo[1].id)}" class="btn btn-info btn-header ">
                            <i class="fa fa-area-chart"></i> Ver
                        </a>
                    </g:if>
                    <g:else>
                        <a href="${g.createLink(controller: 'documento',action: 'subir',params: ['tipo':TipoDocumento.findByCodigo('TP12').id,id:estacion.codigo])}" class="btn btn-info btn-header btn-sm ">
                            <i class="fa fa-area-chart"></i> Registrar
                        </a>
                    </g:else>
                </div>
            </div>

            <div class="header-item">
                <div class="titulo-card" style="text-align: left;padding-left: 15px">
                    Documentos de soporte
                </div>

                <div class="header-content">
                    <div class="circle-card ${docs[0]}"></div>

                    <a href="${g.createLink(controller: 'estacion',action: 'requerimientosEstacion',id: estacion.codigo)}" class="btn btn-info btn-header ">
                        <i class="fa fa fa-server"></i> Ver
                    </a>

                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-1">
            <label>Filtrar por:</label>
        </div>

        <div class="col-md-3">
            <g:select name="tipos" from="${TipoDocumento.list([sort: 'nombre'])}" value="${params.td}"
                      noSelection="['': 'Todos los tipos de documento']" data-live-search="true"
                      optionKey="id" optionValue="nombre" class="form-control input-sm"/>
        </div>

        <div class="col-md-3">
            <div class="input-group">
                <input type="text" id="txt-buscar" class="form-control" placeholder="Referencia o Descripción"
                       value="${params.search}"/>
                <span class="input-group-btn">
                    <a href="#" class="btn btn-primary" type="button" id="btnBuscar">
                        <i class="fa fa-search "></i>
                    </a>
                </span>
            </div>
        </div>

        <div class="col-md-1">
            <a href="${g.createLink(controller: 'documento', action: 'subir', id: estacion.codigo)}"
               id="btn-subir" class="btn btn-info">
                <i class="fa fa-upload"></i> Registrar nuevo documento
            </a>
        </div>
    </div>

    <div class="row" style="height: 400px;overflow-y: auto;width: 82%">
        <table class="table table-striped table-hover table-bordered" style="font-size: 11px">
            <thead>
            <tr>
                <th>Tipo</th>
                <th>Referencia</th>
                <th>Descripción</th>
                <th style="width: 100px">Registro</th>
                <th style="width: 100px">Vence</th>
                <th style="width:60px;">Ver</th>
            </tr>
            </thead>
            <tbody>
            <g:if test="${documentos.size() > 0}">
                <g:each in="${documentos}" var="docu">
                    <tr class="tr-info ${docu.tipo.id}">
                        <td>${docu.tipo.nombre}</td>
                        <td>
                            <elm:textoBusqueda busca="${params.search}">
                                ${docu.referencia}
                            </elm:textoBusqueda>
                        </td>
                        <td>
                            <elm:textoBusqueda busca="${params.search}">
                                ${docu.descripcion}
                            </elm:textoBusqueda>
                        </td>
                        <td style="width: 100px;text-align: center">${docu.fechaRegistro.format("dd-MM-yyyy")}</td>
                        <td style="width: 100px;text-align: center">${docu.fin?.format("dd-MM-yyyy")}</td>
                        <td>
                            <g:link controller="documento" action="arbolEstacion" id="${docu.id}"
                                    class="btn btn-primary btn-sm">
                                <i class="fa fa-search"></i>
                            </g:link>
                        </td>
                    </tr>
                </g:each>
            </g:if>
            <g:else>
                <tr>
                    <td colspan="5">
                        No hay documentos registrados
                    </td>
                </tr>
            </g:else>
            </tbody>
        </table>
    </div>
</elm:container>
<elm:modal id="modal-lic" titulo="Licencia ambiental">
    <div class="modal-body">

        <div class="card" style="width:260px;height: 120px;min-height: 120px">
            <a href="#" id="nueva">
                <div class="cardContent">
                    Crear Nueva
                </div>

                <div class="dibujo">
                    <img src="${g.resource(dir: 'images', file: 'documents7.png')}" style="width: 100%">
                </div>
            </a>
        </div>

        <div class="card" style="width:260px;height: 120px;min-height: 120px">
            <g:link controller="licencia" action="registrarLicencia" id="${estacion.codigo}" style="text-decoration: none">
                <div class="cardContent">
                    Editar
                </div>

                <div class="dibujo">
                    <img src="${g.resource(dir: 'images', file: 'open131.png')}" style="width: 100%">
                </div>
            </g:link>
        </div>

    </div>
</elm:modal>
<script type="text/javascript">
    function verConsultores(id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'estacion', action:'consultores_ajax')}",
            data    : {
                codigo : id
            },
            success : function (msg) {
                bootbox.dialog({
                    title   : "Consultores",
                    message : msg,
                    class   : "modal-lg",
                    buttons : {
                        ok : {
                            label     : "Aceptar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        });
    }
    function warning() {
        var msg = "La estación ${estacion.nombre} ya tiene una licencia ambiental vigente, si decide continuar dicha licencia será anulada. Continuar? <span style='color:red'>Está acción no puede ser revertida.</span>"
        bootbox.confirm({
            message  : msg,
            title    : "Atención",
            class    : "modal-error",
            callback : function (res) {
                if (res) {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:'licencia', action:'crearNueva',id: estacion.codigo)}",
                        data    : {
                            id : "${estacion.codigo}"
                        },
                        success : function (msg) {
                            location = "${createLink(controller:'licencia', action:'registrarLicencia',id: estacion.codigo)}"
                        }
                    });
                }
            }
        })
    }
    function verInspectores(id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'estacion', action:'inspectores_ajax')}",
            data    : {
                codigo : id
            },
            success : function (msg) {
                bootbox.dialog({
                    title   : "Supervisores",
                    message : msg,
                    class   : "modal-lg",
                    buttons : {
                        ok : {
                            label     : "Aceptar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        });
    }
    function verEstacion(id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'estacion', action:'show_ajax')}",
            data    : {
                id : id
            },
            success : function (msg) {
                bootbox.dialog({
                    title   : "Datos de la estación",
                    message : msg,
                    buttons : {
                        ok : {
                            label     : "Aceptar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        });
    }
    function verProcesos() {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'auditoriaAmbiental', action:'showProcesos',id:estacion.codigo)}",
            data    : "",
            success : function (msg) {
                bootbox.dialog({
                    title   : "Procesos de auditoría ambiental",
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        ok : {
                            label     : "Aceptar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        });
    }

    function buscar() {
        openLoader();
        var td = $("#tipos").val();
        var search = $.trim($("#txt-buscar").val());
        var prms = "";
        if (td != "") {
            prms += "td=" + td;
        }
        if (search != "") {
            if (prms != "") {
                prms += "&";
            }
            prms += "search=" + search;
        }
        if (prms != "") {
            prms = "?" + prms;
        }
        location.href = "${createLink(controller: 'estacion', action:'showEstacion')}/${estacion.codigo}" + prms;
    }
    $(function () {
        $("#tipos").selectpicker().change(function () {
            buscar();
        });
        $("#btnBuscar").click(function () {
            buscar();
            return false;
        });
        $(".detalles").click(function () {
            verEstacion("${estacion.codigo}");
            return false;
        });
        $(".consultores").click(function () {
            verConsultores("${estacion.codigo}");
            return false;
        });
        $(".supervisor").click(function () {
            verInspectores("${estacion.codigo}");
            return false;
        });

        $("#nueva-lic").click(function () {
            $("#modal-lic").modal("show");
            return false;
        });
        $("#nueva").click(function () {
            warning()
        })
        $("#detalles-audt").click(function(){
            verProcesos();
        })
    });
</script>
</body>
</html>