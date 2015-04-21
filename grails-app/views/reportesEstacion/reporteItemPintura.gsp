<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Reporte de dotaciones</title>
</head>
<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<elm:container tipo="horizontal" titulo="Reporte de dotaciones valorado">
    <div class="row">
        <div class="col-md-1">
            <label>
                Desde:
            </label>
        </div>
        <div class="col-md-2">
            <elm:datepicker name="desde" class="form-control input-sm"></elm:datepicker>
        </div>
        <div class="col-md-1">
            <label>
                Hasta:
            </label>
        </div>
        <div class="col-md-2">
            <elm:datepicker name="hasta"  class="form-control input-sm"></elm:datepicker>
        </div>
        <div class="col-md-1">
            <label>
                Item:
            </label>
        </div>
        <div class="col-md-3">
            <g:select name="items" id="items" from="${items}" optionKey="codigo" optionValue="descripcion" noSelection="['-1':'Seleccione']" class="form-control input-sm"></g:select>
        </div>
        <div class="col-md-1">
            <a href="#"  id="ver" class="btn btn-info btn-sm"><i class="fa fa-search"></i> Ver</a>
        </div>
        <div class="col-md-1">
            <a href="#"  id="imprimir" class="btn btn-info btn-sm"><i class="fa fa-print"></i> Imprimir</a>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12" id="lista">

        </div>
    </div>
</elm:container>
<script type="text/javascript">
    $("#ver").click(function(){
        if($("#items").val()!="-1" && $("#desde_input").val()!="" && $("#hasta_input").val()!=""){
            openLoader()
            $.ajax({
                type    : "POST",
                url     : '${createLink(action:'itemsPintura')}',
                data    : {
                    codigo : $("#items").val(),
                    desde:$("#desde_input").val(),
                    hasta:$("#hasta_input").val()

                },
                success : function (msg) {
                    closeLoader()
                    $("#lista").html(msg)
                }
            });
        }else{
            bootbox.alert("Seleccione un item y las fechas desde y hasta.")
        }
    });
    $("#imprimir").click(function () {
        if($("#items").val()!="-1" && $("#desde_input").val()!="" && $("#hasta_input").val()!=""){
            var url = "${createLink(controller: 'reportesEstacion',action: 'itemsPinturaPdf')}?codigo="+$("#items").val()+"Wdesde="+$("#desde_input").val()+"Whasta="+$("#hasta_input").val() ;
            location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
        }else{
            bootbox.alert("Seleccione un item y las fechas desde y hasta.")
        }
    })
</script>
</body>
</html>