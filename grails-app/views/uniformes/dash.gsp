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
        <div class="titulo-card"><i class="fa fa-shopping-cart"></i> Dotación de uniformes</div>
        <g:link controller="uniformes" action="listaSemaforos" params="[search:'green-equipo']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[0]}">${equipo}</div>
                Estaciones con dotación vigente
            </div>
        </g:link>
        <g:link controller="uniformes" action="listaSemaforos" params="[search:'orange-equipo']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[1]}">${equipoWarning}</div>
                Estaciones con dotación por caducar
            </div>
        </g:link>
        <g:link controller="uniformes" action="listaSemaforos" params="[search:'red-equipo']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card svt-bg-danger">${total-(equipo+equipoWarning)}</div>
                Estaciones sin dotación vigente
            </div>
        </g:link>
    </div>

</div>




</body>
</html>