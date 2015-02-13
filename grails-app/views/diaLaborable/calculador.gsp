<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 12/02/2015
  Time: 19:07
--%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <meta charset="UTF-8">
        <title>Calculador de días laborables</title>

        <style type="text/css">
        .respuesta {
            margin-top    : 10px;
            margin-bottom : 0;
        }
        </style>

    </head>

    <body>
        <div class="row">
            <div class="col-md-6 col-xs-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            Días laborables entre 2 fechas
                        </h3>
                    </div>

                    <div class="panel-body">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label for="fecha1" class="col-sm-2 control-label">Fecha 1</label>

                                <div class="col-sm-4">
                                    <elm:datepicker name="fecha1" class="form-control input-sm" daysOfWeekDisabled="[0, 6]"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="fecha2" class="col-sm-2 control-label">Fecha 2</label>

                                <div class="col-sm-4">
                                    <elm:datepicker name="fecha2" class="form-control input-sm" daysOfWeekDisabled="[0, 6]"/>
                                </div>
                            </div>
                        </form>

                        <div class="alert alert-info respuesta hidden" id="respuestaEntre">
                            Respuesta aqui
                        </div>
                    </div>

                    <div class="panel-footer">
                        <a href="#" id="btnCalcEntre" class="btn btn-primary">
                            <i class="fa fa-calculator"></i> Calcular
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-xs-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            Fecha <em>n</em> días laborables después
                        </h3>
                    </div>

                    <div class="panel-body">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label for="fecha" class="col-sm-2 control-label">Fecha 1</label>

                                <div class="col-sm-4">
                                    <elm:datepicker name="fecha" class="form-control input-sm" daysOfWeekDisabled="[0, 6]"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="dias" class="col-sm-2 control-label">Días</label>

                                <div class="col-sm-4">
                                    <g:field type="number" class="form-control input-sm digits" name="dias"/>
                                </div>
                            </div>
                        </form>

                        <div class="alert alert-info respuesta hidden" id="respuestaDias">
                            Respuesta aqui
                        </div>
                    </div>

                    <div class="panel-footer">
                        <a href="#" id="btnCalcDias" class="btn btn-primary">
                            <i class="fa fa-calculator"></i> Calcular
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(function () {
                $("#btnCalcEntre").click(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action: 'calcEntre_ajax')}",
                        data    : {
                            fecha1 : $("#fecha1_input").val(),
                            fecha2 : $("#fecha2_input").val()
                        },
                        success : function (msg) {
                            var obj = $.parseJSON(msg);
                            if (obj[0]) {
                                var html = "<div>Hay " + obj[1] + " días laborables</div>";
                                html += obj[2];
                                $("#respuestaEntre").removeClass("alert-error").addClass("alert-success").html(html).removeClass("hidden");
                            } else {
                                $("#respuestaEntre").removeClass("alert-success").addClass("alert-error").html(obj[1]).removeClass("hidden");
                            }
                        }
                    });
                    return false;
                });
                $("#btnCalcDias").click(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action: 'calcDias_ajax')}",
                        data    : {
                            fecha : $("#fecha_input").val(),
                            dias  : $("#dias").val()
                        },
                        success : function (msg) {
                            var obj = $.parseJSON(msg);
                            if (obj[0]) {
                                var html = "<div>La fecha es " + obj[2] + "</div>";
                                html += obj[3];
                                $("#respuestaDias").removeClass("alert-error").addClass("alert-success").html(html).removeClass("hidden");
                            } else {
                                $("#respuestaDias").removeClass("alert-success").addClass("alert-error").html(obj[1]).removeClass("hidden");
                            }
                        }
                    });
                    return false;
                });
            });
        </script>
    </body>
</html>