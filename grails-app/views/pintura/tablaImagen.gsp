<table class="table table-striped table-hover table-bordered" style="margin-top: 15px;font-size: 12px">
    <thead>
    <tr>
        <th style="width: 60%">
            <div class="row" style="margin-top: 0px">
                <div class="col-md-2">
                    Estación
                </div>
                <div class="col-md-4">
                    <div class="input-group" >
                        <input type="text" class="form-control input-sm" id="txt-buscar" placeholder="Buscar">
                        <span class="input-group-addon svt-bg-primary " id="btn-buscar" style="cursor: pointer" >
                            <i class="fa fa-search " ></i>
                        </span>
                    </div>
                </div>
                <div class="col-md-3 ">
                    <a href="#" class="btn btn-primary btn-sm" id="reset"><i class="fa fa-refresh"></i> Resetear filtros</a>
                </div>
            </div>
        </th>
        <th># Factura</th>
        <th>Pintura</th>
        <th>Rotulación</th>
        <th>Total</th>
        <th></th>
    </tr>
    </thead>
    <tbody>
    <g:set var="totalP" value="${0}"></g:set>
    <g:set var="totalR" value="${0}"></g:set>
    <g:each in="${datos}" var="d" status="">
        <g:set var="tR" value="${d.getRotulacion()}"></g:set>
        <g:set var="tP" value="${d.getPintura()}"></g:set>
        <g:set var="totalP" value="${totalP+tP}"></g:set>
        <g:set var="totalR" value="${totalR+tR}"></g:set>

        <tr class="tr-info">
            <td class="desc">${d.cliente}</td>
            <td class="desc">${d.numeroFactura}</td>
            <td style="text-align: right">
                <g:formatNumber number="${tP}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
            </td>
            <td style="text-align: right">
                <g:formatNumber number="${tR}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
            </td>
            <td style="text-align: right">
                <g:formatNumber number="${tP+tR}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
            </td>
            <td class="td-semaforo" style="text-align: center">
                <a href="#" class="btn btn-primary btn-sm detalles" iden="${d.id}"  title="Detalles"><i class="fa fa-search"></i></a>
            </td>
        </tr>

    </g:each>
    <tr>
        <td style="font-weight: bold" colspan="2">TOTAL</td>
        <td style="text-align: right;font-weight: bold">
            <g:formatNumber number="${totalP}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
        </td>
        <td style="text-align: right;font-weight: bold">
            <g:formatNumber number="${totalR}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
        </td>
        <td style="text-align: right;font-weight: bold">
            <g:formatNumber number="${totalP+totalR}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
        </td>
    </tr>
    </tbody>
</table>
<script type="text/javascript">
    $("#btn-buscar").click(function(){
        var buscar = $("#txt-buscar").val().trim()
        $(".desc").removeHighlight();
        $(".tr-info").hide()
        if(buscar!=""){
            $(".desc").highlight(buscar, true);
            $(".highlight").parents("tr").show()
        }else{
            $(".tr-info").show()
        }

    });
    $("#reset").click(function () {
        $(".tr-info").show()
        $(".desc").removeHighlight();
    })
    $(".detalles").click(function(){
        var id = $(this).attr("iden")
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'pintura', action:'verDetalles')}",
            data: {
                id: id
            },
            success: function (msg) {
                bootbox.dialog({
                    title: "Detalle de rubros",
                    message: msg,
                    class:"modal-lg",
                    buttons: {
                        ok: {
                            label: "Aceptar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        }
                    }
                });
            }
        });
        return false
    });
</script>