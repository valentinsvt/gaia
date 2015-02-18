<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 17/02/2015
  Time: 12:36
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Reporte Documentos por Estación</title>
</head>


<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div class="btn-toolbar toolbar">
    <div class="btn-group pull-right col-md-3">
        <div class="input-group">
            <input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">
            <span class="input-group-btn">
                <g:link controller="reportesEstacion" action="documentos" class="btn btn-default btn-search">
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
        <g:each in="${tiposDocumentos}" var="tipo">
            <th style="width: 70px">${tipo?.nombre}</th>
        </g:each>
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
            <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion, [sort: "id"])}"/>
            <g:set var="numeros" value="1"/>
            <g:each in="${documentos.tipo}" var="documento">
                <td>
                    <elm:textoBusqueda busca="${params.search}">
                        <g:fieldValue bean="${documento}" field="id"/>
                    </elm:textoBusqueda>
                </td>
            </g:each>
        </tr>
    </g:each>

    </tbody>
</table>

<elm:pagination total="${estacionInstanceCount}" params="${params}"/>



</body>
</html>