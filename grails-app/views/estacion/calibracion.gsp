<html>
<head>
    <meta name="layout" content="main"/>
    <title>Estación ${estacion.nombre}</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <script src="${resource(dir: 'js/plugins/ckeditor-4.4.6/', file: 'ckeditor.js')}"></script>

    <style>
    .blog {
        overflow-y    : auto;
        width         : 100%;
        border-radius : 5px;
        border        : 1px solid #000000;
        padding       : 10px;
        position      : relative;
        font-size     : 12px;
    }

    .more {
        width       : 99%;
        height      : 30px;
        line-height : 30px;
        bottom      : 5px;
        text-align  : center;
        color       : #006EB7;
        cursor      : pointer;
    }

    .entrada-row {
        width         : 99%;
        border        : 1px solid #3758A1;
        padding       : 10px;
        background    : none;
        border-radius : 5px;
        margin-bottom : 10px;
        position      : relative;
    }

    legend {
        padding-left : 10px;
        font-size    : 15px;
    }

    .header-entrada {
        cursor : pointer;
    }

    .delete {
        position : absolute;
        bottom   : 5px;
        right    : 5px;
        color    : red;
    }
    </style>
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
</head>

<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<div class="pdf-viewer">
    <div class="pdf-content">
        <div class="pdf-container" id="doc"></div>

        <div class="pdf-handler">
            <i class="fa fa-arrow-right"></i>
        </div>

        <div class="pdf-header" id="data">
            N. Referencia: <span id="referencia-pdf" class="data"></span>

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
<elm:container tipo="horizontal" titulo="Calibración diaria de la estación: ${estacion.nombre}" style="margin-top:0px">

    <div class="row">
        <div class="col-md-3">
            <div class="btn-toolbar toolbar">
                <div class="btn-group">
                    <g:link controller="estacion" action="showEstacion" id="${estacion.codigo}" class="btn btn-default btn-sm">
                        Estación
                    </g:link>
                    <a href="#" class="btn btn-info btn-sm" id="agregar">
                        <i class="fa fa-plus"></i>
                        Agregar entrada
                    </a>

                    <a href="#" class="btn btn-default btn-sm" id="oficio">
                        <i class="fa fa-file-pdf-o"></i>
                        Oficio
                    </a>

                </div>
            </div>
        </div>

        <g:form action="calibracion">
            <input type="hidden" name="id" value="${estacion.codigo}">
            <input type="hidden" name="limite" value="20">

            <div class="col-md-1">
                <label>
                    Desde
                </label>
            </div>

            <div class="col-md-2">
                <elm:datepicker name="inicio" class="form-control input-sm inicio required" value="${inicio}"/>
            </div>

            <div class="col-md-1">
                <label>
                    Hasta
                </label>
            </div>

            <div class="col-md-2">
                <elm:datepicker name="fin" class="form-control input-sm fin required" value="${fin}"/>
            </div>
            <div class="col-md-1">
                <input type="submit" class="btn btn-info btn-sm" value=" Filtrar">

                </a>
            </div>
        </g:form>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="blog">

                <g:each in="${entradas}" var="e" status="i">
                    <div class="entrada-row">
                        <legend class="svt-bg-info header-entrada">Por: ${e.persona ? e.persona.login : e.estacion.nombre}, el ${e.fecha.format("dd-MM-yyyy HH:mm:ss")}</legend>

                        <div class="row">
                            <div class="col-md-12">
                                ${e.texto}
                            </div>
                        </div>
                        <g:if test="${e.path && e.path != ''}">
                            <div class="row">
                                <div class="col-md-2" style="width: 120px">
                                    <label>Archivo adjunto:</label>
                                </div>

                                <div class="col-md-10">
                                    <a href="#" class="btn btn-success btn-sm ver-doc ${e.tipo}" iden="${e.id}" file="${e.path}">
                                        <i class="fa fa-search"></i> Ver
                                    </a>
                                    <g:if test="${e.tipo == 'I'}">
                                        <a href="${resource()}/${e.path}" target="_blank" class="btn btn-success btn-sm descargar" iden="${e.id}" file="${e.path}">
                                            <i class="fa fa-download"></i> Abrir
                                        </a>
                                    </g:if>
                                </div>
                            </div>
                        </g:if>
                        <g:if test="${session.tipo=='usuario'}">
                            <div class="delete">
                                <a href="#" class="eliminar btn btn-danger btn-sm" id="${e.id}" title="Eliminar">
                                    <i class="fa fa-trash"></i>
                                </a>
                            </div>
                        </g:if>
                    </div>
                </g:each>
                <g:if test="${entradas.size() == 0}">
                    <div class="entrada-row">
                        No se encontraron entradas
                    </div>
                </g:if>
                <g:if test="${entradas.size() > limite - 1}">
                    <g:link controller="estacion" action="calibracion" params="[id: estacion.codigo, limite: limite + 20, inicio_input: inicio, fin_input: fin]">
                        <div class="more">
                            Cargar más
                        </div>
                    </g:link>
                </g:if>
            </div>
        </div>
    </div>
</elm:container>
<div class="modal fade" id="modal-entrada">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">Nueva entrada</h4>
            </div>

            <div class="modal-body">
                <g:form class="frm-subir" controller="estacion" action="nuevaEntrada" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${estacion.codigo}">

                    <div class="row">
                        <div class="col-md-1">
                            <label>Estación</label>
                        </div>
                        <div class="col-md-4">
                            ${estacion.nombre}
                        </div>
                        <div class="col-md-1">
                            <label>Manguera</label>
                        </div>
                        <div class="col-md-3">
                            <g:select name="manguera" from="${mangueras}" optionKey="codigo" optionValue="codigo" id="manguera" class="form-control input-sm" noSelection="['-1':'Seleccione']"></g:select>
                        </div>
                        <div class="col-md-1">
                            <a href="#" class="btn btn-default btn-sm" id="copiar">
                                Copiar Código
                            </a>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-md-12">
                            <textarea id="texto" name="texto" class="form-control input-sm ckeditor"></textarea>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-2">
                            <label>Adjuntar (PDF/Imagen)</label>
                        </div>

                        <div class="col-md-8">
                            <input type="file" name="file" id="file" class="form-control">
                        </div>
                    </div>
                </g:form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-info" id="guardar">Guardar</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->


<div class="modal fade" id="modal-oficio">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">Oficio</h4>
            </div>

            <div class="modal-body">
                <g:form class="frm-oficio" controller="estacion" action="oficio" >
                    <input type="hidden" name="id" value="${estacion.codigo}">

                    <div class="row">
                        <div class="col-md-1">
                            <label>Estación</label>
                        </div>
                        <div class="col-md-4">
                            ${estacion.nombre}
                        </div>
                        <div class="col-md-1">
                            <label>Manguera</label>
                        </div>
                        <div class="col-md-3">
                            <g:select name="manguera" from="${mangueras}" optionKey="codigo" optionValue="codigo" id="manguera_oficio" class="form-control input-sm" noSelection="['-1':'Seleccione']"></g:select>
                        </div>


                    </div>
                    <div class="row">
                        <div class="col-md-1">
                            <label>Para: </label>
                        </div>
                        <div class="col-md-4">
                            <input type="text" name="para" id="para" class="form-control input-sm">
                        </div>
                        <div class="col-md-1">
                            <label>Número: </label>
                        </div>
                        <div class="col-md-3">
                            <input type="text" name="numero" id="numero" class="form-control input-sm">
                        </div>
                        <div class="col-md-1">
                            <a href="#" id="generar" class="btn btn-info btn-sm">Generar</a>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <textarea id="texto_oficio" name="texto_oficio" class="form-control input-sm ckeditor"></textarea>
                        </div>
                    </div>


                </g:form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-info" id="guardar_oficio">Guardar</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script type="text/javascript">
    function showPdf(div) {
        $("#msgNoPDF").show();
        $("#doc").html("")
        var pathFile = div.attr("file")
        $("#referencia-pdf").html("Archivo adjunto")
        var path = "${resource()}/" + pathFile;
        var myPDF = new PDFObject({
            url           : path,
            pdfOpenParams : {
                navpanes  : 1,
                statusbar : 0,
                view      : "FitW"
            }
        }).embed("doc");
        $(".pdf-viewer").show("slide", {direction : 'right'})
        $("#data").show()
    }
    function showImg(div) {
        $("#msgNoPDF").hide();
        $("#doc").html("")
        var pathFile = div.attr("file")
        $("#referencia-pdf").html("Archivo adjunto")
        var path = "${resource()}/" + pathFile;
        $("#doc").html("<img src='" + path + "' width='100%'></img>")
        $(".pdf-viewer").show("slide", {direction : 'right'})
        $("#data").show()
    }
    $(".eliminar").click(function () {
        var boton = $(this)
        bootbox.confirm({
            message  : "Está seguro? Está acción no puede revertirse",
            title    : "Atención",
            class    : "modal-error",
            callback : function (res) {
                if (res) {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:'estacion', action:'borrarEntrada')}",
                        data    : {
                            id : boton.attr("id")
                        },
                        success : function (msg) {
                            boton.parent().parent().remove()
                            // console.log(boton.parent().parent())
                        }
                    });
                }
            }
        })
    })
    $(".header-entrada").click(function () {
        $(this).parent().find(".row").toggle()
    })
    $(".P").click(function () {
        showPdf($(this))
        return false
    })
    $(".I").click(function () {
        showImg($(this))
        return false
    })
    $(".pdf-handler").click(function () {
        $(".pdf-viewer").hide("slide", {direction : 'right'})
        $("#data").hide()
    })
    $("#agregar").click(function () {
        $("#modal-entrada").modal("show")
    })
    $("#oficio").click(function () {
        $("#modal-oficio").modal("show")
    })

    $("#generar").click(function(){
        var m_names = new Array("Enero", "Febrero", "Marzo",
                "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre",
                "Octubre", "Noviembre", "Diciembre");

        var d = new Date();
        var curr_date = d.getDate();
        var curr_month = d.getMonth();
        var curr_year = d.getFullYear();

        var fecha =""+curr_date + " de " + m_names[curr_month]+ " de " + curr_year
        var texto = "<p>Quito, "+fecha+"</p>"
        texto+="<p>Oficio número: "+$("#numero").val()+"</p>"
        texto+="<p>Para: "+$("#para").val()+"</p>"
        texto+="<p>Calibración de la manguera: "+$("#manguera_oficio").val()+"</p>"
       // console.log(CKEDITOR.instances)

        if($("#manguera_oficio").val()!="-1"){
            CKEDITOR.instances.texto_oficio.setData(texto)
        }
        return false
    })


    $("#copiar").click(function(){
        if($("#manguera").val()!="-1"){
            CKEDITOR.instances.texto.setData(CKEDITOR.instances.texto.getData().substring(0,CKEDITOR.instances.texto.getData().length-5)+" "+$("#manguera").val()+"</p>")
        }
        return false
        //$(".cke_contents_ltr").append($("#manguera").val())
    })

    $("#guardar").click(function () {
        var data = CKEDITOR.instances.texto.getData()
        if (data.length > 0) {
            $(".frm-subir").submit()
        } else {
            bootbox.alert({
                message : "Por favor, ingrese el texto de la entrada",
                title   : "Error",
                class   : "modal-error"

            })
        }
    });
    $("#guardar_oficio").click(function () {
        var data = CKEDITOR.instances.texto_oficio.getData()
        if (data.length > 0) {
            $(".frm-oficio").submit()
        } else {
            bootbox.alert({
                message : "Por favor, ingrese el texto de la entrada",
                title   : "Error",
                class   : "modal-error"

            })
        }
    });

    var _validFileExtensions = [".jpg", ".jpeg", ".png", ".pdf"];
    $("#file").change(function () {
        var sFileName = $(this).val();
        if (sFileName.length > 0) {
            var blnValid = false;
            for (var j = 0; j < _validFileExtensions.length; j++) {
                var sCurExtension = _validFileExtensions[j];
                if (sFileName.substr(sFileName.length - sCurExtension.length, sCurExtension.length).toLowerCase() == sCurExtension.toLowerCase()) {
                    blnValid = true;
                    break;
                }
            }

            if (!blnValid) {
                bootbox.alert({
                    message : "El archivo " + sFileName + " es invalido, los tipos de archivos permitidos son: " + _validFileExtensions.join(", "),
                    title   : "Error",
                    class   : "modal-error"

                })
                $("#file").replaceWith($("#file").val('').clone(true));
                return false;

            }
        }
    })
</script>
</body>
</html>