<%@ page import="gaia.Contratos.esicc.Uniforme" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Reporte de dotaciones</title>
</head>
<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<elm:container tipo="horizontal" titulo="Reporte de dotaciones">
    <div class="row">
        <div class="col-md-1">
            <label>
                Periodo:
            </label>
        </div>
        <div class="col-md-3">
            <g:select name="periodo" id="periodo" from="${gaia.Contratos.esicc.PeriodoDotacion.list([sort:'codigo'])}" optionKey="codigo" optionValue="descripcion" noSelection="['-1':'Seleccione']" class="form-control input-sm"></g:select>
        </div>
        <div class="col-md-1">
            <label>
                Uniforme:
            </label>
        </div>
        <div class="col-md-3">
            <g:select name="uniforme" id="uniforme" from="${Uniforme.list([sort:'descripcion'])}" optionKey="codigo" optionValue="descripcion" class="form-control input-sm"></g:select>
        </div>
        <div class="col-md-1">
            <a href="#"  id="ver" class="btn btn-info btn-sm"><i class="fa fa-search"></i> Ver</a>
        </div>
        <div class="col-md-1">
            <a href="#"  id="imprimir" class="btn btn-info btn-sm"><i class="fa fa-print"></i> Imprimir</a>
        </div>
    </div>
    <div class="row">
        <div class="col-md-10" id="lista">

        </div>
    </div>
</elm:container>
<script type="text/javascript">
    $("#ver").click(function(){
        if($("#periodo").val()!="-1"){
            openLoader()
            $.ajax({
                type    : "POST",
                url     : '${createLink(action:'dotacionesPorUniforme')}',
                data    : {
                    periodo : $("#periodo").val(),
                    uniforme: $("#uniforme").val()

                },
                success : function (msg) {
                    closeLoader()
                    $("#lista").html(msg)
                }
            });
        }else{
            bootbox.alert("Seleccione un periodo")
        }
    });
    $("#imprimir").click(function () {
        if($("#periodo").val()!="-1"){
            var url = "${createLink(controller: 'reportesDotacion',action: 'dotacionesPorUniformePdf')}?periodo="+$("#periodo").val()+"Wuniforme="+$("#uniforme").val() ;
            location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
        }else{
            bootbox.alert("Seleccione un periodo")
        }
    })
</script>
</body>
</html>