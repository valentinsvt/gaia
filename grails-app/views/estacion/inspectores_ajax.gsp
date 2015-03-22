<%@ page import="gaia.documentos.Inspector" %>
<g:if test="${session.usuario=='usuario'}">
    <div class="row">
        <div class="col-md-1">Supervisor</div>

        <div class="col-md-3">
            <g:select name="ins" from="${Inspector.list([sort: 'nombre'])}" class="form-control input-sm"
                      optionKey="id" optionValue="nombre"/>
        </div>

        <div class="col-md-3">
            <a href="#" class="btn btn-success btn-sm" title="Agregar" id="btnAddIns">
                <i class="fa fa-plus"></i>
            </a>
            <a href="#" class="btn btn-success btn-sm" title="Registrar nuevo supervisor" id="btnCreateIns">
                <i class="fa fa-file-o"></i> Registrar nuevo supervisor
            </a>
        </div>
    </div>
</g:if>
<div class="row">
    <div class="col-md-12" id="divInspectores">

    </div>
</div>

<script type="text/javascript">
    var $div = $("#divInspectores");
    function loadInspectores() {
        $div.html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'inspector', action:'listEstacion_ajax')}",
            data    : {
                codigo : "${estacion.codigo}"
            },
            success : function (msg) {
                $div.html(msg);
            }
        });
    }

    function submitFormInspector() {
        var $form = $("#frmInspector");
        var $btn = $("#dlgCreateEditInspector").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Supervisor");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    closeLoader();
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function () {
                        if (parts[0] == "SUCCESS") {
                            $("#ins").replaceWith(parts[2]);
                            $("#dlgCreateEditInspector").modal("hide");
                        } else {
                            spinner.replaceWith($btn);
                            return false;
                        }
                    }, 1000);
                },
                error   : function () {
                    log("Ha ocurrido un error interno", "Error");
                    closeLoader();
                }
            });
        } else {
            return false;
        } //else
    }
    function createEditInspector(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? { id : id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'inspector', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditInspector",
                    title : title + " Supervisor",

                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormInspector();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    $(function () {
        loadInspectores();

        $("#btnAddIns").click(function () {
            var ins = $("#ins").val();
            var est = "${estacion.codigo}";

            var existe = false;
            $("#tbIns").children("tr").each(function () {
                var $tr = $(this);
                var c = $tr.data("ins");
                if (c == ins) {
                    existe = true;
                    $tr.effect("highlight", 800);
                }
            });

            if (!existe) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'inspector', action:'addInspector_ajax')}",
                    data    : {
                        codigo : est,
                        ins    : ins
                    },
                    success : function (msg) {
                        var parts = msg.split("*");
                        log(parts[1], parts[0].toLowerCase());
                        if (parts[0] == "SUCCESS") {
                            loadInspectores();
                        }
                    }
                });
            }
        });

        $("#btnCreateIns").click(function () {
            createEditInspector();
        });

    });
</script>