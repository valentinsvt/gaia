<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <title>
        Registrar control anual
    </title>
    <style type="text/css">
    label{
        padding-top: 5px;
    }
    fieldset{
        margin-top: 15px;
        padding: 10px;
        padding-top: 0px;
        margin-left: -10px;
    }
    legend{
        border-color: #3A87AD;
        color: #3A87AD;
    }
    .header-flow-item{
        width: 33%;
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
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <a href="${g.createLink(controller: 'estacion',action: 'showEstacion',id: estacion.codigo)}" class="btn btn-default ">
            Estación
        </a>
        <a href="${g.createLink(controller: 'documento', action: 'arbolEstacion', params: [codigo: estacion.codigo])}" class="btn btn-default mapa">
            <i class="fa fa-file-pdf-o"></i> Visor de documentos
        </a>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Estación: ${estacion.nombre}" >
<div class="panel panel-info" style="margin-top: 20px">
<div class="panel-heading">${proceso.tipo.nombre}</div>
<div class="panel-body" style="padding:0px">
<div class="header-flow">

    <div class="header-flow-item active">
        <span class="badge active">1</span>
        Pago y documentación inicial
        <span class="arrow"></span>
    </div>
    <g:if test="${detallePago?.documento}">
        <g:link controller="control" action="acta" id="${proceso.id}" style="text-decoration: none">
            <div class="header-flow-item disabled">
                <span class="badge disabled">2</span>
                Acta de control
                <span class="arrow"></span>
            </div>
        </g:link>
    </g:if>
    <g:else>
        <div class="header-flow-item disabled">
            <span class="badge disabled">2</span>
            Acta de control
            <span class="arrow"></span>
        </div>
    </g:else>
    <div class="header-flow-item disabled">
        <span class="badge disabled">3</span>
        Certificado de control anual
    </div>
</div>
<div class="flow-body">
<div class="row" style="border-bottom: 1px solid #3A5DAA;width: 99%;padding-bottom: 10px;margin-bottom: 5px">
    <div class="col-md-3">
        <label>
            Consultor encargado del proceso:
        </label>
    </div>
    <div class="col-md-4">
        <g:select name="consultor"  id="consultor" class="form-control input-sm" from="${gaia.documentos.ConsultorEstacion.findAllByEstacion(estacion)?.consultor}" optionKey="id" optionValue="nombre" value="${proceso?.consultor?.id}"/>
    </div>
    <div class="col-md-1">
        <a href="#" class="btn btn-success" id="consultor-btn">
            <i class="fa fa-disk"></i> Guardar
        </a>
    </div>
</div>
<g:form class="frm-subir-tdr" controller="control" action="upload" enctype="multipart/form-data" >
    <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
    <input type="hidden" name="proceso" value="${proceso?.id}" >
    <input type="hidden" name="id" value="${detallePago?.id}" >
    <input type="hidden" name="tipo" value="pago" >
    <input type="hidden" name="paso" value="1" >
    <input type="hidden" name="origen" value="registrarControl" >
    <div class="row">
        <div class="col-md-2">
            <label>
                Pago
            </label>
        </div>
        <div class="col-md-4">
            <g:if test="${detallePago?.documento}">
                <div id="botones-tdr">
                    ${detallePago.documento.codigo}
                    <a href="#" data-file="${detallePago.documento.path}"
                       data-ref="${detallePago.documento.referencia}"
                       data-codigo="${detallePago.documento.codigo}"
                       data-tipo="${detallePago.documento.tipo.nombre}"
                       target="_blank" class="btn btn-info ver-doc" >
                        <i class="fa fa-search"></i> Ver
                    </a>
                    <a href="#" class="btn btn-info cambiar" iden="tdr">
                        <i class="fa fa-refresh"></i> Cambiar
                    </a>
                    <util:displayEstadoDocumento documento="${detallePago.documento}"/>
                </div>
                <div id="div-file-tdr" style="display: none">
                    <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                </div>
            </g:if>
            <g:else>
                <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
            </g:else>
        </div>
    </div>
    <div class="row">
        <div class="col-md-2">
            <label>
                N. referencia
            </label>
        </div>
        <div class="col-md-4">
            <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detallePago?.documento?.referencia}">
        </div>
        <div class="col-md-1">
            <label>
                Emisión
            </label>
        </div>
        <div class="col-md-3">
            <elm:datepicker name="inicio" class="required form-control input-sm" value="${detallePago?.documento?.inicio}"/>
        </div>
    </div>

    <div class="row">
        <div class="col-md-1">
            <a href="#" class="btn btn-primary" id="guardar-tdr">
                <i class="fa fa-save"></i>
                Guardar
            </a>
        </div>
    </div>
</g:form>
<fieldset>
    <legend>Permiso de funcionamiento de bomberos</legend>
    <g:form class="frm-subir-apb" controller="control" action="upload" enctype="multipart/form-data" >
        <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
        <input type="hidden" name="proceso" value="${proceso?.id}" >
        <input type="hidden" name="id" value="${detalleBomberos?.id}" >
        <input type="hidden" name="tipo" value="bomberos" >
        <input type="hidden" name="paso" value="1" >
        <input type="hidden" name="origen" value="registrarControl" >
        <div class="row" style="margin-top: 0px">
            <div class="col-md-2">
                <label>
                    Permiso de bomberos
                </label>
            </div>
            <div class="col-md-4" style="">
                <g:if test="${detalleBomberos?.documento}">
                    <div id="botones-apb_${detalleBomberos?.id}">
                        ${detalleBomberos.documento.codigo}
                        <a href="#" data-file="${detalleBomberos.documento.path}"
                           data-ref="${detalleBomberos.documento.referencia}"
                           data-codigo="${detalleBomberos.documento.codigo}"
                           data-tipo="${detalleBomberos.documento.tipo.nombre}"
                           target="_blank" class="btn btn-info ver-doc" >
                            <i class="fa fa-search"></i> Ver
                        </a>
                        <a href="#" class="btn btn-info cambiar" iden="apb_${detalleBomberos?.id}">
                            <i class="fa fa-refresh"></i> Cambiar
                        </a>
                        <util:displayEstadoDocumento documento="${detalleBomberos.documento}"/>
                    </div>
                    <div id="div-file-apb_${detalleBomberos?.id}" style="display: none">
                        <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                    </div>
                </g:if>
                <g:else>
                    <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                </g:else>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    N. referencia
                </label>
            </div>
            <div class="col-md-4">
                <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detalleBomberos?.documento?.referencia}">
            </div>
            <div class="col-md-1">
                <label>
                    Emisión
                </label>
            </div>
            <div class="col-md-3">
                <elm:datepicker name="inicio" id="bmb__${detalleBomberos?.id}" class="required form-control input-sm" value="${detalleBomberos?.documento?.inicio}"/>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    Observaciones
                </label>
            </div>
            <div class="col-md-8">
                <input type="text" name="descripcion" class="form-control input-sm required" required="" value="${detalleBomberos?.documento?.descripcion}" maxlength="512">
            </div>
        </div>
        <div class="row">
            <div class="col-md-1">
                <a href="#" class="btn btn-primary guardar-docs" id="guardar-apb">
                    <i class="fa fa-save"></i>
                    Guardar
                </a>
            </div>
        </div>
    </g:form>
</fieldset>

<fieldset>
    <legend>Certificación técnica de tanques</legend>
    <g:form class="frm-subir-apb" controller="control" action="upload" enctype="multipart/form-data" >
        <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
        <input type="hidden" name="proceso" value="${proceso?.id}" >
        <input type="hidden" name="id" value="${detalleTanques?.id}" >
        <input type="hidden" name="tipo" value="tanque" >
        <input type="hidden" name="paso" value="1" >
        <input type="hidden" name="origen" value="registrarControl" >
        <div class="row" style="margin-top: 0px">
            <div class="col-md-2">
                <label>
                    Certificado
                </label>
            </div>
            <div class="col-md-4" style="">
                <g:if test="${detalleTanques?.documento}">
                    <div id="botones-apb_${detalleTanques?.id}">
                        ${detalleTanques.documento.codigo}
                        <a href="#" data-file="${detalleTanques.documento.path}"
                           data-ref="${detalleTanques.documento.referencia}"
                           data-codigo="${detalleTanques.documento.codigo}"
                           data-tipo="${detalleTanques.documento.tipo.nombre}"
                           target="_blank" class="btn btn-info ver-doc" >
                            <i class="fa fa-search"></i> Ver
                        </a>
                        <a href="#" class="btn btn-info cambiar" iden="apb_${detalleTanques?.id}">
                            <i class="fa fa-refresh"></i> Cambiar
                        </a>
                        <util:displayEstadoDocumento documento="${detalleTanques.documento}"/>
                    </div>
                    <div id="div-file-apb_${detalleTanques?.id}" style="display: none">
                        <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                    </div>
                </g:if>
                <g:else>
                    <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                </g:else>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    N. referencia
                </label>
            </div>
            <div class="col-md-4">
                <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detalleTanques?.documento?.referencia}">
            </div>

        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    Emisión
                </label>
            </div>
            <div class="col-md-3">
                <elm:datepicker name="inicio" id="tanque__${detalleTanques?.id}" class="required form-control input-sm" value="${detalleTanques?.documento?.inicio}"/>
            </div>
            <div class="col-md-1">
                <label>
                    Vence
                </label>
            </div>
            <div class="col-md-3">
                <elm:datepicker name="fin" id="tanque_fin_${detalleTanques?.id}" class="required form-control input-sm" value="${detalleTanques?.documento?.fin}"/>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    Observaciones
                </label>
            </div>
            <div class="col-md-8">
                <input type="text" name="descripcion" class="form-control input-sm required" required="" value="${detalleTanques?.documento?.descripcion}" maxlength="512">
            </div>
        </div>
        <div class="row">
            <div class="col-md-1">
                <a href="#" class="btn btn-primary guardar-docs" id="guardar-tanques">
                    <i class="fa fa-save"></i>
                    Guardar
                </a>
            </div>
        </div>
    </g:form>
</fieldset>

<fieldset>
    <legend>Póliza de daños a terceros y responsabilidad civil</legend>
    <g:form class="frm-subir-apb" controller="control" action="upload" enctype="multipart/form-data" >
        <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
        <input type="hidden" name="proceso" value="${proceso?.id}" >
        <input type="hidden" name="id" value="${detallePoliza?.id}" >
        <input type="hidden" name="tipo" value="poliza" >
        <input type="hidden" name="paso" value="1" >
        <input type="hidden" name="origen" value="registrarControl" >
        <div class="row" style="margin-top: 0px">
            <div class="col-md-2">
                <label>
                    Certificado
                </label>
            </div>
            <div class="col-md-4" style="">
                <g:if test="${detallePoliza?.documento}">
                    <div id="botones-apb_${detallePoliza?.id}">
                        ${detallePoliza.documento.codigo}
                        <a href="#" data-file="${detallePoliza.documento.path}"
                           data-ref="${detallePoliza.documento.referencia}"
                           data-codigo="${detallePoliza.documento.codigo}"
                           data-tipo="${detallePoliza.documento.tipo.nombre}"
                           target="_blank" class="btn btn-info ver-doc" >
                            <i class="fa fa-search"></i> Ver
                        </a>
                        <a href="#" class="btn btn-info cambiar" iden="apb_${detallePoliza?.id}">
                            <i class="fa fa-refresh"></i> Cambiar
                        </a>
                        <util:displayEstadoDocumento documento="${detallePoliza.documento}"/>
                    </div>
                    <div id="div-file-apb_${detallePoliza?.id}" style="display: none">
                        <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                    </div>
                </g:if>
                <g:else>
                    <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                </g:else>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    N. referencia
                </label>
            </div>
            <div class="col-md-4">
                <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detallePoliza?.documento?.referencia}">
            </div>

        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    Emisión
                </label>
            </div>
            <div class="col-md-3">
                <elm:datepicker name="inicio" id="poliza__${detallePoliza?.id}" class="required form-control input-sm" value="${detallePoliza?.documento?.inicio}"/>
            </div>
            <div class="col-md-1">
                <label>
                    Vence
                </label>
            </div>
            <div class="col-md-3">
                <elm:datepicker name="fin" id="poliza_fin_${detallePoliza?.id}" class="required form-control input-sm" value="${detallePoliza?.documento?.fin}"/>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    Observaciones
                </label>
            </div>
            <div class="col-md-8">
                <input type="text" name="descripcion" class="form-control input-sm required" required="" value="${detallePoliza?.documento?.descripcion}" maxlength="512">
            </div>
        </div>
        <div class="row">
            <div class="col-md-1">
                <a href="#" class="btn btn-primary guardar-docs" id="guardar-poliza">
                    <i class="fa fa-save"></i>
                    Guardar
                </a>
            </div>
        </div>
    </g:form>
</fieldset>

<g:if test="${detalleLicencia}">
    <g:if test="${detalleLicencia.documento.tipo.codigo=='TP01'}">
        <fieldset>
            <legend>Licencia</legend>
            <div class="row">
                <div class="col-md-1">
                    <label>Licencia</label>
                </div>
                <div class="col-md-4">
                    <div id="botones-apb_${detalleLicencia?.id}">
                        ${detalleLicencia.documento.codigo}
                        <a href="#" data-file="${detalleLicencia.documento.path}"
                           data-ref="${detalleLicencia.documento.referencia}"
                           data-codigo="${detalleLicencia.documento.codigo}"
                           data-tipo="${detalleLicencia.documento.tipo.nombre}"
                           target="_blank" class="btn btn-info ver-doc" >
                            <i class="fa fa-search"></i> Ver
                        </a>
                        <util:displayEstadoDocumento documento="${detalleLicencia.documento}"/>
                    </div>
                </div>
            </div>
        </fieldset>
    </g:if>
</g:if>
<g:else>
    <fieldset>
        <legend>Certificado de licencia ambiental</legend>
        <g:form class="frm-subir-apb" controller="control" action="upload" enctype="multipart/form-data" >
            <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
            <input type="hidden" name="proceso" value="${proceso?.id}" >
            <input type="hidden" name="id" value="${detalleLicencia?.id}" >
            <input type="hidden" name="tipo" value="lic" >
            <input type="hidden" name="paso" value="1" >
            <input type="hidden" name="origen" value="registrarControl" >
            <div class="row" style="margin-top: 0px">
                <div class="col-md-2">
                    <label>
                        Certificado
                    </label>
                </div>
                <div class="col-md-4" style="">
                    <g:if test="${detalleLicencia?.documento}">
                        <div id="botones-apb_${detalleLicencia?.id}">
                            ${detalleLicencia.documento.codigo}
                            <a href="#" data-file="${detalleLicencia.documento.path}"
                               data-ref="${detalleLicencia.documento.referencia}"
                               data-codigo="${detalleLicencia.documento.codigo}"
                               data-tipo="${detalleLicencia.documento.tipo.nombre}"
                               target="_blank" class="btn btn-info ver-doc" >
                                <i class="fa fa-search"></i> Ver
                            </a>
                            <a href="#" class="btn btn-info cambiar" iden="apb_${detalleLicencia?.id}">
                                <i class="fa fa-refresh"></i> Cambiar
                            </a>
                            <util:displayEstadoDocumento documento="${detalleLicencia.documento}"/>
                        </div>
                        <div id="div-file-apb_${detalleLicencia?.id}" style="display: none">
                            <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                        </div>
                    </g:if>
                    <g:else>
                        <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                    </g:else>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <label>
                        N. referencia
                    </label>
                </div>
                <div class="col-md-4">
                    <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detalleLicencia?.documento?.referencia}">
                </div>

            </div>
            <div class="row">
                <div class="col-md-2">
                    <label>
                        Emisión
                    </label>
                </div>
                <div class="col-md-3">
                    <elm:datepicker name="inicio" id="licencia__${detalleLicencia?.id}" class="required form-control input-sm" value="${detalleLicencia?.documento?.inicio}"/>
                </div>
                <div class="col-md-1">
                    <label>
                        Vence
                    </label>
                </div>
                <div class="col-md-3">
                    <elm:datepicker name="fin" id="licencia_fin_${detalleLicencia?.id}" class="required form-control input-sm" value="${detalleLicencia?.documento?.fin}"/>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <label>
                        Observaciones
                    </label>
                </div>
                <div class="col-md-8">
                    <input type="text" name="descripcion" class="form-control input-sm required" required="" value="${detalleLicencia?.documento?.descripcion}" maxlength="512">
                </div>
            </div>
            <div class="row">
                <div class="col-md-1">
                    <a href="#" class="btn btn-primary guardar-docs" id="guardar-lic">
                        <i class="fa fa-save"></i>
                        Guardar
                    </a>
                </div>
            </div>
        </g:form>
    </fieldset>
</g:else>

<g:each in="${detallesOtros}" var="d">
    <fieldset>
        <legend>Otros</legend>
        <g:form class="frm-subir-apb" controller="control" action="upload" enctype="multipart/form-data" >
            <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
            <input type="hidden" name="proceso" value="${proceso?.id}" >
            <input type="hidden" name="id" value="${d?.id}" >
            <input type="hidden" name="tipo" value="otros" >
            <input type="hidden" name="paso" value="1" >
            <input type="hidden" name="origen" value="registrarControl" >
            <div class="row" style="margin-top: 0px">
                <div class="col-md-2">
                    <label>
                        Documento
                    </label>
                </div>
                <div class="col-md-4" style="">
                    <g:if test="${d?.documento}">
                        <div id="botones-otros_${d?.id}">
                            ${d.documento.codigo}
                            <a href="#" data-file="${d.documento.path}"
                               data-ref="${d.documento.referencia}"
                               data-codigo="${d.documento.codigo}"
                               data-tipo="${d.documento.tipo.nombre}"
                               target="_blank" class="btn btn-info ver-doc" >
                                <i class="fa fa-search"></i> Ver
                            </a>
                            <a href="#" class="btn btn-info cambiar" iden="otros_${d?.id}">
                                <i class="fa fa-refresh"></i> Cambiar
                            </a>
                            <util:displayEstadoDocumento documento="${d.documento}"/>
                        </div>
                        <div id="div-file-otros_${d?.id}" style="display: none">
                            <input type="file" name="file"  class="form-control "  style="border-right: none" accept=".pdf">
                        </div>
                    </g:if>
                    <g:else>
                        <input type="file" name="file" id="file" class="form-control required"  style="border-right: none" accept=".pdf">
                    </g:else>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <label>
                        N. referencia
                    </label>
                </div>
                <div class="col-md-4">
                    <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${d?.documento?.referencia}">
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <label>
                        Emisión
                    </label>
                </div>
                <div class="col-md-3">
                    <elm:datepicker name="inicio" id="otros__${d?.id}" class="required form-control input-sm" value="${d?.documento?.inicio}"/>
                </div>
                <div class="col-md-1">
                    <label>
                        Vence
                    </label>
                </div>
                <div class="col-md-3">
                    <elm:datepicker name="fin" id="otros_fin_${d?.id}" class="required form-control input-sm" value="${d?.documento?.fin}"/>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <label>
                        Observaciones
                    </label>
                </div>
                <div class="col-md-8">
                    <input type="text" name="descripcion" class="form-control input-sm required" required="" value="${d?.documento?.descripcion}" maxlength="512">
                </div>
            </div>
            <div class="row">
                <div class="col-md-1">
                    <a href="#" class="btn btn-primary guardar-docs" id="guardar-otros_${d.id}">
                        <i class="fa fa-save"></i>
                        Guardar
                    </a>
                </div>
            </div>
        </g:form>
    </fieldset>
</g:each>
<fieldset>
    <legend>Otros</legend>
    <g:form class="frm-subir-apb" controller="control" action="upload" enctype="multipart/form-data" >
        <input type="hidden" name="estacion_codigo" value="${estacion.codigo}" >
        <input type="hidden" name="proceso" value="${proceso?.id}" >
        <input type="hidden" name="id" value="" >
        <input type="hidden" name="tipo" value="otros" >
        <input type="hidden" name="paso" value="1" >
        <input type="hidden" name="origen" value="registrarControl" >
        <div class="row" style="margin-top: 0px">
            <div class="col-md-2">
                <label>
                    Documento
                </label>
            </div>
            <div class="col-md-4" style="">
                    <input type="file" name="file" id="file_otros_nuevo" class="form-control required"  style="border-right: none" accept=".pdf">
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    N. referencia
                </label>
            </div>
            <div class="col-md-4">
                <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="">
            </div>

        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    Emisión
                </label>
            </div>
            <div class="col-md-3">
                <elm:datepicker name="inicio" id="otros__nuevo" class="required form-control input-sm" value=""/>
            </div>
            <div class="col-md-1">
                <label>
                    Vence
                </label>
            </div>
            <div class="col-md-3">
                <elm:datepicker name="fin" id="otros_fin_nuevo" class=" form-control input-sm" value=""/>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>
                    Observaciones
                </label>
            </div>
            <div class="col-md-8">
                <input type="text" name="descripcion" class="form-control input-sm required" required="" value="" maxlength="512">
            </div>
        </div>
        <div class="row">
            <div class="col-md-1">
                <a href="#" class="btn btn-primary guardar-docs" id="guardar-otros_nuevo">
                    <i class="fa fa-save"></i>
                    Guardar
                </a>
            </div>
        </div>
    </g:form>
</fieldset>

</div>
</div>
</div>
</elm:container>
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

    var validator = $(".frm-subir-tdr").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        }
    });
    var validator = $(".frm-subir-obs").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        }
    });
    var validator = $(".frm-subir-apb").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        }
    });
    $(".ver-doc").click(function(){
        showPdf($(this))
        return false
    })
    $(".pdf-handler").click(function(){
        $(".pdf-viewer").hide("slide",{direction:'right'})
        $("#data").hide()
    })

    $("#guardar-tdr").click(function(){
        $(".frm-subir-tdr").submit()
        return false
    })
    $(".cambiar").click(function(){
        var id = $(this).attr("iden")
        $("#botones-"+id).hide()
        $("#div-file-"+id).show()
        return false
    })
    $(".guardar-docs").click(function(){
        $(this).parents("form").submit()
        return false
    })
    $("#guardar-apb").click(function(){
        $(this).parents("form").submit()
        return false
    })
    $("#consultor-btn").click(function(){
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'licencia', action:'cambiarConsultor')}",
            data: {
                id: $("#consultor").val(),
                proceso : "${proceso?.id}"
            },
            success: function (msg) {
                log("Datos guardados")
            }
        });
    })
</script>
</body>
</html>