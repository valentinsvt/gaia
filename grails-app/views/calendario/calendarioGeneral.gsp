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
        .creado, .porCaducar {
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

        .leyenda {
            position : fixed;
            top      : 150px;
            left     : 0;
            border   : solid 1px #999;
            padding  : 5px;
        }

        .leyendaItem {
            cursor  : default;
            padding : 5px;
        }
        </style>

    </head>

    <body>

        <div class="leyenda corner-right">
            <div class="leyendaItem creado corner-top-right">Registrado</div>

            <div class="leyendaItem porCaducar corner-bottom-right">Caduca</div>
        </div>

        <div id='calendar'></div>

        <script type="text/javascript">
            $(function () {
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
                            className : "doc creado"
                        },
                        {
                            url       : '${createLink(controller: "calendario", action: "documentosPorCaducarGeneral_ajax")}', // use the `url` property
                            className : "doc porCaducar"
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