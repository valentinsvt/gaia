<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 07/03/2015
  Time: 7:38
--%>

    <div class="container ui-corner-all" style="width: 200px; margin-left: 125px">
        <b>Consultor:</b>  <g:select name="consultor" from="${consultores}" id="consultorId" optionValue="nombre" optionKey="id" style="width: 200px"  noSelection="['-1': 'Todos']"/>
    </div>
    <div class="" style="width: 150px; margin-left: 140px">
        <b>Desde: </b>  <elm:datepicker name="inicio" id="inicioVal" class="required form-control input-sm" default="none" noSelection="['': '']"/>
        <b>Hasta: </b>     <elm:datepicker name="fin" id="finVal" class="required form-control input-sm" default="none" noSelection="['': '']" />
    </div>