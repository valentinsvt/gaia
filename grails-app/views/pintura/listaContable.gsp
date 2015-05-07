<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Detalle de pintura y mantenimiento por estación</title>
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight',file: 'jquery-highlight1.js')}"></imp:js>
</head>
<body>
<elm:container tipo="horizontal" titulo="Detalle de pintura y mantenimiento por estación">
    <div class="row">
        <div class="col-md-1">
            <label>Desde</label>
        </div>
        <div class="col-md-2">
            <elm:datepicker class="form-control input-sm desde" name="desde" ></elm:datepicker>
        </div>
        <div class="col-md-1">
            <label>Hasta</label>
        </div>
        <div class="col-md-2">
            <elm:datepicker class="form-control input-sm hasta" name="hasta"  value="${new Date()}"></elm:datepicker>
        </div>
        <div class="col-md-1">
            <a href="#" class="btn btn-info btn-sm" style="width: 100%" id="ver">
                <i class="fa fa-search"></i> Ver
            </a>
        </div>
        <div class="col-md-1">
            <a href="#" class="btn btn-info btn-sm" style="width: 100%" id="imprimir">
                <i class="fa fa-print"></i> Imprimir
            </a>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12" id="detalle">

        </div>
    </div>
</elm:container>
<script type="text/javascript">

    $("#ver").click(function(){
        if($("#desde_input").val()!="" && $("#hasta_input").val()!=""){
            openLoader()
            $.ajax({
                type: "POST",
                url: "${createLink(controller:'pintura', action:'tablaContable')}",
                data: {
                    desde: $("#desde_input").val(),
                    hasta: $("#hasta_input").val()
                },
                success: function (msg) {
                    $("#detalle").html(msg)
                    closeLoader()
                }
            });
        }else{
            bootbox.alert('Por favor seleccione las fechas "Desde" y "Hasta"')
        }

    })
    $("#imprimir").click(function () {
        if($("#desde_input").val()!="" && $("#hasta_input").val()!=""){
            var url = "${createLink(controller: 'reportePintura',action: 'listaContablePdf')}?desde="+$("#desde_input").val()+"Whasta="+$("#hasta_input").val() ;
            location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url+"&filename=ReporteDePinturaYMantenimiento.pdf";
        }else{
            bootbox.alert('Por favor seleccione las fechas "Desde" y "Hasta"')
        }
    })
</script>
</body>
</html>