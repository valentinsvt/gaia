
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Reporte Documentos por Vencer</title>
</head>
<body>
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
        <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion)}"/>
        <g:if test="${documentos.size() > 0}">
            <tr>
                <td>
                    <elm:textoBusqueda busca="${params.search}">
                        <g:fieldValue bean="${estacion}" field="nombre"/>
                    </elm:textoBusqueda>
                </td>
                <td>
                    <ul>
                        <g:each in="${documentos}" var="documento">
                            <li>
                                <elm:textoBusqueda busca="${params.search}">
                                    <g:fieldValue bean="${documento.tipo}" field="nombre"/>
                                </elm:textoBusqueda>
                            </li>
                        </g:each>
                    </ul>
                </td>
                <td>
                    <ul>
                        <g:each in="${documentos}" var="documento">

                            <li>
                                <elm:textoBusqueda busca="${params.search}">
                                    <g:fieldValue bean="${documento}" field="referencia"/>
                                </elm:textoBusqueda>
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
                                <g:if test="${documento?.fin < new Date().plus(30)}">
                                    <li style="color: #da4f49">
                                        Vencido  ${documento?.fin?.format("dd-MM-yyyy")}
                                    </li>
                                </g:if>
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