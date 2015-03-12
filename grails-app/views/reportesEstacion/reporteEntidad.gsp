<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 07/03/2015
  Time: 0:29
--%>

<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 17/02/2015
  Time: 14:33
--%>
<%@ page import="gaia.UtilitariosTagLib" contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Documentos por Entidad</title>
    <rep:estilos orientacion="l" pagTitle="Documentos por entidad"/>

    <style type="text/css">
    .titulo, .proyecto, .componente {
        width : 16cm;
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

    /*td {*/
        /*padding : 3px;*/
        /*border  : 1px solid #fff*/
    /*}*/

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

<rep:headerFooter title="Documentos por entidad"/>

%{--<div role="tabpanel">--}%
    <!-- Nav tabs -->


    <!-- Tab panes -->
    %{--<div class="tab-content">--}%
        %{--<div role="tabpanel" class="tab-pane active" id="mae">--}%
        <fieldset>
    <legend>Ministerio del Ambiente</legend>
    </fieldset>
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
                <g:each in="${tiposDocumentosMae}" var="documentos" status="h">
                    <tr>
                        <td>
                            <g:if test="${tiposDocumentosMae.size() > 0}">
                                <util:clean str="${documentos?.nombre}"/>
                            </g:if>
                            <g:else>
                            </g:else>
                        </td>
                        <td>
                            <g:set var="docs" value="${gaia.documentos.Documento.findAllByTipo(documentos, [sort: "inicio"])}"/>

                            <g:if test="${docs.size() > 0}">
                                  <util:clean str="${docs?.referencia?.last()}"/>
                             </g:if>
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
<fieldset>
    <legend>Agencia de Regulación y Control Hidrocarburífero</legend>
</fieldset>
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
                            <util:clean str="${documentosArch?.nombre}"/>
                        </td>
                        <td>
                            <g:set var="docsArch" value="${gaia.documentos.Documento.findAllByTipo(documentosArch, [sort: "inicio"])}"/>

                            <g:if test="${docsArch.size() > 0}">
                                %{--${docsArch?.referencia?.last()}--}%
                                <util:clean str="${docsArch?.referencia?.last()}"/>

                            </g:if>
                            <g:else>

                            </g:else>

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

</body>
</html>