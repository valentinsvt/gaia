<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 07/03/2015
  Time: 0:20
--%>

<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 17/02/2015
  Time: 12:36
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Reporte Documentos por Estación</title>
</head>


<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <div class="row">
            <div class="col-md-1">
                <label>
                    Consultor:
                </label>
            </div>

            <div class="col-md-3">
                <g:select name="consultor" from="${consultores}" id="consultorId" optionValue="nombre" optionKey="id" style="width: 200px"  noSelection="['-1': 'Todos']"/>

            </div>


            <div class="col-md-1">
                <label>
                    Desde:
                </label>
            </div>

            <div class="col-md-2">
                <elm:datepicker name="inicio" id="inicioVal" class="required form-control input-sm" default="none" noSelection="['': '']"/>
            </div>

            <div class="col-md-1">
                <label>
                    Hasta:
                </label>
            </div>

            <div class="col-md-2">
                <elm:datepicker name="fin" id="finVal" class="required form-control input-sm" default="none" noSelection="['': '']" />
            </div>
            <a href="#" class="btn btn-default btnActualizar">
                <i class="fa fa-refresh"></i> Actualizar
            </a>

            <a href="#" class="btn btn-default btnImprimir">
                <i class="fa fa-print"></i> Imprimir
            </a>

        </div>


    </div>


</div>

<table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">
    <thead>
    <tr>
        <th style="width: 100px;">Consultor</th>
        <th>Estación</th>
        <th>Documento</th>
        <th>N° Referencia</th>
        <th>Estado</th>
        <th>Emisión</th>
        <th>Vence</th>


    </tr>
    </thead>

    <tbody id="tabla">
    </tbody>
    %{--<tbody id="tb">--}%

    %{--<g:each in="${documentos}" var="documento">--}%
        %{--<tr>--}%
            %{--<g:if test="${documento?.consultor?.nombre}">--}%
            %{--<td>--}%
                %{--${documento?.consultor?.nombre}--}%
            %{--</td>--}%
                %{--<td>--}%
                    %{--${documento?.estacion?.nombre}--}%
                %{--</td>--}%
            %{--<td>--}%
                %{--${documento?.tipo?.nombre}--}%
            %{--</td>--}%
                %{--<td>--}%
                    %{--${documento?.referencia}--}%
                %{--</td>--}%
                %{--<td>--}%
                    %{--<g:if test="${documento?.estado == "A"}">--}%
                        %{--Aprobado--}%
                    %{--</g:if>--}%
                    %{--<g:else>--}%
                        %{--No Aprobado--}%
                    %{--</g:else>--}%

                %{--</td>--}%

            %{--<td>--}%
                %{--${documento?.inicio?.format("dd-MM-yyyy")}--}%
            %{--</td>--}%
            %{--<td>--}%
                %{--${documento?.fin?.format("dd-MM-yyyy")}--}%
            %{--</td>--}%


            %{--</g:if>--}%
        %{--</tr>--}%
    %{--</g:each>--}%

    %{--</tbody>--}%
</table>

%{--<elm:pagination total="${estacionInstanceCount}" params="${params}"/>--}%


<script type="text/javascript">

    $(".btnImprimir").click(function () {
//        imprimirDocs()
        var fi = $("#inicioVal").val()
        var ff = $("#finVal").val()
        var cc = $("#consultorId").val()
        $.ajax({
        type    : "POST",
        url     : '${createLink(action:'reporteDocumentosConsultor')}',
        data    : {
        fechaInicio : $("#inicioVal").val(),
        fechaFin : $("#finVal").val(),
        consultorId: $("#consultorId").val()

        },
        success : function (msg) {
        var url = "${createLink(controller: 'reportesEstacion',action: 'reporteDocumentosConsultor')}?consultorId=" + cc + "WfechaInicio=" + fi + "WfechaFin=" + ff;
        location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
        }
        });
    });


    function imprimirDocs() {
//        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'docConsultor_ajax')}",
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgDocs",
                    title   : "Documentos por Consultor",
//                    class   : "modal-sm",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        imprimir : {
                            label     : "Imprimir",
                            className : "btn-success",

                            callback  : function () {

                                var fi = $("#inicioVal").val()
                                var ff = $("#finVal").val()
                                var cc = $("#consultorId").val()

                                var url = "${createLink(controller: 'reportesEstacion',action: 'reporteDocumentosConsultor')}?consultorId=" + cc + "WfechaInicio=" + fi + "WfechaFin=" + ff;
                                location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;

                                %{--$.ajax({--}%
                                    %{--type    : "POST",--}%
                                    %{--url     : '${createLink(action:'reporteDocumentosConsultor')}',--}%
                                    %{--data    : {--}%
                                        %{--fechaInicio : $("#inicioVal").val(),--}%
                                        %{--fechaFin : $("#finVal").val(),--}%
                                        %{--consultorId: $("#consultorId").val()--}%

                                    %{--},--}%
                                    %{--success : function (msg) {--}%
                                        %{--var url = "${createLink(controller: 'reportesEstacion',action: 'reporteDocumentosConsultor')}";--}%
                                        %{--location.href = "${g.createLink(controller:'pdf',action:'pdfLink')}?url=" + url;--}%
                                    %{--}--}%
                                %{--});--}%
                            }
                        }
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    }


    $(".btnActualizar").click(function () {
        $.ajax({
            type    : "POST",
            url     : '${createLink(action:'tablaDocumentosConsultor')}',
            data    : {
                fechaInicio : $("#inicioVal").val(),
                fechaFin : $("#finVal").val(),
                consultorId: $("#consultorId").val()

            },
            success : function (msg) {
                $("#tabla").html(msg)
            }
        });
    });


</script>
</body>
</html>