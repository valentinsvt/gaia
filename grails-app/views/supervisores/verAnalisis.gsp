<fieldset style="margin: 20px;margin-top: 5px">
    <legend style="color: #006EB7">Estación: ${an.estacion.nombre}</legend>
    <div class="row">
        <div class="col-md-2">
            <label>Supervisor</label>
        </div>
        <div class="col-md-4">
            ${an.supervisor.nombre}
        </div>
    </div>
    <div class="row">
        <div class="col-md-2" style="background: #9ed3ff;height: 20px;padding-top: 1px;">
            <label>
                Ventas ${lastYear.format("MM-yyyy")}:
            </label>
        </div>
        <div class="col-md-2" style="background: #9ed3ff;height: 20px;;padding-top: 1px;">
            <g:formatNumber number="${an.ventasAnio}" type="currency" currencySymbol="\$ "></g:formatNumber>
        </div>
        <div class="col-md-2" style="background: #FFDA9E;height: 20px;;padding-top: 1px;">
            <label>
                Ventas ${lastMonth.format("MM-yyyy")}:
            </label>
        </div>
        <div class="col-md-2" style="background: #FFDA9E;height: 20px;;padding-top: 1px;">
            <g:formatNumber number="${an.ventasMes}" type="currency" currencySymbol="\$ "></g:formatNumber>
        </div>
    </div>
    <div class="row">
        <div class="col-md-2">
            <label>
                Variación:
            </label>
        </div>
        <div class="col-md-4">
            ${an.ventasMes-an.ventasAnio > 0?'':'-'}<g:formatNumber number="${an.ventasMes-an.ventasAnio}" type="currency" currencySymbol="\$ "></g:formatNumber>
            <g:if test="${an.ventasAnio > 0}">
                <span style="margin-left: 40px">${((an.ventasMes*100/an.ventasAnio)-100).toDouble().round(2)}%</span>
            </g:if>
            <g:else>
                <span style="margin-left: 40px">0.00</span>
            </g:else>
            <g:if test="${an.ventasMes-an.ventasAnio > 0}">
                <i class="fa fa-arrow-up" style="color: #008000;margin-left: 40px" title="Incremento"></i>
            </g:if>
            <g:else>
                <i class="fa fa-arrow-down" style="color: #de0b00;margin-left: 40px" title="Decremento"></i>
            </g:else>
        </div>
    </div>
    <div class="row">
        <div class="col-md-2">
            <label>
                Comentario:
            </label>
        </div>
        <div class="col-md-8">
            ${an.comentario}
        </div>
    </div>
</fieldset>

</body>
</html>