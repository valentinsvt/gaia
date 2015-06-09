<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<div class="row">
    <div class="col-md-2">
        <label>
            Siguiente generación de pdf
        </label>
    </div>
    <div class="col-md-2">
        ${nextEstado?.format("dd-MM-yyyy HH:mm:ss")}
    </div>
    <div class="col-md-2">
        <label>
            Siguiente envío de emails
        </label>
    </div>
    <div class="col-md-2">
        ${nextEmail?.format("dd-MM-yyyy HH:mm:ss")}
    </div>
</div>
<table class="table table-striped table-hover table-bordered" style="font-size: 11px">
    <thead>
    <tr>
        <th style="width: 30px">#</th>
        <th>Código</th>
        <th>Estacion</th>
        <th>Mes</th>
        <th>Archivo</th>
        <th>Fecha de envío</th>
        <th>Fecha ejecución</th>
        <th>Generado por:</th>
        <th style="width: 250px">Mensaje</th>
        <th>
            <i class="fa fa-envelope-o" title="Enviar"></i><br>
            <input type="checkbox" class="chk-todos" checked>
        </th>
    </tr>
    </thead>
    <tbody>
    <g:set var="lastFecha" value="${null}"></g:set>
    <g:each in="${estados}" var="e" status="i">
        <g:if test="${lastFecha!=e.registro}">
            <g:set var="lastFecha" value="${e.registro}"></g:set>
            <tr>
                <td colspan="10" class="filaFecha"> Generados el ${e.registro.format("dd-MM-yyyy HH:mm:ss")} </td>
            </tr>
        </g:if>
        <tr>
            <td style="text-align: center">${i+1}</td>
            <td>
                ${e.cliente.codigo}
            </td>
            <td>${e.cliente.nombre}</td>
            <td style="text-align: center">${e.mes}</td>
            <td style="text-align: center">
                <g:if test="${e.path}">
                    <a href="#" data-file="${e?.path}"
                       data-ref="Estado de cuenta estación : ${e.cliente.codigo}"
                       data-codigo="${e.mes}"
                       data-tipo="Estado de cuenta"
                       target="_blank" class="btn btn-info ver-doc btn-sm"  >
                        <i class="fa fa-search"></i> Ver
                    </a>

                </g:if>
                <g:else>
                    <g:if test="${e.ultimaEjecucion}">
                        <i class="fa fa-times"></i>
                        Error
                    </g:if>
                    <g:else>
                        <i class="fa fa-clock-o"></i>
                        Pendiente de ejecución
                    </g:else>
                </g:else>
            </td>
            <td>${e.envio?.format("dd-MM-yyyy")}</td>
            <td>${e.ultimaEjecucion?.format("dd-MM-yyyy")}</td>
            <td>${e.usuario}</td>
            <td>${e.mensaje}</td>
            <td>
                <g:if test="${e.path}">
                    <input type="checkbox" class="chk" value="${e.id}" iden="${e.id}" ${e.envio?'':'checked'}>
                </g:if>
            </td>
        </tr>
    </g:each>

    </tbody>
</table>

<a href="#" class="btn btn-info" id="generar"> <i class="fa fa-cogs"></i> Generar</a>
<a href="#" class="btn btn-info" id="enviar"> <i class="fa fa-envelope-o"></i> Enviar seleccionados</a>
<script type="text/javascript">
    $("#generar").click(function(){
        <g:if test="${estados.size()>0}">
        var msn = "Los estados de cuenta ya han sido generados para este mes, si decide continuar se generarán nuevos estados de cuenta para todas las estaciones del supervisor ${supervisor.nombre}"
        </g:if>
        <g:else>
        var msn = "Está seguro?"
        </g:else>
        bootbox.confirm(msn,function(result){
            if(result){
                openLoader()
                $.ajax({
                    type    : "POST",
                    url     : '${createLink(action:'generarEstados')}',
                    data    : {
                        supervisor : $("#supervisor").val(),
                        mes: $("#mes").val()

                    },
                    success : function (msg) {
                        closeLoader()
                        $("#lista").html(msg)
                    }
                });
            }
        })
    })
    $(".ver-doc").click(function(){
        showPdf($(this))
        return false
    })
    $(".pdf-handler").click(function(){
        $(".pdf-viewer").hide("slide",{direction:'right'})
        $("#data").hide()
    })
    $(".chk-todos").change(function(){
        $('.chk').prop('checked', this.checked);
    })
    $("#enviar").click(function(){
        $("#modal-copia").modal("show")
    })
</script>