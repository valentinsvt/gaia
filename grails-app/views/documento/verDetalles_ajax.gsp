<%--
  Created by IntelliJ IDEA.
  User: Luz
  Date: 2/9/2015
  Time: 9:25 PM
--%>

<div class="row">
    <div class="col-md-3 show-label">
        Estación
    </div>

    <div class="col-md-6">
        ${doc.estacion.nombre}
    </div>
</div>

<div class="row">
    <div class="col-md-3 show-label">
        Tipo de documento
    </div>

    <div class="col-md-6">
        ${doc.tipo.nombre}
    </div>
</div>

<div class="row">
    <div class="col-md-3 show-label">
        Fecha de registro
    </div>

    <div class="col-md-6">
        ${doc.fechaRegistro.format("dd-MM-yyyy")}
    </div>
</div>

<div class="row">
    <div class="col-md-3 show-label">
        Fecha de inicio
    </div>

    <div class="col-md-6">
        ${doc.inicio.format("dd-MM-yyyy")}
    </div>
</div>

<div class="row">
    <div class="col-md-3 show-label">
        Fecha de caducidad
    </div>

    <div class="col-md-6">
        <g:if test="${doc.fin}">
            <g:set var="clase" value="info"/>
            <g:set var="icon" value=""/>
            <g:set var="dias" value="${doc.fin.clearTime() - new Date().clearTime()}"/>
            <g:if test="${doc.fin.clearTime() <= new Date().clearTime()}">
                <g:set var="clase" value="danger"/>
                <g:set var="icon" value="fa-exclamation-triangle"/>
            </g:if>
            <g:elseif test="${doc.fin.clearTime() <= new Date().clearTime() + 30}">
                <g:set var="clase" value="warning"/>
                <g:set var="icon" value="fa-exclamation-circle"/>
            </g:elseif>
            <span class="text-${clase}">
                <strong>
                    ${doc.fin.format("dd-MM-yyyy")}
                    (${dias > 0 ? "En " : "Hace "}${Math.abs(dias)} día${Math.abs(dias) == 1 ? "" : "s"} calendario)
                </strong>
                <g:if test="${icon}">
                    <i class="fa ${icon}"></i>
                </g:if>
            </span>
        </g:if>
        <g:else>
            Sin fecha de caducidad
        </g:else>
    </div>
</div>

<div class="row">
    <div class="col-md-3 show-label">
        Referencia
    </div>

    <div class="col-md-6">
        ${doc.referencia}
    </div>
</div>

<div class="row">
    <div class="col-md-3 show-label">
        Código
    </div>

    <div class="col-md-6">
        ${doc.codigo}
    </div>
</div>

<div class="row">
    <div class="col-md-3 show-label">
        Descripción
    </div>

    <div class="col-md-6">
        ${doc.descripcion}
    </div>
</div>