<p style="font-weight: bold;">SUPERVISOR: ${supervisor.nombre}</p>
<table class="table table-bordered table-hover" style="font-size: 11px">
    <thead>
    <tr>
        <th>Estación</th>
        <th>Uniforme</th>
        <th>Talla</th>
        <th>Cantidad</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="lastEstacion" value="${null}"></g:set>
    <g:each in="${datos}" var="d" >
        <g:set var="lastUniforme" value="${null}"></g:set>
        <g:each in="${d.value}" var="u">
            <g:each in="${u.value}" var="t">
                <tr>
                    <g:if test="${lastEstacion!=d.key}">
                        <td style="font-weight: bold">${d.key}</td>
                        <g:set var="lastEstacion" value="${d.key}"></g:set>
                    </g:if>
                    <g:else>
                        <td></td>
                    </g:else>
                    <g:if test="${lastUniforme!=u.key}">
                        <td style="font-weight: bold">${u.key}</td>
                        <g:set var="lastUniforme" value="${u.key}"></g:set>
                    </g:if>
                    <g:else>
                        <td></td>
                    </g:else>
                    <td style="text-align: center">${t.key}</td>
                    <td style="text-align: right">${t.value}</td>
                </tr>
            </g:each>
        </g:each>
    </g:each>
    </tbody>
</table>
