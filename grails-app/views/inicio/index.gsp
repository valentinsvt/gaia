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
    }
    .texto-link{
        border-radius: 5px;
        height: 85px;
        padding: 3px;
        width: 59%;
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
    </style>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
</head>
<body>
<div class="row">
    <g:link controller="inicio" action="modulos" params="[modulo:'ambiente']" >
        <div class="col-md-3">
            <div class="link-modulo">
                <div class="imagen-link" style="padding-left: 14px">
                    <img src="${resource(dir: 'images',file: 'eco9.png')}" height="100%" >
                </div>
                <div class="texto-link">
                    Gestion Ambiental
                </div>
            </div>
        </div>
    </g:link>
    <g:link controller="inicio" action="modulos" params="[modulo:'contratos']" >
        <div class="col-md-3">
            <div class="link-modulo">
                <div class="imagen-link" style="padding-left: 12px">
                    <img src="${resource(dir: 'images',file: 'contrato.png')}" height="100%" >
                </div>
                <div class="texto-link">
                    Contratos
                </div>

            </div>
        </div>
    </g:link>
</div>
</body>
</html>