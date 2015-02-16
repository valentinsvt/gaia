<%--
  Created by IntelliJ IDEA.
  User: Luz
  Date: 2/10/2015
  Time: 12:46 AM
--%>

<%@ page import="gaia.documentos.TipoDocumento; gaia.documentos.Dashboard; gaia.estaciones.Estacion" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <imp:js src="${resource(dir: 'js/plugins/fullcalendar-2.2.6', file: 'fullcalendar.min.js')}"/>
        <imp:js src="${resource(dir: 'js/plugins/fullcalendar-2.2.6/lang', file: 'es.js')}"/>
        <imp:css src="${resource(dir: 'js/plugins/fullcalendar-2.2.6', file: 'fullcalendar.min.css')}"/>

        <imp:js src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"/>
        <imp:css src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.min.css')}"/>

        <meta name="layout" content="main">

        <title>Calendario general</title>


        <style type="text/css">
        .creado, .porCaducar, .caducado {
            cursor  : pointer;
            padding : 3px;
        }

        .creado {
            background : #3859A3;
            color      : white;
            border     : #3859A3;
        }

        .porCaducar {
            background : #FFA324;
            color      : white;
            border     : #FFA324;
        }

        .caducado {
            background : #ce464a;
            color      : white;
            border     : #ce464a;
        }

        .leyenda {
            position : fixed;
            top      : 150px;
            left     : 0;
            border   : solid 1px #999;
            padding  : 5px 5px 5px 0;
        }

        .leyendaItem {
            /*cursor  : default;*/
            /*padding : 5px;*/
        }
        </style>

    </head>

    <body>

        <div class="btn-toolbar" role="toolbar" style="margin-bottom: 10px;">
            <div class="btn-group" data-toggle="buttons">
                <label class="btn btn-azul active leyendaItem showing"
                       data-hide="creado" data-tipo="registrados" title="Ocultar registrados">
                    <input type="checkbox" autocomplete="off" checked> Registrado
                </label>
                <label class="btn btn-amarillo active leyendaItem showing"
                       data-hide="porCaducar" data-tipo="por caducar" title="Ocultar por caducar">
                    <input type="checkbox" autocomplete="off" checked> Por caducar
                </label>
                <label class="btn btn-rojo active leyendaItem showing"
                       data-hide="caducado" data-tipo="caducados" title="Ocultar caducados">
                    <input type="checkbox" autocomplete="off" checked> Caducado
                </label>
            </div>

            <div class="btn-group" role="group">
                <g:select name="est" from="${Dashboard.list().estacion.sort {
                    it.nombre
                }}" optionKey="codigo" optionValue="nombre" noSelection="['': 'Todas las estaciones']"
                          class="selectFiltro corner-left" data-live-search="true" data-width="150px"/>
                <a href="#" class="btn btn-info btnFiltro" style="float:right;">
                    <i class="fa fa-exchange"></i> Cambiar
                </a>
            </div>

            <div class="btn-group" role="group">
                <g:select name="td" from="${TipoDocumento.list(sort: 'nombre')}" optionKey="id" optionValue="nombre"
                          noSelection="['': 'Todos los tipos de documento']" data-width="150px"
                          class="selectFiltro corner-left" data-live-search="true"/>
                <a href="#" class="btn btn-info btnFiltro" style="float:right;">
                    <i class="fa fa-exchange"></i> Cambiar
                </a>
            </div>
        </div>

        <div id='calendar'></div>

        <script type="text/javascript">
            var show = {
                creado     : true,
                porCaducar : true,
                caducado   : true
            };

            function sourceEventos(url, tipo) {
                return {
                    url       : url,
                    type      : 'POST',
                    data      : function () {
                        return {
                            show : show[tipo],
                            est  : $("#est").val(),
                            td   : $("#td").val()
                        };
                    },
                    error     : function () {
                        alert('there was an error while fetching events!');
                    },
                    className : "doc " + tipo
                };
            }

            $(function () {

                $(".selectFiltro").selectpicker({
                    specialStyle : "border-top-left-radius:4px; border-bottom-left-radius:4px;"
                });

                $(".btnFiltro").click(function () {
                    $('#calendar').fullCalendar('refetchEvents');
                });

                $(".leyendaItem").click(function () {
                    var $this = $(this);
                    var hide = $this.data("hide");
                    var tipo = $this.data("tipo");
                    var showing = $this.hasClass("showing");
                    if (showing) {
//                        $(".doc." + hide).addClass("hidden");
                        $this.removeClass("showing");
                        $this.attr("title", "Mostrar " + tipo);
                        show[hide] = false;
                    } else {
//                        $(".doc." + hide).removeClass("hidden");
                        $this.addClass("showing");
                        $this.attr("title", "Ocultar " + tipo);
                        show[hide] = true;
                    }
                    $('#calendar').fullCalendar('refetchEvents');
                });

                $('#calendar').fullCalendar({
                    header       : {
                        left   : 'prev,next today',
                        center : 'title',
                        right  : ''
                    },
                    aspectRatio  : 2,
                    defaultDate  : '${fecha}',
                    eventRender  : function (event, element, view) {
                        element.find('span.fc-title').html(element.find('span.fc-title').text());
                    },
                    eventSources : [
                        sourceEventos('${createLink(controller: "calendario", action: "documentosCreadosGeneral_ajax")}',
                                "creado"),
                        sourceEventos('${createLink(controller: "calendario", action: "documentosPorCaducarGeneral_ajax")}',
                                "porCaducar"),
                        sourceEventos('${createLink(controller: "calendario", action: "documentosCaducadosGeneral_ajax")}',
                                "caducado")
                    ],
                    eventClick   : function (calEvent, jsEvent, view) {
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(controller:'documento', action:'verDetalles_ajax')}",
                            data    : {
                                id : calEvent.id
                            },
                            success : function (msg) {
                                var b = bootbox.dialog({
                                    id      : "dlgShowDoc",
                                    title   : "Documento",
                                    message : msg,
                                    buttons : {
                                        cerrar : {
                                            label     : "Cerrar",
                                            className : "btn-primary",
                                            callback  : function () {
                                            }
                                        }
                                    } //buttons
                                }); //dialog
                                setTimeout(function () {
                                    b.find(".form-control").first().focus()
                                }, 500);
                            } //success
                        }); //ajax
                    }
                });
            });
        </script>
    </body>
</html>