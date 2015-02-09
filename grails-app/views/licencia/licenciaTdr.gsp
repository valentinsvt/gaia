<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <title>
        Registrar licencia ambiental
    </title>
    <style type="text/css">
    label{
        padding-top: 5px;
    }
    </style>
</head>
<body>
<elm:container tipo="horizontal" titulo="Estación: ${estacion.nombre}" >
    <div class="panel panel-info" style="margin-top: 20px">
        <div class="panel-heading">Licencia ambiental</div>
        <div class="panel-body" style="padding:0px">
            <div class="header-flow">
                <g:link action="registrarLicencia" id="${estacion.codigo}" style="text-decoration: none">
                    <div class="header-flow-item before">
                        <span class="badge before">1</span> Certificado de intersección
                        <span class="arrow"></span>
                    </div>
                </g:link>

                <div class="header-flow-item active">
                    <span class="badge active">2</span>
                    Terminos de referencia
                    <span class="arrow"></span>
                </div>
                <g:if test="${detalleApb?.documento}">
                    <g:link controller="licencia" action="licenciaEia" id="${proceso.id}" style="text-decoration: none">
                        <div class="header-flow-item disabled">
                            <span class="badge disabled">3</span>
                            Estudio de impacto ambiental
                            <span class="arrow"></span>
                        </div>
                    </g:link>
                </g:if>
                <g:else>
                    <div class="header-flow-item disabled">
                        <span class="badge disabled">3</span>
                        Estudio de impacto ambiental
                        <span class="arrow"></span>
                    </div>
                </g:else>
                <div class="header-flow-item disabled">
                    <span class="badge disabled">4</span>
                    Pago y licencia
                </div>
            </div>
            <div class="flow-body">
                <g:form class="frm-subir" controller="licencia" action="upload" enctype="multipart/form-data" >
                    <input type="hidden" name="estacion_cdgo" value="${estacion.codigo}" >
                    <input type="hidden" name="proceso" value="${proceso?.id}" >
                    <input type="hidden" name="id" value="${detalleTdr?.id}" >
                    <input type="hidden" name="paso" value="2" >
                    <div class="row">
                        <div class="col-md-2">
                            <label>
                                Terminos de referencia
                            </label>
                        </div>
                        <div class="col-md-4">
                            <g:if test="${detalleTdr?.documento}">
                                <a href="#" class="btn btn-info">
                                    <i class="fa fa-search"></i> Ver
                                </a>
                                <a href="#" class="btn btn-info">
                                    <i class="fa fa-refresh"></i> Cambiar
                                </a>
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
                            <input type="text" name="referencia" class="form-control input-sm required" maxlength="20" value="${detalleTdr?.documento?.referencia}">
                        </div>
                        <div class="col-md-1">
                            <label>
                                Emisión
                            </label>
                        </div>
                        <div class="col-md-3">
                            <elm:datepicker name="inicio" class="required form-control input-sm" value="${detalleTdr?.documento?.inicio}"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2">
                            <label>
                                Observaciones
                            </label>
                        </div>
                        <div class="col-md-8">
                            <input type="text" name="descripcion" class="form-control input-sm required" required="" maxlength="512">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-1">
                            <a href="#" class="btn btn-primary">
                                <i class="fa fa-save"></i>
                                Guardar
                            </a>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</elm:container>
<script type="text/javascript">

</script>
</body>
</html>