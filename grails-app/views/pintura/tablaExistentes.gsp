
    <table class="table table-bordered table-striped" id="tbl" style="font-size: 11px;width: ${300+items.size()*100}px">
        <thead>
        <tr class="head" style="">
            <th colspan="2"></th>
            <th>Mantenimiento</th>
            <th colspan="${items.size()}">Elementos nuevos</th>
        </tr>
        <tr class="head" style="">
            <th style="width: 200px">Estación</th>
            <th style="width: 100px">Fecha</th>
            <th>Elementos<br/> exist.</th>
            <g:each in="${items}" var="i">
                <th style="width: 100px">${i.descripcion}</th>
            </g:each>
        </tr>
        </thead>
        <tbody class="tbody" >
        <g:each in="${datos}" var="d">
            <tr class="info-row">
                <td style="width: 200px !important;">${d.value["estacion"]}</td>
                <td style="text-align: center">${d.value["fecha"].format("dd-MM-yyyy")}</td>
                <td style="text-align: right">${d.value["Mantenimiento"]}</td>
                <g:each in="${items}" var="i">
                    <td style="text-align: right">${d.value[i.descripcion]}</td>
                </g:each>
            </tr>
        </g:each>
        </tbody>
        <tfoot class="tbody">
        <tr class="info-row ">
            <td colspan="2" style="font-weight: bold">TOTAL</td>
            <td style="text-align: right">${total["TOTAL"]["Mantenimiento"]}</td>
            <g:each in="${items}" var="i">
                <td style="text-align: right">${total["TOTAL"][i.descripcion]}</td>
            </g:each>
        </tr>
        </tfoot>
    </table>

<script type="text/javascript">
    var original = $("#tbl")
    var table = $("#tbl").clone()
    table.find(".head").show()
    $("#header").append(table)
    $(".info-row").click(function(){
        if($(this).hasClass("seleccionado"))
            $(this).removeClass("seleccionado")
        else
            $(this).addClass("seleccionado")
    })
</script>