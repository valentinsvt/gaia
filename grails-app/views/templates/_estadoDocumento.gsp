<g:if test="${documento.estado=='N'}">
    <span style="color: red">
        <i class="fa fa-warning"></i>
        No aprobado
    </span>
    <g:if test="${session.tipo=='usuario'}">
        <a href="#" class="btn btn-success btn-sm" title="Aprobar" id="apbdcmt_${documento.id}">
            <i class="fa fa-check"></i>
        </a>
    </g:if>
    <script type="text/javascript">
        $("#apbdcmt_${documento.id}").click(function(){
            bootbox.dialog({
                title   : "Aprobar documento",
                message : "<i class='fa fa-check fa-3x pull-left text-success text-shadow'></i><p>" +
                "¿Está seguro que desea aprobar el documento?.</p>",
                buttons : {
                    cancelar : {
                        label     : "Cancelar",
                        className : "btn-default",
                        callback  : function () {
                        }
                    },
                    eliminar : {
                        label     : "<i class='fa fa-check'></i> Aprobar",
                        className : "btn-success",
                        callback  : function () {
                            openLoader("Aprobando el documento");
                            $.ajax({
                                type    : "POST",
                                url     : '${createLink(controller:'documento', action:'aprobarDocumento')}',
                                data    : {
                                    id : "${documento.id}"
                                },
                                success : function (msg) {
                                   window.location.reload(true)
                                },
                                error: function() {
                                    log("Ha ocurrido un error interno", "Error");
                                    closeLoader();
                                }
                            });
                        }
                    }
                }
            });
            return false
        })
    </script>
</g:if>
<g:else>
    <span class="text-success" style="font-weight: bold">
        <i class="fa fa-check"></i>
        Aprobado
    </span>
</g:else>