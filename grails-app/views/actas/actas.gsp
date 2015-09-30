<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Impresión de actas</title>
    <meta name="layout" content="main"/>
</head>

<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<elm:container tipo="horizontal" titulo="Reporte de dotaciones valorado">
    <div class="row">
        <div class="col-md-1">
            <label>
                Periodo:
            </label>
        </div>
        <div class="col-md-3">
            <g:select name="periodo" id="periodo" from="${periodos}" optionKey="codigo" optionValue="descripcion" noSelection="['-1':'Seleccione']" class="form-control input-sm"/>
        </div>
        <div class="col-md-1">
            <label>
                Supervisor:
            </label>
        </div>
        <div class="col-md-3">
            <g:select name="supervisor" id="sup" from="${sups}" optionKey="id" optionValue="nombre" noSelection="['-1':'Seleccione']" class="form-control input-sm"/>
        </div>
        <div class="col-md-1">
            <a href="#"  id="imprimir" class="btn btn-info btn-sm"><i class="fa fa-print"></i> Imprimir</a>
        </div>
    </div>
</elm:container>
<script>
    $("#imprimir").click(function(){
        location.href="${g.createLink(controller: 'actas',action: 'actasPorSupervisor')}/?periodo="+$("#periodo").val()+"&sup="+$("#sup").val()
    })
</script>
</body>
</html>