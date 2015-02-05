<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Parámetros</title>

        <style type="text/css">
        .fa-ul li {
            margin : 5px;
        }
        </style>
    </head>

    <body>

        <div class="row">
            <div class="col-md-8">

            %{--<div class="panel panel-primary">--}%
            %{--<div class="panel-heading">--}%
            %{--<h3 class="panel-title">Parámetros del Sistema</h3>--}%
            %{--</div>--}%

            %{--<div class="panel-body">--}%
                <elm:container tipo="horizontal" titulo="Parámetros del Sistema">
                    <ul class="fa-ul">
                        <li>
                            <i class="fa-li fa fa-paint-brush text-info"></i>
                            <g:link class="over" controller="color" action="list">
                                Colores
                            </g:link>

                            <div class="descripcion hidden">
                                <h4><i class="fa fa-paint-brush fa-2x"></i> Colores</h4>

                                <p>Permite registrar diferentes colores para la descripción de items de la bodega</p>
                            </div>
                        </li>
                        <li>
                            <i class="fa-li fa fa-street-view text-info"></i>
                            <g:link class="over" controller="cargo" action="list">
                                Cargos
                            </g:link>

                            <div class="descripcion hidden">
                                <h4><i class=" fa fa-street-view fa-2x"></i> Cargos</h4>

                                <p>Permite registrar cargos para registrar funciones en los proyectos</p>
                            </div>
                        </li>
                        <li>
                            <i class="fa-li fa fa-file-archive-o text-info"></i>
                            <g:link class="over" controller="tipoSolicitud" action="list">
                                Tipos de solicitud
                            </g:link>

                            <div class="descripcion hidden">
                                <h4><i class="fa fa-file-archive-o fa-2x"></i> Tipos de solicitud</h4>

                                <p>Permite registrar los diferentes tipos de solicitud</p>
                            </div>
                        </li>
                        <li>
                            <i class="fa-li fa fa-check-square-o text-info"></i>
                            <g:link class="over" controller="estadoSolicitud" action="list">
                                Estados de solicitud
                            </g:link>

                            <div class="descripcion hidden">
                                <h4><i class="fa fa-check-square-o fa-2x "></i> Estados de solicitud</h4>

                                <p>Permite registrar los diferentes estados en los que puede estar una solicitud</p>
                            </div>
                        </li>
                        %{--<li>--}%
                        %{--<i class="fa-li fa flaticon-power30 text-info"></i>--}%
                        %{--<g:link class="over" controller="tipoItem" action="list">--}%
                        %{--Tipos de ítem--}%
                        %{--</g:link>--}%

                        %{--<div class="descripcion hidden">--}%
                        %{--<h4><i class="fa flaticon-power30 fa-2x "></i> Tipos de ítem</h4>--}%

                        %{--<p>Permite registrar los diferentes tipos de ítems</p>--}%
                        %{--</div>--}%
                        %{--</li>--}%
                        %{--<li>--}%
                        %{--<i class="fa-li fa flaticon-construction12 text-info"></i>--}%
                        %{--<g:link class="over" controller="tipoMaquinaria" action="list">--}%
                        %{--Tipos de maquinaria--}%
                        %{--</g:link>--}%

                        %{--<div class="descripcion hidden">--}%
                        %{--<h4><i class="fa flaticon-construction12 fa-2x "></i> Tipos de maquinaria</h4>--}%

                        %{--<p>Permite registrar los diferentes tipos de ítems</p>--}%
                        %{--</div>--}%
                        %{--</li>--}%
                        <li>
                            <i class="fa-li fa fa-server text-info"></i>
                            <g:link class="over" controller="unidad" action="list">
                                Unidades
                            </g:link>

                            <div class="descripcion hidden">
                                <h4><i class=" fa fa-server fa-2x"></i> Unidades</h4>

                                <p>Permite registrar las unidades para el inventario</p>
                            </div>
                        </li>
                    </ul>
                </elm:container>
            %{--</div>--}%
            %{--</div>--}%
            </div>

            <div class="col-md-4">
                <div class="panel panel-info right hidden">
                    <div class="panel-heading">
                        <h3 class="panel-title text-shadow"></h3>
                    </div>

                    <div class="panel-body">

                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(function () {
                $(".over").hover(function () {
                    var $h4 = $(this).siblings(".descripcion").find("h4");
                    var $cont = $(this).siblings(".descripcion").find("p");
                    $(".right").removeClass("hidden").find(".panel-title").html($h4.html()).end().find(".panel-body").html($cont.html());
                }, function () {
                    $(".right").addClass("hidden");
                });
            });
        </script>

    </body>
</html>