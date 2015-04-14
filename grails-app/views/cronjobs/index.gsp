<%@ page import="org.quartz.Trigger" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <g:set var="layoutName" value="${grailsApplication.config.quartz?.monitor?.layout}" />
    <meta name="layout" content="main" />
    <title>Quartz Jobs</title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'quartz-monitor.css', plugin: 'quartz-monitor')}"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery.countdown.css', plugin: 'quartz-monitor')}"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery.clock.css', plugin: 'quartz-monitor')}"/>
    <style type="text/css">
    .text-danger{
        color: #ffffff;
        padding: 5px;
        background: #CE464A;
        border-radius: 5px;
    }
    .text-success{
        color: #ffffff;
        padding: 5px;
        background: #5CB85C;
        border-radius: 5px;
    }
    </style>
</head>
<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<elm:container titulo="Administración de Cronjobs" tipo="horizontal">
    <div class="row">
        <div class="col-md-3">
            <label>
                Estado actual del agente de ejecución:
            </label>
        </div>
        <div class="col-md-2">
            <g:if test="${scheduler.isInStandbyMode()}">
                <span class="text-danger">
                    Detenido
                </span>
                <a href="<g:createLink action="startScheduler"/>"><img class="quartz-tooltip" data-tooltip="Ejecutar" src="<g:resource dir="images" file="play-all.png" plugin="quartz-monitor"/>"></a>
            </g:if>
            <g:else>
                <span class="text-success">
                    Ejecutandose
                </span>
                <a href="<g:createLink action="stopScheduler"/>"><img class="quartz-tooltip" data-tooltip="Pausar" src="<g:resource dir="images" file="pause-all.png" plugin="quartz-monitor"/>"></a>

            </g:else>
        </div>
    </div>

    <div class="row">
        <div class="col-md-2">
            <div id="clocksvt" data-time="${now.time}">
                <h3>Hora del sistema: ${now}</h3>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <table id="quartz-jobs" class="table table-bordered table-striped table-hover">
                <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <g:if test="${grailsApplication.config.quartz.monitor.showTriggerNames}">
                        <th>Trigger Name</th>
                    </g:if>
                    <th>Última ejecución</th>
                    <th class="quartz-to-hide">Resultado</th>
                    <th>Siguiente ejecución</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${jobs}" status="i" var="job">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td>${job.name}</td>
                        <td style="width: 50%">${job.descripcion}</td>
                        <g:if test="${grailsApplication.config.quartz.monitor.showTriggerNames}">
                            <td>${job.trigger?.name}</td>
                        </g:if>
                        <g:set var="tooltip">${job.duration >= 0 ? "Job ran in: " + job.duration + "ms" : (job.error ? "Job threw exception: " + job.error : "")}</g:set>
                        <td style="text-align: center" class="quartz-tooltip quartz-status ${job.status?:"not-run"}" data-tooltip="${tooltip}">${job.lastRun?.format("dd-MM-yyyy HH:mm:ss")}</td>
                        <td class="quartz-to-hide">${tooltip}</td>
                        <g:if test="${scheduler.isInStandbyMode() || job.triggerStatus == Trigger.TriggerState.PAUSED}">
                            <td class="hasCountdown countdown_amount">Pausado</td>
                        </g:if>
                        <g:else>
                            <td class="quartz-countdown" data-next-run="${job.trigger?.nextFireTime?.time ?: ""}">${job.trigger?.nextFireTime}</td>
                        </g:else>
                        <td class="quartz-actions" style="text-align: center">
                            <g:if test="${job.status != 'running'}">
                                <g:if test="${job.trigger}">
                                    <a href="<g:createLink action="stop" params="[jobName:job.name, triggerName:job.trigger.name, triggerGroup:job.trigger.group]"/>"><img class="quartz-tooltip" data-tooltip="Parar y prevenir la ejecución de este proceso en el futuro" src="<g:resource dir="images" file="stop.png" plugin="quartz-monitor"/>"></a>
                                    <g:if test="${job.triggerStatus == Trigger.TriggerState.PAUSED}">
                                        <a href="<g:createLink action="resume" params="[jobName:job.name, jobGroup:job.group]"/>"><img class="quartz-tooltip" data-tooltip="Activar la ejecución del proceso" src="<g:resource dir="images" file="resume.png" plugin="quartz-monitor"/>"></a>
                                    </g:if>
                                    <g:elseif test="${job.trigger.mayFireAgain()}">
                                        <a href="<g:createLink action="pause" params="[jobName:job.name, jobGroup:job.group]"/>"><img class="quartz-tooltip" data-tooltip="Pausar la ejecucuón del proceso" src="<g:resource dir="images" file="pause.png" plugin="quartz-monitor"/>"></a>
                                    </g:elseif>
                                </g:if>
                                <g:else>
                                    <a href="<g:createLink action="start" params="[jobName:job.name, jobGroup:job.group]"/>"><img class="quartz-tooltip" data-tooltip="Empezar ejecución" src="<g:resource dir="images" file="start.png" plugin="quartz-monitor"/>"></a>
                                </g:else>
                                <a href="<g:createLink action="runNow" params="[jobName:job.name, jobGroup:job.group]"/>"><img class="quartz-tooltip" data-tooltip="Ejecutar ahora" src="<g:resource dir="images" file="run.png" plugin="quartz-monitor"/>"></a>
                                <g:if test="${job.trigger instanceof org.quartz.CronTrigger}">
                                    <a href="<g:createLink action="editCronTrigger" params="[triggerName:job.trigger.name, triggerGroup:job.trigger.group]"/>"><img class="quartz-tooltip" data-tooltip="Reschedule" src="<g:resource dir="images" file="reschedule.png" plugin="quartz-monitor"/>"></a>
                                </g:if>
                            </g:if>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>

    </div>

</elm:container>

<g:unless test="${grailsApplication.config.quartz.monitor.showCountdown == false}">
    <g:javascript src="jquery.countdown.js" plugin="quartz-monitor"/>
    <g:javascript src="jquery.color.js" plugin="quartz-monitor"/>
</g:unless>
<g:unless test="${grailsApplication.config.quartz.monitor.showTickingClock == false}">
    <g:javascript src="jquery.clock.js" plugin="quartz-monitor"/>
    <script type="text/javascript">
        $("#clocksvt").clock({
            langSet:"es"
        });
    </script>
</g:unless>
<g:javascript src="quartz-monitor.js" plugin="quartz-monitor"/>
</body>
</html>
