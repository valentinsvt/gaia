<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 16/02/2015
  Time: 17:07
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Reporte de Supervisores y Consultores por estación</title>
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
                <g:link controller="reportesEstacion" action="supervisores" class="btn btn-default btn-search">
                    <i class="fa fa-search"></i>&nbsp;
                </g:link>
            </span>
        </div><!-- /input-group -->
    </div>
</div>

<table border="1" class="table table-condensed table-bordered table-striped table-hover ">
    <thead>
    <tr>
        <th style="width: 100px;">Estación</th>
        <th style="width: 130px;">Consultor</th>
        <th style="width: 130px;">Supervisor</th>
    </tr>
    </thead>
    <tbody id="tb">

    <g:each in="${estaciones}" var="estacion">
        <tr>
            <td>
                ${estacion?.nombre}
            </td>
            <td>
                <g:set var="consultores" value="${gaia.documentos.ConsultorEstacion.findAllByEstacion(estacion)}"/>
               <g:if test="${consultores.size() > 0}">
                   <ul>
                       <g:each in="${consultores}" var="consultor">

                           <li>
                               <elm:textoBusqueda busca="${params.search}">
                                   <g:fieldValue bean="${consultor.consultor}" field="nombre"/>
                               </elm:textoBusqueda>
                           <ul>
                               <li>
                                <b>RUC:</b>                                 <elm:textoBusqueda busca="${params.search}">
                                   <g:fieldValue bean="${consultor.consultor}" field="ruc"/>
                               </elm:textoBusqueda>
                               </li>
                               <li>
                                 <b>TELF:</b>                                 <elm:textoBusqueda busca="${params.search}">
                                   <g:fieldValue bean="${consultor.consultor}" field="telefono"/>
                               </elm:textoBusqueda>
                               </li>
                           </ul>
                           </li>
                       </g:each>
                   </ul>
               </g:if>
               <g:else>
                   <li style="text-align: center; ">
                       No tiene consultor
                   </li>
               </g:else>
            </td>
            <td>
                <g:set var="supervisores" value="${gaia.documentos.InspectorEstacion.findAllByEstacion(estacion)}"/>
                <g:if test="${supervisores.size() > 0}">
                    <ul>
                        <g:each in="${supervisores}" var="supervisor">
                            <li>
                                ${supervisor?.inspector?.nombre}
                           <ul>
                                <li>
                                    <b>TELF:</b>
                                    ${supervisor?.inspector?.telefono}
                                </li>
                                <li>
                                    <b>
                                        EMAIL:
                                    </b>
                                    ${supervisor?.inspector?.mail}
                                </li>
                           </ul>

                            </li>


                        </g:each>
                    </ul>
                </g:if>
                <g:else>
                    <li style="text-align: center">
                        Sin Supervisor
                    </li>

                </g:else>
            </td>
        </tr>
    </g:each>

    </tbody>
</table>

<elm:pagination total="${estacionInstanceCount}" params="${params}" />

<script type="text/javascript">

    $(".btnImprimir").click(function () {
        var url = "${createLink(controller: 'reportesEstacion',action: 'reporteSupervisores')}";
        location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
//                location.href = url;
    });

</script>
</body>
</html>