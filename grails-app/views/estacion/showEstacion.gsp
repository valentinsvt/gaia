<%--
  Created by IntelliJ IDEA.
  User: svt
  Date: 06/02/2015
  Time: 18:52
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Estación ${estacion.nombre}</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <style>
    .td-semaforo{
        text-align: center;
        width: 110px;
    }
    .circle-card{
        width: 40px ;
        height: 40px;
        margin-right: 60px;
    }
    .circle-btn{
        cursor: pointer;
    }
    .btn-header{

        margin-top: -30px;

    }
    .dibujo{
        width: 100px;
        height: 100px;
        border-radius: 5px;
        line-height: 80px;
        display: inline-block;
        margin: 0px;
        padding: 10px;
    }
    .cardContent{
        width: 57%;
        display: inline-block;
        margin: 0px;
        height: 100px;
        line-height:80px;
        padding: 10px;
        font-weight: bold;
        font-size: 20px;
        text-align: center;
    }
    </style>
</head>
<body>
<elm:container tipo="horizontal" titulo="Estación: ${estacion.nombre}" >
    <g:set var="licencia" value="${estacion.getColorLicencia()}"></g:set>
    <g:set var="auditoria" value="${estacion.getColorAuditoria()}"></g:set>
    <g:set var="docs" value="${estacion.getColorDocs()}"></g:set>
    <div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0px;margin-left: -20px">
        <div class="btn-group">
            <a href="#" class="btn btn-default detalles">
                <i class="fa fa-file-o"></i> Ver detalles
            </a>
            <a href="#" class="btn btn-default mapa">
                <i class="fa fa-globe"></i> Ubicar en el mapa
            </a>
            <a href="${g.createLink(controller: 'documento',action: 'arbolEstacion',params: [codigo:estacion.codigo])}" class="btn btn-default mapa">
                <i class="fa fa-file-pdf-o"></i> Visor de documentos
            </a>
            <a href="${g.createLink(controller: 'estacion',action: 'consultores',params: [codigo:estacion.codigo])}" class="btn btn-default mapa">
                <i class="fa fa-file-pdf-o"></i> Consultores
            </a>
        </div>
    </div>
    <div class="row" style="margin-top: 0px">
        <div class="header-panel">
            <div class="header-item">
                <div class="titulo-card" style="text-align: left;padding-left: 15px">
                    Licencia
                </div>
                <div class="header-content">
                    <div class="circle-card ${licencia[0]}" ></div>
                    <g:if test="${licencia[1]}">
                        <a href="#" class="btn btn-primary btn-header "><i class="fa fa-newspaper-o"></i> Ver</a>
                    </g:if>
                    <g:else>
                        <a href="#" class="btn btn-info btn-header " id="nueva-lic"><i class="fa fa-newspaper-o"></i> Registrar</a>
                    </g:else>
                </div>
            </div>
            <div class="header-item">
                <div class="titulo-card" style="text-align: left;padding-left: 15px">
                    Auditoría ambiental
                </div>
                <div class="header-content">
                    <div class="circle-card ${auditoria[0]}" ></div>
                    <g:if test="${auditoria[1]}">
                        <a href="#" class="btn btn-primary btn-header "><i class="fa fa-street-view"></i> Ver</a>
                    </g:if>
                    <g:else>
                        <a href="#" class="btn btn-info btn-header "><i class="fa fa-street-view"></i> Registrar</a>
                    </g:else>
                </div>
            </div>
            <div class="header-item">
                <div class="titulo-card" style="text-align: left;padding-left: 15px">
                    Documentos de soporte
                </div>
                <div class="header-content">
                    <div class="circle-card ${docs[0]}" ></div>
                    <g:if test="${docs[1]}">
                        <a href="#" class="btn btn-primary btn-header "><i class="fa fa fa-server"></i> Ver</a>
                    </g:if>
                    <g:else>
                        <a href="#" class="btn btn-info btn-header "><i class="fa fa fa-server"></i> Registrar</a>
                    </g:else>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-1">
            <label>Filtrar por:</label>
        </div>
        <div class="col-md-3">
            <g:select name="tipos" from="${tipos}"
                      optionKey="key" optionValue="value" class="form-control input-sm"/>
        </div>
        <div class="col-md-3">
            <div class="input-group" >
                <input type="text" class="form-control input-sm" id="txt-buscar" placeholder="Buscar">
                <span class="input-group-addon svt-bg-primary " id="btn-buscar" style="cursor: pointer" >
                    <i class="fa fa-search " ></i>
                </span>
            </div>
        </div>

        <div class="col-md-1">
            <a href="${g.createLink(controller: 'documento',action: 'subir',id: estacion.codigo)}" id="btn-subir" class="btn btn-info"><i class="fa fa-upload"></i> Registrar nuevo documento</a>
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
            </tr>
            </thead>
            <tbody>
            <g:if test="${documentos.size()>0}">
                <g:each in="${documentos}" var="docu">
                    <tr class="tr-info ${docu.tipo.id}">
                        <td>${docu.tipo.nombre}</td>
                        <td>${docu.referencia}</td>
                        <td>${docu.descripcion}</td>
                        <td  style="width: 100px;text-align: center">${docu.fechaRegistro.format("dd-MM-yyyy")}</td>
                        <td  style="width: 100px;text-align: center">${docu.fin?.format("dd-MM-yyyy")}</td>

                    </tr>
                </g:each>
            </g:if>
            <g:else>
                <tr>
                    <td colspan="4">
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
            <g:link controller="licencia" action="registrarLicencia" id="${estacion.codigo}" style="text-decoration: none">
                <div class="cardContent">
                    Nueva
                </div>
                <div class="dibujo">
                    <img src="${g.resource(dir: 'images',file: 'documents7.png')}" style="width: 100%">
                </div>
            </g:link>
        </div>
        <div class="card" style="width:260px;height: 120px;min-height: 120px">
            <g:link controller="licencia" action="registrarExistente" id="${estacion.codigo}" style="text-decoration: none">
                <div class="cardContent">
                    Existente
                </div>
                <div class="dibujo">
                    <img src="${g.resource(dir: 'images',file: 'open131.png')}" style="width: 100%">
                </div>
            </g:link>
        </div>

    </div>
</elm:modal>
<script type="text/javascript">
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
        $(".detalles").click(function(){
            verEstacion("${estacion.codigo}");
        })

        $("#nueva-lic").click(function(){
            $("#modal-lic").modal("show")
        })
    });
</script>
</body>
</html>