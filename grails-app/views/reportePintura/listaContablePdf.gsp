<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title>Reporte contable de pintura y mantenimiento</title>

    <rep:estilos orientacion="l" pagTitle="Reporte de pintura y mantenimiento"/>



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
        <g:each in="${items}" var="item">
            <th>${item.descripcion}</th>
        </g:each>
        <th>Total</th>

    </tr>
    </thead>
    <tbody>
    <g:set var="total" value="${0}"></g:set>
    <g:each in="${datos}" var="d" status="">
        <g:set var="tot" value="${d.getTotal()}"></g:set>
        <tr class="tr-info">
            <td class="desc">${d.cliente.nombre}</td>
            <td class="desc">${d.numeroFactura}</td>
            <g:each in="${items}" var="item">
                <g:set var="valor" value="${d.getTotalGrupo(item)}"></g:set>
                <g:set var="dumy" value="${totales[item.id]+=valor}"></g:set>
                <td style="text-align: right">
                    <g:formatNumber number="${valor}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
                </td>
            </g:each>
            <td style="text-align: right">
                <g:formatNumber number="${tot}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
            </td>
            <g:set var="total" value="${total+=tot}"></g:set>

        </tr>

    </g:each>
    <tr>
        <td style="font-weight: bold" colspan="2">TOTAL</td>
        <g:each in="${totales}">
            <td style="text-align: right;font-weight: bold">
                <g:formatNumber number="${it.value.toDouble().round(2)}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
            </td>
        </g:each>
        <td style="text-align: right;font-weight: bold">
            <g:formatNumber number="${total.toDouble().round(2)}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
        </td>
    </tr>
    </tbody>
</table>


</body>
</html>