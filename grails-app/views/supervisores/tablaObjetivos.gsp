<div class="row" style="margin-bottom: 15px">
    <div class="col-md-5">
        <div class="input-group" >
            <input type="text" class="form-control input-sm" id="txt-buscar" placeholder="Buscar">
            <span class="input-group-addon svt-bg-primary " id="btn-buscar" style="cursor: pointer" >
                <i class="fa fa-search " ></i>
            </span>
        </div>
    </div>
    <div class="col-md-3">
        <a href="#" class="btn btn-primary btn-sm" id="reset"><i class="fa fa-refresh"></i> Resetear filtros</a>
    </div>
</div>
<table class="table table-bordered table-condensed table-striped">
    <thead>
    <tr>
        <th>Registro</th>
        <th>Mes / Anio</th>
        <th>Objetivo</th>
        <th>Ver</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${objetivos}" var="o">
        <tr class="tr-info">
            <td>${o.fecha.format("dd-MM-yyyy")}</td>
            <td class="desc">${o.mes}</td>
            <td class="desc">${o.objetivo.nombre}</td>
            <td style="text-align: center">
                <g:if test="${o.path}">
                    <a href="${resource()+'/'+ o.path}" class="descargar btn btn-info btn-sm" target="_blank">
                        <i class="fa fa-download"></i>
                    </a>
                </g:if>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>
<script>
    function search(clase){
        $(".tr-info").hide()
        $("."+clase).show()
    }
    $("#btn-buscar").click(function(){
        var buscar = $("#txt-buscar").val().trim()
        $(".desc").removeHighlight();
        $(".tr-info").hide()
        if(buscar!=""){
            $(".desc").highlight(buscar, true);
            $(".highlight").parents("tr").show()
        }else{
            $(".tr-info").show()
        }

    });
    $("#reset").click(function () {
        $(".tr-info").show()
        $(".desc").removeHighlight();
    })
</script>