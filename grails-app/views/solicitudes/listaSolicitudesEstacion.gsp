<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Solicitudes de dotación de la estación ${estacion.nombre}</title>
</head>

<body>
<div class="btn-toolbar toolbar" style="margin-top: 0px;margin-bottom: 10;margin-left: -20px">
    <div class="btn-group">
        <g:link controller="uniformes" action="listaSemaforos" class="btn btn-default">
            <i class="fa fa-list"></i> Estaciones
        </g:link>
        <g:link controller="uniformes" action="empleados" class="btn btn-default">
            <i class="fa fa-group"></i> Empleados
        </g:link>
        <g:link controller="solicitudes" action="solicitar" id="${estacion.codigo}" class="btn btn-default">
            <i class="fa fa-file-archive-o"></i> Nueva solicitud
        </g:link>
    </div>
</div>
<elm:container titulo="Historial de solicitudes de dotación de la estación ${estacion.nombre}">
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
                    <th>Estado</th>
                    <th></th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${solicitudes}" var="s" status="i">
                    <tr>
                        <td style="width: 30px">${i+1}</td>
                        <td>${s.registro.format("dd-MM-yyyy")}</td>
                        <td>${s.estacion}</td>
                        <td>${s.supervisor.nombre}</td>
                        <td>${s.observaciones}</td>
                        <td>
                            <g:if test="${s.estado=='A'}">
                                Aprobado
                            </g:if>
                            <g:if test="${s.estado=='N'}">
                                Negado
                            </g:if>
                            <g:if test="${s.estado=='S'}">
                                Pendiente de aprobación
                            </g:if>
                            <g:if test="${s.estado=='P'}">
                                Pendiente de envío
                            </g:if>
                        </td>
                        <td style="width: 60px">
                            <g:link controller="solicitudes" action="verSolicitud" params="[pedido:s.id]"  class="btn btn-info btn-sm" iden="${s.id}">
                                <i class="fa fa-search"></i> Ver
                            </g:link>
                        </td>
                        <td style="width: 60px">
                            <g:if test="${s.estado=='P'}">
                                <g:link controller="solicitudes" action="detalle" params="[id:estacion.codigo,pedido:s.id]"  class="btn btn-info btn-sm" iden="${s.id}">
                                    <i class="fa fa-pencil"></i> Editar
                                </g:link>
                            </g:if>
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