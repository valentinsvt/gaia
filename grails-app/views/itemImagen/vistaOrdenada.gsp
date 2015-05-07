<%--
  Created by IntelliJ IDEA.
  User: ZAPATAV
  Date: 5/5/2015
  Time: 12:54 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Registro, pintura y mantenimiento</title>
    <meta name="layout" content="main"/>
    <title>Items imagen</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"/>
    <imp:css src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.min.css')}"/>
    <style>
    a.collapse{
        text-decoration: none;
    }
    a.collapsed{
        text-decoration: none;
    }
    .P{
        color: #ffa751;
        margin-right: 10px;
    }
    .R{
        color: #fe6560;
        margin-right: 10px;
    }
    .N{
        color: #62bdff;
        margin-right: 10px;
    }
    .A{
        margin-right: 10px;
        color: #81ffb6;
    }
    </style>
</head>
<body>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <g:link controller="moduloPintura" action="listaSemaforos" class="btn btn-default">
            <i class="fa fa-list"></i> Estaciones
        </g:link>

    </div>
</div>
<elm:container tipo="horizontal" titulo="Items imagen">

    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true" style="margin-top: 20px">
        <g:each in="${items}" var="item" status="i">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="head-${item.id}">
                    <h4 class="panel-title">
                        <a  class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#tab-${item.id}" aria-expanded="false" aria-controls="tab-${item.id}" style="width: 100%">
                            <i class=" ${item.tipoItem} fa ${item.tipoItem=='P'?'fa-paint-brush':'fa-photo'}" title="${item.tipoItem=='P'?'Pintura':'Rotulación'}"></i>

                            ${item.descripcion}
                        </a>
                    </h4>
                </div>
                <div id="tab-${item.id}"class="panel-collapse collapse" role="tabpanel" aria-labelledby="head-${item.id}" >
                    <div class="panel-body">
                        <table class="table table-striped table-hover">
                            <thead>
                            <tr>
                                <th style="width: 70%">Item</th>
                                <th>Cantidad</th>
                                <th>V.unitario</th>
                                <th>Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${gaia.pintura.ItemImagen.findAllByPadre(item)}" var="it" status="j">
                                <tr>
                                    <td>${it.descripcion}</td>
                                    <td>
                                        <input type="text" class=" number form-control input-sm cant_${it.id} padre_${item.id}" style="text-align: right" >
                                    </td>
                                    <td>
                                        <input type="text" class=" number form-control input-sm val_${it.id} padre_${item.id}" style="text-align: right" >
                                    </td>
                                    <td>
                                        <input type="text" class=" number form-control input-sm tot_${it.id} padre_${item.id}" style="text-align: right" >
                                    </td>
                                </tr>
                            </g:each>
                            <tr>
                                <td colspan="3" style="font-weight: bold">TOTAL</td>
                                <td style="text-align: right;font-weight: bold" class="total_${item.id}"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </g:each>
    </div>

</elm:container>
<script type="text/javascript">


</script>
</body>
</html>