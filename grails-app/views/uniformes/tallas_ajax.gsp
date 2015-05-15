<%@ page import="gaia.Contratos.esicc.Tallas" %>
<input type="hidden" id="emp" value="${empleado.id}">
<table class="table table-striped table-bordered">
    <thead>
    <tr>
        <th colspan="2">
            Tallas del empleado: ${empleado.nombre} - C.I. ${empleado.cedula} - ${empleado.sexo}
        </th>
    </tr>
    <tr>
        <th style="width: 85%">Uniforme</th>
        <th>Talla</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${tallas}" var="t">
        <tr>
            <td>${t.uniforme}</td>
            <td uniforme="${t.uniforme.codigo}" empleado="${empleado.id}" >
                <g:select class="talla form-control input-sm"  name="tallas"
                          from="${Tallas.findAllByCodigoInList(gaia.Contratos.esicc.UniformeTalla.findAllByUniforme(t.uniforme).codigo)}"
                          optionKey="codigo" optionValue="talla" value="${t.talla?.codigo}"></g:select>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>