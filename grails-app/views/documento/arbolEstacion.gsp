<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 23/01/2015
  Time: 17:44
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Documentos</title>

        <script src="${resource(dir: 'js/plugins/jstree-3.0.9/dist', file: 'jstree.min.js')}"></script>
        <link href="${resource(dir: 'js/plugins/jstree-3.0.9/dist/themes/default', file: 'style.min.css')}" rel="stylesheet">
        <link href="${resource(dir: 'css/custom', file: 'jstree-context.css')}" rel="stylesheet">

        <style type="text/css">
        #tree {
            overflow-y : auto;
            height     : 440px;
        }

        .jstree-search {
            color : #5F87B2 !important;
        }
        </style>
    </head>

    <body>

        %{--<div>Icon made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed under <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a></div>--}%

        <div class="row" style="margin-bottom: 10px;">
            <div class="col-md-2">
                <div class="input-group input-group-sm">
                    <g:textField name="searchArbol" class="form-control input-sm" placeholder="Buscador"/>
                    <span class="input-group-btn">
                        <a href="#" id="btnSearchArbol" class="btn btn-sm btn-info">
                            <i class="fa fa-search"></i>
                        </a>
                    </span>
                </div><!-- /input-group -->
            </div>

            <div class="col-md-3 hidden" id="divSearchRes">
                <span id="spanSearchRes">
                    5 resultados
                </span>

                <div class="btn-group">
                    <a href="#" class="btn btn-xs btn-default" id="btnNextSearch" title="Siguiente">
                        <i class="fa fa-chevron-down"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnPrevSearch" title="Anterior">
                        <i class="fa fa-chevron-up"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnClearSearch" title="Limpiar búsqueda">
                        <i class="fa fa-close"></i>
                    </a>
                </div>
            </div>

            <div class="col-md-4">
                <div class="btn-group">
                    <a href="#" class="btn btn-xs btn-default" id="btnCollapseAll" title="Cerrar todos los nodos">
                        <i class="fa fa-minus-square-o"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnExpandAll" title="Abrir todos los nodos">
                        <i class="fa fa-plus-square"></i>
                    </a>
                </div>

                <div class="btn-group">
                    <g:link action="arbol" params="[inactivos: params.inactivos == 'S' ? 'N' : 'S']" class="btn btn-xs btn-default">
                        <i class="fa fa-power-off"></i> ${params.inactivos == 'S' ? 'Ocultar' : 'Mostrar'} inactivos
                    </g:link>
                </div>

            </div>
        </div>

        <div id="tree" class="well">
            ${raw(arbol)}
        </div>

        <script type="text/javascript">
            var searchRes = [];
            var posSearchShow = 0;
            var $treeContainer = $("#tree");

            function createContextMenu(node) {
                var nodeStrId = node.id;
                var $node = $("#" + nodeStrId);
                var nodeId = nodeStrId.split("_")[1];
                var nodeType = $node.data("jstree").type;

                var nodeText = $node.children("a").first().text();

                var cantHijos = parseInt($node.data("hijos"));

                var esRoot = nodeType == "root";
                var esTipoUsuario = nodeType == "dpto";
                var esTipoUsuarioInactivo = nodeType == "dptoInactivo";
                var esUsuario = nodeType == "usuario";
                var esUsuarioInactivo = nodeType == "usuarioInactivo";

                var crearDep = {
                    label  : "Nuevo tipo de Usuario",
                    icon   : "fa fa-building-o text-success",
                    action : function () {
                        createEditTipoUsuario(nodeId);
                    }
                };
                var editarDep = {
                    label  : "Modificar tipo de Usuario",
                    icon   : "fa fa-pencil text-info",
                    action : function () {
                        createEditTipoUsuario(null, nodeId);
                    }
                };
                var eliminarDep = {
                    label            : "Eliminar tipo de Usuario",
                    icon             : "fa fa-trash-o text-danger",
                    separator_before : true,
                    action           : function () {
                        deleteTipoUsuario(nodeId);
                    }
                };
                var activarDep = {
                    label            : "Activar tipo de Usuario",
                    icon             : "fa fa-power-off text-success",
                    separator_before : true,
                    action           : function () {
                        cambiarActivoTipoUsuario(nodeId, 1);
                    }
                };
                var desactivarDep = {
                    label            : "Desactivar tipo de Usuario",
                    icon             : "fa fa-power-off text-muted",
                    separator_before : true,
                    action           : function () {
                        cambiarActivoTipoUsuario(nodeId, 0);
                    }
                };
                var verDep = {
                    label            : "Ver tipo de Usuario",
                    icon             : "fa fa-search",
                    separator_before : true,
                    action           : function () {
                        showTipoUsuario(nodeId);
                    }
                };

                var crearUsuario = {
                    label            : "Nuevo usuario",
                    icon             : "fa fa-user text-success",
                    separator_before : true,
                    action           : function () {
                        createEditPersona(nodeId);
                    }
                };
                var editarUsuario = {
                    label  : "Modificar usuario",
                    icon   : "fa fa-pencil text-info",
                    action : function () {
                        createEditPersona(null, nodeId);
                    }
                };
                var eliminarUsuario = {
                    label            : "Eliminar usuario",
                    icon             : "fa fa-trash-o text-danger",
                    separator_before : true,
                    action           : function () {
                        deletePersona(nodeId);
                    }
                };
                var activarUsuario = {
                    label            : "Activar usuario",
                    icon             : "fa fa-power-off text-success",
                    separator_before : true,
                    action           : function () {
                        cambiarActivoPersona(nodeId, 1);
                    }
                };
                var desactivarUsuario = {
                    label            : "Desactivar usuario",
                    icon             : "fa fa-power-off text-muted",
                    separator_before : true,
                    action           : function () {
                        cambiarActivoPersona(nodeId, 0);
                    }
                };
                var verUsuario = {
                    label            : "Ver usuario",
                    icon             : "fa fa-search",
                    separator_before : true,
                    action           : function () {
                        showPersona(nodeId);
                    }
                };
                var resetPassUsuario = {
                    label            : "<span class='text-warning text-shadow'>Resetear contraseña</span>",
                    icon             : "fa fa-unlock text-warning text-shadow",
                    separator_before : true,
                    action           : function () {
                        cambiarPassPersona(nodeId, "pass");
                    }
                };
                var addPicUsuario = {
                    label  : "Foto",
                    icon   : "fa fa-picture-o",
                    action : function () {

                    }
                };

                var items = {};

                if (esRoot) {
                    items.crearDep = crearDep;
                } else if (esTipoUsuario) {
                    items.verDep = verDep;
                    items.crearDep = crearDep;
                    items.editarDep = editarDep;
                    if (cantHijos == 0) {
                        items.desactivarDep = desactivarDep;
//                        items.eliminarDep = eliminarDep;
                    }
                    items.crearUsuario = crearUsuario;
                } else if (esTipoUsuarioInactivo) {
                    items.verDep = verDep;
                    items.editarDep = editarDep;
                    if (cantHijos == 0) {
                        items.activarDep = activarDep;
//                        items.eliminarDep = eliminarDep;
                    }
                } else if (esUsuario) {
                    items.verUsuario = verUsuario;
                    items.editarUsuario = editarUsuario;
                    items.foto = addPicUsuario;
                    items.desactivarUsuario = desactivarUsuario;
                    items.resetPass = resetPassUsuario;
                } else if (esUsuarioInactivo) {
                    items.verUsuario = verUsuario;
                    items.editarUsuario = editarUsuario;
                    items.foto = addPicUsuario;
                    items.activarUsuario = activarUsuario;
                }

                return items;
            }

            function scrollToNode($scrollTo) {
                $treeContainer.jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                    scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
                });
            }

            function scrollToRoot() {
                var $scrollTo = $("#root");
                scrollToNode($scrollTo);
            }

            function scrollToSearchRes() {
                var $scrollTo = $(searchRes[posSearchShow]).parents("li").first();
                $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + searchRes.length);
                scrollToNode($scrollTo);
            }

            $(function () {

                $treeContainer.on("loaded.jstree", function () {
                    $("#loading").hide();
                    $("#tree").removeClass("hidden");
                }).on("select_node.jstree", function (node, selected, event) {
//                    $('#tree').jstree('toggle_node', selected.selected[0]);
                }).jstree({
                    plugins     : ["types", "state", "contextmenu", "search"],
                    core        : {
                        multiple       : false,
                        check_callback : true,
                        themes         : {
                            variant : "small",
                            dots    : true,
                            stripes : true
                        }
                    },
                    contextmenu : {
                        show_at_node : false,
                        items        : createContextMenu
                    },
                    state       : {
                        key : "docsEstacion"
                    },
                    search      : {
                        fuzzy             : false,
                        show_only_matches : false,
                        ajax              : {
                            url     : "${createLink(action:'arbolSearch_ajax')}",
                            success : function (msg) {
                                var json = $.parseJSON(msg);
                                $.each(json, function (i, obj) {
                                    $('#tree').jstree("open_node", obj);
                                });
                                setTimeout(function () {
                                    searchRes = $(".jstree-search");
                                    var cantRes = searchRes.length;
                                    posSearchShow = 0;
                                    $("#divSearchRes").removeClass("hidden");
                                    $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);
                                    scrollToSearchRes();
                                }, 300);

                            }
                        }
                    },
                    types       : {
                        estacion : {
                            icon : "${resource(dir:'images/tree', file:'fuel_16.png')}"
                        },
                        tipoDoc  : {
                            icon : "fa fa-briefcase text-info"
                        },
                        doc      : {
                            icon : "fa fa-file-pdf-o text-danger"
                        }
                    }
                });

                $("#btnExpandAll").click(function () {
                    $treeContainer.jstree("open_all");
                    scrollToRoot();
                    return false;
                });

                $("#btnCollapseAll").click(function () {
                    $treeContainer.jstree("close_all");
                    scrollToRoot();
                    return false;
                });

                $('#btnSearchArbol').click(function () {
                    $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
                    return false;
                });
                $("#searchArbol").keypress(function (ev) {
                    if (ev.keyCode == 13) {
                        $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
                        return false;
                    }
                });

                $("#btnPrevSearch").click(function () {
                    if (posSearchShow > 0) {
                        posSearchShow--;
                    } else {
                        posSearchShow = searchRes.length - 1;
                    }
                    scrollToSearchRes();
                    return false;
                });

                $("#btnNextSearch").click(function () {
                    if (posSearchShow < searchRes.length - 1) {
                        posSearchShow++;
                    } else {
                        posSearchShow = 0;
                    }
                    scrollToSearchRes();
                    return false;
                });

                $("#btnClearSearch").click(function () {
                    $treeContainer.jstree("clear_search");
                    $("#searchArbol").val("");
                    posSearchShow = 0;
                    searchRes = [];
                    scrollToRoot();
                    $("#divSearchRes").addClass("hidden");
                    $("#spanSearchRes").text("");
                });

            });
        </script>
    </body>
</html>