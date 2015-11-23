<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Simulador</title>
    <style>
    .pys{
        background: #fffb03;
        color: #ff111d;
        font-weight: bold;
    }
    .petro{
        background: #2e6cff;
        color: #ffffff;
        font-weight: bold;
    }
    .bg-pys{
        background: rgba(252, 248, 193,0.3);
    }
    .bg-petro{
        background: rgba(63,110, 252,0.1);
    }
    .textfield{
        width: 100%;
        text-align: right;
        margin: 0px;
        padding: 2px;
        border: 0px;

    }
    .numero{
        width: 90px;
    }
    .header{
        text-align: center;
        font-weight: bold;
    }
    .table td{
        padding: 0px !important;
    }
    .bold{
        font-weight: bold;
    }
    .addon{
        width: 90% !important;
    }
    .borde{
        border: 1px solid black !important;
    }
    </style>
</head>
<body>
<div class="row" style="margin-top: -10px">
<div class="col-md-12" id="contenido">
<table class="table table-condensed table-bordered" style="font-size: 10px">
<tr>
    <td style="width: 250px"></td>
    <td colspan="4" class="pys" style="text-align: center">
        PYS
    </td>
    <td colspan="4" class="petro" style="text-align: center">
        PETROCOMERCIAL
    </td>
</tr>
<tr>
    <td ></td>
    <td class="header">EXTRA</td>
    <td class="header">SUPER</td>
    <td class="header">DIESEL</td>
    <td class="header">ECOPAIS</td>
    <td class="header">EXTRA</td>
    <td class="header">SUPER</td>
    <td class="header">DIESEL</td>
    <td class="header">ECOPAIS</td>
</tr>
<tr numero="1">
    <td class=" bold">PRECIO PCO. SIN IVA</td>
    <td style="text-align: right" class="numero">
        <input type="text"  class="textfield bold first" value="1.16890" id="A1">
    </td>
    <td style="text-align: right" class="numero ">
        <input type="text" class="textfield bold" value="1.50000" id="A2">
    </td>
    <td style="text-align: right" class="numero">
        <input type="text" class="textfield bold" value="0.80420" id="A3">
    </td>
    <td style="text-align: right" class="numero ">
        <input type="text" class="textfield bold" value="1.16890" id="A4">
    </td>
    <td style="text-align: right" class="numero">
        <input type="text"  class="textfield bold" value="1.16890" id="A5">
    </td>
    <td style="text-align: right" class="numero ">
        <input type="text" class="textfield bold" value="1.50000" id="A6">
    </td>
    <td style="text-align: right" class="numero">
        <input type="text" class="textfield bold" value="0.80420" id="A7">
    </td>
    <td style="text-align: right" class="numero ">
        <input type="text" class="textfield bold" value="1.16890" id="A8">
    </td>
</tr>
<tr numero="2">
    <td>12% IVA</td>
    <td style="text-align: right" class="numero">
        <input type="text" class="textfield" row="2" id="B1" variables="#A1" formula="#A1*0.12">
    </td>
    <td style="text-align: right" class="numero">
        <input type="text" class="textfield" id="B2" variables="#A2" formula="#A2*0.12">
    </td>
    <td style="text-align: right" class="numero">
        <input type="text" class="textfield" id="B3" variables="#A3" formula="#A3*0.12">
    </td>
    <td style="text-align: right" class="numero">
        <input type="text" class="textfield" id="B4" variables="#A4" formula="#A4*0.12">
    </td>
    <td style="text-align: right" class="numero">
        <input type="text" class="textfield" id="B5" variables="#A5" formula="#A5*0.12">
    </td>
    <td style="text-align: right" class="numero">
        <input type="text" class="textfield" id="B6" variables="#A6" formula="#A6*0.12">
    </td>
    <td style="text-align: right" class="numero">
        <input type="text" class="textfield" id="B7" variables="#A7" formula="#A7*0.12">
    </td>
    <td style="text-align: right" class="numero">
        <input type="text" class="textfield" id="B8" variables="#A8" formula="#A8*0.12">
    </td>
</tr>
<tr numero="3 ">
    <td class=" bold">P.V.P REFERENCIAL INCL. IVA
    </td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield" id="C1" value="1.480170"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield" id="C2" value="2.009000"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield" id="C3" value="1.037000"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield" id="C4" value="1.480170"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield" id="C5" value="1.480170"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield" id="C6" value="2.009000"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield" id="C7" value="1.037000"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield" id="C8" value="1.480170"></td>
</tr>
<tr numero="4 ">
    <td class=" bold">MARGEN DE COMERCIALIZACION A REPARTIR
    </td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield bold"  id="D1" variables="#A1;#B1;#C1" formula="#C1-#B1-#A1"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield bold" id="D2" variables="#A2;#B2;#C2" formula="#C2-#B2-#A2"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield bold" id="D3" variables="#A3;#B3;#C3" formula="#C3-#B3-#A3"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield bold" id="D4" variables="#A4;#B4;#C4" formula="#C4-#B4-#A4"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield bold"  id="D5"  variables="#A5;#B5;#C5" formula="#C5-#B5-#A5"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield bold"  id="D6"  variables="#A6;#B6;#C6" formula="#C6-#B6-#A6"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield bold"  id="D7"  variables="#A7;#B7;#C7" formula="#C7-#B7-#A7"></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield bold"  id="D8" variables="#A8;#B8;#C8" formula="#C8-#B8-#A8"></td>
</tr>
<tr numero="5">
    <td class=" bold">MARGEN
    </td>
    <td style="text-align: right" class="numero">
        <span style="float: left" class="bold">%</span>
        <input type="text" class="textfield bold addon" id="E1" value="1.40">
    </td>
    <td style="text-align: right" class="numero">
        <span style="float: left" class="bold">%</span>
        <input type="text" class="textfield bold addon" id="E2" value="1.40" >
    </td>
    <td style="text-align: right" class="numero">
        <span style="float: left" class="bold">%</span>
        <input type="text" class="textfield bold addon" id="E3" value="1.40" >
    </td>
    <td style="text-align: right" class="numero">
        <span style="float: left" class="bold">%</span>
        <input type="text" class="textfield bold addon" id="E4" value="1.40"  >
    </td>
    <td style="text-align: right" class="numero">
        <span style="float: left" class="bold">%</span>
        <input type="text" class="textfield bold addon" id="E5"  value="2.25">
    </td>
    <td style="text-align: right" class="numero">
        <span style="float: left" class="bold">%</span>
        <input type="text" class="textfield bold addon" id="E6"  value="5.90">
    </td>
    <td style="text-align: right" class="numero">
        <span style="float: left" class="bold">%</span>
        <input type="text" class="textfield bold addon" id="E7" value="1.10">
    </td>
    <td style="text-align: right" class="numero">
        <span style="float: left" class="bold">%</span>
        <input type="text" class="textfield bold addon" id="E8" value="2.25">
    </td>
</tr>
<tr numero="6">
    <td class=" bold">PRECIO EX TERMINAL PCO.
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="F1" class="textfield" value="1.168900"></td>
    <td style="text-align: right" class="numero"><input type="text" id="F2" class="textfield" value="1.500000"></td>
    <td style="text-align: right" class="numero"><input type="text" id="F3" class="textfield" value="0.804200"></td>
    <td style="text-align: right" class="numero"><input type="text" id="F4" class="textfield" value="1.168900"></td>
    <td style="text-align: right" class="numero"><input type="text" id="F5" class="textfield" value="1.168900"></td>
    <td style="text-align: right" class="numero"><input type="text" id="F6" class="textfield" value="1.500000"></td>
    <td style="text-align: right" class="numero"><input type="text" id="F7" class="textfield" value="0.804200"></td>
    <td style="text-align: right" class="numero"><input type="text" id="F8" class="textfield" value="1.168900"></td>
</tr>
<tr numero="7">
    <td>MARGEN DE GANANCIA DE COMERCIALIZADORA
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="G1" class="textfield" variables="#F1;#E1" formula="#F1*#E1/100"></td>
    <td style="text-align: right" class="numero"><input type="text" id="G2" class="textfield" variables="#F2;#E2" formula="#F2*#E2/100"></td>
    <td style="text-align: right" class="numero"><input type="text" id="G3" class="textfield" variables="#F3;#E3" formula="#F3*#E3/100"></td>
    <td style="text-align: right" class="numero"><input type="text" id="G4" class="textfield" variables="#F4;#E4" formula="#F4*#E4/100"></td>
    <td style="text-align: right" class="numero"><input type="text" id="G5" class="textfield" variables="#F5;#E5" formula="#F5*#E5/100"></td>
    <td style="text-align: right" class="numero"><input type="text" id="G6" class="textfield" variables="#F6;#E6" formula="#F6*#E6/100"></td>
    <td style="text-align: right" class="numero"><input type="text" id="G7" class="textfield" variables="#F7;#E7" formula="#F7*#E7/100"></td>
    <td style="text-align: right" class="numero"><input type="text" id="G8" class="textfield" variables="#F8;#E8" formula="#F8*#E8/100"></td>
</tr>
<tr numero="8">
    <td>PRECIO PRODUCTO
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="H1" class="textfield bold"  variables="#G1;#F1" formula="#F1+#G1"></td>
    <td style="text-align: right" class="numero"><input type="text" id="H2" class="textfield bold"  variables="#G2;#F2" formula="#F2+#G2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="H3" class="textfield bold" variables="#G3;#F3" formula="#F3+#G3"></td>
    <td style="text-align: right" class="numero"><input type="text" id="H4" class="textfield bold" variables="#G4;#F4" formula="#F4+#G4"></td>
    <td style="text-align: right" class="numero"><input type="text" id="H5" class="textfield bold" variables="#G5;#F5" formula="#F5+#G5"></td>
    <td style="text-align: right" class="numero"><input type="text" id="H6" class="textfield bold" variables="#G6;#F6" formula="#F6+#G6"></td>
    <td style="text-align: right" class="numero"><input type="text" id="H7" class="textfield bold" variables="#G7;#F7" formula="#F7+#G7"></td>
    <td style="text-align: right" class="numero"><input type="text" id="H8" class="textfield bold" variables="#G8;#F8" formula="#F8+#G8"></td>
</tr>
<tr numero="9">
    <td>12% I.V.A.
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="I1" class="textfield" variables="#H1" formula="#H1*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="I2" class="textfield" variables="#H2" formula="#H2*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="I3" class="textfield" variables="#H3" formula="#H3*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="I4" class="textfield" variables="#H4" formula="#H4*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="I5" class="textfield" variables="#H5" formula="#H5*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="I6" class="textfield" variables="#H6" formula="#H6*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="I7" class="textfield" variables="#H7" formula="#H7*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="I8" class="textfield" variables="#H8" formula="#H8*0.12"></td>
</tr>
<tr numero="10">
    <td class=" bold">SUBTOTAL
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="J1" class="textfield bold" variables="#I1;#H1" formula="#I1+#H1"></td>
    <td style="text-align: right" class="numero"><input type="text" id="J2" class="textfield bold" variables="#I2;#H2" formula="#I2+#H2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="J3" class="textfield bold" variables="#I3;#H3" formula="#I3+#H3"></td>
    <td style="text-align: right" class="numero"><input type="text" id="J4" class="textfield bold" variables="#I4;#H4" formula="#I4+#H4"></td>
    <td style="text-align: right" class="numero"><input type="text" id="J5" class="textfield bold" variables="#I5;#H5" formula="#I5+#H5"></td>
    <td style="text-align: right" class="numero"><input type="text" id="J6" class="textfield bold" variables="#I6;#H6" formula="#I6+#H6"></td>
    <td style="text-align: right" class="numero"><input type="text" id="J7" class="textfield bold" variables="#I7;#H7" formula="#I7+#H7"></td>
    <td style="text-align: right" class="numero"><input type="text" id="J8" class="textfield bold" variables="#I8;#H8" formula="#I8+#H8"></td>
</tr>
<tr numero="11">
    <td>RETENC. 12% I.V.A. PRESUN.
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="K1" class="textfield" variables="#N1;#H1" formula="(#N1-#H1)*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="K2" class="textfield" variables="#N2;#H2" formula="(#N2-#H2)*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="K3" class="textfield" variables="#N3;#H3" formula="(#N3-#H3)*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="K4" class="textfield" variables="#N4;#H4" formula="(#N4-#H4)*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="K5" class="textfield" variables="#N5;#H5" formula="(#N5-#H5)*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="K6" class="textfield" variables="#N6;#H6" formula="(#N6-#H6)*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="K7" class="textfield" variables="#N7;#H7" formula="(#N7-#H7)*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="K8" class="textfield" variables="#N8;#H8" formula="(#N8-#H8)*0.12"></td>
</tr>
<tr numero="12">
    <td>RETENCION 3*1000
    </td>
    <td style="text-align: right" class="numero"><input type="text"  id="L1" class="textfield" variables="#H1" formula="#H1*(3/1000)"></td>
    <td style="text-align: right" class="numero"><input type="text" id="L2" class="textfield" variables="#H2" formula="#H2*(3/1000)"></td>
    <td style="text-align: right" class="numero"><input type="text" id="L3" class="textfield" variables="#H3" formula="#H3*(3/1000)"></td>
    <td style="text-align: right" class="numero"><input type="text" id="L4" class="textfield" variables="#H4" formula="#H4*(3/1000)"></td>
    <td style="text-align: right" class="numero"><input type="text" id="L5" class="textfield" variables="#H5" formula="#H5*(3/1000)"></td>
    <td style="text-align: right" class="numero"><input type="text" id="L6" class="textfield" variables="#H6" formula="#H6*(3/1000)"></td>
    <td style="text-align: right" class="numero"><input type="text" id="L7" class="textfield" variables="#H7" formula="#H7*(3/1000)"></td>
    <td style="text-align: right" class="numero"><input type="text" id="L8" class="textfield" variables="#H8" formula="#H8*(3/1000)"></td>
</tr>
<tr numero="13">
    <td class=" bold">TOTAL
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="M1" class="textfield bold"  variables="#J1;#K1;#L1" formula="#J1+#K1+#L1"></td>
    <td style="text-align: right" class="numero"><input type="text" id="M2" class="textfield bold" variables="#J2;#K2;#L2" formula="#J2+#K2+#L2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="M3" class="textfield bold" variables="#J3;#K3;#L3" formula="#J3+#K3+#L3"></td>
    <td style="text-align: right" class="numero"><input type="text" id="M4" class="textfield bold" variables="#J4;#K4;#L4" formula="#J4+#K4+#L4"></td>
    <td style="text-align: right" class="numero"><input type="text" id="M5" class="textfield bold" variables="#J5;#K5;#L5" formula="#J5+#K5+#L5"></td>
    <td style="text-align: right" class="numero"><input type="text" id="M6" class="textfield bold" variables="#J6;#K6;#L6" formula="#J6+#K6+#L6"></td>
    <td style="text-align: right" class="numero"><input type="text" id="M7" class="textfield bold" variables="#J7;#K7;#L7" formula="#J7+#K7+#L7"></td>
    <td style="text-align: right" class="numero"><input type="text" id="M8" class="textfield bold" variables="#J8;#K8;#L8" formula="#J8+#K8+#L8"></td>
</tr>
<tr numero="14">
    <td>PRECIO VENTA PRODUCTO
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="N1" class="textfield bold" value="1.321580"></td>
    <td style="text-align: right" class="numero"><input type="text" id="N2" class="textfield bold" value="1.793750"></td>
    <td style="text-align: right" class="numero"><input type="text" id="N3" class="textfield bold" value="0.925890"></td>
    <td style="text-align: right" class="numero"><input type="text" id="N4" class="textfield bold" value="1.321580"></td>
    <td style="text-align: right" class="numero"><input type="text" id="N5" class="textfield bold" value="1.321580"></td>
    <td style="text-align: right" class="numero"><input type="text" id="N6" class="textfield bold" value="1.793750"></td>
    <td style="text-align: right" class="numero"><input type="text" id="N7" class="textfield bold" value="0.925890"></td>
    <td style="text-align: right" class="numero"><input type="text" id="N8" class="textfield bold" value="1.321580"></td>
</tr>
<tr numero="15">
    <td>12% IV.A.
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="O1" class="textfield" variables="#N1" formula="#N1*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="O2" class="textfield" variables="#N2" formula="#N2*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="O3" class="textfield" variables="#N3" formula="#N3*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="O4" class="textfield" variables="#N4" formula="#N4*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="O5" class="textfield" variables="#N5" formula="#N5*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="O6" class="textfield" variables="#N6" formula="#N6*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="O7" class="textfield" variables="#N7" formula="#N7*0.12"></td>
    <td style="text-align: right" class="numero"><input type="text" id="O8" class="textfield" variables="#N8" formula="#N8*0.12"></td>
</tr>
<tr numero="16">
    <td class=" bold">PRECIO DE VENTA AL PUBLICO REFEREN.
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="P1" class="textfield bold" variables="#N1;#O1" formula="#N1+#O1"></td>
    <td style="text-align: right" class="numero"><input type="text" id="P2" class="textfield bold" variables="#N2;#O2" formula="#N2+#O2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="P3" class="textfield bold" variables="#N3;#O3" formula="#N3+#O3"></td>
    <td style="text-align: right" class="numero"><input type="text" id="P4" class="textfield bold" variables="#N4;#O4" formula="#N4+#O4"></td>
    <td style="text-align: right" class="numero"><input type="text" id="P5" class="textfield bold" variables="#N5;#O5" formula="#N5+#O5"></td>
    <td style="text-align: right" class="numero"><input type="text" id="P6" class="textfield bold" variables="#N6;#O6" formula="#N6+#O6"></td>
    <td style="text-align: right" class="numero"><input type="text" id="P7" class="textfield bold" variables="#N7;#O7" formula="#N7+#O7"></td>
    <td style="text-align: right" class="numero"><input type="text" id="P8" class="textfield bold" variables="#N8;#O8" formula="#N8+#O8"></td>
</tr>
<tr numero="17">
    <td>UTILIDAD FINANCIERA BRUTA GANANCIA ESTACIÓN X GALON
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="Q1" class="textfield bold" variables="#P1;#M1" formula="#P1-#M1"></td>
    <td style="text-align: right" class="numero"><input type="text" id="Q2" class="textfield bold" variables="#P2;#M2" formula="#P2-#M2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="Q3" class="textfield bold" variables="#P3;#M3" formula="#P3-#M3"></td>
    <td style="text-align: right" class="numero"><input type="text" id="Q4" class="textfield bold" variables="#P4;#M4" formula="#P4-#M4"></td>
    <td style="text-align: right" class="numero"><input type="text" id="Q5" class="textfield bold" variables="#P5;#M5" formula="#P5-#M5"></td>
    <td style="text-align: right" class="numero"><input type="text" id="Q6" class="textfield bold" variables="#P6;#M6" formula="#P6-#M6"></td>
    <td style="text-align: right" class="numero"><input type="text" id="Q7" class="textfield bold" variables="#P7;#M7" formula="#P7-#M7"></td>
    <td style="text-align: right" class="numero"><input type="text" id="Q8" class="textfield bold" variables="#P8;#M8" formula="#P8-#M8"></td>
</tr>
<tr numero="18">
    <td>UTILIDAD FINANCIERA BRUTA (%)
    </td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="R1" class="textfield bold addon" decimales="2" variables="#Q1;#M1" formula="#Q1/#M1*100"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="R2" class="textfield bold addon" decimales="2" variables="#Q2;#M2" formula="#Q2/#M2*100"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="R3" class="textfield bold addon" decimales="2" variables="#Q3;#M3" formula="#Q3/#M3*100"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="R4" class="textfield bold addon" decimales="2" variables="#Q4;#M4" formula="#Q4/#M4*100"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="R5" class="textfield bold addon" decimales="2" variables="#Q5;#M5" formula="#Q5/#M5*100"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="R6" class="textfield bold addon" decimales="2" variables="#Q6;#M6" formula="#Q6/#M6*100"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="R7" class="textfield bold addon" decimales="2" variables="#Q7;#M7" formula="#Q7/#M7*100"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="R8" class="textfield bold addon" decimales="2" variables="#Q8;#M8" formula="#Q8/#M8*100"></td>
</tr>
<tr numero="19">
    <td class=" bold">GALONES VENDIDOS AL MES
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="S1" class="textfield bold" value="60000"></td>
    <td style="text-align: right" class="numero"><input type="text" id="S2" class="textfield bold" value="8000"></td>
    <td style="text-align: right" class="numero"><input type="text" id="S3" class="textfield bold" value="220000"></td>
    <td style="text-align: right" class="numero"><input type="text" id="S4" class="textfield bold" value="60000"></td>
    <td style="text-align: right" class="numero"><input type="text" id="S5" class="textfield bold" value="260000"></td>
    <td style="text-align: right" class="numero"><input type="text" id="S6" class="textfield bold" value="110000"></td>
    <td style="text-align: right" class="numero"><input type="text" id="S7" class="textfield bold" value="108000"></td>
    <td style="text-align: right" class="numero"><input type="text" id="S8" class="textfield bold" value="60000"></td>
</tr>
<tr numero="20">
    <td class=" bold">UTILIDAD BRUTA POR PRODUCTO
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="T1" class="textfield bold" variables="#S1;#Q1" formula="#S1*#Q1" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="T2" class="textfield bold" variables="#S2;#Q2" formula="#S2*#Q2" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="T3" class="textfield bold" variables="#S3;#Q3" formula="#S3*#Q3" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="T4" class="textfield bold" variables="#S4;#Q4" formula="#S4*#Q4" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="T5" class="textfield bold" variables="#S5;#Q5" formula="#S5*#Q5" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="T6" class="textfield bold" variables="#S6;#Q6" formula="#S6*#Q6" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="T7" class="textfield bold" variables="#S7;#Q7" formula="#S7*#Q7" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="T8" class="textfield bold" variables="#S8;#Q8" formula="#S8*#Q8" decimales="2"></td>
</tr>
<tr numero="21">
    <td class=" bold">UTILIDAD BRUTA TOTAL MES (USD)
    </td>
    <td style="text-align: right" class="numero" colspan="4"><input type="text" id="U4" class="textfield" variables="#T1;#T2;#T3;#T4" formula="#T1+#T2+#T3+#T4" decimales="2"></td>

    <td style="text-align: right" class="numero" colspan="4"><input type="text" id="U8" class="textfield" variables="#T5;#T6;#T7;#T8" formula="#T5+#T6+#T7+#T8" decimales="2"></td>
</tr>
<tr numero="22">
    <td>COMERCIALIZADORA
    </td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="V1" class="textfield bold  addon" variables="#D1;#G1" formula="#G1/#D1*100" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="V2" class="textfield bold addon" variables="#D2;#G2" formula="#G2/#D2*100" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="V3" class="textfield bold addon" variables="#D3;#G3" formula="#G3/#D3*100" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="V4" class="textfield bold addon" variables="#D4;#G4" formula="#G4/#D4*100" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="V5" class="textfield bold addon" variables="#D5;#G5" formula="#G5/#D5*100" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="V6" class="textfield bold addon" variables="#D6;#G6" formula="#G6/#D6*100" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="V7" class="textfield bold addon" variables="#D7;#G7" formula="#G7/#D7*100" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="V8" class="textfield bold addon" variables="#D8;#G8" formula="#G8/#D8*100" decimales="2"></td>
</tr>
<tr numero="23">
    <td>ESTACIÒN DE SERVICIO
    </td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="W1" class="textfield bold addon" variables="#V1" formula="100-#V1"  decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="W2" class="textfield bold addon" variables="#V2" formula="100-#V2" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="W3" class="textfield bold addon" variables="#V3" formula="100-#V3" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="W4" class="textfield bold addon" variables="#V4" formula="100-#V4" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="W5" class="textfield bold addon" variables="#V5" formula="100-#V5" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="W6" class="textfield bold addon" variables="#V6" formula="100-#V6" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="W7" class="textfield bold addon" variables="#V7" formula="100-#V7" decimales="2"></td>
    <td style="text-align: right" class="numero"><span style="float: left" class="bold">%</span><input type="text" id="W8" class="textfield bold addon" variables="#V8" formula="100-#V8"></td>
</tr>
<tr numero="24">
    <td class=" bold">RUBRO
    </td>
    <td style="text-align: right" class="numero bold">EXTRA</td>
    <td style="text-align: right" class="numero bold">SUPER</td>
    <td style="text-align: right" class="numero bold">DIESEL</td>
    <td style="text-align: right" class="numero bold">ECOPAIS</td>
    <td style="text-align: right" class="numero bold">EXTRA</td>
    <td style="text-align: right" class="numero bold">SUPER</td>
    <td style="text-align: right" class="numero bold">DIESEL</td>
    <td style="text-align: right" class="numero bold">ECOPAIS</td>
</tr>
<tr numero="25">
    <td class=" bold">UTILIDAD ANUAL DE LA ESTACIÓN
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="X1" class="textfield" variables="#T1" formula="#T1*12" decimales="2" ></td>
    <td style="text-align: right" class="numero"><input type="text" id="X2" class="textfield" variables="#T2" formula="#T2*12" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="X3" class="textfield" variables="#T3" formula="#T3*12" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="X4" class="textfield" variables="#T4" formula="#T4*12" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="X5" class="textfield" variables="#T5" formula="#T5*12" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="X6" class="textfield" variables="#T6" formula="#T6*12" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="X7" class="textfield" variables="#T7" formula="#T7*12" decimales="2"></td>
    <td style="text-align: right" class="numero"><input type="text" id="X8" class="textfield" variables="#T8" formula="#T8*12" decimales="2"></td>
</tr>
<tr numero="25">
    <td class=" bold">TOTAL
    </td>
    <td style="text-align: right" class="numero" colspan="4"><input type="text" id="Y1" class="textfield bold" variables="#X1;#X2;#X3;#X4" formula="#X1+#X2+#X3+#X4" decimales="2" ></td>
    <td style="text-align: right" class="numero" colspan="4"><input type="text" id="Y5" class="textfield bold" variables="#X5;#X6;#X7;#X8" formula="#X5+#X6+#X7+#X8" decimales="2" ></td>
</tr>
<tr numero="26">
    <td class=" bold">BENEFICIOS PYS
    </td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield bold disabled" value="Seguro" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text" class="textfield bold disabled" value="Imagen" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield bold disabled" value="Uniforme" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield bold disabled" value="Total" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value="" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value="" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value=""  disabled></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value="" disabled ></td>
</tr>
<tr numero="27">
    <td class=" bold">
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="BN2"  class="textfield" value="5000"  ></td>
    <td style="text-align: right" class="numero"><input type="text" id="BN3"  class="textfield" value="2500"  ></td>
    <td style="text-align: right" class="numero"><input type="text" id="BN4"   class="textfield" value="700"  ></td>
    <td style="text-align: right" class="numero"><input type="text" id="BN1" class="textfield bold" variables="#BN2;#BN3;#BN4" formula="#BN2+#BN3+#BN4" value="8200" decimales="2"  ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value=""  disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value="" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value="" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value="" disabled ></td>
</tr>
<tr numero="28">
    <td class=" bold" colspan="4">
        UTILIDAD ANUAL FINAL
    </td>
    <td style="text-align: right" class="numero"><input type="text" id="1" class="textfield bold" variables="#BN1;#Y1" formula="#BN1+#Y1" decimales="2"  ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value="" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value="" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value="" disabled ></td>
    <td style="text-align: right" class="numero"><input type="text"  class="textfield disabled" value="" disabled ></td>
</tr>
</table>
</div>
</div>
<div class="row">
    <div class="col-md-1">
        <a href="#" id="pantalla" class="btn btn-info btn-sm">
            <i class="fa fa-desktop"></i>
        </a>
    </div>
</div>
<script>
    $("#pantalla").click(function(){
        document.getElementById("contenido").webkitRequestFullscreen();
        $("#contenedor").css({"overflow":"auto",width:"100%"})
    })
    function colores(){
        $("input").each(function(){
            var id = $(this).attr("id")
            if(id!="" && id!=undefined){
                if(id.indexOf("1")>-1 || id.indexOf("2")>-1 || id.indexOf("3")>-1 || id.indexOf("4")>-1){
                    $(this).addClass("bg-pys")
                }else{
                    $(this).addClass("bg-petro")
                }
            }
            var formula = $(this).attr("formula")
            if(!$(this).hasClass("disabled")){
                if(formula=="" || formula==undefined){
                    $(this).addClass("borde")
                }
            }


        });
    }
    colores()
    $("input").blur(function(){
        var row = $(this).parent().parent().attr("numero")
//        console.log(row)

        $("tr").each(function(){
            var r = $(this).attr("numero")
            if(r!="" && r!=undefined){
                r=r*1
                if(r>=row*1){
                    $(this).find("input").each(function(){
                        var decimales = $(this).attr("decimales")
                        if(isNaN(decimales) || decimales=="")
                            decimales=5
                        else
                            decimales=decimales*1
                        var formula = $(this).attr("formula")
                        if(formula!="" && formula!=undefined){
                            var variables = $(this).attr("variables")
                            variables = variables.split(";")
//                               console.log(variables)
                            $(variables).each(function(){
//                                console.log(this)
                                var valor = $(""+this).val()
//                                   console.log(valor)
                                formula=formula.replace(""+this,valor)
                            })
                            $(this).val(eval(formula).toFixed(decimales))
                        }
                    })
                }
            }
        })

    })
    $(".first").blur()
</script>
</body>
</html>