<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Análisis de ventas del supervisor ${session.usuario}</title>
    <style type="text/css">
    fieldset{
        padding: 10px;
        border: 1px solid #1777C9;
        border-radius: 5px;
    }
    legend{
        padding-top: 0px;
        margin-bottom: 0px;
        margin-top: 40px;
        background: transparent !important;
        border: none;
    }
    .number{
        text-align: right;
    }
    </style>
</head>
<body>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <g:link action="listaSemaforos" class="btn btn-default detalles btn-sm">
            <i class="fa fa-list"></i> Estaciones
        </g:link>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Análisis de ventas estación: ${cliente.nombre}">
    <div class="row">
        <div class="col-md-5">
            <fieldset style="margin-top: 20px;">
                <legend style="color: #006EB7">Ventas ${lastYear.format("MM-yyyy")}</legend>
                <div class="row">
                    <div class="col-md-4 col-md-offset-1" >
                        <label>
                            Extra:
                        </label>
                    </div>
                    <div class="col-md-4 number" >
                        <g:formatNumber number="${ventasAnterior['0101']}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 col-md-offset-1" >
                        <label>
                            Super:
                        </label>
                    </div>
                    <div class="col-md-4 number">
                        <g:formatNumber number="${ventasAnterior['0103']}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 col-md-offset-1">
                        <label>
                            Extra con Etanol:
                        </label>
                    </div>
                    <div class="col-md-4 number" >
                        <g:formatNumber number="${ventasAnterior['0174']}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 col-md-offset-1" >
                        <label>
                            Diesel premiun:
                        </label>
                    </div>
                    <div class="col-md-4 number" >
                        <g:formatNumber number="${ventasAnterior['0121']}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 col-md-offset-1" >
                        <label>
                            Total ${lastYear.format("MM-yyyy")}:
                        </label>
                    </div>
                    <div class="col-md-4 number" >
                        <g:formatNumber number="${totalAnterior}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="col-md-5">
            <fieldset style="margin-top: 20px;">
                <legend style="color: #006EB7"> Ventas ${lastMonth.format("MM-yyyy")}</legend>
                <div class="row">
                    <div class="col-md-4 col-md-offset-1" >
                        <label>
                            Extra:
                        </label>
                    </div>
                    <div class="col-md-4 number" >
                        <g:formatNumber number="${ventasActual['0101']}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    </div>
                    <div class="col-md-1">
                        <g:if test="${ventasActual['0101']-ventasAnterior['0101'] > 0}">
                            <i class="fa fa-arrow-up" style="color: #008000;margin-left: 40px" title="Incremento"></i>
                        </g:if>
                        <g:else>
                            <i class="fa fa-arrow-down" style="color: #de0b00;margin-left: 40px" title="Decremento"></i>
                        </g:else>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 col-md-offset-1" >
                        <label>
                            Super:
                        </label>
                    </div>
                    <div class="col-md-4 number">
                        <g:formatNumber number="${ventasActual['0103']}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    </div>
                    <div class="col-md-1">
                        <g:if test="${ventasActual['0103']-ventasAnterior['0103'] > 0}">
                            <i class="fa fa-arrow-up" style="color: #008000;margin-left: 40px" title="Incremento"></i>
                        </g:if>
                        <g:else>
                            <i class="fa fa-arrow-down" style="color: #de0b00;margin-left: 40px" title="Decremento"></i>
                        </g:else>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 col-md-offset-1">
                        <label>
                            Extra con Etanol:
                        </label>
                    </div>
                    <div class="col-md-4 number" >
                        <g:formatNumber number="${ventasActual['0174']}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    </div>
                    <div class="col-md-1">
                        <g:if test="${ventasActual['0174']-ventasAnterior['0174'] > 0}">
                            <i class="fa fa-arrow-up" style="color: #008000;margin-left: 40px" title="Incremento"></i>
                        </g:if>
                        <g:else>
                            <i class="fa fa-arrow-down" style="color: #de0b00;margin-left: 40px" title="Decremento"></i>
                        </g:else>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 col-md-offset-1" >
                        <label>
                            Diesel premiun:
                        </label>
                    </div>
                    <div class="col-md-4 number" >
                        <g:formatNumber number="${ventasActual['0121']}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    </div>
                    <div class="col-md-1">
                        <g:if test="${ventasActual['0121']-ventasAnterior['0121'] > 0}">
                            <i class="fa fa-arrow-up" style="color: #008000;margin-left: 40px" title="Incremento"></i>
                        </g:if>
                        <g:else>
                            <i class="fa fa-arrow-down" style="color: #de0b00;margin-left: 40px" title="Decremento"></i>
                        </g:else>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 col-md-offset-1" >
                        <label>
                            Total ${lastMonth.format("MM-yyyy")}:
                        </label>
                    </div>
                    <div class="col-md-4 number" >
                        <g:formatNumber number="${totalActual}" type="currency" currencySymbol="\$ "></g:formatNumber>
                    </div>
                    <div class="col-md-1">
                        <g:if test="${totalActual-totalAnterior > 0}">
                            <i class="fa fa-arrow-up" style="color: #008000;margin-left: 40px" title="Incremento"></i>
                        </g:if>
                        <g:else>
                            <i class="fa fa-arrow-down" style="color: #de0b00;margin-left: 40px" title="Decremento"></i>
                        </g:else>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>


    <div class="row">
        <div class="col-md-2">
            <label>
                Variación:
            </label>
        </div>
        <div class="col-md-4">
            ${totalActual-totalAnterior > 0?'':'-'}<span style=""><g:formatNumber number="${totalActual-totalAnterior}" type="currency" currencySymbol="\$ "/>
            <g:if test="${totalAnterior > 0}">
                <span style="${totalActual-totalAnterior < 0?'color:red':''};margin-left: 40px">${((totalActual*100/totalAnterior)-100).toDouble().round(2)}%</span>
            </g:if>
            <g:else>
                <span style="margin-left: 40px">0.00</span>
            </g:else>
            <g:if test="${totalActual-totalAnterior > 0}">
                <i class="fa fa-arrow-up" style="color: #008000;margin-left: 40px" title="Incremento"></i>
            </g:if>
            <g:else>
                <i class="fa fa-arrow-down" style="color: #de0b00;margin-left: 40px" title="Decremento"></i>
            </g:else>
        </div>
    </div>
    <div class="row">
        <g:form action="saveAnalisis" class="frmAnalisis">
            <input type="hidden" name="id" value="${analisis?.id}">
            <input type="hidden" name="estacion" value="${cliente.codigo}">
            <input type="hidden" name="fecha" value="${analisis?analisis.fecha:lastMonth?.format('dd-MM-yyyy')}">
            <input type="hidden" name="ventasMes" value="${totalActual}">
            <input type="hidden" name="ventasAnio" value="${totalAnterior}">
            <input type="hidden" name="diferencia" value="${totalActual-totalAnterior}">
            <g:if test="${totalAnterior > 0}">
                <input type="hidden" name="porcentaje" value="${((totalActual*100/totalAnterior)-100).toDouble().round(2)}">
            </g:if>
            <g:else>
                <input type="hidden" name="porcentaje" value="0.00">
            </g:else>
            <div class="col-md-2">
                <label>
                    Comentario:
                </label>
            </div>
            <div class="col-md-8">
                <textarea class="form-control input-sm" rows="10" style="resize: none" name="comentario">${analisis?.comentario}</textarea>
            </div>
        </g:form>
    </div>
    <div class="row">
        <div class="col-md-1">
            <a href="#" id="guardar" class="btn btn-success">
                <i class="fa fa-save"></i> Guardar
            </a>
        </div>
    </div>

</elm:container>
<script type="text/javascript">
    $("#guardar").click(function(){
        $(".frmAnalisis").submit()
    })
</script>
</body>
</html>