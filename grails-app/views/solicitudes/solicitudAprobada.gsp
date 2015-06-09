<%@ page contentType="text/html"%>
<html>
<head>
    <title>Nueva solicitud de dotación</title>

</head>
<body>
<table style="width: 650px;height: 60px;border: none;border-collapse: collapse">
    <tr>
        <td>
            <img src="cid:logo" style="height: 60px;float: left">
        </td>
        <td style="height: 60px">
            <h1 style="color:#006EB7;margin-top: 0px;width: 310px;text-align: center;font-weight: bold;font-size: 22px">
                PETROLEOS Y SERVICIOS<br/>
            </h1>
            Av. 6 de Diciembre N30-182 y Alpallana, Quito (593) (2) 381-9680
        </td>
    </tr>
    <tr>
        <td colspan="2"  style="border-top:1px solid #E03F23;height: 20px; ">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2" style="background: #82A640;color: #ffffff;font-weight: bold;padding-left: 10px;width: 600px">
           Solicitud aprobada
        </td>
    </tr>
    <tr>
        <td colspan="2"  style="height: 20px; ">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2">
            Su solicitud de dotación de uniformes ha sido aprobada. Los detalles se presentan a continuación
        </td>
    </tr>
    <tr>
        <td colspan="2"  style="height: 10px; ">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2" >
            <table style="border: none;border-collapse: collapse;width: 100%">
                <tr>
                    <td style="font-weight: bold">Fecha:</td>
                    <td>${sol.registro?.format("dd-MM-yyyy")}</td>
                    <td style="font-weight: bold">Periodo de dotación:</td>
                    <td>${sol.periodo.descripcion}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">Supervisor:</td>
                    <td> ${sol.supervisor.nombre}</td>
                    <td style="font-weight: bold">Estación:</td>
                    <td>${sol.estacion.nombre}</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2"  style="height: 10px; ">&nbsp;</td>
    </tr>

</table>


</body>
</html>