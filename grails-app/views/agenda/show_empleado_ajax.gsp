
<g:if test="${!empleado}">
    <elm:notFound elem="Industria" genero="f"/>
</g:if>
<g:else>
    <div class="modal-contenido">
        <g:if test="${empleado?.nombre}">
            <div class="row">
                <div class="col-sm-2 show-label">
                    Nombre
                </div>
                <div class="col-sm-4">
                    <g:fieldValue bean="${empleado}" field="nombre"/>
                    <g:fieldValue bean="${empleado}" field="apellido"/>
                </div>
                <div class="col-sm-2 show-label">
                    Fecha Nacimiento
                </div>
                <div class="col-sm-4">
                    ${empleado.fechaNacimiento?.format("dd-MM-yyyy")}
                </div>

            </div>
        </g:if>
        <div class="row">
            <div class="col-sm-2 show-label">
                Direccion
            </div>
            <div class="col-sm-10">
                <g:fieldValue bean="${empleado}" field="direccion"/>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2 show-label">
                Sexo
            </div>
            <div class="col-sm-4" >
                ${empleado.sexo==1?"Masculino":"Femenino"}
            </div>
            <div class="col-sm-2 show-label">
                Estado civil
            </div>
            <div class="col-sm-4" >
                <g:fieldValue bean="${empleado}" field="estadoCivil"/>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2 show-label">
                Nacionalidad
            </div>
            <div class="col-sm-4" >
                ${empleado.nacionalidad}
            </div>
            <div class="col-sm-2 show-label">
                IESS
            </div>
            <div class="col-sm-4" >
                ${empleado.afiliacionIess}
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2 show-label">
                EMail
            </div>
            <div class="col-sm-4" >
                <g:fieldValue bean="${empleado}" field="email"/>  <i class="fa fa-info-circle" style="color:#FFA324 "></i>
            </div>
            <div class="col-sm-2 show-label">
                Telefono
            </div>

            <div class="col-sm-4" >
                <g:fieldValue bean="${empleado}" field="telefono"/> <i class="fa fa-info-circle" style="color:#FFA324 "></i>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2 show-label">
                Ingreso
            </div>
            <div class="col-sm-4" >
                ${empleado.ingreso?.format("dd-MM-yyyy")}
            </div>
            <div class="col-sm-2 show-label">
                Salida
            </div>
            <div class="col-sm-4" >
                ${empleado.salida?.format("dd-MM-yyyy")}
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2 show-label">
                Cod. sectorial
            </div>
            <div class="col-sm-4" >
                ${empleado.codigoSectorial}
            </div>
            <div class="col-sm-2 show-label">
                Ciudad Trabajo
            </div>
            <div class="col-sm-4" >
                ${empleado.ciudadTrabajo}
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2 show-label">
                Cargo
            </div>
            <div class="col-sm-4" >
                ${empleado.cargo}
            </div>

        </div>






    </div>
    <script type="text/javascript">
        $(".fa-info-circle").attr("title","Importante")
    </script>
</g:else>