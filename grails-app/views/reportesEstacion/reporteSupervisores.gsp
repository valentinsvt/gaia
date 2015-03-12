<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 07/03/2015
  Time: 1:17
--%>

<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 16/02/2015
  Time: 17:07
--%>


<html>
    <head>

        <title>Reporte de Supervisores y Consultores por estación</title>

        <rep:estilos orientacion="p" pagTitle="Reporte de Supervisores y Consultores por estación"/>
        <style type="text/css">
        .titulo, .proyecto, .componente {
            width : 16cm;
        }

        .titulo {
            height        : .5cm;
            font-size     : 16pt;
            font-weight   : bold;
            text-align    : center;
            margin-bottom : .5cm;
        }

        .row {
            width      : 100%;
            height     : 14px;
            margin-top : 10px;
            font-size  : 12px;
        }

        .label {
            width       : 150px;
            font-weight : bold;
        }

        /*td {*/
        /*padding : 3px;*/
        /*border  : 1px solid #fff*/
        /*}*/

        table {
            font-size       : 12px;
            border-collapse : collapse;
        }

        th {
            background-color : #3A5DAA;
            color            : #ffffff;
            font-weight      : bold;
            font-size        : 12px;
            border           : 1px solid #fff;
            padding          : 3px;
        }

        .table {
            font-size  : 10pt;
            margin-top : 10px;
        }

        .table td {
            font-size : 10pt;
        }
        </style>
    </head>

    <body>

        <rep:headerFooter title="Reporte de Supervisores y Consultores por estación"/>


        <table border="1" class="table table-condensed table-bordered table-striped table-hover ">
            <thead>
                <tr>
                    <th style="width: 100px;">Estación</th>
                    <th style="width: 130px;">Consultor</th>
                    <th style="width: 130px;">Supervisor</th>
                </tr>
            </thead>
            <tbody id="tb">

                <g:each in="${estaciones}" var="estacion">
                    <tr>
                        <td>
                            <util:clean str="${estacion?.nombre}"/>
                        </td>
                        <td>
                            <g:set var="consultores" value="${gaia.documentos.ConsultorEstacion.findAllByEstacion(estacion)}"/>
                            <g:if test="${consultores.size() > 0}">
                                <ul>
                                    <g:each in="${consultores}" var="consultor">

                                        <li>
                                            <util:clean str="${consultor?.consultor?.nombre}"/>
                                            <ul>
                                                <li>
                                                    <b>RUC:</b>                                 <elm:textoBusqueda busca="${params.search}">
                                                    <g:fieldValue bean="${consultor.consultor}" field="ruc"/>
                                                </elm:textoBusqueda>
                                                </li>
                                                <li>
                                                    <b>TELF:</b>                                 <elm:textoBusqueda busca="${params.search}">
                                                    <g:fieldValue bean="${consultor.consultor}" field="telefono"/>
                                                </elm:textoBusqueda>
                                                </li>
                                            </ul>
                                        </li>
                                    </g:each>
                                </ul>
                            </g:if>
                            <g:else>
                                <li style="text-align: center; ">
                                    No tiene consultor
                                </li>
                            </g:else>
                        </td>
                        <td>
                            <g:set var="supervisores" value="${gaia.documentos.InspectorEstacion.findAllByEstacion(estacion)}"/>
                            <g:if test="${supervisores.size() > 0}">
                                <ul>
                                    <g:each in="${supervisores}" var="supervisor">
                                        <li>
                                            %{--${supervisor?.inspector?.nombre}--}%
                                            <util:clean str="${supervisor?.inspector?.nombre}"/>
                                            ${supervisor?.inspector?.telefono}
                                            ${supervisor?.inspector?.mail}

                                        </li>

                                    </g:each>
                                </ul>
                            </g:if>
                            <g:else>
                                <li style="text-align: center">
                                    Sin Supervisor
                                </li>

                            </g:else>
                        </td>
                    </tr>
                </g:each>

            </tbody>
        </table>

    </body>
</html>