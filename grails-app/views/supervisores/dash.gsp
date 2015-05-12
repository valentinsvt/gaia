<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>PYS Supervisores</title>
    <style type="text/css">
    .inicio img {
        height : 190px;
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
            <table class="table table-striped table-condensed table-bordered table-hover">
                <thead>
                <tr>
                    <th>Supervisor</th>
                    <g:each in="${objetivos}" var="o">
                        <th title="${o.descripcion}">${o.nombre}<br>${o.meta}</th>
                    </g:each>
                </tr>
                </thead>
                <tbody>
                <g:each in="${supervisores}" var="s">
                    <tr>
                        <td>${s.nombre}</td>
                        <g:each in="${objetivos}" var="o">
                            <g:if test="${o.codigo=='VTES'}">
                                <td style="text-align: center"><div class="circle-card ${colores[2]}" ></div></td>
                            </g:if>
                            <g:else>
                                <td style="text-align: center"><div class="circle-card ${colores[2]}" ></div></td>
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