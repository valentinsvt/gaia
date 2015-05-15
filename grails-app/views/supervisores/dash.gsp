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
                    <g:set var="c" value="${i>6?6:i}"></g:set>
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
                                <td style="text-align: center"><div class="circle-card" style="background: ${colores[0]}"></div></td>
                            </g:else>

                        </g:each>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</elm:container>
</body>
</html>