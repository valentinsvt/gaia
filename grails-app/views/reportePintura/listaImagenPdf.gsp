<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title>Reporte contable de pintura y mantenimiento</title>

    <rep:estilos orientacion="p" pagTitle="Reporte de pintura y mantenimiento"/>



    <style type="text/css">

    .label {
        width       : 150px;
        font-weight : bold;
    }

    table {
        font-size       : 10px;
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
<rep:headerFooter title="Reporte de pintura y mantenimiento desde ${inicio.format('dd-MM-yyyy')} hasta ${fin.format('dd-MM-yyyy')}"/>
<table class="table table-striped table-hover table-bordered" style="margin-top: 15px;font-size: 11px">
    <thead>
    <tr>
        <th style="width: 30%">
            Estación
        </th>
        <th># Factura</th>
        <th>Pintura</th>
        <th>Rotulación</th>
        <th>Total</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="totalP" value="${0}"></g:set>
    <g:set var="totalR" value="${0}"></g:set>
    <g:each in="${datos}" var="d" status="">
        <g:set var="tR" value="${d.getRotulacion()}"></g:set>
        <g:set var="tP" value="${d.getPintura()}"></g:set>
        <g:set var="totalP" value="${totalP+tP}"></g:set>
        <g:set var="totalR" value="${totalR+tR}"></g:set>

        <tr class="tr-info">
            <td class="desc">${d.cliente.nombre}</td>
            <td class="desc">${d.numeroFactura}</td>
            <td style="text-align: right">
                <g:formatNumber number="${tP}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
            </td>
            <td style="text-align: right">
                <g:formatNumber number="${tR}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
            </td>
            <td style="text-align: right">
                <g:formatNumber number="${tP+tR}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
            </td>
        </tr>

    </g:each>
    <tr>
        <td style="font-weight: bold" colspan="2">TOTAL</td>
        <td style="text-align: right;font-weight: bold">
            <g:formatNumber number="${totalP}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
        </td>
        <td style="text-align: right;font-weight: bold">
            <g:formatNumber number="${totalR}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
        </td>
        <td style="text-align: right;font-weight: bold">
            <g:formatNumber number="${totalP+totalR}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
        </td>
    </tr>
    </tbody>
</table>


</body>
</html>