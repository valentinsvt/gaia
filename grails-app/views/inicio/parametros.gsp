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
            <div class="col-md-5">

            %{--<div class="panel panel-primary">--}%
            %{--<div class="panel-heading">--}%
            %{--<h3 class="panel-title">Parámetros del Sistema</h3>--}%
            %{--</div>--}%

            %{--<div class="panel-body">--}%
                <elm:container tipo="horizontal" titulo="Parámetros del Sistema">
                    <ul class="fa-ul">
                        <li>
                            <i class="fa-li fa fa-server text-info"></i>
                            <g:link class="over" controller="entidad" action="list">
                                Entidades
                            </g:link>

                            <div class="descripcion hidden">
                            <h4><i class=" fa fa-server fa-2x"></i> Entidades</h4>

                                <p>Listado de las entidades de control ambiental</p>
                            </div>
                        </li>
                        <li>
                            <i class="fa-li fa fa-file-archive-o text-info"></i>
                            <g:link class="over" controller="tipoDocumento" action="list">
                                Tipos de Documentos
                            </g:link>

                            <div class="descripcion hidden">
                                   <h4><i class="fa fa-file-archive-o fa-2x"></i> Tipos de Documentos</h4>

                                <p>Listado de los diferentes Tipos de Documentos que se encuentran en el sistema</p>
                            </div>
                        </li>
                        <li>
                            <i class="fa-li fa fa-server text-info"></i>
                            <g:link class="over" controller="dependencia" action="list">
                                Dependencias
                            </g:link>

                            <div class="descripcion hidden">
                                <h4><i class=" fa fa-server fa-2x"></i> Dependencias</h4>

                                <p>Listado de Dependencias</p>
                            </div>
                        </li>
                        <li>
                            %{--<i class="fa-li fa fa-check-square-o text-info"></i>--}%
                            <i class="fa-li fa fa-street-view text-info"></i>
                            <g:link class="over" controller="consultor" action="list">
                                Consultores
                            </g:link>

                            <div class="descripcion hidden">
                                %{--<h4><i class="fa fa-check-square-o fa-2x "></i> Consultores</h4>--}%
                                <h4><i class=" fa fa-street-view fa-2x"></i> Consultores</h4>

                                <p>Listado de Consultores</p>
                            </div>
                        </li>
                        <li>
                            %{--<i class="fa-li fa fa-server text-info"></i>--}%
                            <i class="fa-li fa fa-street-view text-info"></i>
                            <g:link class="over" controller="inspector" action="list">
                                Inspectores
                            </g:link>

                            <div class="descripcion hidden">
                                %{--<h4><i class=" fa fa-server fa-2x"></i> Inspectores</h4>--}%
                                <h4><i class=" fa fa-street-view fa-2x"></i> Inspectores</h4>

                                <p>Listado de Inspectores</p>
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