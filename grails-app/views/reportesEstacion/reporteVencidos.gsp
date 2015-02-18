<%@ page import="gaia.documentos.Documento" %>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <title>Ingreso a bodega</title>


    </head>

    <body>
        <div class="header">
            Header
        </div>

        <div class="hoja">
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
                <tbody id="tb">
                    <g:each in="${estaciones}" var="estacion">
                        <g:set var="documentos" value="${Documento.findAllByEstacion(estacion)}"/>
                        <g:if test="${documentos.size() > 0}">
                            <tr>
                                <td>
                                    <g:fieldValue bean="${estacion}" field="nombre"/>
                                </td>
                                <td>
                                    <ul>
                                        <g:each in="${documentos}" var="documento">
                                            <li>
                                                <g:fieldValue bean="${documento.tipo}" field="nombre"/>
                                            </li>
                                        </g:each>
                                    </ul>
                                </td>
                                <td>
                                    <ul>
                                        <g:each in="${documentos}" var="documento">
                                            <li>
                                                <g:fieldValue bean="${documento}" field="referencia"/>
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
        </div>

        <div class="footer">
            Impreso el ${new Date().format('dd-MM-yyyy HH:mm:ss')}
        </div>

    </body>
</html>
