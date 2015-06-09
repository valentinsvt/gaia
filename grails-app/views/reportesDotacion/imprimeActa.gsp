<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title>Reporte de dotaciones</title>

    <rep:estilos orientacion="p" pagTitle="ACTA DE ENTREGA RECEPCIÓN"/>



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
<rep:headerFooter title="ACTA DE ENTREGA RECEPCIÓN"/>
<p>A los ${fecha.format("dd")} días de ${fecha.format("MMMM")} del ${fecha.format("yyyy")}, se realiza la entrega recepción de la dotación de
uniforme para la ${sol.estacion.nombre}, según se detalla a continuación:</p>

<table class="table table-striped  table-bordered">
    <thead>

    <tr class="tbody">
        <th style="width: 70%">Uniforme</th>
        <th>Talla</th>
        <th>Cantidad</th>
    </tr>
    </thead>
    <tbody class="tbody">
    <g:set var="anterior" value="${null}"></g:set>
    <g:each in="${subdetalle}" var="s" status="i">
        <g:if test="${anterior!=s.uniforme.descripcion}">
            <g:set var="anterior" value="${s.uniforme.descripcion}"></g:set>
            <g:set var="td" value="${s.uniforme.descripcion}"></g:set>
        </g:if>
        <g:else>
            <g:set var="td" value=""></g:set>
        </g:else>
        <tr>
            <td style="width: 30%">${td}</td>
            <td style="text-align: center">${s.talla.talla}</td>
            <td style="text-align: center">${s.cantidad}</td>
        </tr>
    </g:each>
    </tbody>
</table>
<table style="width: 100%;margin-top: 15px;">
    <tr>
        <td colspan="4">
            <b>Entrega por Petróleos y servicios</b>
        </td>
        <td>
            <b>Recibe por ${sol.estacion.nombre}</b>
        </td>
    </tr>
    <tr>
        <td style="width: 30%;height: 100px;border-bottom: 1px solid #000000;padding: 10px"></td>
        <td style="width: 20px;"></td>
        <td style="width: 30%;height: 100px;border-bottom: 1px solid #000000"></td>
        <td style="width: 20px;"></td>
        <td style="width: 30%;height: 100px;border-bottom: 1px solid #000000"></td>
    </tr>
    <tr>
        <td style="width: 30%;">SR. DIEGO PÉREZ</td>
        <td style="width: 20px;"></td>
        <td style="width: 30%;">SR. ${sol.supervisor.nombre.toUpperCase()}</td>
        <td style="width: 20px;"></td>
        <td style="width: 30%;">SR.</td>
    </tr>
    <tr>
        <td>Coordinador administrativo</td>
        <td style="width: 20px;"></td>
        <td>Supervisor promotor</td>
        <td style="width: 20px;"></td>
        <td>C.C.</td>
    </tr>
</table>
<p>El representante de la E/S certifica que los objetos recibidos están de acuerdo con su pedido, y que ha sido informado de que tales
objetos tienen garantía del proveedor, por lo que, en caso de deterioro dentro de los primeros seis meses, tiene el derecho de pedir su cambio,
para lo cual enregará al Supervisor Promotor el objeto defectuoso y Petróleos y Servicios por medio del mismo Supervisor Promotor le
entregará el reemplazo.</p>
<p style="font-weight: bold">Por ${sol.estacion.nombre}</p>
<p style="font-weight: bold">Sr.</p>
</body>
</html>