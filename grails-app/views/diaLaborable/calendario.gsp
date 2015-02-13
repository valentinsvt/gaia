<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 12/02/2015
  Time: 19:08
--%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <meta charset="UTF-8">
        <title>Días laborables</title>

        <style type="text/css">
        h1 {
            text-align : center;
        }

        div.mes {
            height : 225px;
        }

        div.mes table td {
            text-align : center;
        }

        .dia {
            cursor : pointer;
        }
        </style>

    </head>

    <body>

        <h1>
            <form class="form-inline">
                <div class="form-group">
                    <label for="anio">Año</label>
                    <g:select style="width: auto; font-size: large;" name="anio" class="form-control input-lg"
                              from="${anio - 3..anio + 5}" value="${params.anio}"/>
                </div>
                <a href="#" class="btn btn-primary" id="btnCambiar">
                    <i class="fa fa-exchange"></i> Cambiar
                </a>
                <a href="#" class="btn btn-success" id="btnGuardar">
                    <i class="fa fa-save"></i> Guardar
                </a>
            </form>
        </h1>

        <div class="alert alert-info">
            Los días marcados con <span class="svt-bg-warning" style="padding: 0 3px;">1</span> son no laborables. <br/>
            Para cambiar el estado de un día haga cilck sobre el mismo.<br/>
            Los cambios se guardarán únicamente haciendo click en el botón "Guardar".
        </div>

        <g:set var="mesAct" value="${null}"/>
        <g:each in="${dias}" var="dia" status="i">
            <g:set var="mes" value="${meses[dia.fecha.format('MM').toInteger()]}"/>
            <g:set var="dia" value="${meses[dia.fecha.format('MM').toInteger()]}"/>
            <g:if test="${mes != mesAct}">
                <g:if test="${mesAct}">
                    </table>
                    </div>
                </g:if>
                <g:set var="mesAct" value="${mes}"/>
                <g:set var="num" value="${1}"/>
                <div class="col-md-3 col-xs-6 mes">
                <table class="table table-bordered table-condensed" >
                <thead>
                <tr>
                <th class="nombreMes" colspan="7">${mesAct}</th>
                </tr>
                <tr>
                    <th>Lun</th>
                    <th>Mar</th>
                    <th>Mié</th>
                    <th>Jue</th>
                    <th>Vie</th>
                    <th>Sáb</th>
                    <th>Dom</th>
                </tr>
                </thead>
            </g:if>
            <g:if test="${num % 7 == 1}">
                <tr>
            </g:if>
            <g:if test="${dia.fecha.format("dd").toInteger() == 1}">
                <g:if test="${dia.dia.toInteger() != 1}">%{--No empieza en lunes: hay q dibujar celdas vacias en los dias necesarios--}%
                    <g:each in="${1..(dia.dia.toInteger() - 1 + (dia.dia.toInteger() > 0 ? 0 : 7))}" var="extra">
                        <td class="disabled"></td>
                        <g:set var="num" value="${num + 1}"/>
                    </g:each>
                </g:if>
            </g:if>
            <td class="dia ${dia.ordinal == 0 ? 'svt-bg-warning' : ''}" data-fecha="${dia.fecha.format('dd-MM-yyyy')}" data-id="${dia.id}">
                ${dia.fecha.format("dd")}
            </td>

            <g:set var="num" value="${num + 1}"/>

            <g:if test="${i == dias.size() - 1 || (i < dias.size() - 1) && (meses[dias[i + 1].fecha.format('MM').toInteger()] != mesAct)}">
                <g:if test="${dia.dia.toInteger() != 0}">
                    <g:each in="${1..7 - (num % 7 > 0 ? num % 7 : 7) + 1}" var="extra">
                        <td class="disabled"></td>
                    </g:each>
                </g:if>
            </g:if>
        </g:each>
    </table>
    </div>

        <script type="application/javascript">
            $(function () {
                $('.dia').click(function () {
                    $(this).toggleClass("svt-bg-warning");
                }).hover(function () {
                    $(this).addClass("active");
                }, function () {
                    $(this).removeClass("active");
                });
                $("#anio").val("${params.anio}");

                $("#btnCambiar").click(function () {
                    var anio = $("#anio").val();
                    if ("" + anio != "${params.anio}") {
                        openLoader("Cargando año " + anio);
                        location.href = "${createLink(action: 'calendario')}?anio=" + anio;
                    }
                    return false;
                });

                $("#btnGuardar").click(function () {
                    openLoader("Guardando cambios");
                    var cont = 1;
                    var data = "";
                    $(".dia").each(function () {
                        var $dia = $(this);
                        var fecha = $dia.data("fecha");
                        var id = $dia.data("id");
                        var laborable = !$dia.hasClass("svt-bg-warning");
                        if (data != "") {
                            data += "&";
                        }
                        data += "dia=" + id + ":" + fecha + ":";
                        if (laborable) {
                            data += cont;
                            cont++;
                        } else {
                            data += "0";
                        }
                    });
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action: 'saveCalendario_ajax')}",
                        data    : data,
                        success : function (msg) {
                            if (msg == "OK") {
                                location.reload(true);
                            } else {
                                bootbox.alert(msg, function () {
                                    openLoader();
                                    location.reload(true);
                                });
                            }
                        }
                    });
                    return false;
                });
            });
        </script>

    </body>
</html>