<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title>Reporte de dotaciones</title>

    <rep:estilos orientacion="p" pagTitle="Reporte de dotaciones del periodo: ${periodo}"/>



    <style type="text/css">

    .label {
        width       : 150px;
        font-weight : bold;
    }

    table {
        font-size       : 12px;
        border-collapse : collapse;
    }

    th {
        background-color : #3A5DAA;
        color            : #ffffff;
        font-weight      : bold;
        font-size        : 12px;
        border           : 1px solid #000;
        padding          : 3px;
    }


    .table {
        width: 100%;
        font-size  : 10pt;
        margin-top : 10px;
        border-collapse: collapse;
    }


    .table td {
        font-size : 10pt;
        border: 1px solid #000000;
        padding: 3px;

    }

    </style>
</head>


<body>


<rep:headerFooter title="Reporte de dotaciones del periodo: ${periodo}"/>
<table class="table table-bordered table-condensed table-hover table-striped">
    <thead>
    <tr>
        <th colspan="6">Reporte de dotaciones para el periodo: ${periodo}</th>
    </tr>
    <tr>
        <th>#</th>
        <th>Estación</th>
        <th>Supervisor</th>
        <th>Solicitado</th>
        <th>Entregado</th>
        <th>Valor</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="total" value="${0}"></g:set>
    <g:each in="${dotaciones}" var="d" status="i">
        <g:set var="total" value="${total+d.getTotal()}"></g:set>
        <tr>
            <td style="text-align: center;width: 30px;">${i+1}</td>
            <td>${d.estacion}</td>
            <td>${gaia.documentos.Inspector.findByCodigo(d.estacion.codigoSupervisor)?.nombre}</td>
            <td style="text-align: center">${d.fecha?.format("dd-MM-yyyy")}</td>
            <td style="text-align: center">${periodo.fecha?.format("dd-MM-yyyy")}</td>
            <td style="text-align: right">${d.getTotal()}</td>
        </tr>
    </g:each>
    <tr>
        <th style="font-weight: bold" colspan="5">Total</th>
        <th style="font-weight: bold;text-align: right"><g:formatNumber number="${total}" type="currency"></g:formatNumber></th>
    </tr>
    </tbody>
</table>
<g:if test="${sinDotacion.size()>0}">
    <table class="table table-bordered table-condensed table-hover table-striped" style="margin-top: 20px">
        <thead>
        <tr><th colspan="6">Estaciones sin dotación para el periodo: ${periodo.descripcion}</th></tr>
        <tr>
            <th>#</th>
            <th>Estación</th>
            <th>Supervisor</th>
            <th>Pedido</th>
            <th>Estado</th>
            <th>Total</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${sinDotacion}" status="i" var="d">
            <tr>
                <td style="text-align: center;width: 30px;">${i+1}</td>
                <td>${d.key.estacion}</td>
                <td>${gaia.documentos.Inspector.findByCodigo(d.key.estacion.codigoSupervisor)?.nombre}</td>
                <td style="text-align: center">${d.value}</td>
                <td style="text-align: center">${d.value!="N.A."?d.value.estado:'N.A.'}</td>
                <td style="text-align: center">${d.value!="N.A."?d.value.getTotal():'0'}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</g:if>


</body>
</html>