<table class="table table-striped  table-bordered">
    <thead>
    <tr class="cabecera">
        <th colspan="7">
            Detalle del pedido
        </th>
    </tr>
    <tr class="tbody">
        <th>Cédula</th>
        <th>Nombre</th>
        <th>Sexo</th>
        <th>Uniforme</th>
        <th>Talla</th>
        <th>Cantidad</th>
        <th></th>
    </tr>
    </thead>
    <tbody class="tbody">
    <g:set var="total" value="${0}"></g:set>
    <g:each in="${detalle}" var="s" status="i">
        <tr>
            <td>${s.empleado.cedula}</td>
            <td>${s.empleado.nombre}</td>
            <td>${s.empleado.sexo}</td>
            <td style="font-size: 11px">${s.uniforme.descripcion}</td>
            <td>${s.talla.talla}</td>
            <td style="text-align: right">${s.cantidad}</td>
            <td style="text-align: center;width: 40px">
                <a href="#" class="btn btn-danger borrar btn-sm" title="borrar" iden="${s.id}">
                    <i class="fa fa-trash"></i>
                </a>
            </td>
        </tr>
    </g:each>
    </tbody>

</table>