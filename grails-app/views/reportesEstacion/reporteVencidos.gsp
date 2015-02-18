<html>
    <head>
        <title>Ingreso a bodega</title>

        <style type="text/css">
        @page {
            size   : 21cm 29.7cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width     : 16.5cm;
            font-size : 12px;
        }

        .titulo, .proyecto, .componente {
            width : 16cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 24.7cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 11pt;
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
            font-size : 12px;
        }

        th {
            background-color : #3A5DAA;
            color            : #ffffff;
            font-weight      : bold;
            font-size        : 12px;
            border           : 1px solid #fff;
            padding          : 3px;
        }

        .odd {
            background-color : #d7dfda;
        }

        .even {
            background-color : #fff;
        }

        div.header {
            display    : block;
            text-align : center;
            position   : running(header);
        }

        div.footer {
            display    : block;
            text-align : center;
            position   : running(footer);
        }

        div.content {
            page-break-after : always;
        }

        @page {
            @top-center {
                content : element(header);
            }
        }

        @page {
            @bottom-center {
                content : element(footer);
            }
        }
        </style>
    </head>

    <body>
        <div class="header">
            Header
        </div>

        <div class="hoja">
            BODY
        </div>

        <div class="footer">
            Impreso el ${new Date().format('dd-MM-yyyy HH:mm:ss')}
        </div>

    </body>
</html>
%{--<%@ page import="gaia.documentos.Documento" contentType="text/html;charset=UTF-8" %>--}%
%{--<html>--}%
%{--<head>--}%
%{--<title>Reporte Documentos por Vencer</title>--}%
%{--</head>--}%

%{--<body>--}%
%{--<table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">--}%
%{--<thead>--}%
%{--<tr>--}%
%{--<th style="width: 100px;">Estación</th>--}%
%{--<th style="width: 130px;">Tipo Documento</th>--}%
%{--<th style="width: 70px;"># Referencia</th>--}%
%{--<th style="width: 70px;">Emisión</th>--}%
%{--<th style="width: 70px;">Vencimiento</th>--}%
%{--</tr>--}%
%{--</thead>--}%
%{--<tbody id="tb">--}%
%{--<g:each in="${estaciones}" var="estacion">--}%
%{--<g:set var="documentos" value="${Documento.findAllByEstacion(estacion)}"/>--}%
%{--<g:if test="${documentos.size() > 0}">--}%
%{--<tr>--}%
%{--<td>--}%
%{--<g:fieldValue bean="${estacion}" field="nombre"/>--}%
%{--</td>--}%
%{--<td>--}%
%{--<ul>--}%
%{--<g:each in="${documentos}" var="documento">--}%
%{--<li>--}%
%{--<g:fieldValue bean="${documento.tipo}" field="nombre"/>--}%
%{--</li>--}%
%{--</g:each>--}%
%{--</ul>--}%
%{--</td>--}%
%{--<td>--}%
%{--<ul>--}%
%{--<g:each in="${documentos}" var="documento">--}%
%{--<li>--}%
%{--<g:fieldValue bean="${documento}" field="referencia"/>--}%
%{--</li>--}%
%{--</g:each>--}%
%{--</ul>--}%
%{--</td>--}%
%{--<td>--}%
%{--<ul>--}%
%{--<g:each in="${documentos}" var="documento">--}%
%{--<li>--}%
%{--${documento?.inicio?.format("dd-MM-yyyy")}--}%
%{--</li>--}%
%{--</g:each>--}%
%{--</ul>--}%
%{--</td>--}%
%{--<td>--}%
%{--<ul>--}%
%{--<g:each in="${documentos}" var="documento">--}%
%{--<g:if test="${documento?.fin}">--}%
%{--<g:if test="${documento.fin.clearTime() <= new Date().clearTime()}">--}%
%{--<li style="color: #ce464a">--}%
%{--Vencido ${documento?.fin?.format("dd-MM-yyyy")}--}%
%{--</li>--}%
%{--</g:if>--}%
%{--<g:elseif test="${documento?.fin < new Date().plus(30)}">--}%
%{--<li style="color: #ffa324">--}%
%{--Por vencer  ${documento?.fin?.format("dd-MM-yyyy")}--}%
%{--</li>--}%
%{--</g:elseif>--}%
%{--<g:else>--}%
%{--<li>--}%
%{--${documento?.fin?.format("dd-MM-yyyy")}--}%
%{--</li>--}%
%{--</g:else>--}%
%{--</g:if>--}%
%{--<g:else>--}%
%{--<li>--}%
%{--Sin fecha de vencimiento--}%
%{--</li>--}%
%{--</g:else>--}%
%{--</g:each>--}%
%{--</ul>--}%
%{--</td>--}%
%{--</tr>--}%
%{--</g:if>--}%
%{--</g:each>--}%
%{--</tbody>--}%
%{--</table>--}%
%{--</body>--}%
%{--</html>--}%