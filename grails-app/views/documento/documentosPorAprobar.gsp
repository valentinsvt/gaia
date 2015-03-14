<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Documentación requeridas</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight', file: 'jquery-highlight1.js')}"></imp:js>
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <style>
    .td-semaforo {
        text-align : center;
        width      : 110px;
    }

    .circle-card {
        width  : 22px;
        height : 22px;
    }

    .circle-btn {
        cursor : pointer;
    }

    .highlight {
        background-color : yellow;
    }
    </style>
</head>

<body>

<elm:container tipo="horizontal" titulo="Documentación por aprobar">

    <table class="table table-striped table-hover table-bordered" style="margin-top: 15px;width: 70%">
        <thead>
        <tr>
            <th>Estación</th>
            <th>Documentos</th>
            <th>Ver</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${estaciones}" var="e">
            <tr>
                <td>${e.value[0]}</td>
                <td style="text-align: center">${e.value[1]}</td>
                <td style="text-align: center">
                    <g:link controller="estacion" action="documentosPorAprobar" id="${e.value[2]}" title="Ver" class="btn btn-sm btn-info">
                        <i class="fa fa-check"></i>
                    </g:link>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</elm:container>

</body>
</html>