<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 15/03/2015
  Time: 23:03
--%>

%{--<table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">--}%
    %{--<thead>--}%
    %{--<tr>--}%
        %{--<th style="width: 100px;">Consultor</th>--}%
        %{--<th>Estación</th>--}%
        %{--<th>Documento</th>--}%
        %{--<th>N° Referencia</th>--}%
        %{--<th>Estado</th>--}%
        %{--<th>Emisión</th>--}%
        %{--<th>Vence</th>--}%


    %{--</tr>--}%
    %{--</thead>--}%
    %{--<tbody id="tb">--}%

    <g:each in="${documentos}" var="documento">
        <tr>
            <g:if test="${documento?.consultor?.nombre}">
                <td>
                    ${documento?.consultor?.nombre}
                </td>
                <td>
                    ${documento?.estacion?.nombre}
                </td>
                <td>
                    ${documento?.tipo?.nombre}
                </td>
                <td>
                    ${documento?.referencia}
                </td>
                <td>
                    <g:if test="${documento?.estado == "A"}">
                        Aprobado
                    </g:if>
                    <g:else>
                        No Aprobado
                    </g:else>

                </td>

                <td>
                    ${documento?.inicio?.format("dd-MM-yyyy")}
                </td>
                <td>
                    ${documento?.fin?.format("dd-MM-yyyy")}
                </td>


            </g:if>
        </tr>
    </g:each>

    %{--</tbody>--}%
%{--</table>--}%