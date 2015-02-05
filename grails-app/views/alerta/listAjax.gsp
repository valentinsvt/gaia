<div class="titulo-alertas">
<i class="fa fa-warning"></i>    Alertas del usuario ${session.usuario }
</div>
<table class="table table-condensed table-bordered table-striped table-hover" style="font-size: 11px">
    <thead>
    <tr>
        <th>Fecha</th>
        <th>Mensaje</th>
        <th>Link</th>
    </tr>
    </thead>
    <tbody>
    <g:if test="${alertaInstanceCount > 0}">
        <g:each in="${alertaInstanceList}" status="i" var="alertaInstance">
            <tr>

                <td style="text-align: center"><g:formatDate date="${alertaInstance.fechaEnvio}" format="dd-MM-yyyy"/></td>
                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${alertaInstance}" field="mensaje"/></elm:textoBusqueda></td>
                <td class="text-center">
                    <g:link  controller="alerta" action="showAlerta" id="${alertaInstance.id}" class="btn btn-warning btn-sm">IR</g:link>
                </td>
            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr class="danger">
            <td class="text-center" colspan="8">
                <g:if test="${params.search && params.search != ''}">
                    No se encontraron resultados para su búsqueda
                </g:if>
                <g:else>
                    No se encontraron registros que mostrar
                </g:else>
            </td>
        </tr>
    </g:else>
    </tbody>
</table>