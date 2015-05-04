<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>P&S</title>
    <style type="text/css">
    .inicio img {
        height : 190px;
    }

    i {
        margin-right : 5px;
    }
    .link-modulo{
        width: 100%;
        height: 100px;
        border-radius: 5px;
        /*border: 1px solid #000;*/
        padding: 7px;
        background: #006EB7;
    }
    .imagen-link{
        border-radius: 5px;
        height: 85px;
        width: 40%;
        display: inline-table;
        line-height: 100%;
        padding: 5px;
        /*border: 1px solid #000000;*/
        margin: 0px;
        background: #ffffff;
        text-decoration: none;

    }
    .texto-link{
        border-radius: 5px;
        height: 85px;
        padding: 3px;
        width: 55%;
        display: inline-table;
        line-height: 78px;
        vertical-align: middle;
        font-weight: bold;
        text-align: center;
        /*border: 1px solid #000000;*/
        margin: 0px;
        color: #E14429;
        text-shadow: #ffffff;
        font-size: 14px;
        text-shadow:
        -1px -1px 0 #fff,
        1px -1px 0 #fff,
        -1px 1px 0 #fff,
        1px 1px 0 #fff;
        text-decoration: none;
    }
    .fondo{
        width: 100%;
        height: 381px;
        background-image: url("${g.resource(dir: 'images',file: 'fondo2.jpg')}");
        background-position: -180px -120px ;
        background-repeat: no-repeat;
        position: relative;
        margin-bottom: 0px;
        margin-top: -11px;
    }
    .barra{
        width: 100%;
        margin-top: 0px;
        height: 150px;
        background: #82A22F;
    }
    .modulo{
        position: absolute;
        border-radius: 50%;
        height: 120px;
        width: 120px;
        background: #243038;
        text-align: center;
        line-height: 120px;
        color: #fff;
        font-size: 60px;
    }
    .titulo{
        background: transparent;
        color: #ffffff;
        height: 40px;
        line-height: 40px;
        width: 120px;
        position: absolute;
        text-align: center;
        font-weight: bold;
        text-shadow:

    }
    </style>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
</head>
<body>
<div class="fondo">
    <g:each in="${session.sistemas}" var="sistema" status="i" >
        <g:if test="${sistema.codigo!='T'}">
            <g:link controller="inicio" action="modulos" params="[sistema:sistema.codigo]" title="${sistema.descripcion}" id="link_${i}"  >
                <div class="modulo" style="bottom: -70px;left: ${60+220*(i-1)}px">
                %{--<img src="${resource(dir: 'images',file: sistema.imagen)}" height="50%" >--}%
                    <g:if test="${i==1}">
                        <i class="fa flaticon-fuel2"></i>
                    </g:if>
                    <g:if test="${i==2}">
                        <i class="fa fa-dashboard"></i>
                    </g:if>
                    <g:if test="${i==3}">
                        <i class="fa fa-sort-alpha-desc"></i>
                    </g:if>
                    <g:if test="${i==4}">
                        <i class="fa flaticon-car24"></i>
                    </g:if>
                    <g:if test="${i==5}">
                        <i class="fa fa-cogs"></i>
                    </g:if>
                    <g:if test="${i==6}">
                        <i class="fa laticon-handy"></i>
                    </g:if>
                </div>
            </g:link>
            <g:link controller="inicio" action="modulos" params="[sistema:sistema.codigo]" title="${sistema.descripcion}" id="link_${i}"  >
                <div class="titulo" style="bottom: -120px;left: ${60+220*(i-1)}px">
                    ${sistema.nombre}
                </div>
            </g:link>
        </g:if>
    </g:each>
%{--<div class="modulo" style="bottom: -70px;left: 60px">--}%

%{--</div>--}%
%{--<div class="modulo" style="bottom: -70px;left: 270px">--}%
%{--<img src="${resource(dir: 'images',file: "ambiente.png")}" height="50%" >--}%
%{--</div>--}%
%{--<div class="modulo" style="bottom: -70px;left: 490px"></div>--}%
%{--<div class="modulo" style="bottom: -70px;left: 710px"></div>--}%
%{--<div class="modulo" style="bottom: -70px;left: 930px"></div>--}%
</div>
<div class="barra">

</div>

</body>
</html>