<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Detalle de la solicitud #${sol.id}</title>
    <meta name="layout" content="main"/>
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <style>
    .alert{
        padding-bottom: 4px !important;
    }
    </style>
</head>
<body>
<div class="btn-toolbar toolbar" style="margin-top: 0px;margin-bottom: 10;margin-left: -20px">
    <div class="btn-group">
        <g:link controller="uniformes" action="listaSemaforos" class="btn btn-default">
            <i class="fa fa-list"></i> Estaciones
        </g:link>
        <g:link controller="solicitudes" action="listaSolicitudesEstacion" id="${sol.estacion.codigo}" class="btn btn-default">
            <i class="fa fa-folder"></i> Solicitudes
        </g:link>
        <g:if test="${sol.estado=='A'}">
            <a href="#" id="imprimir" class="btn btn-default">
                <i class="fa fa-print"></i> Imprimir
            </a>
            <a href="#" id="imprimirActa" class="btn btn-default">
                <i class="fa fa-print"></i> Imprimir acta
            </a>
        </g:if>
    </div>
</div>
<elm:container  titulo="Detalle de la solicitud #${sol.id}">
    <div class="row">
        <div class="col-md-1">
            <label>Fecha</label>
        </div>
        <div class="col-md-2">
            ${sol.registro?.format("dd-MM-yyyy")}
        </div>
        <div class="col-md-2">
            <label>Periodo de dotación</label>
        </div>
        <div class="col-md-2">
            ${sol.periodo.descripcion}
        </div>
    </div>
    <div class="row">
        <div class="col-md-1">
            <label>Supervisor</label>
        </div>
        <div class="col-md-2">
            ${sol.supervisor.nombre}
        </div>
        <div class="col-md-2">
            <label>Estación</label>
        </div>
        <div class="col-md-5">
            ${sol.estacion}
        </div>
    </div>
    <div class="row">
        <div class="col-md-1">
            <label>Estado</label>
        </div>
        <div class="col-md-2">
            <g:if test="${sol.estado=='A'}">
                <i class="fa fa-check" style="color:#008000"></i>
                Aprobado
            </g:if>
            <g:if test="${sol.estado=='N'}">
                <i class="fa fa-times" style="color:red"></i>
                Negado
            </g:if>
            <g:if test="${sol.estado=='S'}">
                Pendiente de aprobación
            </g:if>
            <g:if test="${sol.estado=='P'}">
                Pendiente de envío
            </g:if>
        </div>
        <div class="col-md-2">
            <label>Número de operadores</label>
        </div>
        <div class="col-md-1">
            ${gaia.uniformes.NominaEstacion.countByEstacionAndEstado(sol.estacion,"A")} <i class="fa fa-user"></i>
        </div>
    </div>

    <div class="row">
        <div class="col-md-10">
            <table class="table table-striped  table-bordered">
                <thead>
                <tr class="cabecera">
                    <th colspan="9">
                        Detalle del pedido
                    </th>
                </tr>
                <tr class="tbody">
                    <th>#</th>
                    <th>Cédula</th>
                    <th>Nombre</th>
                    <th>Sexo</th>
                    <th>Uniforme</th>
                    <th>Talla</th>
                    <th>Cantidad</th>
                    <th>P. Unitario</th>
                    <th>Total</th>
                </tr>
                </thead>
                <tbody class="tbody">
                <g:set var="total" value="${0}"></g:set>
                <g:each in="${subdetalle}" var="s" status="i">
                    <tr>
                        <td style="text-align: center">${i+1}</td>
                        <td>${s.empleado.cedula}</td>
                        <td>${s.empleado.nombre}</td>
                        <td>${s.empleado.sexo}</td>
                        <td style="font-size: 11px">${s.uniforme.descripcion}</td>
                        <td>${s.talla.talla}</td>
                        <td style="text-align: right">${s.cantidad}</td>
                        <td style="text-align: right">
                            <g:formatNumber number="${s.precio}" type="currency" currencySymbol="\$"/>
                        </td>
                        <td style="text-align: right">
                            <g:set var="total" value="${total+=s.cantidad*s.precio}"></g:set>
                            <g:formatNumber number="${s.cantidad*s.precio}" type="currency" currencySymbol="\$"/>
                        </td>
                    </tr>
                </g:each>
                </tbody>
                <tfoot>
                <tr>
                    <td colspan="8" style="font-weight: bold">TOTAL</td>
                    <td style="text-align: right;font-weight: bold">
                        <g:formatNumber number="${total}" type="currency" currencySymbol="\$"/>
                    </td>
                </tr>
                </tfoot>
            </table>
        </div>
    </div>

</elm:container>
<script type="text/javascript">
    $("#imprimir").click(function(){
        var url = "${createLink(controller: 'reportesDotacion',action: 'imprimeSolicitud',id: sol.id)}" ;
        location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
    })
    $("#imprimirActa").click(function(){
        var url = "${createLink(controller: 'reportesDotacion',action: 'imprimeActa',id: sol.id)}" ;
        location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
    })
</script>
</body>
</html>