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
        <a href="#" class="btn btn-default btnImprimir">
            <i class="fa fa-print"></i> Imprimir
        </a>
    </div>
</div>

<table border="1" class="table table-condensed table-bordered table-striped table-hover tablaSuperCon" width="100%">
    <thead>
    <tr>
        <th style="width: 100px;">Consultor</th>
        <th>Documento</th>
        <th>Fecha Emisión</th>
        <th>Fecha Vencimiento</th>
        <th>N° Referencia</th>
        <th>Estado</th>
        <th>Estación</th>
    </tr>
    </thead>
    <tbody id="tb">

    <g:each in="${documentos}" var="documento">
        <tr>
            <g:if test="${documento?.consultor?.nombre}">
            <td>
                ${documento?.consultor?.nombre}
            </td>
            <td>
                ${documento?.tipo?.nombre}
            </td>
            <td>
                ${documento?.inicio?.format("dd-MM-yyyy")}
            </td>
            <td>
                ${documento?.fin?.format("dd-MM-yyyy")}
            </td>
            <td>
                    ${documento?.referencia}
            </td>
                <td>
                    <g:if test="${documento?.estado == "N"}">
                        Negado
                    </g:if>
                    <g:else>
                        Aprobado
                    </g:else>

                </td>
                <td>
                    ${documento?.estacion?.nombre}
                </td>

            </g:if>
        </tr>
    </g:each>

    </tbody>
</table>

%{--<elm:pagination total="${estacionInstanceCount}" params="${params}"/>--}%


<script type="text/javascript">

    $(".btnImprimir").click(function () {
        imprimirDocs()
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
    } //createEdit

</script>
</body>
</html>