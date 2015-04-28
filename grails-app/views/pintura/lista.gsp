<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Detalle de pintura y mantenimiento por estación</title>
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight',file: 'jquery-highlight1.js')}"></imp:js>
</head>
<body>
<elm:container tipo="horizontal" titulo="Detalle de pintura y mantenimiento por estación año: ${now.format('yyyy')}">
    <div class="row">
        <div class="col-md-12">
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
                    <th>Mantenimiento</th>
                    <th>Total</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <g:set var="totalP" value="${0}"></g:set>
                <g:set var="totalR" value="${0}"></g:set>
                <g:set var="totalM" value="${0}"></g:set>
                <g:each in="${dash}" var="d" status="">
                    <g:set var="datos" value="${d.getParcialesPintura(inicio,fin)}"></g:set>
                    <g:set var="totalP" value="${totalP+datos["Pintura"]}"></g:set>
                    <g:set var="totalR" value="${totalR+datos["Rotulación"]}"></g:set>
                    <g:set var="totalM" value="${totalM+datos["Mantenimiento"]}"></g:set>
                    <g:if test="${(datos["Pintura"]+datos["Rotulación"]+datos["Mantenimiento"])>0}">
                        <tr class="tr-info">
                            <td class="desc">${d.estacion.nombre}</td>
                            <td class="desc">${datos["factura"]}</td>
                            <td style="text-align: right">${datos["Pintura"].toDouble().round(2)}</td>
                            <td style="text-align: right">${datos["Rotulación"].toDouble().round(2)}</td>
                            <td style="text-align: right">${datos["Mantenimiento"].toDouble().round(2)}</td>
                            <td style="text-align: right">${(datos["Pintura"]+datos["Rotulación"]+datos["Mantenimiento"]).toDouble().round(2)}</td>
                            <td class="td-semaforo">
                                <a href="#" class="btn btn-primary btn-sm detalles" iden="${d.estacion.codigo}"  title="Detalles"><i class="fa fa-search"></i></a>
                            </td>
                        </tr>
                    </g:if>
                </g:each>
                <tr>
                    <td style="font-weight: bold" colspan="2">TOTAL</td>
                    <td style="text-align: right;font-weight: bold">${totalP.toDouble().round(2)}</td>
                    <td style="text-align: right;font-weight: bold">${totalR.toDouble().round(2)}</td>
                    <td style="text-align: right;font-weight: bold">${totalM.toDouble().round(2)}</td>
                    <td style="text-align: right;font-weight: bold">
                        ${(totalP+totalM+totalR).toDouble().round(2)}
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</elm:container>
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
</body>
</html>