<%@ page import="gaia.documentos.Consultor" %>
<g:if test="${session.tipo=='usuario'}">
    <div class="row">
        <div class="col-md-1">Consultor</div>

        <div class="col-md-3">
            <g:select name="cons" from="${Consultor.list([sort: 'nombre'])}" class="form-control input-sm"
                      optionKey="id" optionValue="nombre"/>
        </div>

        <div class="col-md-3">
            <a href="#" class="btn btn-success btn-sm" title="Agregar" id="btnAddCons">
                <i class="fa fa-plus"></i>
            </a>
            <a href="#" class="btn btn-success btn-sm" title="Registrar nuevo consultor" id="btnCreateCons">
                <i class="fa fa-file-o"></i> Registrar nuevo consultor
            </a>
        </div>
    </div>
</g:if>
<div class="row">
    <div class="col-md-12" id="divConsultores">

    </div>
</div>

<script type="text/javascript">
    var $div = $("#divConsultores");
    function loadConsultores() {
        $div.html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'consultor', action:'listEstacion_ajax')}",
            data    : {
                codigo : "${estacion.codigo}"
            },
            success : function (msg) {
                $div.html(msg);
            }
        });
    }

    function submitFormConsultor() {
        var $form = $("#frmConsultor");
        var $btn = $("#dlgCreateEditConsultor").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Consultor");
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
                            $("#cons").replaceWith(parts[2]);
                            $("#dlgCreateEditConsultor").modal("hide");
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
    function createEditConsultor(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? { id : id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'consultor', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditConsultor",
                    title : title + " Consultor",

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
                                return submitFormConsultor();
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
        loadConsultores();

        $("#btnAddCons").click(function () {
            var cons = $("#cons").val();
            var esta = "${estacion.codigo}";

            var existe = false;
            $("#tbCons").children("tr").each(function () {
                var $tr = $(this);
                var c = $tr.data("cons");
                if (c == cons) {
                    existe = true;
                    $tr.effect("highlight", 800);
                }
            });

            if (!existe) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'consultor', action:'addConsultor_ajax')}",
                    data    : {
                        codigo : "${estacion.codigo}",
                        cons   : cons
                    },
                    success : function (msg) {
                        var parts = msg.split("*");
                        log(parts[1], parts[0].toLowerCase());
                        if (parts[0] == "SUCCESS") {
                            loadConsultores();
                        }
                    }
                });
            }
        });

        $("#btnCreateCons").click(function () {
            createEditConsultor();
        });
    });
</script>