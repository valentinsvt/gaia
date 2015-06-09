<table class="table table-bordered table-hover">
    <thead>
    <tr>
        <th style="width: 30px">#</th>
        <th>Código</th>
        <th>Estación</th>
        <th>PDF</th>
        <th>Fecha creación</th>
        <th>Fecha impresión</th>
        <th>Fecha envío</th>
        <th>Generado por</th>
        <th>Enviar</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${estados}" var="e" status="i">
        <tr>
            <td style="text-align: center">${i+1}</td>
            <td>${e.cliente.codigo}</td>
            <td>${e.cliente.nombre}</td>
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
                    <a href="#" class="btn btn-primary btn-sm generar" iden="${e.id}"><i class="fa fa-file-pdf-o"></i> Generar</a>
                </g:else>
            </td>
            <td style="text-align: center">${e.registro.format("dd-MM-yyyy hh:mm:ss")}</td>
            <td style="text-align: center">${e.path?e.ultimaEjecucion?.format("dd-MM-yyyy hh:mm:ss"):''}</td>
            <td style="text-align: center">${e.envio?.format("dd-MM-yyyy hh:mm:ss")}</td>
            <td>${e.usuario}</td>
            <td style="text-align: center">
                <g:if test="${e.path}">
                    <a href="#" class="btn btn-info btn-sm enviar" iden="${e.id}">
                        <i class="fa fa-envelope-o"></i> Enviar
                    </a>
                </g:if>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>
<div class="row">
    <div class="col-md-2">
        <a href="#" id="generar" class="btn btn-sm btn-info" cliente="${cliente.codigo}">
            <i class="fa fa-cogs"></i> Generar nuevo
        </a>
    </div>
</div>
<script type="text/javascript">
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
    $(".enviar").click(function(){
        $("#estado_id").val($(this).attr("iden"))
        $("#modal-copia").modal("show")
    })
    $("#generar").click(function(){
        var cliente = $(this).attr("cliente")
        var msn = "Al generar un nuevo estado de cuenta la información de facturas vencidas y prorrogadas puede diferir del" +
                " archivo generado originalmente. Desea continuar?"
        bootbox.confirm(msn,function(result){
            if(result){
                openLoader()
                $.ajax({
                    type    : "POST",
                    url     : '${createLink(action:'generarEstadoEstacion')}',
                    data    : {
                        cliente : cliente,
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
    $(".generar").click(function(){
        openLoader()
        $.ajax({
            type    : "POST",
            url     : '${createLink(action:'generarPdf')}',
            data    : {
                estado : $(this).attr("iden"),
                cliente : $("#cliente").val(),
                mes: $("#mes").val()
            },
            success : function (msg) {
                closeLoader()
                $("#lista").html(msg)
            }
        });
    })
</script>