<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Solicitudes pendientes de aprobación</title>
</head>

<body>
<div class="btn-toolbar toolbar" style="margin-top: 0px;margin-bottom: 10;margin-left: -20px">
    <div class="btn-group">
        <g:link controller="uniformes" action="listaSemaforos" class="btn btn-default">
            <i class="fa fa-list"></i> Estaciones
        </g:link>
    </div>
</div>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<elm:container titulo="Solicitudes pendientes de aprobación">
    <div class="row">
        <div class="col-md-10">
            <table class="table table-striped table-bordered">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Fecha</th>
                    <th>Estación</th>
                    <th>Supervisor</th>
                    <th>Observaciones</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${sols}" var="s" status="i">
                    <tr>
                        <td style="width: 30px;text-align: center">${i+1}</td>
                        <td style="text-align: center">${s.registro.format("dd-MM-yyyy")}</td>
                        <td>${s.estacion}</td>
                        <td>${s.supervisor.nombre}</td>
                        <td>${s.observaciones}</td>

                        <td style="width: 60px">
                            <g:link controller="solicitudes" action="revisar" params="[pedido:s.id]"  class="btn btn-info btn-sm" iden="${s.id}">
                                <i class="fa fa-check"></i> Revisar
                            </g:link>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>

</elm:container>
</body>
</html>