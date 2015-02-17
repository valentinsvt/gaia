<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 18/12/14
  Time: 11:59 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Gestión documental ambiental</title>
    <style type="text/css">
    .inicio img {
        height : 190px;
    }

    i {
        margin-right : 5px;
    }
    </style>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
</head>
<body>

<div class="row">
    <div class="card" style="width:273px;">
        <div class="titulo-card"><i class="fa fa-newspaper-o"></i>Licencia ambiental</div>
        <g:link controller="estacion" action="listaSemaforos" params="[search:'green-lic']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[colorLicencia]}">${licencia}</div>
                Estaciones con licencia
            </div>
        </g:link>
        <g:link controller="estacion" action="listaSemaforos" params="[search:'red-lic']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[colorLicencia]}">${tot-licencia}</div>
                Estaciones sin licencia
            </div>
        </g:link>
    </div>

    <div class="card" style="width: 318px">
        <div class="titulo-card"><i class="fa fa-server"></i> Documentos de soporte</div>
        <g:link controller="estacion" action="listaSemaforos" params="[search:'green-doc']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[colorDocs]}">${docs}</div>
                Estaciones con documentos de soporte
            </div>
        </g:link>
        <g:link controller="estacion" action="listaSemaforos" params="[search:'red-doc']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[colorDocs]}">${tot-docs}</div>
                Estaciones sin documentos de soporte
            </div>
        </g:link>
    </div>
    <div class="card" style="width:273px;">
        <div class="titulo-card"><i class="fa fa-newspaper-o"></i>Monitoreo vigente</div>
        <g:link controller="estacion" action="listaSemaforos" params="[search:'green-moni']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[colorMonitoreo]}">${monitoreo}</div>
                Estaciones con monitoreo
            </div>
        </g:link>
        <g:link controller="estacion" action="listaSemaforos" params="[search:'red-moni']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[colorMonitoreo]}">${tot-monitoreo}</div>
                Estaciones sin monitoreo
            </div>
        </g:link>
    </div>


</div>
<div class="row">
    <div class="card">
        <div class="titulo-card"><i class="fa fa-street-view"></i>Auditoría ambiental</div>
        <g:link controller="estacion" action="listaSemaforos" params="[search:'green-audt']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[colorAuditoria]}">${auditoria}</div>
                Estaciones con auditoría vigente
            </div>
        </g:link>
        <g:link controller="estacion" action="listaSemaforos" params="[search:'red-audt']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[colorAuditoria]}">${tot-auditoria}</div>
                Estaciones sin auditoría vigente
            </div>
        </g:link>
    </div>
    <div class="card">
        <div class="titulo-card"><i class="fa fa-server"></i> Documentación completa</div>

        <div class="cardContent">
            <div class="circle-card ${colores[colorOk]}">${ok}</div>
            Estaciones con documentación completa
        </div>
        <div class="cardContent">
            <div class="circle-card ${colores[colorOk]}">${tot-ok}</div>
            Estaciones sin documentación completa
        </div>
    </div>
    <div class="card" style="width: 272px">
        <div class="titulo-card"><i class="fa fa-warning"></i> Alertas</div>

        <div class="cardContent">
            <div class="circle-card ${alertas>0?colores[2]:colores[0]}">${alertas}</div>
            Pendientes
        </div>
    </div>
</div>
<div class="row">
    <div class="table-report" style="width: 617px">
        <div class="titulo-report"><i class="fa fa-sort-amount-asc"></i>Documentos por caducar</div>
        <div class="report-content">
            <table class="table table-striped table-hover table-bordered" style="border-top: none">
                <thead>
                <tr>
                    <th  style="width: 30%;text-align: left">Documento</th>
                    <th  style="width: 30%;text-align: left">Estación</th>
                    <th >Referecia</th>
                    <th >Caduca</th>
                </tr>
                </thead>
                <tbody>
                <g:if test="${documentos.size()>0}">
                    <g:each in="${documentos}" var="docu">
                        <tr>
                            <td>${docu.tipo.nombre}</td>
                            <td>${docu.estacion}</td>
                            <td>${docu.referencia}</td>
                            <td style="text-align: center">${docu.fin.format("dd-MM-yyyy")}</td>
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <tr>
                        <td colspan="4">No hay documentos por caducar</td>
                    </tr>
                </g:else>

                </tbody>
            </table>
        </div>
    </div>

</div>


</body>
</html>