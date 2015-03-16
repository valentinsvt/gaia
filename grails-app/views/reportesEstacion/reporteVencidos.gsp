<%@ page import="gaia.documentos.Documento" %>

<html>
    <head>
        <title>Documentos por vencer</title>

        <rep:estilos orientacion="l" pagTitle="Documentos vencidos"/>

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

    <rep:headerFooter title="Documentos vencidos"/>
    <table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">

        <thead>
                <tr>
                    <th style="width: 100px;">Estación</th>
                    <th style="width: 130px;">Tipo Documento</th>
                    <th style="width: 70px;"># Referencia</th>
                    <th style="width: 70px;">Emisión</th>
                    <th style="width: 70px;">Vencimiento</th>
                </tr>
            </thead>
            <tbody>
                <g:each in="${estaciones}" var="estacion">
                    <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion)}"/>
                    <g:if test="${documentos.size() > 0}">
                        <tr>
                            <td>
                                <util:clean str="${estacion?.nombre}"/>
                            </td>
                            <td>
                                <ul style="vertical-align: inherit !important;">
                                    <g:each in="${documentos}" var="documentoR">
                                        <g:if test="${documentoR?.tipo?.nombre}">
                                            <li>
                                                <util:clean str="${documentoR?.tipo?.nombre}"/>
                                            </li>
                                        </g:if>
                                        <g:else>
                                            <li>
                                                NADA
                                            </li>
                                        </g:else>
                                    </g:each>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <g:each in="${documentos}" var="documento">
                                        <li>
                                            <util:clean str="${documento?.referencia}"/>
                                        </li>
                                    </g:each>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <g:each in="${documentos}" var="documento">
                                        <li>
                                            ${documento?.inicio?.format("dd-MM-yyyy")}
                                        </li>
                                    </g:each>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <g:each in="${documentos}" var="documento">
                                        <g:if test="${documento?.fin}">
                                            <g:if test="${documento.fin.clearTime() <= new Date().clearTime()}">
                                                <li style="color: #ce464a">
                                                    Vencido ${documento?.fin?.format("dd-MM-yyyy")}
                                                </li>
                                            </g:if>
                                            <g:elseif test="${documento?.fin < new Date().plus(30)}">
                                                <li style="color: #ffa324">
                                                    Por vencer  ${documento?.fin?.format("dd-MM-yyyy")}
                                                </li>
                                            </g:elseif>
                                            <g:else>
                                                <li>
                                                    ${documento?.fin?.format("dd-MM-yyyy")}
                                                </li>
                                            </g:else>
                                        </g:if>
                                        <g:else>
                                            <li>
                                                Sin fecha de vencimiento
                                            </li>
                                        </g:else>
                                    </g:each>
                                </ul>
                            </td>
                        </tr>
                    </g:if>
                </g:each>
            </tbody>
        </table>

    </body>
</html>
