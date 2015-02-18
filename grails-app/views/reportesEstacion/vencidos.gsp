<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 16/02/2015
  Time: 18:35
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Reporte Documentos por Vencer</title>
</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div class="btn-toolbar toolbar">
<div class="btn-group pull-right col-md-3">
        <div class="input-group">
            <input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">
            <span class="input-group-btn">
                <g:link controller="reportesEstacion" action="vencidos" class="btn btn-default btn-search">
                    <i class="fa fa-search"></i>&nbsp;
                </g:link>
            </span>
        </div><!-- /input-group -->
    </div>
</div>


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
        <tr>
            <td>
             <elm:textoBusqueda busca="${params.search}">
                 <g:fieldValue bean="${estacion}" field="nombre"/>
             </elm:textoBusqueda>
            </td>
            <td>
                <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion)}"/>
                <g:if test="${documentos.size() > 0}">
                   <ul>
                        <g:each in="${documentos}" var="documento">

                            <li>
                                <elm:textoBusqueda busca="${params.search}">
                                    <g:fieldValue bean="${documento.tipo}" field="nombre"/>
                                </elm:textoBusqueda>
                            </li>
                        </g:each>
                    </ul>
                </g:if>
                <g:else>
                    <li style="text-align: center; ">
                        No tiene documentos
                    </li>
                </g:else>
            </td>
            <td>
                <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion)}"/>
                <g:if test="${documentos.size() > 0}">
                    <ul>
                        <g:each in="${documentos}" var="documento">

                            <li>
                                <elm:textoBusqueda busca="${params.search}">
                                    <g:fieldValue bean="${documento}" field="referencia"/>
                                </elm:textoBusqueda>
                            </li>
                        </g:each>
                    </ul>
                </g:if>
                <g:else>
                    <li style="text-align: center; ">
                        No tiene # de referencia
                    </li>
                </g:else>
            </td>
            <td>
                <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion)}"/>
                <g:if test="${documentos.size() > 0}">
                    <ul>
                        <g:each in="${documentos}" var="documento">

                            <li>
                                ${documento?.inicio?.format("dd-MM-yyyy")}
                            </li>
                        </g:each>
                    </ul>
                </g:if>
                <g:else>
                    <li style="text-align: center; ">
                        No tiene fecha de emisión
                    </li>
                </g:else>
            </td>
            <td>
                <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion)}"/>
                <g:if test="${documentos.size() > 0}">
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
                </g:if>
                <g:else>
                    <li style="text-align: center; ">

                    </li>
                </g:else>
            </td>
        </tr>
    </g:each>

    </tbody>
</table>

<elm:pagination total="${estacionInstanceCount}" params="${params}"/>


</body>
</html>