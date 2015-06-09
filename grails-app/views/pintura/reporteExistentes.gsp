<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Reporte de mantenimiento y repintura</title>
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight',file: 'jquery-highlight1.js')}"></imp:js>
    <style>
    .highlight { background-color: yellow; }
    .seleccionado{
        background: #fff5a1 !important;
        font-weight: bold;
    }
    </style>
</head>
<body>

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
        <a href="#" class="btn btn-info btn-sm" style="width: 100%" id="excel">
            <i class="fa fa-file-excel-o"></i> Excel
        </a>
    </div>
    <div class="col-md-2">
        <a href="#" class="btn btn-info btn-sm"  id="fs">
            <i class="fa fa-desktop"></i> Pantalla completa
        </a>
    </div>

</div>
<div class="row" style="position: relative;overflow: auto;width: 95%;" id="contenedor">
    <div id="header" style="z-index:999;width:${2000}px;position: absolute;top: 0px;left: 0px;height: 87px;overflow: hidden;display: none "></div>
    <div id="detalle"style="width:${2020}px;height:450px;position: relative;overflow-y: auto;overflow-x:hidden;display: none;padding-right: 15px; ">


    </div>
</div>
<script type="text/javascript">
    var ch=0
    var dh=0
    $(document).keyup(function(e){
        if (e.keyCode == 27){
            $("#contenedor").css({height:ch})
            $("#detalle").css({height:dh})
        }
    })
    $("#fs").click(function(){
        document.getElementById("contenedor").webkitRequestFullscreen();
        ch = $("#contenedor").height()
        dh = $("#detalle").height()
        $("#contenedor").css({height:$(window).height()})
        $("#detalle").css({height:$(window).height()-40})

    })

    $("#ver").click(function(){

        if($("#desde_input").val()!="" && $("#hasta_input").val()!=""){
            openLoader()
            $.ajax({
                type: "POST",
                url: "${createLink(controller:'pintura', action:'tablaExistentes')}",
                data: {
                    desde: $("#desde_input").val(),
                    hasta: $("#hasta_input").val()
                },
                success: function (msg) {


                    $("#detalle").html(msg)
                    $("#detalle").show()
                    $("#header").show()
                    closeLoader()
                }
            });
        }else{
            bootbox.alert('Por favor seleccione las fechas "Desde" y "Hasta"')
        }

    })
    $("#excel").click(function(){

        if($("#desde_input").val()!="" && $("#hasta_input").val()!=""){

            location.href="${createLink(controller:'reportesExcelPintura', action:'tablaExistentesExcel')}?desde="+$("#desde_input").val()+"&hasta="+$("#hasta_input").val()

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