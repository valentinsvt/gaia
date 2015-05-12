<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Historial de la estación: ${estacion}, del supervisor: ${session.usuario}</title>
</head>

<body>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <g:link action="listaSemaforos" class="btn btn-default detalles btn-sm">
            <i class="fa fa-list"></i> Estaciones
        </g:link>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Historial de la estación: ${estacion}, del supervisor: ${session.usuario}">
<table class="table table-striped table-hover table-bordered" style="margin-top: 20px">
    <thead>
    <th>Estación</th>
    <th>Fecha</th>
    <th>Comentario</th>
    <th style="width: 40px"></th>
    </thead>
    <tbody>
    <g:each in="${analisis}" var="a">
        <tr>
            <td>${a.estacion.nombre}</td>
            <td style="text-align: center">${a.fecha?.format("dd-MM-yyyy")}</td>
            <td>${a.comentario}</td>
            <td style="text-align: center">
                <a href="${g.createLink(action: 'editarAnalisis',id: a.id)}"  title="Editar" class="editar btn btn-info btn-sm" iden="${a.id}">
                    <i class="fa fa-pencil"></i>
                </a>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>
</elm:container>

</body>
</html>