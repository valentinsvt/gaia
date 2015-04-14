<%@ page import="gaia.Contratos.esicc.Tallas" %>
<table class="table table-striped table-bordered table-condensed table-hover">
    <thead>
    <tr>
        <th>Item</th>
        <th>Talla</th>
        <th>
            Cantidad<br>
            Solicitada
        </th>
        <th>
            Cantidad<br>
            Aprobada
        </th>
        <th>Valor <br> unitario</th>
        <th>Total</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="total" value="${0}"></g:set>
    <g:each in="${detalle}" var="d">
        <g:set var="total" value="${total+=d.cantidadAprobada*d.precio}"></g:set>
        <tr>
            <td>${d.uniforme.descripcion}</td>
            <td>${Tallas.findByCodigo(d.talla).talla}</td>
            <td style="text-align: right">${d.cantidadPedida}</td>
            <td style="text-align: right">${d.cantidadAprobada}</td>
            <td style="text-align: right">${d.precio}</td>
            <td style="text-align: right">${(d.cantidadAprobada*d.precio).toDouble().round(2)}</td>
        </tr>
    </g:each>
    <tr>
        <td colspan="5" style="font-weight: bold">TOTAL</td>
        <td style="text-align: right;font-weight: bold">${total.toDouble().round(2)}</td>
    </tr>
    </tbody>
</table>