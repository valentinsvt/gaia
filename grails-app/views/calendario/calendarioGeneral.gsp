<%--
  Created by IntelliJ IDEA.
  User: Luz
  Date: 2/10/2015
  Time: 12:46 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <imp:js src="${resource(dir: 'js/plugins/fullcalendar-2.2.6', file: 'fullcalendar.min.js')}"/>
        <imp:js src="${resource(dir: 'js/plugins/fullcalendar-2.2.6/lang', file: 'es.js')}"/>
        <imp:css src="${resource(dir: 'js/plugins/fullcalendar-2.2.6', file: 'fullcalendar.min.css')}"/>
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
            padding : 5px;
        }
        </style>

    </head>

    <body>

        <div class="leyenda corner-right">
            <div data-hide="creado" data-tipo="registrados" class="leyendaItem creado corner-top-right showing" title="Ocultar registrados">Registrado</div>

            <div data-hide="porCaducar" data-tipo="por caducar" class="leyendaItem porCaducar showing" title="Ocultar por caducar">Por caducar</div>

            <div data-hide="caducado" data-tipo="caducados" class="leyendaItem caducado corner-bottom-right showing" title="Ocultar caducados  ">Caducado</div>
        </div>

        <div id='calendar'></div>

        <script type="text/javascript">
            var show = {
                creado     : true,
                porCaducar : true,
                caducado   : true
            };

            $(function () {

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
                        {
                            url       : '${createLink(controller: "calendario", action: "documentosCreadosGeneral_ajax")}', // use the `url` property
                            type      : 'POST',
                            data      : function () {
                                return {show : show.creado};
                            },
                            error     : function () {
                                alert('there was an error while fetching events!');
                            },
                            className : "doc creado"
                        },
                        {
                            url       : '${createLink(controller: "calendario", action: "documentosPorCaducarGeneral_ajax")}', // use the `url` property
                            type      : 'POST',
                            data      : function () {
                                return {show : show.porCaducar};
                            },
                            error     : function () {
                                alert('there was an error while fetching events!');
                            },
                            className : "doc porCaducar"
                        },
                        {
                            url       : '${createLink(controller: "calendario", action: "documentosCaducadosGeneral_ajax")}', // use the `url` property
                            type      : 'POST',
                            data      : function () {
                                return  {show : show.caducado};
                            },
                            error     : function () {
                                alert('there was an error while fetching events!');
                            },
                            className : "doc caducado"
                        }
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