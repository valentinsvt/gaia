<table class="table table-striped table-bordered table-condensed table-hover">
    <thead>
    <tr>
        <th>Item</th>
        <th>Cantidad</th>
        <th>Valor <br> unitario</th>
        <th>Total</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="total" value="${0}"></g:set>
    <g:each in="${detalle}" var="d">
        <g:set var="total" value="${total+=d.total}"></g:set>
        <tr>
            <td>${d.item.descripcion}</td>
            <td style="text-align: right">${d.cantidad}</td>
            <td style="text-align: right">${d.unitario}</td>
            <td style="text-align: right">${d.total}</td>
        </tr>
    </g:each>
    <tr>
        <td colspan="3" style="font-weight: bold">TOTAL</td>
        <td style="text-align: right;font-weight: bold">${total.toDouble().round(2)}</td>
    </tr>
    </tbody>
</table>