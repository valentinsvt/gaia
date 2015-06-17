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
    .objetivo{
        color: #ffab38;
        font-weight: bold;
    }
    .supervisor{
        color: #3A5DAA;
        font-weight: bold;
    }
    </style>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
</head>

<body>
<elm:container titulo="Objetivos asesores de servicio al cliente, mes de ${meses[mesint-1]}">
    <div class="row">
        <div class="col-md-12">
            <table class="table  table-condensed table-bordered table-hover">
                <thead>
                <tr>
                    <th>Supervisor</th>
                    <g:each in="${objetivos}" var="o">
                        <th title="${o.descripcion}">${o.nombre}<br>${o.meta}</th>
                    </g:each>
                </tr>
                </thead>
                <tbody>
                <g:each in="${supervisores}" var="s" status="i">

                    <tr>
                        <td>${s.nombre}</td>
                        <g:each in="${objetivos}" var="o">
                            <g:if test="${o.codigo=='VTES'}">
                                <g:set var="an" value="${s.getAnalisisVentas(fecha)}"></g:set>
                                <g:if test="${an[0].size()>0}">
                                    <td style="text-align: center" title="${an[0].size()} / ${an[1]} Análisis registrados">
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
                                    <g:if test="${o.tipo=='C'}">
                                        <td style="text-align: center">
                                            <a href="#" class="registrar btn btn-info btn-sm"
                                               objetivo="${o.descripcion}" supervisor="${s.nombre}"
                                               idOb="${o.id}" idSup="${s.codigo}"
                                               mes="${o.periocidad=='A'?anio:mesString}">
                                                <i class="fa fa-check"></i>
                                            </a>
                                        </td>
                                    </g:if>
                                    <g:else>
                                        <td style="text-align: center"><div class="circle-card" style="background: ${colores[0]}"></div></td>
                                    </g:else>
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
</elm:container>
<script type="text/javascript">
    $(".registrar").click(function(){
        var objetivo = $(this).attr("objetivo")
        var supervisor = $(this).attr("supervisor")
        var mesString = "${meses[mesint-1]}"
        var idOb=$(this).attr("idOb")
        var idSup = $(this).attr("idSup")
        var mes = $(this).attr("mes")
        bootbox.confirm("Está apunto de registrar como compleatado el obejtivo: <span class='objetivo'>"+objetivo+"</span>, del supervisor <span class='supervisor'>"+supervisor+"</span> para el mes de "+mesString+". Está seguro?",
                function(result){
                    if(result){
                        $.ajax({
                            type: "POST",
                            url: "${createLink(controller:'supervisores', action:'cumplirObjetivo')}",
                            data: {
                                supervisor: idSup,
                                objetivo:idOb,
                                mes:mes
                            },
                            success: function (msg) {
                                location.reload(true)
                            }
                        });
                    }
                }
        )
    })
</script>
</body>
</html>