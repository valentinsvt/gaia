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
    @-webkit-keyframes greenPulse {
        from { background-color: #ce464a; -webkit-box-shadow: 0 0 9px #333; }
        50% { background-color: #ce464a; -webkit-box-shadow: 0 0 18px #bd022f; }
        to { background-color: #ce464a; -webkit-box-shadow: 0 0 9px #333333; }
    }
    .svt-bg-danger {
        -webkit-animation-name: greenPulse;
        -webkit-animation-duration: 2s;
        -webkit-animation-iteration-count: infinite;
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
    <div class="card">
        <div class="titulo-card"><i class="fa fa-warning"></i> Alertas</div>

        <div class="cardContent">
            <div class="circle-card ${alertas>0?colores[2]:colores[0]}">${alertas}</div>
            Pendientes
        </div>
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

</div>
<div class="row">
    <div class="table-report">
        <div class="titulo-report"><i class="fa fa-sort-amount-asc"></i>Documentos por caducar</div>
        <div class="report-content">
            <table class="table table-striped table-hover table-bordered" style="border-top: none">
                <thead>
                <tr>
                    <th class="header-table-report" style="width: 30%;text-align: left">Documento</th>
                    <th class="header-table-report" style="width: 30%;text-align: left">Estación</th>
                    <th class="header-table-report">Referecia</th>
                    <th class="header-table-report">Caduca</th>
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
                        <td colspan="3">No hay documentos por caducar</td>
                    </tr>
                </g:else>

                </tbody>
            </table>
        </div>
    </div>

</div>


</body>
</html>