<%@ page import="gaia.documentos.Inspector" %>
<div class="row">
    <div class="col-md-1">Supervisor</div>

    <div class="col-md-3">
        <g:select name="ins" from="${Inspector.list([sort: 'nombre'])}" class="form-control input-sm"
                  optionKey="id" optionValue="nombre"/>
    </div>

    <div class="col-md-1">
        <a href="#" class="btn btn-success btn-sm" title="Agregar" id="btnAddIns">
            <i class="fa fa-plus"></i>
        </a>
    </div>
</div>

<div class="row">
    <div class="col-md-12" id="divInspectores">

    </div>
</div>

<script type="text/javascript">
    var $div = $("#divInspectores");
    function loadInspectores() {
        $div.html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'inspector', action:'listEstacion_ajax')}",
            data    : {
                codigo : "${estacion.codigo}"
            },
            success : function (msg) {
                $div.html(msg);
            }
        });
    }

    $(function () {
        loadInspectores();

        $("#btnAddIns").click(function () {
            var ins = $("#ins").val();
            var est = "${estacion.codigo}";

            var existe = false;
            $("#tbIns").children("tr").each(function () {
                var $tr = $(this);
                var c = $tr.data("ins");
                if (c == ins) {
                    existe = true;
                    $tr.effect("highlight", 800);
                }
            });

            if (!existe) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'inspector', action:'addInspector_ajax')}",
                    data    : {
                        codigo : "${estacion.codigo}",
                        ins    : ins
                    },
                    success : function (msg) {
                        var parts = msg.split("*");
                        log(parts[1], parts[0].toLowerCase());
                        if (parts[0] == "SUCCESS") {
                            loadInspectores();
                        }
                    }
                });
            }
        });
    });
</script>