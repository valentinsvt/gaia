<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 07/03/2015
  Time: 8:03
--%>

<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 07/03/2015
  Time: 0:20
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

    <title>Reporte Documentos por Consultor</title>

    <rep:estilos orientacion="l" pagTitle="Reporte de Documentos por Consultor"/>

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

    td {
        padding : 3px;
        border  : 1px solid #fff
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


<rep:headerFooter title="Reporte de Documentos por Consultor"/>

<fieldset>
    <g:if test="${consultor}">
        <legend><b>Consultor: </b>${consultor?.nombre + " - " + consultor?.ruc}</legend>
    </g:if>
    <g:else>
        <legend><b>Consultor: Todos los consultores </b></legend>
    </g:else>

</fieldset>

<table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">
    <thead>
    <tr>
        <th style="width: 100px;">Consultor</th>
        <th>Estación</th>
        <th>Documento</th>
        <th>N° Referencia</th>
        <th>Estado</th>
        <th>Emisión</th>
        <th>Vence</th>


    </tr>
    </thead>
    <tbody id="tb">

    <g:each in="${documentos}" var="documento">
        <tr>
            <g:if test="${documento?.consultor?.nombre}">
                <td>
                    <util:clean str="${documento?.consultor?.nombre}"/>
                </td>
                <td>
                    <util:clean str="${documento?.estacion?.nombre}"/>
                </td>
                <td>
                    <util:clean str="${documento?.tipo?.nombre}"/>
                </td>
                <td>
                    <util:clean str="${documento?.referencia}"/>
                </td>
                <td>
                    <g:if test="${documento?.estado == "A"}">
                        Aprobado
                    </g:if>
                    <g:else>
                        No Aprobado
                    </g:else>
                </td>
                <td>
                    ${documento?.inicio?.format("dd-MM-yyyy")}
                </td>
                <td>
                    ${documento?.fin?.format("dd-MM-yyyy")}
                </td>



            </g:if>
        </tr>
    </g:each>

    </tbody>
</table>

</body>
</html>