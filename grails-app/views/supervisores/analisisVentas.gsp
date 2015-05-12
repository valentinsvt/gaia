<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Análisis de ventas del supervisor ${session.usuario}</title>
</head>

<body>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <g:link action="listaSemaforos" class="btn btn-default detalles btn-sm">
            <i class="fa fa-list"></i> Estaciones
        </g:link>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Análisis de ventas del supervisor: ${session.usuario}">
    <fieldset style="margin-top: 20px;">
        <legend style="color: #006EB7">Estación: ${cliente.nombre}</legend>
        <div class="row">
            <div class="col-md-2" style="background: #9ed3ff;height: 20px;padding-top: 1px;">
                <label>
                    Ventas ${lastYear.format("MM-yyyy")}:
                </label>
            </div>
            <div class="col-md-2" style="background: #9ed3ff;height: 20px;;padding-top: 1px;">
                <g:formatNumber number="${ventasAnterior}" type="currency" currencySymbol="\$ "></g:formatNumber>
            </div>
            <div class="col-md-2" style="background: #FFDA9E;height: 20px;;padding-top: 1px;">
                <label>
                    Ventas ${lastMonth.format("MM-yyyy")}:
                </label>
            </div>
            <div class="col-md-2" style="background: #FFDA9E;height: 20px;;padding-top: 1px;">
                <g:formatNumber number="${ventasActual}" type="currency" currencySymbol="\$ "></g:formatNumber>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    Variación:
                </label>
            </div>
            <div class="col-md-4">
                ${ventasActual-ventasAnterior > 0?'':'-'}<span style=""><g:formatNumber number="${ventasActual-ventasAnterior}" type="currency" currencySymbol="\$ "/>
                <g:if test="${ventasAnterior > 0}">
                    <span style="${ventasActual-ventasAnterior < 0?'color:red':''};margin-left: 40px">${((ventasActual*100/ventasAnterior)-100).toDouble().round(2)}%</span>
                </g:if>
                <g:else>
                    <span style="margin-left: 40px">0.00</span>
                </g:else>
                <g:if test="${ventasActual-ventasAnterior > 0}">
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
                <input type="hidden" name="ventasMes" value="${ventasActual}">
                <input type="hidden" name="ventasAnio" value="${ventasAnterior}">
                <input type="hidden" name="diferencia" value="${ventasActual-ventasAnterior}">
                <g:if test="${ventasAnterior > 0}">
                    <input type="hidden" name="porcentaje" value="${((ventasActual*100/ventasAnterior)-100).toDouble().round(2)}">
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
    </fieldset>
</elm:container>
<script type="text/javascript">
    $("#guardar").click(function(){
        $(".frmAnalisis").submit()
    })
</script>
</body>
</html>