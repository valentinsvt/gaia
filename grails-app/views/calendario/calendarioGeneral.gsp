<%--
  Created by IntelliJ IDEA.
  User: Luz
  Date: 2/10/2015
  Time: 12:46 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">

        <imp:js src="${resource(dir: 'js/plugins/fullcalendar-2.2.6', file: 'fullcalendar.min.js')}"/>
        <imp:css src="${resource(dir: 'js/plugins/fullcalendar-2.2.6', file: 'fullcalendar.min.css')}"/>
        <title>Calendario general</title>
    </head>

    <body>

        <div id='calendar'></div>

        <script type="text/javascript">
            $(function () {
                $('#calendar').fullCalendar({
                    header      : {
                        left   : 'prev,next today',
                        center : 'title',
                        right  : 'month,agendaWeek,agendaDay'
                    },
                    defaultDate : '${fecha}',
                    editable    : true
                });
            });
        </script>
    </body>
</html>