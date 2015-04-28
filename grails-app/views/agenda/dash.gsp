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
    </style>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
</head>
<body>

<div class="row">
    <div class="card" style="width:273px;">
        <div class="titulo-card" style="font-size: 22px"><i class="fa flaticon-car24"></i> Estaciones de servicio</div>

        <div class="cardContent">
            <div class="circle-card 0">10</div>
            Activas
        </div>
        <div class="cardContent">
            <div class="circle-card ">10</div>
            Suspendidas
        </div>
        <div class="cardContent">
            <div class="circle-card ">10</div>
            Cesantes
        </div>
        <div class="cardContent">
            <div class="circle-card ">10</div>
            Resiliadas
        </div>
    </div>
    <div class="card" style="width:273px;">
        <div class="titulo-card" style="font-size: 22px">
            <i class="fa flaticon-worker5"></i > Industrias
        </div>

        <div class="cardContent">
            <div class="circle-card 0">10</div>
            Cesantes
        </div>


        <div class="cardContent">
            <div class="circle-card ">10</div>
            Estaciones sin licencia
        </div>

    </div>
</div>


</body>
</html>