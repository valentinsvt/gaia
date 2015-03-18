<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 07/03/2015
  Time: 0:29
--%>

<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 17/02/2015
  Time: 14:33
--%>
<%@ page import="gaia.UtilitariosTagLib" contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Documentos por Entidad</title>
    <rep:estilos orientacion="l" pagTitle="Documentos por entidad"/>

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

<rep:headerFooter title="Documentos por entidad"/>


<table>
    <thead>

    </thead>
    <tbody>
    <tr>
        <td colspan="5">
            <label>
                <b>Estación:</b>
            </label>
            ${estacion?.nombre}
        </td>
        <td colspan="5">

        </td>
        <td colspan="5">

        </td>
        <td colspan="5">
            <label>
                <b>Fecha:</b>
            </label>
            ${new java.util.Date().format("dd-MM-yyyy")}
        </td>
    </tr>
    <tr>
        <td colspan="5">
            <label>
                <b>Provincia:</b>
            </label>
            ${estacion?.provincia}
        </td>
        <td colspan="5">


        </td>
        <td colspan="5">

        </td>
        <td colspan="5">
            <label>
                <b>Cantón:</b>
            </label>
            ${estacion?.canton}

        </td>
    </tr>
    <tr>
        <td colspan="5">
            <label>
                <b>Propietario:</b>
            </label>

            ${estacion?.propetario}
        </td>
        <td colspan="5">

        </td>
        <td colspan="5">

        </td>
        <td colspan="5">
            <label>
                <b>Teléfono:</b>
            </label>
            ${estacion?.telefono}
        </td>
    </tr>
    </tbody>

</table>

<g:each in="${entidades}" var="ent">

    <fieldset>
        <legend>
           <b>${ent.nombre}</b>
        </legend>
    </fieldset>

    <table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">
        <thead>
        <tr>
            <th style="width: 100px;">Entidad</th>
            <th style="width: 130px;">Tipo Documento</th>
            <th style="width: 70px;"># Referencia</th>
            <th style="width: 70px;">Consultor</th>
            <th style="width: 70px;">Estado</th>
            <th style="width: 70px;">Emisión</th>
            <th style="width: 70px;">Vencimiento</th>
        </tr>
        </thead>
        <tbody>


        <g:each in="${tipos}" var="tipo">
            <g:if test="${tipo.tipo.entidad == ent}">
                <tr>

                    <td>

                        <util:clean str="${tipo?.tipo?.entidad?.nombre}"/>
                    </td>
                    <td>

                        <g:if test="${tipos.size() > 0}">
                            <util:clean str="${tipo?.tipo?.nombre}"/>
                        </g:if>
                        <g:else>
                        </g:else>
                    </td>
                    <td>
                        <util:clean str="${tipo?.referencia}"/>
                    </td>
                    <td>
                        <util:clean str="${tipo?.consultor?.nombre}"/>
                    </td>
                    <td>
                        <g:if test="${tipo?.estado == 'N' }">
                            No Aprobado
                        </g:if>
                        <g:else>
                            Aprobado
                        </g:else>

                    </td>
                    <td style="text-align: center">

                        ${tipo?.inicio?.format("dd-MM-yyyy")}

                    </td>
                    <td style="text-align: center">
                        ${tipo?.fin?.format("dd-MM-yyyy")}
                    </td>
                </tr>
            </g:if>


        </g:each>
        </tbody>
    </table>
</g:each>


</body>
</html>