<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title>Reporte de dotaciones</title>

    <rep:estilos orientacion="p" pagTitle="LISTAD0 DOTACIONES APROBADAS"/>



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
        font-size        : 10px;
        border           : 1px solid #000;
        padding          : 3px;
    }


    .table {
        width: 100%;
        font-size  : 10px;
        margin-top : 10px;
        border-collapse: collapse;
    }


    .table td {
        font-size : 10px;
        border: 1px solid #000000;
        padding: 3px;

    }

    </style>
</head>
<body>
<rep:headerFooter title="LISTAD0 DOTACIONES APROBADAS"/>

<table class="table table-bordered table-striped table-hover" style="font-size: 11px">
    <thead>
    <tr>
        <th style="width: 150px">Supervisor</th>
        <g:each in="${uniformes}" var="u">
            <th>${u.toStringCorto()}</th>
        </g:each>
    </tr>
    </thead>
    <tbody>
    <g:each in="${datos}" var="d" status="i">
        <tr>
            <td style="font-weight: ${i==datos.size()-1?'bold':'normal'}">${d.key}</td>
            <g:each in="${d.value}" var="sd">
                <td style="font-weight: ${i==datos.size()-1?'bold':'normal'};text-align: right">${sd.value}</td>
            </g:each>
        </tr>
    </g:each>
    </tbody>
</table>
</body>
</html>