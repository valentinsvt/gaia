<%--
  Created by IntelliJ IDEA.
  User: Luz
  Date: 2/9/2015
  Time: 10:10 PM
--%>

<div class="alert alert-info">
    <h4>Nueva observación</h4>
    <g:textArea name="obs" class="form-control"/>
    <a href="#" class="btn btn-success" id="btnSave" style="margin-top: 5px;">
        <i class="fa fa-save"></i> Guardar
    </a>
</div>

<div id="observaciones" style="max-height: 250px; overflow-y: auto; ">
    <g:each in="${obs}" var="o">
        <div class="panel panel-info">
            <div class="panel-heading">
                <h3 class="panel-title">${o.persona.nombre} <small>${o.fecha.format("dd-MM-yyyy HH:mm")}</small></h3>
            </div>

            <div class="panel-body">
                ${o.observacion}
            </div>
        </div>
    </g:each>
</div>

<script type="text/javascript">
    $(function () {
        $("#btnSave").click(function () {
            var obs = $.trim($("#obs").val());
            var id = "${doc.id}";

            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'observacion', action:'save_ajax')}",
                data    : {
                    "documento.id" : id,
                    observacion    : obs
                },
                success : function (msg) {
                    if (msg.startsWith("ERROR")) {
                        var parts = msg.split("*");
                        log(parts[1], "error"); // log(msg, type, title, hide)
                    } else {
                        $("#observaciones").html(msg);
                        $("#obs").val("");
                    }
                }
            });
        });
    });
</script>