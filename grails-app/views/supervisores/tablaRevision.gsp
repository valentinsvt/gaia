<table class="table table-condensed  table-hover table-bordered" style="font-size: 11px">
    <thead>
    <tr>
        <th style="width: 25px">#</th>
        <th style="width: 20%">Estación</th>
        <g:set var="tam" value="${0}"></g:set>
        <g:each in="${meses}" var="m" status="i">
            <g:if test="${i+1<actual}">
                <g:set var="tam" value="${tam=tam+1}"></g:set>
                <th style="width: 60px">${m.key}</th>
            </g:if>
        </g:each>
    </tr>
    </thead>
    <tbody>
    <g:each in="${estaciones}" var="e" status="j">
        <tr>
            <td style="width: 25px;text-align: center">${j+1}</td>
            <td>${e.nombre}</td>
            <g:each in="${meses}" var="m" status="i">
                <g:if test="${i+1<actual}">
                    <g:set var="an" value="${gaia.supervisores.Analisis.findByEstacionAndFechaBetween(e,new Date().parse('dd-MM-yyyy','01-'+m.value+"-"+anio),new Date().parse('dd-MM-yyyy','31-'+m.value+"-"+anio))}"></g:set>
                    <g:if test="${an}">
                        <g:set var="dummy" value="${totales[i]+=an.diferencia}"></g:set>
                        <td style="width:150px;text-align: right;line-height: 25px" class="activo">
                            <div style=" width: 80px;display: inline-table">
                                ${an.diferencia > 0?'':'-'}<g:formatNumber number="${an.diferencia}" type="currency" currencySymbol="\$ "/><br/>
                                <span style="margin-left: 10px">${an.porcentaje} %</span>
                            </div>
                            <g:if test="${an.porcentaje==0}">
                                <i class="fa fa-arrow-right" style="color: #62bdff;margin-left: 10px;margin-right: 10px" title=""></i>
                            </g:if>
                            <g:if test="${an.porcentaje>0}">
                                <i class="fa fa-arrow-up" style="color: #008000;margin-left: 10px;margin-right: 10px" title="Incremento"></i>
                            </g:if>
                            <g:if test="${an.porcentaje<0}">
                                <i class="fa fa-arrow-down" style="color: #de0b00;margin-left: 10px;margin-right: 10px" title="Decremento"></i>
                            </g:if>
                            <a href="#" title="ver" class="ver btn btn-sm btn-info" iden="${an.id}">
                                <i class="fa fa-search"></i></a>
                        </td>
                    </g:if>
                    <g:else>
                        <td  style="width:150px;" class="disabled">
                        </td>
                    </g:else>

                </g:if>
            </g:each>
        </tr>
    </g:each>
    <tr>
        <td></td>
        <td style="font-weight: bold">Total</td>
        <g:each in="${meses}" var="m" status="i">
            <g:if test="${i+1<actual}">
                <td style="text-align: right">
                    ${totales[i] > 0?'':'-'}<g:formatNumber number="${totales[i]}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    <g:if test="${totales[i]==0}">
                        <i class="fa fa-arrow-right" style="color: #62bdff;margin-left: 10px;margin-right: 10px" title=""></i>
                    </g:if>
                    <g:if test="${totales[i]>0}">
                        <i class="fa fa-arrow-up" style="color: #008000;margin-left: 10px;margin-right: 10px" title="Incremento"></i>
                    </g:if>
                    <g:if test="${totales[i]<0}">
                        <i class="fa fa-arrow-down" style="color: #de0b00;margin-left: 10px;margin-right: 10px" title="Decremento"></i>
                    </g:if>
                </td>
            </g:if>
        </g:each>

    </tr>
    </tbody>
</table>
<script type="text/javascript">
    $(".ver").click(function() {
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'supervisores', action:'verAnalisis')}",
            data: {
                id: $(this).attr("iden")
            },
            success: function (msg) {
                bootbox.dialog({
                    title: "Análisis de la competencia",
                    message: msg,
                    class: "modal-lg",
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
        })
    });
</script>