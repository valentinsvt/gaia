<table class="table table-bordered table-condensed table-hover table-striped">
    <thead>
    <tr>
        <th colspan="6">Reporte de pintura y mantenimiento por Item</th>
    </tr>
    <tr>
        <th>#</th>
        <th>Estación</th>
        <th>Fecha</th>
        <th>Item</th>
        <th>Factura</th>
        <th>Valor</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="total" value="${0}"></g:set>
    <g:each in="${datos}" var="d" status="i">
        <g:set var="total" value="${total+d['sub'].total}"></g:set>
        <tr>
            <td style="text-align: center;width: 30px;">${i+1}</td>
            <td>${d["estacion"]}</td>
            <td>${d.fecha?.format("dd-MM-yyyy")}</td>
            <td>${d["sub"].item.descripcion}</td>
            <td>${d.factura}</td>
            <td style="text-align: right">${d['sub'].total}</td>
        </tr>
    </g:each>
    <tr>
        <th style="font-weight: bold" colspan="5">Total</th>
        <th style="font-weight: bold;text-align: right"><g:formatNumber number="${total}" type="currency" ></g:formatNumber></th>
    </tr>
    </tbody>
</table>