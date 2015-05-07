<table class="table table-striped table-hover table-bordered" style="margin-top: 15px;font-size: 11px">
    <thead>
    <tr>
        <th style="width: 30%">
            <div class="row" style="margin-top: 0px">
                <div class="col-md-5">
                    Estación
                </div>
                <div class="col-md-7 ">
                    <a href="#" class="btn btn-primary btn-sm" id="reset"><i class="fa fa-refresh"></i> Resetear filtros</a>
                </div>
            </div>
            <div class="row" style="margin-top: 10px">
                <div class="col-md-12">
                    <div class="input-group" >
                        <input type="text" class="form-control input-sm" id="txt-buscar" placeholder="Buscar">
                        <span class="input-group-addon svt-bg-primary " id="btn-buscar" style="cursor: pointer" >
                            <i class="fa fa-search " ></i>
                        </span>
                    </div>
                </div>
            </div>

        </th>
        <th># Factura</th>
        <g:each in="${items}" var="item">
            <th>${item.descripcion}</th>
        </g:each>
        <th>Total</th>
        <th></th>
    </tr>
    </thead>
    <tbody>
    <g:set var="total" value="${0}"></g:set>
    <g:each in="${datos}" var="d" status="">
        <g:set var="tot" value="${d.getTotal()}"></g:set>
        <tr class="tr-info">
            <td class="desc">${d.cliente.nombre}</td>
            <td class="desc">${d.numeroFactura}</td>
            <g:each in="${items}" var="item">
                <g:set var="valor" value="${d.getTotalGrupo(item)}"></g:set>
                <g:set var="dumy" value="${totales[item.id]+=valor}"></g:set>
                <td style="text-align: right">
                    <g:formatNumber number="${valor}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
                </td>
            </g:each>
            <td style="text-align: right">
                <g:formatNumber number="${tot}" type="currency" currencySymbol="" minFractionDigits="2"></g:formatNumber>
            </td>
            <g:set var="total" value="${total+=tot}"></g:set>
            <td class="td-semaforo">
                <a href="#" class="btn btn-primary btn-sm detalles" iden="${d.id}"  title="Detalles"><i class="fa fa-search"></i></a>
            </td>
        </tr>

    </g:each>
    <tr>
        <td style="font-weight: bold" colspan="2">TOTAL</td>
        <g:each in="${totales}">
            <td style="text-align: right;font-weight: bold">
                <g:formatNumber number="${it.value.toDouble().round(2)}" type="currency" currencySymbol=""></g:formatNumber>
            </td>
        </g:each>
        <td style="text-align: right;font-weight: bold">
            <g:formatNumber number="${total.toDouble().round(2)}" type="currency" currencySymbol=""></g:formatNumber>
        </td>
    </tr>
    </tbody>
</table>
<script type="text/javascript">
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
</script>