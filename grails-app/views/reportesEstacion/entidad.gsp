<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 17/02/2015
  Time: 14:33
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Documentos por Entidad</title>
</head>

<body>


<div class="btn-toolbar toolbar">
    %{--<div class="btn-group">--}%
        %{--<div class="row">--}%
            <div class="col-md-1">
                <label>
                    Estación:
                </label>
            </div>

            <div class="col-md-4">
                <g:select name="estacion" from="${estaciones}" id="estacionVal" optionKey="codigo" style="width: 200px" />


            </div>
            <div class="col-md-1">
                <label>
                    Entidad:
                </label>
            </div>

            <div class="col-md-4">
                <g:select name="entidad" from="${entidades}" id="entidadVal" optionValue="nombre" optionKey="id" style="width: 200px"  noSelection="['-1': 'Todos']"/>
            </div>

            <a href="#" class="btn btn-default btnActualizar">
                <i class="fa fa-refresh"></i> Actualizar
            </a>

            <a href="#" class="btn btn-default btnImprimir">
                <i class="fa fa-print"></i> Imprimir
            </a>

        %{--</div>--}%
    %{--</div>--}%
</div>

<table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">
    <thead>
    <tr>
        <th style="width: 100px;">Entidad</th>
        <th style="width: 130px;">Tipo Documento</th>
        <th style="width: 70px;"># Referencia</th>
        <th style="width: 70px;">Consultor</th>
        <th style="width: 70px;">Estado</th>
        <th style="width: 70px;">Emisión</th>
        <th style="width: 70px;">Vencimiento</th>
    </tr>
    </thead>
    <tbody id="tabla">

    </tbody>
</table>


<script type="text/javascript">

    %{--$(".btnImprimir").click(function () {--}%
        %{--var est = $("#estacionVal").val()--}%
        %{--var ent = $("#entidadVal").val()--}%
        %{--var url = "${createLink(controller: 'reportesEstacion',action: 'reporteEntidad')}";--}%
        %{--var url = "${createLink(controller: 'reportesEstacion',action: 'reporteEntidad')}?entidad=" + ent + "Westacion=" + est;--}%
        %{--location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;--}%
    %{--});--}%

    $(".btnImprimir").click(function () {
        var est = $("#estacionVal").val()
        var ent = $("#entidadVal").val()

        var data = {
            estacion : $("#estacionVal").val(),
            entidad : $("#entidadVal").val()
        }

        $.ajax({
            type    : "POST",
            url     : '${createLink(action:'reporteEntidad')}',
            data    :
              data,

            success : function (msg) {
                var url = "${createLink(controller: 'reportesEstacion',action: 'reporteEntidad')}?entidadId="+ ent+"WestacionId=" + est;
                %{--var url = "${createLink(controller: 'reportesEstacion',action: 'reporteEntidad')}";--}%
                location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
            }
        });
    });

    $(".btnActualizar").click(function () {
        $.ajax({
            type    : "POST",
            url     : '${createLink(action:'tablaEntidad')}',
            data    : {
                estacion : $("#estacionVal").val(),
                entidad : $("#entidadVal").val()
            },
            success : function (msg) {
                $("#tabla").html(msg)
            }
        });
    });

</script>

</body>
</html>