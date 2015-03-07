<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 07/03/2015
  Time: 11:12
--%>

<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 17/02/2015
  Time: 12:36
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Reporte Documentos por Estación</title>

    <rep:estilos orientacion="l" pagTitle="Reporte de Documentos por Estación"/>

    <style type="text/css">
    .titulo, .proyecto, .componente {
        width : 16cm;
    }

    .titulo {
        height        : .5cm;
        font-size     : 16pt;
        font-weight   : bold;
        text-align    : center;
        margin-bottom : .5cm;
    }

    .row {
        width      : 100%;
        height     : 14px;
        margin-top : 10px;
        font-size  : 12px;
    }

    .label {
        width       : 150px;
        font-weight : bold;
    }

    /*td {*/
        /*padding : 3px;*/
        /*border  : 1px solid #fff*/
    /*}*/

    table {
        font-size       : 12px;
        border-collapse : collapse;
    }

    th {
        background-color : #3A5DAA;
        color            : #ffffff;
        font-weight      : bold;
        font-size        : 12px;
        border           : 1px solid #fff;
        padding          : 3px;
    }

    .table {
        font-size  : 10pt;
        margin-top : 10px;
    }

    .table td {
        font-size : 10pt;
    }
    </style>
</head>


<body>
<rep:headerFooter title="Reporte de Documentos por Estación"/>



<table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">
    <thead>
    <tr>
        <th style="width: 100px;">Estación</th>
        <th>Documento</th>
        <th>Fecha Inicio</th>
        <th>Fecha Fin</th>
    </tr>
    </thead>
    <tbody id="tb">

    <g:each in="${estaciones}" var="estacion">
        <tr>
            <td>
            ${estacion?.nombre}
            </td>
            <td>
                <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion, [sort: "id"])}"/>
                <g:each in="${documentos}" var="documento">
                    ${documento?.tipo?.nombre}<br/>
                </g:each>
            </td>
            <td style="text-align: center">
                <g:each in="${documentos}" var="documentoI">
                    ${documentoI?.inicio?.format("dd-MM-yyyy")}<br/>
                </g:each>
            </td>
            <td style="text-align: center">
                <g:each in="${documentos}" var="documentoF">
                    ${documentoF?.fin?.format("dd-MM-yyyy")}<br/>
                </g:each>
            </td>
        </tr>
    </g:each>

    </tbody>
</table>


</body>
</html>