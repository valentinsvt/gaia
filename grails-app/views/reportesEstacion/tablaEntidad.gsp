<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 16/03/2015
  Time: 0:34
--%>
%{--<g:each in="${entidad}" var="tabla">--}%
    %{----}%
%{--</g:each>--}%
%{--<table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">--}%
    %{--<thead>--}%
    %{--<tr>--}%
        %{--<th style="width: 130px;">Tipo Documento</th>--}%
        %{--<th style="width: 70px;"># Referencia</th>--}%
        %{--<th style="width: 70px;">Emisión</th>--}%
        %{--<th style="width: 70px;">Vencimiento</th>--}%
    %{--</tr>--}%
    %{--</thead>--}%
    %{--<tbody>--}%
    <g:each in="${tipos}" var="tipo">
        <tr>

            <td>
                ${tipo?.tipo?.entidad?.nombre}
            </td>
            <td>

                <g:if test="${tipos.size() > 0}">
                ${tipo?.tipo?.nombre}
                </g:if>
                <g:else>
                </g:else>
            </td>
            <td>
                <g:set var="docs" value="${gaia.documentos.Documento.findAllByTipo(tipo?.tipo, [sort: "inicio"])}"/>

                %{--<g:if test="${docs.size() > 0}">--}%
                    %{--${docs?.referencia?.last()}--}%
                %{--</g:if>--}%
                %{--<g:else>--}%

                %{--</g:else>--}%
            ${tipo?.referencia}


            </td>
            <td style="text-align: center">
                %{--<g:if test="${docs.size() > 0}">--}%
                    %{--${docs?.inicio?.last().format("dd-MM-yyyy")}--}%
                %{--</g:if>--}%
                %{--<g:else>--}%

                %{--</g:else>--}%
                ${tipo?.inicio?.format("dd-MM-yyyy")}

            </td>
            <td style="text-align: center">
                %{--<g:if test="${docs.size() > 0}">--}%
                    %{--${docs?.fin?.last()?.format("dd-MM-yyyy")}--}%
                %{--</g:if>--}%
                %{--<g:else>--}%

                %{--</g:else>--}%
                ${tipo?.fin?.format("dd-MM-yyyy")}
            </td>
        </tr>
    </g:each>
    %{--</tbody>--}%
%{--</table>--}%