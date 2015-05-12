<div class="row">
    <div class="col-md-12" style="height: 400px;overflow: auto">
        <table class="table table-condensed table-striped">
            <thead>
            <tr>
                <th>Sistema</th>
                <th>Módulo</th>
                <th>Acción</th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${acciones}" var="a">
                <tr>
                    <td><i class="fa ${a.sistema.imagen}"></i> ${a.sistema.nombre}</td>
                    <td><i class="fa ${a.modulo.icono}"></i> ${a.modulo.nombre}</td>
                    <td><i class="fa ${a.icono}"></i> ${a.descripcion}</td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
</div>
