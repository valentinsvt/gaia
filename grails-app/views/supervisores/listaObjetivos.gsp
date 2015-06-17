<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Analisis de competencia por supervisor</title>
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight',file: 'jquery-highlight1.js')}"></imp:js>
    <style>
    .highlight { background-color: yellow; }
    </style>
</head>

<body>
<elm:container tipo="horizontal" titulo="Analisis de ventas por supervisor">
    <div class="row">
        <div class="col-md-1">
            <label>Supervisor:</label>
        </div>
        <div class="col-md-3">
            <g:select name="supervisor" from="${supervisores}" optionKey="codigo" optionValue="nombre" id="supervisores"
                      class="form-control input-sm" ></g:select>
        </div>
        <div class="col-md-1">
            <a href="#" class="btn btn-sm btn-info" id="ver"><i class="fa fa-search"></i> Ver</a>
        </div>
    </div>
    <div class="row">
        <div class="col-md-8" id="detalle">

        </div>
    </div>
</elm:container>
<script type="text/javascript">
    $("#ver").click(function(){
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'supervisores', action:'tablaObjetivos')}",
            data: {
                supervisor: $("#supervisores").val()
            },
            success: function (msg) {
                $("#detalle").html(msg)
            }
        });
    });
</script>
</body>
</html>