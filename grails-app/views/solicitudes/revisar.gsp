<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Detalle de la solicitud #${sol.id}</title>
    <meta name="layout" content="main"/>
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <style>
    .alert{
        padding-bottom: 4px !important;
    }
    .even{
        background: #E3E6F2;
    }
    .cabecera{
        cursor: pointer;
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
        <g:link controller="solicitudes" action="listaSolicitudesEstacion" id="${sol.estacion.codigo}" class="btn btn-default">
            <i class="fa fa-folder"></i> Solicitudes
        </g:link>
    </div>
</div>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<elm:container  titulo="Detalle de la solicitud #${sol.id}">
    <div class="row">
        <div class="col-md-1">
            <label>Fecha</label>
        </div>
        <div class="col-md-2">
            ${sol.registro?.format("dd-MM-yyyy")}
        </div>
        <div class="col-md-2">
            <label>Periodo de dotación</label>
        </div>
        <div class="col-md-2">
            ${sol.periodo.descripcion}
        </div>
    </div>
    <div class="row">
        <div class="col-md-1">
            <label>Supervisor</label>
        </div>
        <div class="col-md-2">
            ${sol.supervisor.nombre}
        </div>
        <div class="col-md-2">
            <label>Estación</label>
        </div>
        <div class="col-md-5">
            ${sol.estacion}
        </div>
    </div>
    <div class="row" style="margin-bottom: 20px">
        <div class="col-md-1">
            <label>Estado</label>
        </div>
        <div class="col-md-2">
            <g:if test="${sol.estado=='A'}">
                Aprobado
            </g:if>
            <g:if test="${sol.estado=='N'}">
                Negado
            </g:if>
            <g:if test="${sol.estado=='S'}">
                Pendiente de aprobación
            </g:if>
            <g:if test="${sol.estado=='P'}">
                Pendiente de envío
            </g:if>
        </div>
        <div class="col-md-2">
            <label>Certificado IESS</label>
        </div>
        <div class="col-md-2">
            <a href="#" data-file="${certificado?.path}"
               data-ref="Certificado del IESS"
               data-codigo=""
               data-tipo="Certificado del IESS"
               target="_blank" class="btn btn-info ver-doc btn-sm" title="${certificado?.path}" >
                <i class="fa fa-search"></i> Ver
            </a>
        </div>
        <div class="col-md-2">
            <label>Número de operadores</label>
        </div>
        <div class="col-md-1">
            ${gaia.uniformes.NominaEstacion.countByEstacionAndEstado(sol.estacion,"A")} <i class="fa fa-user"></i>
        </div>
    </div>

    <div class="row">
        <div class="col-md-10">
            <table class="table table-bordered table-striped">
                <thead>
                <tr class="cabecera">
                    <th colspan="6">
                        Detalle resumido
                    </th>
                </tr>
                <tr class="tbody">
                    <th>Uniforme</th>
                    <th>Tallas</th>
                    <th>Cantidad</th>
                </tr>
                </thead>
                <tbody class="tbody">
                <g:each in="${resumen}" var="r">
                    <tr>
                        <td>${r.key}</td>
                        <td>
                            <ul class="pys">
                                <g:each in="${r.value['detalle']}" var="d">
                                    <li>${d}</li>
                                </g:each>
                            </ul>
                        </td>
                        <td style="text-align: right;font-weight: bold">${r.value["cantidad"]}</td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-10" >
            <elm:message tipo="info" clase="" >
                Si los precios de la tabla están desactualizados por favor actualícelos antes de aprobar la solicitud
            </elm:message>
        </div>
    </div>
    <div class="row">
        <div class="col-md-10">
            <table class="table table-bordered">
                <thead>
                <tr class="cabecera">
                    <th colspan="6">
                        Detalle del pedido
                    </th>
                </tr>
                <tr class="tbody">
                    <th>Uniforme</th>
                    <th>Talla</th>
                    <th>Cantidad</th>
                    <th>P. Unitario</th>
                    <th>Total</th>
                    <th style="text-align: center">
                        <input type="checkbox" value="1" class="chk-todos" checked>
                    </th>
                </tr>
                </thead>
                <tbody class="tbody">
                <g:set var="cont" value="${1}"></g:set>
                <g:set var="total" value="${0}"></g:set>
                <g:set var="anterior" value="${null}"></g:set>
                <g:set var="totalParcial" value="${0}"></g:set>
                <g:each in="${detalle}" var="d" status="i">

                    <g:set var="total" value="${total+=d.cantidad*d.uniforme.precio}"></g:set>
                    <g:if test="${anterior!=d.uniforme.descripcion}">
                        <g:set var="cont" value="${cont+=1}"></g:set>
                        <g:set var="anterior" value="${d.uniforme.descripcion}"></g:set>
                        <g:set var="td" value="${d.uniforme.descripcion}"></g:set>
                    </g:if>
                    <g:else>
                        <g:set var="td" value=""></g:set>
                    </g:else>
                    <tr class="${cont%2==0?'even':'odd'}">
                        <td>${td}</td>
                        <td>
                            ${d.talla}
                        </td>
                        <td style="text-align: right">${d.cantidad}</td>
                        <td style="text-align: right">
                            <g:formatNumber number="${d.uniforme.precio}" type="currency" currencySymbol="\$"/>
                        </td>
                        <td style="text-align: right">
                            <g:formatNumber number="${d.cantidad*d.uniforme.precio}" type="currency" currencySymbol="\$"/>
                        </td>
                        <td style="text-align: center">
                            <input type="checkbox" value="1" class="chk" checked
                                   iden="${d.id}">
                        </td>
                    </tr>
                </g:each>
                </tbody>
                <tfoot class="tbody">
                <tr>
                    <td colspan="4" style="font-weight: bold">TOTAL</td>
                    <td style="font-weight: bold;text-align: right">
                        <g:formatNumber number="${total}" type="currency" currencySymbol="\$"/>
                    </td>
                    <td></td>
                </tr>
                </tfoot>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-1">
            <a href="#" class="btn btn-success"  id="aprobar">
                <i class="fa fa-check"></i> Aprobar
            </a>
        </div>
        <div class="col-md-1">
            <a href="#" class="btn btn-danger"  id="negar">
                <i class="fa fa-times"></i> Negar
            </a>
        </div>
    </div>
</elm:container>

<div class="modal fade dlg-aprobar" >
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Aprobar la solicitud #${sol.id}</h4>
            </div>
            <div class="modal-body">
                <g:form class="frmAprobar" action="aprobarSolicitud">
                    <input type="hidden" name="id" value="${sol.id}">
                    <input type="hidden" id="datos" name="datos" value="">
                    <div class="row">
                        <div class="col-md-5">
                            <label>
                                Ingrese su clave para completar la autorización
                            </label>
                        </div>

                        <div class="col-md-5">
                            <div class="grupo">
                                <div class="input-group input-group-sm">
                                    <g:passwordField name="auth" class="form-control input-sm required"/>
                                    <span class="input-group-addon">
                                        <i class="fa fa-unlock-alt"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </g:form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-success" id="dlg-aprobar">Aprobar</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<g:form action="negarSolicitud" class="frmNegar">
    <input type="hidden" name="id" value="${sol.id}">
</g:form>
<script type="text/javascript">
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
    $(".ver-doc").click(function(){
        showPdf($(this))
        return false
    })
    $(".pdf-handler").click(function(){
        $(".pdf-viewer").hide("slide",{direction:'right'})
        $("#data").hide()
    })
    $(".cabecera").click(function(){
        $(this).parent().parent().find(".tbody").fadeToggle()
    })
    $(".chk-todos").change(function(){
        $('.chk').prop('checked', this.checked);
    })
    $("#aprobar").click(function(){
        var data = ""
        $(".chk").each(function(){
            if(this.checked){
                data+=$(this).attr("iden")+";"
            }
        });
        if(data==""){
            bootbox.alert("Error: Seleccione al menos un registro en la tabla de detalle o niegue la solicitud")
        }else{
            $("#datos").val(data)
            $(".frmAprobar").submit()
        }

        return false
    })
    $("#dlg-aprobar").click(function(){
        if($("#pass").val()!="")
            $(".frmAprobar").submit()

    })
    $("#negar").click(function(){
        bootbox.confirm("Está seguro. Está acción es irreversible",function(result){
            if(result)
                $(".frmNegar").submit()
        });

    })
</script>
</body>
</html>