<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 2/18/14
  Time: 12:39 PM
--%>

<html>
    <head>
        <meta name="layout" content="main">
        <title>Configuración personal</title>

        <!-- The Load Image plugin is included for the preview images and image resizing functionality -->
        <imp:js src="${resource(dir: 'js/plugins/jQuery-File-Upload-5.42.2/js/imgResize', file: 'load-image.min.js')}"/>
        <!-- The Canvas to Blob plugin is included for image resizing functionality -->
        <imp:js src="${resource(dir: 'js/plugins/jQuery-File-Upload-5.42.2/js/imgResize', file: 'canvas-to-blob.min.js')}"/>
        <!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
        <imp:js src="${resource(dir: 'js/plugins/jQuery-File-Upload-5.42.2/js', file: 'jquery.iframe-transport.js')}"/>
        <!-- The basic File Upload plugin -->
        <imp:js src="${resource(dir: 'js/plugins/jQuery-File-Upload-5.42.2/js', file: 'jquery.fileupload.js')}"/>
        <!-- The File Upload processing plugin -->
        <imp:js src="${resource(dir: 'js/plugins/jQuery-File-Upload-5.42.2/js', file: 'jquery.fileupload-process.js')}"/>
        <!-- The File Upload image preview & resize plugin -->
        <imp:js src="${resource(dir: 'js/plugins/jQuery-File-Upload-5.42.2/js', file: 'jquery.fileupload-image.js')}"/>

        <imp:css src="${resource(dir: 'js/plugins/jQuery-File-Upload-5.42.2/css', file: 'jquery.fileupload.css')}"/>

        <style type="text/css">
        .table {
            font-size     : 13px;
            width         : auto !important;
            margin-bottom : 0 !important;
        }

        .container-celdasAcc {
            max-height : 200px;
            width      : 804px; /*554px;*/
            overflow   : auto;
        }

        .col100 {
            width : 100px;
        }

        .col200 {
            width : 250px;
        }

        .col300 {
            width : 304px;
        }

        .col-md-1.xs {
            width : 45px;
        }

        </style>

    </head>

    <body>
        <div class="form-group">
            <div class="alert alert-info">
                Datos del usuario: <strong>${usuario.nombre} ${usuario.apellido} (${usuario.login})</strong>
            </div>
        </div>

        <div class="panel-group" id="accordion">

            <g:set var="abierto" value="${false}"/>

            <g:set var="abierto" value="${true}"/>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapsePass">
                            Cambiar contraseña
                        </a>
                    </h4>
                </div>

                <div id="collapsePass" class="panel-collapse collapse  ${params.tipo == 'foto' ? '' : 'in'}">
                    <div class="panel-body">
                        <g:form class="form-horizontal" name="frmPass" role="form" action="savePass_ajax" method="POST">
                            <div class="form-group required">
                                %{--<div class="form-group required">--}%
                                %{--<span class="grupo">--}%
                                <span class="form-grup col-md-3">
                                    <label for="password_actual" class="control-label text-info">
                                        Contraseña actual
                                    </label>

                                    %{--<div class="col-md-2">--}%
                                    <div class="input-group">
                                        <g:passwordField name="password_actual" class="form-control required"/>
                                        <span class="input-group-addon"><i class="fa fa-unlock"></i></span>
                                    </div>
                                    %{--</div>--}%
                                </span>
                                %{--</div>--}%

                                <span class="form-grup col-md-3">
                                    <label for="password" class="control-label text-info">
                                        Nueva contraseña
                                    </label>

                                    %{--<div class="col-md-3">--}%
                                    <div class="input-group">
                                        <g:passwordField name="password" class="form-control required"/>
                                        <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                                    </div>
                                    %{--</div>--}%
                                </span>
                                <span class="form-grup col-md-3">
                                    <label for="password_again" class="control-label text-info">
                                        Confirme la contraseña
                                    </label>

                                    %{--<div class="col-md-3">--}%
                                    <div class="input-group">
                                        <g:passwordField name="password_again" class="form-control required" equalTo="#password"/>
                                        <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                                    </div>
                                    %{--</div>--}%
                                </span>

                                <div class="col-md-2" style="margin-top: 20px;">
                                    <a href="#" class="btn btn-success" id="btnPass">
                                        <i class="fa fa-save"></i> Guardar
                                    </a>
                                </div>
                            </div>
                        </g:form>
                    </div>
                </div>
            </div>

            %{--<div class="panel panel-default">--}%
            %{--<div class="panel-heading">--}%
            %{--<h4 class="panel-title">--}%
            %{--<a data-toggle="collapse" data-parent="#accordion" href="#collapseAuth">--}%
            %{--Cambiar autorización--}%
            %{--</a>--}%
            %{--</h4>--}%
            %{--</div>--}%

            %{--<div id="collapseAuth" class="panel-collapse collapse ">--}%
            %{--<div class="panel-body">--}%
            %{--<g:form class="form-horizontal" name="frmPass" role="form" action="savePass_ajax" method="POST">--}%
            %{--<div class="form-group required">--}%
            %{--<div class="form-group required">--}%
            %{--<span class="grupo">--}%
            %{--<span class="form-grup col-md-3">--}%
            %{--<label for="auth_actual" class="control-label text-info">--}%
            %{--Autorización actual--}%
            %{--</label>--}%

            %{--<div class="col-md-2">--}%
            %{--<div class="input-group">--}%
            %{--<g:passwordField name="auth_actual" class="form-control required"/>--}%
            %{--<span class="input-group-addon"><i class="fa fa-unlock"></i></span>--}%
            %{--</div>--}%
            %{--</div>--}%
            %{--</span>--}%
            %{--</div>--}%

            %{--<span class="form-grup col-md-3">--}%
            %{--<label for="auth" class="control-label text-info">--}%
            %{--Nueva autorización--}%
            %{--</label>--}%

            %{--<div class="col-md-3">--}%
            %{--<div class="input-group">--}%
            %{--<g:passwordField name="auth" class="form-control required"/>--}%
            %{--<span class="input-group-addon"><i class="fa fa-lock"></i></span>--}%
            %{--</div>--}%
            %{--</div>--}%
            %{--</span>--}%
            %{--<span class="form-grup col-md-3">--}%
            %{--<label for="auth_again" class="control-label text-info">--}%
            %{--Confirme la autorización--}%
            %{--</label>--}%

            %{--<div class="col-md-3">--}%
            %{--<div class="input-group">--}%
            %{--<g:passwordField name="auth_again" class="form-control required" equalTo="#password"/>--}%
            %{--<span class="input-group-addon"><i class="fa fa-lock"></i></span>--}%
            %{--</div>--}%
            %{--</div>--}%
            %{--</span>--}%

            %{--<div class="col-md-2" style="margin-top: 20px;">--}%
            %{--<a href="#" class="btn btn-success" id="btnAuth">--}%
            %{--<i class="fa fa-save"></i> Guardar--}%
            %{--</a>--}%
            %{--</div>--}%
            %{--</div>--}%
            %{--</g:form>--}%
            %{--</div>--}%
            %{--</div>--}%
            %{--</div>--}%

            %{--<div class="panel panel-default">--}%
            %{--<div class="panel-heading">--}%
            %{--<h4 class="panel-title">--}%
            %{--<a data-toggle="collapse" data-parent="#accordion" href="#collapseTelf">--}%
            %{--Datos personales--}%
            %{--</a>--}%
            %{--</h4>--}%
            %{--</div>--}%

            %{--<div id="collapseTelf" class="panel-collapse collapse ">--}%
            %{--<div class="panel-body">--}%
            %{--<g:form class="form-horizontal frmTelf" name="frmTelf" role="form" action="saveTelf" method="POST">--}%
            %{--<div class="form-group required">--}%
            %{--<div class="form-group required">--}%
            %{--<span class="grupo">--}%
            %{--<span class="form-grup col-md-3">--}%
            %{--<label for="telefono" class="control-label text-info">--}%
            %{--Número de teléfono--}%
            %{--</label>--}%

            %{--<div class="col-md-2">--}%
            %{--<div class="input-group">--}%
            %{--<g:textField name="telefono" id="telefono" class="form-control digits required" value=""/>--}%
            %{--<span class="input-group-addon"><i class="fa fa-phone"></i></span>--}%
            %{--</div>--}%
            %{--</div>--}%
            %{--</span>--}%
            %{--</div>--}%

            %{--<div class="col-md-2" style="margin-top: 20px;">--}%
            %{--<a href="#" class="btn btn-success" id="btnTelf">--}%
            %{--<i class="fa fa-save"></i> Guardar--}%
            %{--</a>--}%
            %{--</div>--}%
            %{--</div>--}%
            %{--</g:form>--}%
            %{--</div>--}%
            %{--</div>--}%
            %{--</div>--}%

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseFoto">
                            Cambiar foto
                        </a>
                    </h4>
                </div>

                <div id="collapseFoto" class="panel-collapse collapse ${params.tipo == 'foto' || !abierto ? 'in' : ''} ">
                    <div class="panel-body">
                        <div class="btn btn-success fileinput-button" style="margin-bottom: 10px;">
                            <i class="fa fa-plus"></i>
                            <span>Seleccionar imagen</span>
                            <!-- The file input field used as target for the file up3 widget -->
                            <input type="file" name="file" id="file">
                        </div>

                        <div class="alert alert-warning" style="float: right; width: 600px;">
                            <i class="fa fa-warning fa-3x pull-left"></i>
                            Si la foto subida es muy grande, se mostrará un área de selección para recortar la imagen al formato requerido.
                        </div>
                        <g:if test="${usuario.foto && usuario.foto != ''}">
                            <div id="divFoto">
                            </div>
                        </g:if>
                        <g:else>
                            <div class="alert alert-info">
                                <i class="fa fa-picture-o fa-2x"></i>
                                No ha subido ninguna fotografía
                            </div>
                        </g:else>

                        <div id="progress" class="progress progress-striped active">
                            <div class="progress-bar progress-bar-success"></div>
                        </div>

                        <div id="files"></div>
                    </div>
                </div>
            </div>
        </div>


        <script type="text/javascript">
            $(function () {
                var $btnPass = $("#btnPass");
                var $frmPass = $("#frmPass");
                var $btnAuth = $("#btnAuth");
                var $frmAuth = $("#frmAuth");

                $("#password_actual").val("");
                $("#auth_actual").val("");

                $('#file').fileupload({
                    url              : '${createLink(action:'uploadFile')}',
                    dataType         : 'json',
                    maxNumberOfFiles : 1,
                    acceptFileTypes  : /(\.|\/)(jpe?g|png)$/i,
                    maxFileSize      : 1000000 // 1 MB
                }).on('fileuploadadd', function (e, data) {
//                    console.log("fileuploadadd");
                    openLoader("Cargando");
                    data.context = $('<div/>').appendTo('#files');
                    $.each(data.files, function (index, file) {
                        var node = $('<p/>')
                                .append($('<span/>').text(file.name));
                        if (!index) {
                            node
                                    .append('<br>');
                        }
                        node.appendTo(data.context);
                    });
                }).on('fileuploadprocessalways', function (e, data) {
//                    console.log("fileuploadprocessalways");
                    var index = data.index,
                            file = data.files[index],
                            node = $(data.context.children()[index]);
                    if (file.preview) {
                        node
                                .prepend('<br>')
                                .prepend(file.preview);
                    }
                    if (file.error) {
                        node
                                .append('<br>')
                                .append($('<span class="text-danger"/>').text(file.error));
                    }
                    if (index + 1 === data.files.length) {
                        data.context.find('button')
                                .text('Upload')
                                .prop('disabled', !!data.files.error);
                    }
                }).on('fileuploadprogressall', function (e, data) {
//                    console.log("fileuploadprogressall");
                    var progress = parseInt(data.loaded / data.total * 100, 10);
                    $('#progress .progress-bar').css(
                            'width',
                            progress + '%'
                    );
                }).on('fileuploaddone', function (e, data) {
//                    closeLoader();
                    setTimeout(function () {
                        location.href = "${createLink(action: 'personal', params:[tipo:'foto'])}";
                    }, 1000);
                }).on('fileuploadfail', function (e, data) {
                    closeLoader();
                    $.each(data.files, function (index, file) {
                        var error = $('<span class="text-danger"/>').text('File upload failed.');
                        $(data.context.children()[index])
                                .append('<br>')
                                .append(error);
                    });
                });

                function loadFoto() {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action: 'loadFoto')}",
                        success : function (msg) {
                            $("#divFoto").html(msg);
                        }
                    });
                }

                function submitPass() {
                    var url = $frmPass.attr("action");
//                    var data = $frmPass.serialize();
//                    data += "&tipo=pass";

                    var data = {
                        input2 : $("#password").val(),
                        input3 : $("#password_again").val(),
                        tipo   : "pass"
                    };

                    if ($frmPass.valid()) {
                        $btnPass.hide().after(spinner);
                        $.ajax({
                            type    : "POST",
                            url     : url,
                            data    : data,
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                spinner.remove();
                                $btnPass.show();
                                $frmPass.find("input").val("");
                                validatorPass.resetForm();
                            }
                        });
                    }
                }

                function submitAuth() {
                    var url = $frmAuth.attr("action");
//                    var data = $frmPass.serialize();
//                    data += "&tipo=pass";

                    var data = {
                        input2 : $("#auth").val(),
                        input1 : $("#auth_actual").val(),
                        tipo   : "auth"
                    };

                    if ($frmAuth.valid()) {
                        $btnAuth.hide().after(spinner);
                        $.ajax({
                            type    : "POST",
                            url     : url,
                            data    : data,
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                spinner.remove();
                                $btnAuth.show();
                                $frmAuth.find("input").val("");
                                validatorAuth.resetForm();
                            }
                        });
                    }
                }

                loadFoto();

                $frmPass.find("input").keyup(function (ev) {
                    if (ev.keyCode == 13) {
                        submitPass();
                    }
                });
                $frmAuth.find("input").keyup(function (ev) {
                    if (ev.keyCode == 13) {
                        submitAuth();
                    }
                });
                var validatorTelf = $(".frmTelf").validate({
                    errorClass     : "help-block",
                    errorPlacement : function (error, element) {
                        if (element.parent().hasClass("input-group")) {
                            error.insertAfter(element.parent());
                        } else {
                            error.insertAfter(element);
                        }
                        element.parents(".grupo").addClass('has-error');
                    },

                    success : function (label) {
                        label.parents(".grupo").removeClass('has-error');
                    }
                });
                var validatorPass = $frmPass.validate({
                    errorClass     : "help-block",
                    errorPlacement : function (error, element) {
                        if (element.parent().hasClass("input-group")) {
                            error.insertAfter(element.parent());
                        } else {
                            error.insertAfter(element);
                        }
                        element.parents(".grupo").addClass('has-error');
                    },
                    rules          : {
                        password_actual : {
                            remote : {
                                url  : "${createLink(action:'validarPass_ajax')}",
                                type : "post"
                            }
                        }
                    },
                    messages       : {
                        password_actual : {
                            remote : "El password actual no coincide"
                        }
                    },
                    success        : function (label) {
                        label.parents(".grupo").removeClass('has-error');
                    }
                });
                $btnPass.click(function () {
                    submitPass();
                });
                var validatorAuth = $frmAuth.validate({
                    errorClass     : "help-block",
                    errorPlacement : function (error, element) {
                        if (element.parent().hasClass("input-group")) {
                            error.insertAfter(element.parent());
                        } else {
                            error.insertAfter(element);
                        }
                        element.parents(".grupo").addClass('has-error');
                    },
                    rules          : {
                        auth_actual : {
                            remote : {
                                url  : "${createLink(action:'validarAuth_ajax')}",
                                type : "post"
                            }
                        }
                    },
                    messages       : {
                        auth_actual : {
                            remote : "la autorización actual no coincide"
                        }
                    },
                    success        : function (label) {
                        label.parents(".grupo").removeClass('has-error');
                    }
                });
                $btnAuth.click(function () {
                    submitAuth();
                });
                $("#btnTelf").click(function () {
                    var url = $(".frmTelf").attr("action");
                    var data = $(".frmTelf").serialize();
                    if ($(".frmTelf").valid()) {
                        $("#btnTelf").hide().after(spinner);
                        $.ajax({
                            type    : "POST",
                            url     : url,
                            data    : data,
                            success : function (msg) {

                                var parts = msg.split("_");
                                log(parts[1], parts[0] == "OK" ? "success" : "error");
                                spinner.remove();
                                $("#btnTelf").show();
//                        $(".frmTelf").find("input").val("");
                                validatorTelf.resetForm();
                            }
                        });
                    }
                });
            });
        </script>

    </body>
</html>