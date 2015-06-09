<table class="table table-bordered table-striped" id="tbl" style="font-size: 11px;">
    <thead>
    <tr>
        <th colspan="6">Pintura estaciones de servicio existentes</th>
    </tr>
    <tr>
        <th>Código</th>
        <th>Estación</th>
        <th>Fecha</th>
        <th>M<sup>2</sup></th>
        <th>Valor</th>
        <th>Autorización</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="total" value="${0}"></g:set>
    <g:set var="totalMetros" value="${0}"></g:set>
    <g:each in="${datos}" var="d">
        <g:set var="totalMetros" value="${totalMetros+d.value['M2']}"></g:set>
        <g:set var="total" value="${total+d.value['Pintura']}"></g:set>
        <tr>
            <td>${d.value["codigo"]}</td>
            <td>${d.value["estacion"]}</td>
            <td style="text-align: center">${d.value["fecha"]?.format("dd-MM-yyyy")}</td>
            <td style="text-align: right">
                <g:formatNumber number="${d.value['M2']}" minFractionDigits="2" maxFractionDigits="2"></g:formatNumber> M<sup>2</sup>
            </td>
            <td style="text-align: right">
                <g:formatNumber number="${d.value['Pintura']}" minFractionDigits="2" maxFractionDigits="2"></g:formatNumber>
            </td>
            <td style="text-align: center">${d.value["Autorización"]}</td>
        </tr>
    </g:each>
    </tbody>
    <tfoot style="font-weight: bold">
    <tr>
        <td colspan="3">TOTAL</td>
        <td style="text-align: right">
            <g:formatNumber number="${totalMetros}" minFractionDigits="2" maxFractionDigits="2"></g:formatNumber> M<sup>2</sup>
        </td>
        <td style="text-align: right">
            <g:formatNumber number="${total}" minFractionDigits="2" maxFractionDigits="2"></g:formatNumber>
        </td>
        <td style="text-align: right"></td>
    </tr>
    </tfoot>
</table>