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

    <style type="text/css">
    td {
        padding : 3px;
        border  : 1px solid #fff
    }

    </style>
</head>


<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div class="btn-toolbar toolbar">
        <div class="btn-group">
            <a href="#" class="btn btn-default btnImprimir">
                <i class="fa fa-print"></i> Imprimir
            </a>
        </div>


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
        <th>Documento</th>
        <th>N° Referencia</th>
        <th>Estado</th>
        <th>Fecha Inicio</th>
        <th>Fecha Fin</th>
    </tr>
    </thead>
    <tbody id="tb">

    <g:each in="${estaciones}" var="estacion">
        <tr>
            <td >
                <elm:textoBusqueda busca="${params.search}">
                    <g:fieldValue bean="${estacion}" field="nombre"/>
                </elm:textoBusqueda>
            </td>
            <td >
               <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion, [sort: "id"])}"/>
                <g:each in="${documentos}" var="documento">
                            <p style="border-bottom: 1px solid">${documento?.tipo?.nombre}<br/></p>
                </g:each>
            </td>
            <td>
                <g:each in="${documentos}" var="documentoR">
                    <p style="border-bottom: 1px solid"> ${documentoR?.referencia}<br/></p>
                </g:each>
            </td>
            <td>
                <g:each in="${documentos}" var="documentoE">
                    <g:if test="${documentoE?.estado == "A"}">
                        <p style="border-bottom: 1px solid"> Aprobado<br/></p>
                    </g:if>
                    <g:else>
                        <p style="border-bottom: 1px solid">No Aprobado<br/></p>
                    </g:else>
                </g:each>
            </td>

            <td style="text-align: center">
                <g:each in="${documentos}" var="documentoI">
                    <p style="border-bottom: 1px solid"> ${documentoI?.inicio?.format("dd-MM-yyyy")}<br/></p>
                </g:each>
            </td>
            <td style="text-align: center">
                <g:each in="${documentos}" var="documentoF">
                    <p style="border-bottom: 1px solid">${documentoF?.fin?.format("dd-MM-yyyy")}<br/></p>
                </g:each>
            </td>
        </tr>
    </g:each>

    </tbody>
</table>

<elm:pagination total="${estacionInstanceCount}" params="${params}"/>

<script type="text/javascript">

    $(".btnImprimir").click(function () {
        var url = "${createLink(controller: 'reportesEstacion',action: 'reporteDocumentosEstacion')}";
        location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
    });

</script>


</body>
</html>