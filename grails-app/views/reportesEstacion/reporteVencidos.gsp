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
            <th style="width: 70px;">Consultor</th>
            <th style="width: 70px;">Estado</th>
            <th style="width: 70px;">Emisión</th>
            <th style="width: 70px;">Vencimiento</th>

        </tr>
        </thead>
        <tbody id="tb">

        <g:each in="${estaciones}" var="estacion">
            <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion)}"/>
            <g:if test="${documentos.size() > 0}">
                <g:each in="${documentos}" var="documento">
                    <g:if test="${documento?.fin}">
                        <g:if test="${documento.fin.clearTime() <= new Date().clearTime()}">
                        </g:if>
                        <g:elseif test="${(documento?.fin < new Date().plus(30))}">
                            <tr>
                                <td>
                                   %{--${documento?.estacion?.nombre}--}%
                                   <util:clean str="${documento?.estacion?.nombre}"/>
                                </td>
                                <td>
                                    <ul>
                                    %{--${documento?.tipo?.nombre}--}%
                                    <util:clean str="${documento?.tipo?.nombre}"/>
                                    </ul>
                                </td>
                                <td>
                                    <ul>
                                    %{--${documento?.referencia}--}%
                                    <util:clean str="${documento?.referencia}"/>
                                    </ul>
                                </td>
                                <td>
                                    <util:clean str="${documento?.consultor?.nombre}"/>
                                </td>
                                <td>
                                    <g:if test="${documento?.estado == 'N' }">
                                        No Aprobado
                                    </g:if>
                                    <g:else>
                                        Aprobado
                                    </g:else>

                                </td>
                                <td>
                                    <ul>
                                        ${documento?.inicio?.format("dd-MM-yyyy")}
                                    </ul>
                                </td>
                                <td>

                                    <ul>
                                        <g:if test="${documento?.fin}">
                                            <g:if test="${documento.fin.clearTime() <= new Date().clearTime()}">
                                                <li style="color: #ce464a">
                                                    Vencido ${documento?.fin?.format("dd-MM-yyyy")}
                                                </li>
                                            </g:if>
                                            <g:elseif test="${documento?.fin < new Date().plus(30)}">
                                                %{--<li>--}%
                                                    ${documento?.fin?.format("dd-MM-yyyy")}
                                                %{--</li>--}%
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
                                    </ul>
                                </td>

                            </tr>
                        </g:elseif>
                    </g:if>
                </g:each>
            </g:if>
        </g:each>

        </tbody>
    </table>

    </body>
</html>
