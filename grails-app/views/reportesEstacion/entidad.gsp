<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 17/02/2015
  Time: 14:33
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Documentos por Entidad</title>
</head>

<body>


<div role="tabpanel">
    <!-- Nav tabs -->
    <ul class="nav nav-pills" role="tablist">
        <li role="presentation" class="active">
            <a href="#mae" aria-controls="mae" role="tab" data-toggle="pill">Ministerio del Ambiente</a>
        </li>
        <li role="presentation">
            <a href="#arch" aria-controls="arch" role="tab" data-toggle="pill">Agencia de regulación y control hidrocarburífico</a>
        </li>
    </ul>

    <!-- Tab panes -->
    <div class="tab-content">
        <div role="tabpanel" class="tab-pane active" id="mae">

            <table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">
                <thead>
                <tr>
                    <th style="width: 130px;">Tipo Documento</th>
                    <th style="width: 70px;"># Referencia</th>
                    <th style="width: 70px;">Emisión</th>
                    <th style="width: 70px;">Vencimiento</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${tiposDocumentosMae}" var="documentos">
                    <tr>
                         <td>

                            <g:if test="${tiposDocumentosMae.size() > 0}">
                                <elm:textoBusqueda busca="${params.search}">
                                    <g:fieldValue bean="${documentos}" field="nombre"/>
                                </elm:textoBusqueda>
                            </g:if>
                            <g:else>
                            </g:else>
                        </td>
                        <td>
                            <g:set var="docs" value="${gaia.documentos.Documento.findAllByTipo(documentos, [sort: "inicio"])}"/>

                                <g:if test="${docs.size() > 0}">
                                    ${docs?.referencia?.last()}
                                </g:if>
                                <g:else>

                                </g:else>
                            %{--<elm:textoBusqueda busca="${params.search}">--}%
                                %{--<g:fieldValue bean="${documentos}" field=""/>--}%
                            %{--</elm:textoBusqueda>--}%
                        </td>
                        <td style="text-align: center">
                            <g:if test="${docs.size() > 0}">
                                ${docs?.inicio?.last().format("dd-MM-yyyy")}
                            </g:if>
                            <g:else>

                            </g:else>
                        </td>
                        <td style="text-align: center">
                            <g:if test="${docs.size() > 0}">
                                ${docs?.fin?.last()?.format("dd-MM-yyyy")}
                            </g:if>
                            <g:else>

                            </g:else>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
        <div role="tabpanel" class="tab-pane" id="arch">
            <table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">
                <thead>
                <tr>
                    <th style="width: 130px;">Tipo Documento</th>
                    <th style="width: 70px;"># Referencia</th>
                    <th style="width: 70px;">Emisión</th>
                    <th style="width: 70px;">Vencimiento</th>
                </tr>
                </thead>
                <tbody id="tb">
                <g:each in="${tiposDocumentosArch}" var="documentosArch">
                    <tr>
                        <td>

                            <g:if test="${tiposDocumentosArch.size() > 0}">
                                <elm:textoBusqueda busca="${params.search}">
                                    <g:fieldValue bean="${documentosArch}" field="nombre"/>
                                </elm:textoBusqueda>
                            </g:if>
                            <g:else>
                            </g:else>
                        </td>
                        <td>
                            <g:set var="docsArch" value="${gaia.documentos.Documento.findAllByTipo(documentosArch, [sort: "inicio"])}"/>

                            <g:if test="${docsArch.size() > 0}">
                                ${docsArch?.referencia?.last()}
                            </g:if>
                            <g:else>

                            </g:else>
                            %{--<elm:textoBusqueda busca="${params.search}">--}%
                            %{--<g:fieldValue bean="${documentos}" field=""/>--}%
                            %{--</elm:textoBusqueda>--}%
                        </td>
                        <td style="text-align: center">
                            <g:if test="${docsArch.size() > 0}">
                                ${docsArch?.inicio?.last()?.format("dd-MM-yyyy")}
                            </g:if>
                            <g:else>

                            </g:else>
                        </td>
                        <td style="text-align: center">
                            <g:if test="${docsArch.size() > 0}">
                                ${docsArch?.fin?.last()?.format("dd-MM-yyyy")}
                            </g:if>
                            <g:else>

                            </g:else>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
        </div>
    </div>

</body>
</html>