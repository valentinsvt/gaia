<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>PYS Supervisores</title>
    <style type="text/css">
    .inicio img {
        height : 190px;
        background: #e8ff61;
    }

    i {
        margin-right : 5px;
    }
    .circle-card{
        width: 22px !important; ;
        height: 22px !important;;
    }
    </style>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
</head>

<body>
<elm:message tipo="info" clase="">
    Los objetivos: ${obj.nombre.join(", ")} deben ser registrados por un funcionario de la unidad de Distribución, si el sistema muestra
    como objetivo no cumplido por favor comuniquese con dicha unidad.
</elm:message>
<elm:container titulo="Objetivos del supervisor: ${supervisor.nombre}, mes de ${meses[mesint-1]}">
    <div class="row">
        <div class="col-md-12">
            <table class="table  table-condensed table-bordered table-hover">
                <thead style="font-size: 11px">
                <tr>
                    <th>Supervisor</th>
                    <g:each in="${objetivos}" var="o">
                        <th title="${o.descripcion}">${o.nombre}<br>${o.meta}</th>
                    </g:each>
                </tr>
                </thead>
                <tbody>
                <g:each in="${supervisores}" var="s" status="i">
                    <g:set var="c" value="${i>6?6:i}"></g:set>
                    <tr>
                        <td>${s.nombre}</td>
                        <g:each in="${objetivos}" var="o">
                            <g:if test="${o.codigo=='VTES'}">
                                <g:set var="an" value="${s.getAnalisisVentas(fecha)}"></g:set>
                                <g:if test="${an[0].size()>0}">
                                    <td style="text-align: center" title="${an[0].size()} de ${an[1]} Análisis registrados">
                                        <div class="circle-card " style="background: ${colores[an[2]?.toInteger()]}"></div>
                                    </td>
                                </g:if>
                                <g:else>
                                    <td style="text-align: center"><div class="circle-card " style="background: ${colores[0]}" ></div></td>
                                </g:else>
                            </g:if>
                            <g:else>
                                <g:if test="${o.periocidad=='A'}">
                                    <g:set var="cump" value="${gaia.supervisores.CumplimientoSupervisor.findAll('from CumplimientoSupervisor where objetivo=\''+o.id+'\' and mes=\''+anio+'\' and supervisor=\''+s.id+'\'')}"></g:set>
                                </g:if>
                                <g:else>
                                    <g:set var="cump" value="${gaia.supervisores.CumplimientoSupervisor.findAll('from CumplimientoSupervisor where objetivo=\''+o.id+'\' and mes=\''+mesString+'\' and supervisor=\''+s.id+'\'')}"></g:set>
                                </g:else>
                                <g:if test="${cump.size()==0}">
                                    <td style="text-align: center"><div class="circle-card " style="background: ${colores[0]}" ></div></td>
                                </g:if>
                                <g:else>
                                    <td style="text-align: center"><div class="circle-card" style="background: ${colores[6]}"></div></td>
                                </g:else>
                            </g:else>

                        </g:each>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-2">
            <a href="${g.createLink(controller: 'supervisores',action: 'listaSemaforos')}" class="btn btn-info">
               <i class="fa icon-line-graph"></i> Registrar analisis de ventas
            </a>
        </div>
        <div class="col-md-2">
            <a href="${g.createLink(controller: 'supervisores',action: 'registrarCumplimiento')}" class="btn btn-info">
                <i class="fa fa-check"></i> Registrar otros objetivos
            </a>
        </div>
    </div>
</elm:container>
</body>
</html>