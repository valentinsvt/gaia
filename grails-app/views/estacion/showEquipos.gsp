<table class="table table-bordered table-hover table-striped">
    <thead>
    <tr>
        <th>Producto</th>
        <th>Tanque</th>
        <th>Capacidad</th>
        <th>Surtidor</th>
        <th>Manguera</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${mangueras}" var="m">
        <tr>
            <td>${m.tanque.descripcion}</td>
            <td>${m.tanque}</td>
            <td style="text-align: center">${m.tanque.capacidad}</td>
            <td>${m.surtidor}</td>
            <td>${m.codigo}</td>
        </tr>
    </g:each>
    </tbody>
</table>