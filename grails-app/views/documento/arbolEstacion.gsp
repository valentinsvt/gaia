<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 23/01/2015
  Time: 17:44
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE HTML>
<head>
    <meta name="layout" content="main">
    <title>Documentos</title>

    <imp:js src="${resource(dir: 'js/plugins/jstree-3.0.9/dist', file: 'jstree.min.js')}"/>
    <imp:css src="${resource(dir: 'js/plugins/jstree-3.0.9/dist/themes/default', file: 'style.min.css')}"/>
    <imp:css src="${resource(dir: 'css/custom', file: 'jstree-context.css')}"/>

    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>

    <style type="text/css">
    #tree {
    }

    .jstree-search {
        color : #5F87B2 !important;
    }

    .treePart {
        overflow-y : auto;
        height     : 440px;
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

    <div class="well">
        <div class="row no-margin-top">
            <div class="col-md-6 treePart" id="tree">
                ${raw(arbol)}
            </div>

            <div class="col-md-6 treePart" id="doc">
                <p>No tiene configurado el plugin de lectura de PDF en este navegador.</p>

                <p>
                    Puede
                    <a class="text-info" target="_blank" href="C:\Users\Luz\IdeaProjects\gaia\web-app\documentos/08010235/PS-DA-1.pdf">
                        <u>descargar el PDF (C:\Users\Luz\IdeaProjects\gaia\web-app\documentos/08010235/PS-DA-1.pdf) aquí</u>
                    </a>
                </p>

                <p>
                    O
                    <a class="text-info" target="_blank" href="http://get.adobe.com/es/reader/">
                        <u>descargar Adobe Reader aquí</u>
                    </a>
                </p>
            </div>
        </div>
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

            var esEstacion = nodeType == "estacion";
            var esTipoDoc = nodeType == "tipoDoc";
            var esDoc = nodeType == "doc";

            var crearDep = {
                label  : "Nuevo tipo de Usuario",
                icon   : "fa fa-building-o text-success",
                action : function () {

                }
            };
            var items = {};

//                if (esRoot) {
//                    items.crearDep = crearDep;
//                }

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
                var nodeId = selected.selected[0];
                var $node = $("#" + nodeId);
                var nodeType = $node.data("jstree").type;
                if (nodeType == "doc") {
                    var parts = nodeId.split("_");
                    var docId = parts[1];
                    var pathFile = $node.data("file");
                    var path = "${resource()}/" + pathFile;
//                    console.log(path);
                    var myPDF = new PDFObject({
                        url           : path,
                        pdfOpenParams : {
                            navpanes  : 0,
                            statusbar : 1,
                            view      : "Fit",
                            pagemode  : "thumbs"
                        }
                    }).embed("doc");

//                        console.log(docId, path);
//                        var str = '<object data="' + path + '" type="application/pdf" width="100%" height="100%">';
//                        str += '<p>No tiene configurado el plugin de lectura de PDF en este navegador.</p>';
//                        str += '<p>Puede <a class="text-info" target="_blank" href="' + path + '"><u>descargar el PDF (' + path + ') aquí</u></a></p>';
//                        str += '<p>O <a class="text-info" target="_blank" href="http://get.adobe.com/es/reader/"><u>descargar Adobe Reader aquí</u></a>';
//                        str += '</object>';
//                        $("#doc").html(str);
                }
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