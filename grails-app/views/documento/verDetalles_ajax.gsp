<%--
  Created by IntelliJ IDEA.
  User: Luz
  Date: 2/9/2015
  Time: 9:25 PM
--%>

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
            ${doc.fin.format("dd-MM-yyyy")}
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