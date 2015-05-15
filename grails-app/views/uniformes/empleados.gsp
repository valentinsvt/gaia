<%@ page import="gaia.Contratos.esicc.Tallas" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Empleados de la estación: ${estacion.nombre}</title>
    <meta name="layout" content="main"/>
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <style>
    .alert{
        padding-bottom: 4px !important;
    }
    </style>
</head>

<body>
<div class="pdf-viewer">
    <div class="pdf-content" >
        <div class="pdf-container" id="doc"></div>
        <div class="pdf-handler" >
            <i class="fa fa-arrow-right"></i>
        </div>
        <div class="pdf-header" id="data">
            N. Referencia: <span id="referencia-pdf" class="data"></span>
            Código: <span id="codigo" class="data"></span>
            Tipo: <span id="tipo" class="data"></span>



        </div>
        <div id="msgNoPDF">
            <p>No tiene configurado el plugin de lectura de PDF en este navegador.</p>

            <p>
                Puede
                <a class="text-info" target="_blank" style="color: white" href="http://get.adobe.com/es/reader/">
                    <u>descargar Adobe Reader aquí</u>
                </a>
            </p>
        </div>
    </div>
</div>
<div class="btn-toolbar toolbar" style="margin-top: 0px;margin-bottom: 10;margin-left: -20px">
    <div class="btn-group">
        <g:link controller="uniformes" action="listaSemaforos" class="btn btn-default">
            <i class="fa fa-list"></i> Estaciones
        </g:link>
    </div>
</div>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<elm:message tipo="info" clase="">
    <ul style="margin-top: -20px;margin-left: 10px">
        <li>Recuerde que cualquier cambio a la nómina de la estación debe ser
        respaldada con un certificado del IESS que refleje lo registrado en el sistema.
        </li>
        <li>No olvide registrar las tallas de los empleados de la estación, con un clic en el botón:
            <a href="#" title="Tallas" class="btn btn-info btn-sm">
                <i class="fa fa-user"></i>
            </a>
        </li>
        <li>
            Si un empleado registrado previamente no está trabajando actualmente en la estación, use el botón:
            <td style="text-align: center">
                <a href="#" title="Activar / desactivar"  class="btn btn-warning btn-sm ">
                    <i class="fa fa-toggle-on"></i>
                </a>
            </td>
            para desactivarlo.
        </li>
    </ul>
</elm:message>

<elm:container titulo="Empleados de la estación: ${estacion.nombre}">
    <g:form action="subirCertificado" class="frmCertificado" enctype="multipart/form-data" >
        <input type="hidden" name="id" value="${estacion.codigo}">
        <div class="row" style="margin-top: 20px">
            <div class="col-md-2">
                <label>Certificado del IESS</label>
            </div>

            <g:if test="${certificado}">
                <div class="col-md-6">
                    <div id="botones-tdr">
                        <a href="#" data-file="${certificado.path}"
                           data-ref="Certificado del IESS"
                           data-codigo=""
                           data-tipo="Certificado del IESS"
                           target="_blank" class="btn btn-info ver-doc btn-sm" title="${certificado.path}" >
                            <i class="fa fa-search"></i> Ver
                        </a>
                        <a href="#" class="btn btn-info cambiar btn-sm" iden="tdr">
                            <i class="fa fa-refresh"></i> Actualizar
                        </a>
                    </div>
                    <div id="div-file-tdr" style="display: none">
                        <input type="file" name="file"  class="form-control "  style="border-right: none;width: 88%;display: inline-block" accept=".pdf">
                        <a href="#"  class=" subir btn btn-success" style="display: inline-block;margin-top: -5px">
                            <i  class="fa fa-upload"></i> Subir
                        </a>
                    </div>
                </div>
            </g:if>
            <g:else>
                <div class="col-md-5">
                    <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                </div>
                <div class="col-md-1">
                    <a href="#" class="subir btn btn-success">
                        <i  class="fa fa-upload"></i> Subir
                    </a>
                </div>
            </g:else>
        </div>

    </g:form>
    <div class="row">
        <div class="col-md-8">
            <table class="table table-condensed">
                <thead style="border:none !important;">
                <tr style="border: none !important;">
                    <th style="background: transparent;color: #000000;border: none !important;text-align: left;width: 60%">Nombre</th>
                    <th style="background: transparent;color: #000000;border: none !important;">Cédula</th>
                    <th style="background: transparent;color: #000000;border: none !important;width: 15%">Sexo</th>
                    <th style="background: transparent;color: #000000;border: none !important;"></th>
                </tr>
                </thead>
                <tbody style="border:none !important;">
                <tr>
                    <td>
                        <input type="hidden" id="iden">
                        <input type="text" id="nombre" class="form-control input-sm">
                    </td>
                    <td>
                        <input type="text" id="cedula" class="form-control input-sm digits " maxlength="10">
                    </td>
                    <td>
                        <select id="sexo" class="form-control input-sm">
                            <option value="M">Masculino</option>
                            <option value="F">Femenino</option>
                        </select>
                    </td>
                    <td style="text-align: center">
                        <a href="#" title="Agregar" id="agregar" class="btn btn-sm btn-info">
                            <i class="fa fa-plus"></i>
                        </a>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-8" id="detalles">

        </div>
    </div>

</elm:container>
<script type="text/javascript">
    function check_cedula( valor ){
        var cedula = valor
        array = cedula.split( "" );
        num = array.length;
        if ( num == 10 )
        {
            total = 0;
            digito = (array[9]*1);
            for( i=0; i < (num-1); i++ )
            {
                mult = 0;
                if ( ( i%2 ) != 0 ) {
                    total = total + ( array[i] * 1 );
                }
                else
                {
                    mult = array[i] * 2;
                    if ( mult > 9 )
                        total = total + ( mult - 9 );
                    else
                        total = total + mult;
                }
            }
            decena = total / 10;
            decena = Math.floor( decena );
            decena = ( decena + 1 ) * 10;
            final = ( decena - total );
            if ( ( final == 10 && digito == 0 ) || ( final == digito ) ) {

                return true;
            }
            else
            {

                return false;
            }
        }
        else
        {
            return false;
        }
    }
    function showPdf(div){
        $("#msgNoPDF").show();
        $("#doc").html("")
        var pathFile = div.data("file")
        $("#referencia-pdf").html(div.data("ref"))
        $("#codigo").html(div.data("codigo"))
        $("#tipo").html(div.data("tipo"))
        var path = "${resource()}/" + pathFile;
        var myPDF = new PDFObject({
            url           : path,
            pdfOpenParams : {
                navpanes: 1,
                statusbar: 0,
                view: "FitW"
            }
        }).embed("doc");
        $(".pdf-viewer").show("slide",{direction:'right'})
        $("#data").show()
    }
    function cargarEmpleados(){
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'uniformes', action:'listaEmpleados')}",
            data: {
                id:"${estacion.codigo}"
            },
            success: function (msg) {
                $("#detalles").html(msg)

            }
        });
    }
    cargarEmpleados()
    $("#agregar").click(function(){
        var nombre = $("#nombre").val()
        var cedula = $("#cedula").val()
        var sexo = $("#sexo").val()
        if(nombre!="" || cedula!=""){
            if(check_cedula(cedula)){
                $.ajax({
                    type: "POST",
                    url: "${createLink(controller:'uniformes', action:'addEmpleado')}",
                    data: {
                        nombre:nombre,
                        cedula:cedula,
                        sexo:sexo,
                        estacion:"${estacion.codigo}"
                    },
                    success: function (msg) {
                        $("#detalles").html(msg)
                        $("#nombre").val("")
                        $("#cedula").val("")

                    }
                });
            }else{
                bootbox.alert("Por favor, ingrese una cédula valida")
            }

        }else{
            bootbox.alert("Por favor, ingrese el nombre y cédula del empleado")
        }
    })
    $(".subir").click(function(){
        if($("#file").val()!=""){
            $(".frmCertificado").submit()
        }
    })
    $(".ver-doc").click(function(){
        showPdf($(this))
        return false
    })
    $(".pdf-handler").click(function(){
        $(".pdf-viewer").hide("slide",{direction:'right'})
        $("#data").hide()
    })
    $(".cambiar").click(function(){
        var id = $(this).attr("iden")
        $("#botones-"+id).hide()
        $("#div-file-"+id).show()
        return false
    })

</script>
</body>
</html>