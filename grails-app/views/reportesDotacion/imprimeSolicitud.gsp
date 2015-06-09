<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title>Reporte de dotaciones</title>

    <rep:estilos orientacion="p" pagTitle="Dotación #${sol.id}"/>



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
        font-size : 8pt;
        border: 1px solid #000000;
        padding: 3px;

    }

    </style>
</head>
<body>
<rep:headerFooter title="Dotación #${sol.id}"/>
<table style="border: none;border-collapse: collapse;width: 100%">
    <tr>
        <td style="font-weight: bold">Fecha:</td>
        <td>${sol.registro?.format("dd-MM-yyyy")}</td>
        <td style="font-weight: bold">Periodo de dotación:</td>
        <td>${sol.periodo.descripcion}</td>
    </tr>
    <tr>
        <td style="font-weight: bold">Supervisor:</td>
        <td> ${sol.supervisor.nombre}</td>
        <td style="font-weight: bold">Estación:</td>
        <td>${sol.estacion.nombre}</td>
    </tr>
</table>
<table class="table table-striped  table-bordered">
    <thead>
    <tr class="cabecera">
        <th colspan="8">
            Detalle de la dotación
        </th>
    </tr>
    <tr class="tbody">
        <th>Cédula</th>
        <th>Nombre</th>
        <th>Sexo</th>
        <th>Uniforme</th>
        <th>Talla</th>
        <th>Cantidad</th>
        <th>P. Unitario</th>
        <th>Total</th>
    </tr>
    </thead>
    <tbody class="tbody">
    <g:set var="total" value="${0}"></g:set>
    <g:each in="${subdetalle}" var="s" status="i">
        <tr>
            <td>${s.empleado.cedula}</td>
            <td>${s.empleado.nombre}</td>
            <td style="text-align: center">${s.empleado.sexo}</td>
            <td style="width: 30%">${s.uniforme.descripcion}</td>
            <td>${s.talla.talla}</td>
            <td style="text-align: right">${s.cantidad}</td>
            <td style="text-align: right">
                <g:formatNumber number="${s.precio}" type="currency" currencySymbol="\$"/>
            </td>
            <td style="text-align: right">
                <g:set var="total" value="${total+=s.cantidad*s.precio}"></g:set>
                <g:formatNumber number="${s.cantidad*s.precio}" type="currency" currencySymbol="\$"/>
            </td>
        </tr>
    </g:each>
    </tbody>
    <tfoot>
    <tr>
        <td colspan="7" style="font-weight: bold">TOTAL</td>
        <td style="text-align: right;font-weight: bold">
            <g:formatNumber number="${total}" type="currency" currencySymbol="\$"/>
        </td>
    </tr>
    </tfoot>
</table>
</body>
</html>