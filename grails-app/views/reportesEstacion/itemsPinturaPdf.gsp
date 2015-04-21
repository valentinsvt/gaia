<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Reporte de pintura y mantenimiento por Item</title>
    <rep:estilos orientacion="p" pagTitle="Reporte de pintura y mantenimiento por Item: ${item}"/>
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
<rep:headerFooter title="Reporte de pintura y mantenimiento por Item: ${item.descripcion}"/>
<table class="table table-bordered table-condensed table-hover table-striped">
    <thead>
    <tr>
        <th colspan="6">Reporte de pintura y mantenimiento por Item: ${item.descripcion}</th>
    </tr>
    <tr>
        <th>#</th>
        <th>Estación</th>
        <th>Fecha</th>
        <th>Item</th>
        <th>Factura</th>
        <th>Valor</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="total" value="${0}"></g:set>
    <g:each in="${datos}" var="d" status="i">
        <g:set var="total" value="${total+d['sub'].total}"></g:set>
        <tr>
            <td style="text-align: center;width: 30px;">${i+1}</td>
            <td>${d["estacion"]}</td>
            <td>${d.fecha?.format("dd-MM-yyyy")}</td>
            <td>${d["sub"].item.descripcion}</td>
            <td>${d.factura}</td>
            <td style="text-align: right">${d['sub'].total}</td>
        </tr>
    </g:each>
    <tr>
        <th style="font-weight: bold" colspan="5">Total</th>
        <th style="font-weight: bold;text-align: right"><g:formatNumber number="${total}" type="currency" locale="es" currencySymbol="\$"></g:formatNumber></th>
    </tr>
    </tbody>
</table>
</body>
</html>