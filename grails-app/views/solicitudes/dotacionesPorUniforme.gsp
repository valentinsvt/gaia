<table class="table table-bordered table-striped table-hover" style="font-size: 11px">
    <thead>
    <tr>
        <th style="width: 150px">Supervisor</th>
        <g:each in="${tallas}" var="u">
            <th>${u.talla}</th>
        </g:each>
        <th>Total</th>
    </tr>
    </thead>
    <tbody>

    <g:each in="${datos}" var="d" status="i">
        <g:set var="totH" value="${0}"/>
        <tr>
            <td style="font-weight: ${i==datos.size()-1?'bold':'normal'}">${d.key}</td>
            <g:each in="${d.value}" var="sd">
                <td style="font-weight: ${i==datos.size()-1?'bold':'normal'};text-align: right">${sd.value}</td>
                <g:set var="totH" value="${totH+sd.value}"/>
            </g:each>
            <td style="text-align: right">
                ${totH}
            </td>
        </tr>
    </g:each>
    </tbody>
</table>
<p style="font-weight: bold;">TOTAL ${uniforme}: ${total}</p>