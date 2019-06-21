<%--
  Created by IntelliJ IDEA.
  User: ZAPATAV
  Date: 5/5/2015
  Time: 12:54 PM
--%>

<%@ page import="gaia.pintura.ItemImagen" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Registro, pintura y mantenimiento</title>
    <meta name="layout" content="main"/>
    <title>Estación ${estacion.nombre}</title>
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
    .dropdown-header{
        color: #006EB7 !important;
    }
    .numero{
        text-align: right;
    }
    .info-row td{
        background: #7fac35;
        color: #ffffff;
        font-weight: bold;
        padding-left: 10px !important;
    }
    </style>
</head>
<body>
<div class="row" style="margin-top: 0px">
    <div class="col-md-10" style="font-size: 20px;color: #3A5DAA;border-bottom: 1px solid #91bf36;padding-bottom: 5px;">
        Registro de pintura y mantenimiento, estación: ${estacion}
    </div>
</div>
<g:form class="frmIngreso" action="saveIngreso">
    <input type="hidden" name="id" value="${ingreso?.id}">
    <input type="hidden" name="data" id="data" value="">
    <input type="hidden" name="estacion" value="${estacion.codigo}">
    <div class="row" style="margin-top: 25px">
        <div class="col-md-1">
            <label>Fecha</label>
        </div>
        <div class="col-md-3">
            <elm:datepicker class="form-control input-sm required"  name="fin" value="${ingreso?.fin?.format('dd-MM-yyyy')}" ></elm:datepicker>
        </div>
        <div class="col-md-1">
            <label>Atención a</label>
        </div>
        <div class="col-md-2">
            <input type="text" class="form-control input-sm required" maxlength="30" name="atencionA" value="${ingreso?.atencionA}">
        </div>
    </div>
    <div class="row">
        <div class="col-md-1">
            <label>Contratista</label>
        </div>
        <div class="col-md-3">
            <g:select name="contrat" from="${gaia.pintura.Contratista.list([sort: 'nombre'])}"
                      class="form-control input-sm required"
                      optionKey="codigo" optionValue="nombre" value="${ingreso?.contratista?.codigo}"/>
        </div>
        <div class="col-md-1">
            <label>Factura</label>
        </div>
        <div class="col-md-2">
            <input type="text" class="form-control input-sm " maxlength="30" name="numeroFactura" value="${ingreso?.numeroFactura}" >
        </div>
        <div class="col-md-1">
            <label>Autorización de pago</label>
        </div>
        <div class="col-md-2">
            <input type="text" class="form-control input-sm " maxlength="25" name="numeroAp" value="${ingreso?.numeroAp}" >
        </div>
    </div>
    <div class="row">
        <div class="col-md-1">
            <label>Observaciones</label>
        </div>
        <div class="col-md-9">
            <input type="text" class="form-control input-sm" name="observaciones" maxlength="255" value="${ingreso?.observaciones}" >
        </div>
    </div>

    <div class="row" style="margin-top: 20px">
        <div class="col-md-10">
            <table class="table table-condensed">
                <thead style="border:none !important;">
                <tr style="border: none !important;">
                    <th style="width: 60%;background: transparent;color: #000000;border: none !important;text-align: left">Item</th>
                    <th style="background: transparent;color: #000000;border: none !important;">Cantidad</th>
                    <th style="background: transparent;color: #000000;border: none !important;">V. unitario</th>
                    <th style="background: transparent;color: #000000;border: none !important;">Total</th>
                    <th style="background: transparent;color: #000000;border: none !important;"></th>
                </tr>
                </thead>
                <tbody style="border:none !important;">
                <tr>
                    <td>
                        <select class="selectpicker input-sm form-control"  id="item" data-live-search="true" >
                            <g:each in="${items}" var="item">
                                <optgroup label="${item.descripcion}" >
                                    <g:each in="${ItemImagen.findAllByPadre(item)}" var="it">
                                        <option padre="${item}" padre-id="${item.id}" value="${it.id}">${it.descripcion}</option>
                                    </g:each>
                                </optgroup>
                            </g:each>
                        </select>
                    </td>
                    <td>
                        <input type="text" class="form-control input-sm number" id="cantidad" style="height:31px;text-align: right" value="1">
                    </td>
                    <td>
                        <input type="text" class="form-control input-sm number" style="height:31px;;text-align: right" id="valor" value="0">
                    </td>
                    <td>
                        <input type="text" class="form-control input-sm number" style="height:31px;;text-align: right" id="total" value="0" disabled>
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
        <div class="col-md-10">
            <table class="table table-striped table-condensed table-hover">
                <thead>
                <tr>
                    <th colspan="5">Detalle</th>
                </tr>
                <tr>
                    <th style="width: 60%">Item</th>
                    <th>Cantidad</th>
                    <th>V. unitario</th>
                    <th>Total</th>
                    <th></th>
                </tr>
                </thead>
                <tbody id="detalles">
                <g:set var="total" value="${0}"></g:set>
                <g:set var="anterior" value=""></g:set>
                <g:each in="${detalle}" var="d">
                    <g:set var="total" value="${total+(d.cantidad*d.unitario)}"></g:set>
                    <g:if test="${anterior!=d.item.padre}">
                        <tr class="info-row row_${d.item.padre.id}">
                            <td colspan="3"><i class='fa fa-indent'></i> ${d.item.padre}</td>
                            <td style='font-weight: bold' class='numero tp total-${d.item.padre.id}'>0.00</td>
                            <td></td>
                        </tr>
                        <g:set var="anterior" value="${d.item.padre}"></g:set>
                    </g:if>
                    <tr class="detalle" item="${d.item.id}" cantidad="${d.cantidad}" valor="${d.unitario}">
                        <td >${d.item}</td>
                        <td class="numero">${d.cantidad?.toDouble()?.round(2)}</td>
                        <td class="numero">${d.unitario?.toDouble()?.round(2)}</td>
                        <td class='numero total-parcial' padre="${d.item.padre.id}">${d.total?.toDouble()?.round(2)}</td>
                        <td style="text-align: center">
                            <a href='#' class='borrar btn btn-sm btn-danger' title='Borrar'><i class='fa fa-trash'></i></a>
                        </td>
                    </tr>
                </g:each>
                <tr>
                    <td colspan="3" style="font-weight: bold">TOTAL</td>
                    <td id="total-detalle" style="font-weight: bold;text-align: right">${total?.toDouble()?.round(2)}</td>
                    <td></td>
                </tr>
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

<script type="text/javascript">

    var validator = $(".frmIngreso").validate({
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

    function calculaTotal(){
        var total = 0
        var totalParcial = 0
        var lastPadre = ""
        $(".tp").html("0.00")
        $(".total-parcial").each(function() {
            if (lastPadre != $(this).attr("padre")){
                if(lastPadre!=""){
                    $(".total-"+lastPadre).html(number_format(totalParcial,2,"."," "))
                }
                lastPadre = $(this).attr("padre")
                totalParcial = $(this).html()*1
            }else{
                totalParcial +=$(this).html()*1
            }
            total+=$(this).html()*1

        });
        if(lastPadre!=""){
            $(".total-"+lastPadre).html(number_format(totalParcial,2,"."," "))
        }

        $(".tp").each(function(){
            if($(this).html()=="0.00")
                $(this).parent().remove()
        })

        $("#total-detalle").html(number_format(total,2,"."," "))
    }
    $(".detalles").click(function () {
        verEstacion("${estacion.codigo}");
        return false;
    });
    $(".equipo").click(function () {
        verEquipo("${estacion.codigo}");
        return false;
    });
    $("#valor").focus(function(){
        $(this).select();
    })
    $("#valor").blur(function(){
        $("#total").val(number_format($(this).val()*1*$("#cantidad").val()*1,2,".",""))
    })
    $("#cantidad").blur(function(){
        $("#total").val(number_format($("#valor").val()*1*$(this).val()*1,2,".",""))
    })
    $("#agregar").click(function(){

        var item = $("#item").val()
        var texto = $("#item option:selected").text()
        var cantidad = $("#cantidad").val()
        var valor = $("#valor").val()
        var total = cantidad*1*valor*1
        var tr = $("<tr class='detalle "+item+"' ></tr>")
        var btn = $("<a href='#' class='btn btn-sm btn-danger' title='Borrar'><i class='fa fa-trash'></i></a>")
        var td = $("<td style='text-align: center;width: 50px'>")
        var padre = $("#item option:selected").attr("padre")
        var padreId = $("#item option:selected").attr("padre-id")
        var rowPadre

        if(total==0){
            bootbox.alert("La cantidad y el valor unitario deben ser números mayores a cero")
        }else{
            //Se modifica 21 junio 2019 para ingresar ítems duplicados
            //if($("."+item).size()>0){
            //    bootbox.alert("El item "+texto+" ya esta registrado en la sección de detalle")
            //}else{
                tr.attr("item",item)
                tr.attr("cantidad",cantidad)
                tr.attr("valor",valor)
                tr.append("<td>"+texto+"</td><td class='numero'>"+cantidad+"</td><td class='numero'>"+valor+"</td><td class='numero total-parcial' padre='"+padreId+"'>"+number_format(total,2,".","")+"</td>")
                td.append(btn)
                tr.append(td)
                if($(".row_"+padreId).size()>0){
                    rowPadre= $(".row_"+padreId)
                    $(".row_"+padreId).after(tr)
                }else{
                    rowPadre=$("<tr class=' info-row row_"+padreId+"'>")
                    rowPadre.append("<td colspan='3'><i class='fa fa-indent'></i> "+padre+"</td><td style='font-weight: bold' class='numero tp total-"+padreId+"'>"+number_format(total,2,".","")+"</td><td></td>")
                    $("#detalles").prepend(tr)
                    $("#detalles").prepend(rowPadre)

                }

                btn.click(function(){
                    $(this).parent().parent().remove()
                    calculaTotal()
                    return false
                })
                calculaTotal()
            //}

        }

        return false
    });
    $(".borrar").click(function(){
        $(this).parent().parent().remove()
        calculaTotal()
        return false
    })
    $("#guardar").click(function(){
        if($("#fin_input").val()==""){
            bootbox.alert("Por favor ingrese la fecha de finalización de trabajo")
        }else{
            if($(".frmIngreso").valid()){
                var data = ""
                $(".detalle").each(function(){
                    data+=$(this).attr("item")+";"+$(this).attr("cantidad")+";"+$(this).attr("valor")+"W"
                })
                $("#data").val(data)
                $(".frmIngreso").submit()
            }
        }

    })
    calculaTotal()
</script>
</body>
</html>