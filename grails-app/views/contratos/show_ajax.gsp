<%@ page import="gaia.estaciones.Estacion" %>

<g:if test="${!estacionInstance}">
    <elm:notFound elem="Estacion" genero="o"/>
</g:if>
<g:else>
    <div class="modal-contenido">
        <g:if test="${estacionInstance?.nombre}">
            <div class="row">
                <div class="col-sm-2 show-label">
                    Nombre
                </div>
                <div class="col-sm-4">
                    <g:fieldValue bean="${cliente}" field="nombre"/>
                </div>
                <div class="col-sm-2 show-label">
                    Ruc
                </div>
                <div class="col-sm-3">
                    <g:fieldValue bean="${cliente}" field="ruc"/>
                </div>

            </div>
        </g:if>

        <div class="row">
            <div class="col-sm-2 show-label">
                EMail
            </div>
            <div class="col-sm-4" >
                <g:fieldValue bean="${cliente}" field="email"/>  <i class="fa fa-info-circle" style="color:#FFA324 "></i>
            </div>
            <div class="col-sm-2 show-label">
                Direccion
            </div>
            <div class="col-sm-4">
                <g:fieldValue bean="${cliente}" field="direccion"/>
            </div>

        </div>
        <div class="row">
            <div class="col-sm-2 show-label">
                Telefono
            </div>

            <div class="col-sm-4" >
                <g:fieldValue bean="${cliente}" field="telefono"/> <i class="fa fa-info-circle" style="color:#FFA324 "></i>
            </div>
            <div class="col-sm-2 show-label">
                Fax
            </div>

            <div class="col-sm-3">
                <g:fieldValue bean="${cliente}" field="fax"/>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-2 show-label">
                % comercialización
            </div>
            <div class="col-sm-4" >
                ${gaia.Contratos.DashBoardContratos.findByEstacion(estacionInstance)?.porcentajeComercializacion?.round(2)}% <i class="fa fa-info-circle" style="color:#FFA324 "></i>
            </div>
            <div class="col-sm-2 show-label">
                Código
            </div>
            <div class="col-sm-3">
                <g:fieldValue bean="${estacionInstance}" field="codigo"/>
            </div>

        </div>
        <div class="row">
            <div class="col-sm-2 show-label">
                Días crédito
            </div>
            <div class="col-sm-4">
                ${cliente.plazo?.toInteger()} días <i class="fa fa-info-circle" style="color:#FFA324 "></i>
            </div>
            <div class="col-sm-2 show-label">
                Código ARCH
            </div>
            <div class="col-sm-3">
                ${cliente.codigoDnh}
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2 show-label">
                Propetario
            </div>
            <div class="col-sm-4">
                <g:fieldValue bean="${estacionInstance}" field="propetario"/>
            </div>
            <div class="col-sm-2 show-label">
                Arrendatario
            </div>
            <div class="col-sm-3">
                ${estacionInstance.arrendatario}
            </div>
        </div>
        <g:if test="${cliente.nombreRepresentante?.trim()!=''}">
            <div class="row">
                <div class="col-sm-2 show-label">
                    Representante
                </div>
                <div class="col-sm-8">
                    ${cliente.nombreRepresentante}
                </div>
            </div>
        </g:if>
        <div class="row">
            <div class="col-sm-2 show-label">
                Ubicación
            </div>
            <div class="col-sm-10">
                ${gaia.documentos.Ubicacion.findByCodigo(estacionInstance.provincia)?.nombre} - ${gaia.documentos.Ubicacion.findByCodigo(estacionInstance.canton)?.nombre} - ${gaia.documentos.Ubicacion.findByCodigo(estacionInstance.parroquia)?.nombre}
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(".fa-info-circle").attr("title","Importante")
    </script>
</g:else>