<table class="table table-bordered table-striped">
    <thead>
    <tr>
        <th colspan="2">Detalle del kit: ${kit.nombre}</th>
    </tr>
    <tr>
        <th>Uniforme</th>
        <th>Cantidad</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${detalle}" var="d">
        <tr>
            <td>${d.uniforme.descripcion}</td>
            <td style="text-align: center">${d.cantidad}</td>
        </tr>
    </g:each>
    </tbody>
</table>