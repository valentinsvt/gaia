<%@ page import="gaia.estaciones.Estacion" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Estacion</title>
</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-default btnCrear">
            <i class="fa fa-file-o"></i> Crear
        </a>
    </div>

    <div class="btn-group pull-right col-md-3">
        <div class="input-group">
            <input type="text" class="form-control input-search" placeholder="Buscar" value="${params.search}">
            <span class="input-group-btn">
                <g:link controller="estacion" action="list" class="btn btn-default btn-search">
                    <i class="fa fa-search"></i>&nbsp;
                </g:link>
            </span>
        </div><!-- /input-group -->
    </div>
</div>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>

        <g:sortableColumn property="direccion" title="Direccion"/>

        <g:sortableColumn property="mail" title="Mail"/>

        <g:sortableColumn property="telefono" title="Telefono"/>

        <g:sortableColumn property="propetario" title="Propetario"/>

        <g:sortableColumn property="representante" title="Representante"/>

        <g:sortableColumn property="aplicacion" title="Aplicacion"/>

    </tr>
    </thead>
    <tbody>
    <g:if test="${estacionInstanceCount > 0}">
        <g:each in="${estacionInstanceList}" status="i" var="estacionInstance">
            <tr data-id="${estacionInstance.id}">

                <td>${estacionInstance.direccion}</td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${estacionInstance}"
                                                                              field="mail"/></elm:textoBusqueda></td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${estacionInstance}"
                                                                              field="telefono"/></elm:textoBusqueda></td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${estacionInstance}"
                                                                              field="propetario"/></elm:textoBusqueda></td>

                <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${estacionInstance}"
                                                                              field="representante"/></elm:textoBusqueda></td>

                <td><g:fieldValue bean="${estacionInstance}" field="aplicacion"/></td>

            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr class="danger">
            <td class="text-center" colspan="10">
                <g:if test="${params.search && params.search != ''}">
                    No se encontraron resultados para su búsqueda
                </g:if>
                <g:else>
                    No se encontraron registros que mostrar
                </g:else>
            </td>
        </tr>
    </g:else>
    </tbody>
</table>

<elm:pagination total="${estacionInstanceCount}" params="${params}"/>

<script type="text/javascript">
    var id = null;
    function submitFormEstacion() {
        var $form = $("#frmEstacion");
        var $btn = $("#dlgCreateEditEstacion").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Estacion");
            $.ajax({
                type: "POST",
                url: $form.attr("action"),
                data: $form.serialize(),
                success: function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function () {
                        if (parts[0] == "SUCCESS") {
                            location.reload(true);
                        } else {
                            spinner.replaceWith($btn);
                            closeLoader();
                            return false;
                        }
                    }, 1000);
                },
                error: function () {
                    log("Ha ocurrido un error interno", "Error");
                    closeLoader();
                }
            });
        } else {
            return false;
        } //else
    }
    function deleteEstacion(itemId) {
        bootbox.dialog({
            title: "Alerta",
            message: "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +
            "¿Está seguro que desea eliminar el Estacion seleccionado? Esta acción no se puede deshacer.</p>",
            buttons: {
                cancelar: {
                    label: "Cancelar",
                    className: "btn-primary",
                    callback: function () {
                    }
                },
                eliminar: {
                    label: "<i class='fa fa-trash-o'></i> Eliminar",
                    className: "btn-danger",
                    callback: function () {
                        openLoader("Eliminando Estacion");
                        $.ajax({
                            type: "POST",
                            url: '${createLink(controller:'estacion', action:'delete_ajax')}',
                            data: {
                                id: itemId
                            },
                            success: function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                if (parts[0] == "SUCCESS") {
                                    setTimeout(function () {
                                        location.reload(true);
                                    }, 1000);
                                } else {
                                    closeLoader();
                                }
                            },
                            error: function () {
                                log("Ha ocurrido un error interno", "Error");
                                closeLoader();
                            }
                        });
                    }
                }
            }
        });
    }
    function createEditEstacion(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id: id} : {};
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'estacion', action:'form_ajax')}",
            data: data,
            success: function (msg) {
                var b = bootbox.dialog({
                    id: "dlgCreateEditEstacion",
                    title: title + " Estacion",

                    class: "modal-lg",

                    message: msg,
                    buttons: {
                        cancelar: {
                            label: "Cancelar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        },
                        guardar: {
                            id: "btnSave",
                            label: "<i class='fa fa-save'></i> Guardar",
                            className: "btn-success",
                            callback: function () {
                                return submitFormEstacion();
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

    function verEstacion(id) {
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'estacion', action:'show_ajax')}",
            data: {
                id: id
            },
            success: function (msg) {
                bootbox.dialog({
                    title: "Ver Estacion",

                    class: "modal-lg",

                    message: msg,
                    buttons: {
                        ok: {
                            label: "Aceptar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        }
                    }
                });
            }
        });
    }

    $(function () {

        $(".btnCrear").click(function () {
            createEditEstacion();
            return false;
        });

        $("tbody>tr").contextMenu({
            items: {
                header: {
                    label: "Acciones",
                    header: true
                },
                ver: {
                    label: "Ver",
                    icon: "fa fa-search",
                    action: function ($element) {
                        var id = $element.data("id");
                        verEstacion(id);
                    }
                },
                editar: {
                    label: "Editar",
                    icon: "fa fa-pencil",
                    action: function ($element) {
                        var id = $element.data("id");
                        createEditEstacion(id);
                    }
                },
                eliminar: {
                    label: "Eliminar",
                    icon: "fa fa-trash-o",
                    separator_before: true,
                    action: function ($element) {
                        var id = $element.data("id");
                        deleteEstacion(id);
                    }
                }
            },
            onShow: function ($element) {
                $element.addClass("success");
            },
            onHide: function ($element) {
                $(".success").removeClass("success");
            }
        });
    });
</script>

</body>
</html>
