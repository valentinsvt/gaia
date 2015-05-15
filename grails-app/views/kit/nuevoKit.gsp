<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Nuevo kit</title>
    <meta name="layout" content="main"/>
</head>
<body>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <g:link controller="kit" action="lista" class="btn btn-default">
            <i class="fa fa-list"></i> Lista
        </g:link>
    </div>
</div>
<elm:container titulo="Nuevo Kit">
    <g:form class="frmkit" action="save">
        <input type="hidden" name="id" value="${kit?.id}">
        <input type="hidden" name="data" id="data">

        <div class="row">
            <div class="col-md-1">
                <label>Nombre</label>
            </div>
            <div class="col-md-6">
                <input type="text" id="nombre" name="nombre" class="form-control input-sm required" value="${kit?.nombre}">
            </div>
        </div>
        <div class="row">
            <div class="col-md-1">
                <label>Género</label>
            </div>
            <div class="col-md-2">
                <select class="form-control input-sm required" id="genero" name="genero">
                    <option value="M" ${kit?.genero=='M'?'selected':''}>Masculino</option>
                    <option value="F" ${kit?.genero=='F'?'selected':''}>Femenino</option>
                    <option value="U" ${kit?.genero=='U'?'selected':''}>Unisex</option>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-7">
                <table class="table table-condensed">
                    <thead style="border:none !important;">
                    <tr style="border: none !important;">
                        <th style="width: 80%;background: transparent;color: #000000;border: none !important;text-align: left">Uniforme</th>
                        <th style="background: transparent;color: #000000;border: none !important;">Cantidad</th>
                        <th style="background: transparent;color: #000000;border: none !important;"></th>
                    </tr>
                    </thead>
                    <tbody style="border:none !important;">

                    <tr>
                        <td id="td-uniforme">
                            <g:select name="unforme" from="${[]}"></g:select>
                        </td>
                        <td>
                            <input type="number" class="form-control input-sm number" id="cantidad" style="text-align: right" value="1" min="1">
                        </td>
                        <td>
                            <a href="#" title="Agregar" id="agregar" class="btn btn-sm btn-info">
                                <i class="fa fa-plus"></i>
                            </a>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-md-7">
                <table class="table table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th colspan="5">Detalle</th>
                    </tr>
                    <tr>
                        <th style="width: 60%">Uniforme</th>
                        <th>Cantidad</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody id="detalles">
                    <g:each in="${detalles}" var="d">
                        <tr  class="detalle" uniforme="${d.uniforme.codigo}" cantidad="${d.cantidad}">
                            <td>${d.uniforme.descripcion}</td>
                            <td style="text-align: center">${d.cantidad}</td>
                            <td style="text-align: center">
                                <a href="#" class="btn btn-danger btn-sm borrar" title="Borrar" >
                                    <i class="fa fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-md-1">
                <a href="#" class="btn btn-success" id="guardar">
                    <i class="fa fa-save"></i> Guardar
                </a>
            </div>
        </div>
    </g:form>
</elm:container>
<script type="text/javascript">
    var validator = $(".frmkit").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        }

    });
    $("#genero").change(function(){
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'kit', action:'comboUniforme')}",
            data: {
                tipo: $("#genero").val()
            },
            success: function (msg) {
                $("#td-uniforme").html(msg)

            }
        });
    })
    $("#genero").change()
    $("#agregar").click(function(){
        var cantidad = $("#cantidad").val()
        var uniforme = $("#uniforme").val()
        var texto = $("#uniforme option:selected").text()
        if(cantidad*1>0){
            var tr = $("<tr class='detalle'>")
            tr.attr("uniforme",uniforme)
            tr.attr("cantidad",cantidad)
            tr.append("<td>"+texto+"</td>")
            tr.append("<td style='text-align: center'>"+cantidad+"</td>")
            var btn = $("<a href='#' class='btn btn-danger btn-sm borrar' title='Borrar'><i class='fa fa-trash'></i></a>")
            btn.click(function(){
                $(this).parent().parent().remove()
                return false
            })
            var td = $("<td style='text-align: center'>")
            td.append(btn)
            tr.append(td)
            $("#detalles").append(tr)
        }else{
            bootbox.alert("La cantidad debe ser un número positivo")
        }

        return false
    });
    $("#guardar").click(function(){
        if($(".frmkit").valid()){
            var data = ""
            $(".detalle").each(function(){
                data+=$(this).attr("uniforme")+";"+$(this).attr("cantidad")+"W"
            })
            $("#data").val(data)
            $(".frmkit").submit()
        }
    })
    $(".borrar").click(function(){
        $(this).parent().parent().remove()
        return false
    })
</script>
</body>
</html>