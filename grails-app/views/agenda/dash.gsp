<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>PYS Agenda</title>
    <style type="text/css">
    .inicio img {
        height : 190px;
    }

    i {
        margin-right : 5px;
    }
    .circle-card{
        margin-right: 30px !important;
    }
    </style>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
</head>
<body>

<div class="row">
    <div class="card" style="width:273px;">
        <div class="titulo-card" style="font-size: 22px"><i class="fa flaticon-car24"></i> Estaciones de servicio</div>
        <g:link controller="agenda" action="listaEstacion" params="[search:'A']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[0]}">${activas}</div>
                Activas
            </div>
        </g:link>
        <g:link controller="agenda" action="listaEstacion" params="[search:'S']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[1]}">${suspendidas}</div>
                Suspendidas
            </div>
        </g:link>
        <g:link controller="agenda" action="listaEstacion" params="[search:'C']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[2]}">${cesantes}</div>
                Cesantes
            </div>
        </g:link>
    </div>
    <div class="card" style="width:273px;">
        <div class="titulo-card" style="font-size: 22px">
            <i class="fa flaticon-worker5"></i > Industrias
        </div>
        <g:link controller="agenda" action="listaIndustrias" params="[search:'A']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[0]}" >${activasI}</div>
                Activas
            </div>
        </g:link>
        <g:link controller="agenda" action="listaIndustrias" params="[search:'S']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[1]}">${suspendidasI}</div>
                Suspendidas
            </div>
        </g:link>
        <g:link controller="agenda" action="listaIndustrias" params="[search:'C']" style="text-decoration: none">
            <div class="cardContent">
                <div class="circle-card ${colores[2]}">${cesantesI}</div>
                Cesantes
            </div>
        </g:link>
    </div>
</div>


</body>
</html>