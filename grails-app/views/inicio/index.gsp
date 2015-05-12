<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>P&S</title>
    <style type="text/css">
    .inicio img {
        height : 190px;
    }



    .fondo{
        width: 100%;
        height: 381px;
        background-image: url("${g.resource(dir: 'images',file: 'fondo2.jpg')}");
        background-position: -180px -120px ;
        background-repeat: no-repeat;
        position: relative;
        margin-bottom: 0px;
        margin-top: 0px;
    }
    .overlay{
        width: 100%;
        height: 381px;
        background: rgba(0,0,0,0.15);
        position: absolute;
        left: 0px;
        top: 0px;
        z-index: 1;
        margin: 0px;
    }
    .barra{
        width: 100%;
        margin-top: 0px;
        height: 140px;
        /*background: #82A22F;*/
        margin-bottom: 0px;
        background: #006EB7;

    }
    .modulo{
        position: absolute;
        border-radius: 50%;
        height: 120px;
        width: 120px;
        /*background: #006EB7;*/
        background: #243038;
        /*background: #de0b00;*/
        text-align: center;

        line-height: 120px;

        /*color: #fff;*/
        font-size: 60px;
        z-index: 2;
    }

    .titulo{
        background: transparent;
        color: #ffffff;
        height: 40px;
        line-height: 40px;
        width: 120px;
        position: absolute;
        text-align: center;
        font-weight: bold;
        text-decoration: none;

    }
    .titulo:hover{
        text-decoration: none;
        color: #ffffff;
    }
    .texto-modulo{
        color: #ffffff;
    }
    .menu-link{
        color: #fff;
    }
    .menu-link:hover{
        color: #FEDF39;
    }
    </style>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
</head>
<body>
<div class="fondo">
    <div class="overlay"></div>
    <g:set var="display" value="${null}"></g:set>
    <g:if test="${session.sistemas.size()>6}">
        <g:set var="display" value="display:none;"></g:set>
        <g:set var="y" value="${390}"></g:set>
        <g:set var="x" value="${1}"></g:set>
        <g:each in="${session.sistemas}" var="sistema" status="i" >
            <g:if test="${sistema.codigo!='T'}">
                <g:if test="${(i-1)%5==0}">
                    <g:set var="y" value="${y-150}"></g:set>
                    <g:set var="x" value="${1}"></g:set>
                </g:if>
                <div class="modulo menu-item" style="${display}${display?'bottom: -70px;left: 45%':''}"  val-bottom="${y}" val-left="${70+220*(x.toInteger()-1)}" >
                    <g:link class="menu-link" controller="inicio" action="modulos" params="[sistema:sistema.codigo]" title="${sistema.nombre}" id="link_${i}"  >
                        <p><i class=" fa ${sistema.imagen}"></i> </p>
                    %{--<p style=";margin-top: -60px"><span style="font-size: 12px !important">${sistema.nombre}</span></p>--}%
                    </g:link>
                </div>
                <g:set var="x" value="${x+1}"></g:set>
            </g:if>
        </g:each>
        <g:if test="${display}">
            <div class="modulo " style="bottom: -70px;left: 45%;" >
                <a href="#" style="color:#ffffff" class="menu-boton "  >
                    <i class=" texto-modulo fa fa-list"></i>
                </a>
            </div>
            <a href="#" class="menu-boton ">
                <div class="titulo" style="bottom: -120px;left: 45%">
                    Clic para empezar
                </div>
            </a>
        </g:if>
    </g:if>
    <g:else>
        <g:each in="${session.sistemas}" var="sistema" status="i" >
            <g:if test="${sistema.codigo!='T'}">
                <div class="modulo menu-item" style="left:${70+220*(i-1)}px;bottom:-60px  "  >
                    <g:link class="menu-link" controller="inicio" action="modulos" params="[sistema:sistema.codigo]" title="${sistema.descripcion}" id="link_${i}"  >
                        <p><i class=" fa ${sistema.imagen}"></i> </p>
                    %{--<p style=";margin-top: -60px"><span style="font-size: 12px !important">${sistema.nombre}</span></p>--}%
                    </g:link>
                </div>
                <g:link controller="inicio" action="modulos" params="[sistema:sistema.codigo]"
                        title="${sistema.descripcion}" id="link_${i}"
                        style="bottom: -100px;left:${70+220*(i-1)}px "
                        class="menu-item titulo"  val-bottom="10" val-left="${20+150*(i-1)}">
                    <div class=""  >
                        ${sistema.nombre}
                    </div>
                </g:link>
            </g:if>
        </g:each>
    </g:else>

</div>
<div class="barra">

</div>

<script type="text/javascript">
    $(".menu-boton").click(function(){
        var band=false
        $(".menu-item").each(function(){
            if($(this).hasClass("active")){
                band=true;
                $(this).removeClass("active")

                $(this).animate({
                    bottom:-70,
                    left:"45%"
                },1000)


            }else{
                $(this).addClass("active")
                $(this).toggle()
                var b = $(this).attr("val-bottom")
                var l = $(this).attr("val-left")
                $(this).animate({
                    bottom:b,
                    left:l
                },1000)
            }

        })
        if(band){
            $(".titulo").html("Clic para empezar")
            setTimeout(function(){ $(".menu-item").toggle(); }, 1000);

        }else{
            $(".titulo").html("Cerrar")

        }
        return false
    })
</script>
</body>
</html>