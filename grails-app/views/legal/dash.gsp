<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>P&S</title>
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
    <div class="card" style="width:310px;">
        <div class="titulo-card"><i class="fa fa-newspaper-o"></i>Contratos</div>
        <g:link controller="legal" action="listaSemaforos" params="[search:'green-contrato']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[0]}">${contrato}</div>
                Estaciones con contrato vigente
            </div>
        </g:link>
        <g:link controller="legal" action="listaSemaforos" params="[search:'orange-contrato']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[1]}">${contratoWarning}</div>
                Estaciones con contratos por caducar
            </div>
        </g:link>
        <g:link controller="legal" action="listaSemaforos" params="[search:'red-contrato']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card svt-bg-danger">${total-(contrato+contratoWarning)}</div>
                Estaciones sin contrato vigente
            </div>
        </g:link>
    </div>

</div>




</body>
</html>