<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title>Reporte de dotaciones</title>

    <rep:estilos orientacion="p" pagTitle="TOTALES POR SUPERVISOR"/>



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
<rep:headerFooter title="TOTALES POR SUPERVISOR"/>
<p style="font-weight: bold;">SUPERVISOR: ${supervisor.nombre}</p>
<table class="table table-bordered table-hover" style="font-size: 11px">
    <thead>
    <tr>
        <th>Estación</th>
        <th>Uniforme</th>
        <th>Talla</th>
        <th>Cantidad</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="lastEstacion" value="${null}"></g:set>
    <g:each in="${datos}" var="d" >
        <g:set var="lastUniforme" value="${null}"></g:set>
        <g:each in="${d.value}" var="u">
            <g:each in="${u.value}" var="t">
                <tr>
                    <g:if test="${lastEstacion!=d.key}">
                        <td style="font-weight: bold">${d.key}</td>
                        <g:set var="lastEstacion" value="${d.key}"></g:set>
                    </g:if>
                    <g:else>
                        <td></td>
                    </g:else>
                    <g:if test="${lastUniforme!=u.key}">
                        <td style="font-weight: bold">${u.key}</td>
                        <g:set var="lastUniforme" value="${u.key}"></g:set>
                    </g:if>
                    <g:else>
                        <td></td>
                    </g:else>
                    <td style="text-align: center">${t.key}</td>
                    <td style="text-align: right">${t.value}</td>
                </tr>
            </g:each>
        </g:each>
    </g:each>
    </tbody>
</table>
</body>
</html>