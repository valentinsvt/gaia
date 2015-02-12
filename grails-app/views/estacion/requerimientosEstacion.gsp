<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Documentación requeridas</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/jquery-highlight',file: 'jquery-highlight1.js')}"></imp:js>
    <style>
    .td-semaforo{
        text-align: center;
        width: 110px;
    }
    .circle-card{
        width: 22px ;
        height: 22px;
    }
    .circle-btn{
        cursor: pointer;
    }
    .highlight { background-color: yellow; }
    </style>
</head>

<body>
<elm:container tipo="horizontal" titulo="Documentación requerida para la estación: ${estacion.nombre}">
    <div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
        <div class="btn-group">
           <g:link action="showEstacion" id="${estacion.codigo}" class="btn btn-default">
               <i class="fa fa-university"></i>
               Estacion
           </g:link>
            <a href="${g.createLink(controller: 'documento', action: 'arbolEstacion', params: [codigo: estacion.codigo])}" class="btn btn-default mapa">
                <i class="fa fa-file-pdf-o"></i> Visor de documentos
            </a>
        </div>
    </div>
    <table class="table table-striped table-hover table-bordered" style="margin-top: 15px;width: 80%">
        <thead>
        <tr>
            <th>Entidad</th>
            <th style="width: 60%">Tipo de documento</th>
            <th class="td-semaforo">Estado</th>
            <th>Documento</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${reqs}" var="r">
                <tr>
                    <g:set var="doc" value="${estacion.getLastDoc(r.tipo)}"/>
                    <td style="text-align: center">${r.tipo.entidad.codigo}</td>
                    <td>${r.tipo.nombre}</td>
                    <td class="td-semaforo"><div class="circle-card ${doc?'card-bg-green':'svt-bg-danger'}"></div></td>
                    <td style="text-align: center">
                        <g:if test="${doc}">
                            ${doc.referencia}
                            <g:link controller="documento" action="ver" id="${doc.id}" target="_blank" class="btn btn-info btn-sm">
                                <i class="fa fa-search"></i> Ver
                            </g:link>
                        </g:if>
                        <g:else>
                            <g:link controller="documento" action="subir" params="[tipo:r.tipo.id,id:estacion.codigo]" target="_blank" class="btn btn-info btn-sm">
                                <i class="fa fa-upload"></i> Registrar
                            </g:link>
                        </g:else>
                    </td>
                    <td style="text-align: center">
                        <a href="#" class="borrar btn btn-danger btn-sm" id="${r.id}" >
                            <i class="fa fa-trash"></i> No necesario
                        </a>
                    </td>
                </tr>
        </g:each>
        </tbody>
    </table>
</elm:container>
<script type="text/javascript">
    $(".borrar").click(function(){
        var id = $(this).attr("id")
        bootbox.confirm({
            message:"Está seguro?",
            title   : "Atención",
            class   : "modal-error",
            callback:function(res){
                if(res){
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller:'estacion', action:'borrarReq')}",
                        data: {
                            id: id
                        },
                        success: function (msg) {
                            window.location.reload(true)
                        }
                    });
                }
            }
        })
    })
</script>
</body>
</html>