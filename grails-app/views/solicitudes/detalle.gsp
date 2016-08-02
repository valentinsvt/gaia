<html>
<head>
    <meta name="layout" content="main"/>
    <title>Solicitudes de dotación de uniforme</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <style type="text/css">
    label{
        padding-top: 5px;
    }
    .alert{
        padding-bottom: 4px !important;
    }
    .header-flow-item{
        width: 33%;
    }
    select{
        border-radius: 5px;
        padding: 2px;
    }
    .titulo{
        cursor: pointer;
    }
    .panel-body{
        padding: 5px;
        margin-top: 0px;
    }
    </style>
</head>
<body>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <a href="${g.createLink(controller: 'uniformes',action: 'listaSemaforos')}" class="btn btn-default ">
            Estaciónes
        </a>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Estación: ${estacion.nombre}" >
    <div class="panel panel-info" style="margin-top: 20px">
        <div class="panel-heading">Solcitar dotación de uniformes</div>
        <div class="panel-body" style="padding:0px">
            <div class="header-flow">
                <g:link action="solicitar" id="${estacion.codigo}">
                    <div class="header-flow-item before">
                        <span class="badge before">1</span> Requisitos previos
                        <span class="arrow"></span>
                    </div>
                </g:link>
                <div class="header-flow-item active">
                    <span class="badge active">2</span>
                    Detalle
                    <span class="arrow"></span>
                </div>
                <div class="header-flow-item disabled">
                    <span class="badge disabled">3</span>
                    Enviar
                    <span class="arrow"></span>
                </div>
            </div>
            <div class="flow-body">
                <g:form class="frmPedido" action="guardarSolicitud">
                    <input type="hidden" name="id" value="${solicitud?.id}">
                    <input type="hidden" name="estacion" value="${estacion.codigo}">
                    <input type="hidden" name="data" value="" id="datos">
                    <div class="row" style="margin-bottom: 10px">
                        <div class="col-md-2">
                            <label>Periodo de dotación: </label>
                        </div>
                        <div class="col-md-3">
                            <g:select name="periodo" from="${gaia.Contratos.esicc.PeriodoDotacion.list([sort: 'codigo',order: 'desc'])}"
                                      optionKey="codigo" optionValue="descripcion" class="form-control input-sm periodo"/>
                        </div>
                        <div class="col-md-4"></div>
                        <div class="col-md-1 ">
                            <a href="#" id="ayuda" class="btn btn-warning btn-sm" style="width: 100%">
                                <i class="fa fa-question"></i> Ayuda
                            </a>
                        </div>
                    </div>
                    <g:each in="${nomina}" var="n" status="i">
                        <div class="row" style="margin-top: 0px">
                            <div class="col-md-10">
                                <div class="panel panel-warning panel_${n.id}">
                                    <div class="panel-heading titulo">${n.cedula} - ${n.nombre} - ${n.sexo}</div>
                                    <div class="panel-body">
                                        <div class="row contenido" style="margin-top: 0px" >
                                            <div class="col-md-12">
                                                <table class="table table-bordered table-striped " style="font-size: 11px">
                                                    <thead>
                                                    <tr>
                                                        <th>Uniforme</th>
                                                        <th>Talla</th>
                                                        <th>Cantidad</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <g:each in="${gaia.Contratos.esicc.Uniforme.findAllByTipoInListAndEstado(['U',n.sexo],1,[sort: 'descripcion',order: 'desc'])}" var="u">
                                                        <g:if test="${u.codigo!=8}">
                                                            <tr>
                                                                <td>${u.descripcion}</td>
                                                                <td style="text-align: center">${n.getTalla(u)}</td>
                                                                <td style="width: 60px">
                                                                    <g:set var="valor" value="${n.getCantidadSolicitudUniforme(solicitud,u)}"></g:set>
                                                                    <g:select name="cant" from="${0..2}"
                                                                              class="u_${u.codigo} cantidad emp_${n.id} emp_${n.id}_${u.codigo} ${valor?'valor':''}"
                                                                              talla="${n.getTalla(u).codigo}" uniforme="${u.codigo}" empleado="${n.id}"
                                                                              min="0" max="${maximos[u.codigo.toString()]}"
                                                                              value="${(u.codigo == 2 || u.codigo==3)?'1':valor}"
                                                                              disabled="${(u.codigo == 2 || u.codigo==3)?true:false}"
                                                                    >
                                                                    </g:select>

                                                                </td>
                                                            </tr>
                                                        </g:if>
                                                    </g:each>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="row contenido" style="margin-top: 0px">
                                            <div class="col-md-2">
                                                <a href="#" class="guardar btn btn-success btn-sm" grupo="emp_${n.id}" emp="${n.id}" >
                                                    <i class="fa fa-save"></i> Guardar
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                    </g:each>
                    <div class="row">
                        <div class="col-md-10" id="detalle">

                        </div>
                    </div>
                    <g:if test="${!errores}">
                        <div class="row">
                            <div class="col-md-1">
                                <a href="#" class="btn btn-success" id="continuar">
                                    Continuar  <i class="fa fa-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </g:if>
                </g:form>
            </div>
        </div>
    </div>
</elm:container>
<script type="text/javascript">
    function checkPendientes(){
        $(".valor").each(function(){
            var panel = $(this).parents(".panel_"+$(this).attr("empleado"))
            if(!panel.hasClass("panel-success")){
                panel.addClass("panel-success")
                panel.removeClass("panel-warning")
            }
        })
    };

    function cargarDetalle() {
        openLoader()
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'solicitudes', action:'detallePedido')}",
            data: {
                id: "${solicitud?.id}"
            },
            success: function (msg) {
                closeLoader()
                $("#detalle").html(msg)
            }
        });
    }


    checkPendientes()
    $(".u_1").change(function(){

        var emp = $(this).attr("empleado")
        var textfield = $(".emp_"+emp+"_9")
        if(textfield.val()*1 + $(this).val()*1 >2){
            textfield.val(0)
        }
        $(".emp_"+emp+"_10").change()
    })
    $(".u_9").change(function(){
        var emp = $(this).attr("empleado")
        var textfield = $(".emp_"+emp+"_1")
        if(textfield.val()*1 + $(this).val()*1 >2){
            textfield.val(0)
        }
        $(".emp_"+emp+"_10").change()
    })

    $(".u_4").change(function(){

        var emp = $(this).attr("empleado")
        var textfield = $(".emp_"+emp+"_7")
        if(textfield.val()*1 + $(this).val()*1 >2){
            textfield.val(0)
        }
        $(".emp_"+emp+"_10").change()
    })
    $(".u_7").change(function(){
        var emp = $(this).attr("empleado")
        var textfield = $(".emp_"+emp+"_4")
        if(textfield.val()*1 + $(this).val()*1 >2){
            textfield.val(0)
        }
        $(".emp_"+emp+"_10").change()
    })
    /*Validacion de Camisetas hombres*/
    $(".u_10").change(function(){
        var emp = $(this).attr("empleado")
        var pantalones = $(".emp_"+emp+"_9").val()*1
        var overoles = $(".emp_"+emp+"_1").val()*1
        var valor = $(this).val()*1
        var valorPar = $(".emp_"+emp+"_11").val()*1
        var par = $(".emp_"+emp+"_11")
        var max = pantalones*2+overoles
        if(pantalones+overoles==0) {
            $(this).val(0)
            bootbox.alert("Primero seleccione la cantidad de pantalones y/o overoles a entregarse al empleado")
        }
        if(valor>max) {
            $(this).val(max)
            par.val(0)
        }else{
            if(valor+valorPar>max)
                par.val(max-valor)
        }
    })
    $(".u_11").change(function(){
        var emp = $(this).attr("empleado")
        var pantalones = $(".emp_"+emp+"_9").val()*1
        var overoles = $(".emp_"+emp+"_1").val()*1
        var valor = $(this).val()*1
        var valorPar = $(".emp_"+emp+"_10").val()*1
        var par = $(".emp_"+emp+"_10")
        var max = pantalones*2+overoles
        if(pantalones+overoles==0) {
            $(this).val(0)
            bootbox.alert("Primero seleccione la cantidad de pantalones y/o overoles a entregarse al empleado")
        }
        if(valor>max) {
            $(this).val(max)
            par.val(0)
        }else{
            if(valor+valorPar>max)
                par.val(max-valor)
        }
    })
    /*fin Validacion de Camisetas hombres*/
    /*Validacion de Camisetas mujer*/
    $(".u_5").change(function(){
        var emp = $(this).attr("empleado")
        var pantalones = $(".emp_"+emp+"_7").val()*1
        var overoles = $(".emp_"+emp+"_4").val()*1
        var valor = $(this).val()*1
        var valorPar = $(".emp_"+emp+"_6").val()*1
        var par = $(".emp_"+emp+"_6")
        var max = pantalones*2+overoles
        if(pantalones+overoles==0) {
            $(this).val(0)
            bootbox.alert("Primero seleccione la cantidad de pantalones y/o overoles a entregarse al empleado")
        }
        if(valor>max) {
            $(this).val(max)
            par.val(0)
        }else{
            if(valor+valorPar>max)
                par.val(max-valor)
        }
    })
    $(".u_6").change(function(){
        var emp = $(this).attr("empleado")
        var pantalones = $(".emp_"+emp+"_7").val()*1
        var overoles = $(".emp_"+emp+"_4").val()*1
        var valor = $(this).val()*1
        var valorPar = $(".emp_"+emp+"_5").val()*1
        var par = $(".emp_"+emp+"_5")
        var max = pantalones*2+overoles
        if(pantalones+overoles==0) {
            $(this).val(0)
            bootbox.alert("Primero seleccione la cantidad de pantalones y/o overoles a entregarse al empleado")
        }
        if(valor>max) {
            $(this).val(max)
            par.val(0)
        }else{
            if(valor+valorPar>max)
                par.val(max-valor)
        }
    })
    /*fin Validacion de Camisetas mujer*/




    $(".guardar").click(function(){
        openLoader()
        var emp = $(this).attr("emp")
        var pantalonesH = $(".emp_"+emp+"_9").val()*1
        var overolesH = 0 //$(".emp_"+emp+"_1").val()*1
        var pantalonesM = $(".emp_"+emp+"_7").val()*1
        var overolesM = 0 //$(".emp_"+emp+"_4").val()*1
        var camisetasHombres =  $(".emp_"+emp+"_10").val()*1+$(".emp_"+emp+"_11").val()*1
        var camisetasMujeres =$(".emp_"+emp+"_5").val()*1+$(".emp_"+emp+"_6").val()*1
        if(isNaN(pantalonesH))
            pantalonesH=0
        if(isNaN(pantalonesM))
            pantalonesM=0
        if(isNaN(overolesH))
            overolesH=0
        if(isNaN(overolesM))
            overolesM=0
        if(isNaN(camisetasHombres))
            camisetasHombres=0
        if(isNaN(camisetasMujeres))
            camisetasMujeres=0
        var totalPantalones= pantalonesH+pantalonesM//+overolesH+overolesM
        var msg ="<ul>"
        if(totalPantalones!=2){
            msg+="<li>Ingrese una cantidad correcta de pantalones. El empleado puede recibir 2 pantalones </li>"
        }
        var max = (pantalonesH+pantalonesM)//*2+(overolesH+overolesM)

        //alert("pantalonesH " + pantalonesH)
        //alert("pantalonesM " + pantalonesM)
        //alert("camisetasHombres " + pantalonesM)
        //alert("camisetasMujeres " + pantalonesM)
        //alert("max " + max)

        if(camisetasHombres+camisetasMujeres>max){

            msg+="<li>Ingrese una cantidad correcta de camisetas. " +
                    "Recuerde que el empleado debe recibir únicamente 2 camisetas.</li>"
        }
        if(msg=="<ul>"){
            var emp = $(this).attr("grupo")
            var data = ""
            $("."+emp).each(function(){
                data+=$(this).attr("empleado")+";"+$(this).attr("uniforme")+";"+$(this).attr("talla")+";"+$(this).val()+"W"
                $(this).addClass("valor")
            });
            $.ajax({
                type: "POST",
                url: "${createLink(controller:'solicitudes', action:'saveDetalle')}",
                data: {
                    id: "${solicitud?.id}",
                    data:data
                },
                success: function (msg) {
                    checkPendientes()
                    closeLoader()
                    log("Datos guardados","success")
                }
            });
        }else{
            closeLoader()
            msg+="</ul>"
            bootbox.alert({
                title   : "Errores",
                class : "modal-error",
                message: "<p style='font-weight: bold'>Por favor, corrija los siguientes errores:</p> "+msg
            })
        }
        return false

    })
    //    cargarDetalle()
    $(".titulo").click(function(){
        $(this).parent().find(".contenido").toggle()
    })
    $("#continuar").click(function(){
        var emps = ${nomina.size()}
        var paneles = $(".panel-success").size()
        if(emps==paneles){
            location.href="${g.createLink(controller: 'solicitudes',action: 'enviar',id: solicitud.id)}"
        }else{
            var msg = "Error, todavía tiene empleados sin dotación asignada. " +
                    "Por favor ingrese la cantidad de cada uniforme para cada empleado y después presione el botón " +
                    '<a href="#" class=" btn btn-success btn-sm"><i class="fa fa-save"></i> Guardar</a><br/><br/>'+"" +
                    "Los empleados que ya tienen la dotación asignada aparecen con un recuadro de color verde, así:" +
                    " <div class='panel panel-success '><div class='panel-heading titulo'>1234567890 - Nombre Apellido - M</div></div><br/>" +
                    "Aquellos que NO tienen la dotación asignada aparecen con un recuadro de color naranja, así:" +
                    " <div class='panel panel-warning '><div class='panel-heading titulo'>1234567890 - Nombre Apellido - M</div></div><br/>" +
                    "<p>Para más información de un clic en el botón de ayuda</p>"
            bootbox.alert({
                title   : "Errores",
                class : "modal-error",
                message: msg
            })
        }
    });
    $("#ayuda").click(function(){
        var msg = "<p>En está pantalla cada recuadro representa a un empleado de la estación. Para continuar el proceso de la solicitud " +
                "debe registrar la cantidad de cada uniforme para cada empleado y después presionar el botón " +
                '<a href="#" class=" btn btn-success btn-sm"><i class="fa fa-save"></i> Guardar</a></p>'+"" +
                "<p>Este proceso debe repetirse por cada empleado que se muestra en pantalla.</p>" +
                "<p>A cada empleado se le puede asignar: <ul>" +
                "<li>1 Botas</li>" +
                "<li>1 Gorra</li>" +
                "<li>2 pantalones</li>" +
                "<li>2 camisetas</li>" +
                "</ul></p>" +
                "Los empleados que ya tienen la dotación asignada correctamente aparecen con un recuadro de color verde, así:" +
                " <div class='panel panel-success '><div class='panel-heading titulo'>1234567890 - Nombre Apellido - M</div></div><br/>" +
                "Aquellos que NO tienen la dotación asignada aparecen con un recuadro de color naranja, así:" +
                " <div class='panel panel-warning '><div class='panel-heading titulo'>1234567890 - Nombre Apellido - M</div></div><br/>"
        bootbox.alert({
            title   : "Ayuda",
            class : "modal-lg",
            message: msg
        })
        return false
    })
</script>
</body>
</html>