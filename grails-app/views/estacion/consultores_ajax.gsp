<%@ page import="gaia.documentos.Consultor" %>
<div class="row">
    <div class="col-md-1">Consultor</div>

    <div class="col-md-3">
        <g:select name="cons" from="${Consultor.list([sort: 'nombre'])}" class="form-control input-sm"
                  optionKey="id" optionValue="nombre"/>
    </div>

    <div class="col-md-1">
        <a href="#" class="btn btn-success btn-sm" title="Agregar" id="btnAddCons">
            <i class="fa fa-plus"></i>
        </a>
    </div>
</div>

<div class="row">
    <div class="col-md-12" id="divConsultores">

    </div>
</div>

<script type="text/javascript">
    var $div = $("#divConsultores");
    function loadConsultores() {
        $div.html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'consultor', action:'listEstacion_ajax')}",
            data    : {
                codigo : "${estacion.codigo}"
            },
            success : function (msg) {
                $div.html(msg);
            }
        });
    }

    $(function () {
        loadConsultores();

        $("#btnAddCons").click(function () {
            var cons = $("#cons").val();
            var esta = "${estacion.codigo}";

            var existe = false;
            $("#tbCons").children("tr").each(function () {
                var $tr = $(this);
                var c = $tr.data("cons");
                if (c == cons) {
                    existe = true;
                    $tr.effect("highlight", 800);
                }
            });

            if (!existe) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'consultor', action:'addConsultor_ajax')}",
                    data    : {
                        codigo : "${estacion.codigo}",
                        cons   : cons
                    },
                    success : function (msg) {
                        var parts = msg.split("*");
                        log(parts[1], parts[0].toLowerCase());
                        if (parts[0] == "SUCCESS") {
                            loadConsultores();
                        }
                    }
                });
            }
        });
    });
</script>