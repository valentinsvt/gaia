package gaia.reportes.dotacion

import gaia.Contratos.DashBoardContratos
import gaia.Contratos.esicc.Pedido
import gaia.Contratos.esicc.PeriodoDotacion
import gaia.Contratos.esicc.Tallas
import gaia.Contratos.esicc.Uniforme
import gaia.Contratos.esicc.UniformeTalla
import gaia.documentos.Inspector
import gaia.uniformes.PedidoUniformes
import gaia.uniformes.SubDetallePedido

class ReportesDotacionController {

    def reporteDotaciones(){

    }

    def dotaciones(){
        def periodo = PeriodoDotacion.findByCodigo(params.periodo)
        def dash = DashBoardContratos.list([sort: "id"])
        def dotaciones = []
        def sinDotacion = [:]
        dash.each {d->
            def dotacion = Pedido.findByEstacionAndPeriodo(d.estacion,periodo)
            if(dotacion){
                if(dotacion.estado=="A")
                    dotaciones.add(dotacion)
                else
                    sinDotacion.put(d,dotacion)
            }else{
                sinDotacion.put(d,"N.A.")
            }


        }
       return  [dotaciones:dotaciones,periodo:periodo,sinDotacion:sinDotacion]
    }
    def dotacionesPdf(){
        def periodo = PeriodoDotacion.findByCodigo(params.periodo)
        def dash = DashBoardContratos.list([sort: "id"])
        def dotaciones = []
        def sinDotacion = [:]
        dash.each {d->
            def dotacion = Pedido.findByEstacionAndPeriodo(d.estacion,periodo)
            if(dotacion){
                if(dotacion.estado=="A")
                    dotaciones.add(dotacion)
                else
                    sinDotacion.put(d,dotacion)
            }else{
                sinDotacion.put(d,"N.A.")
            }


        }
        return  [dotaciones:dotaciones,periodo:periodo,sinDotacion:sinDotacion]
    }

    def imprimeSolicitud(){
        def sol = PedidoUniformes.get(params.id)
        def subdetalle = SubDetallePedido.findAllByPedido(sol)

        def fecha = new Date()
        [sol:sol,subdetalle:subdetalle,fecha:fecha]
    }

    def imprimeActa(){
        def sol = PedidoUniformes.get(params.id)
        def subdetalle = SubDetallePedido.findAllByPedido(sol)
        subdetalle=subdetalle.sort{it.uniforme.descripcion}
        def fecha = new Date()
        [sol:sol,subdetalle:subdetalle,fecha:fecha]
    }

    def dotacionesPorItemPdf(){

        def periodo = PeriodoDotacion.findByCodigo(params.periodo)
        def supervisores = []
        if(params.supervisor=="-1")
            supervisores=Inspector.list([sort: "nombre"])
        else
            supervisores.add(Inspector.findByCodigo(params.supervisor))
        def datos = [:]
        def uniformes = Uniforme.list()
        supervisores.each {
            datos.put(it.nombre,[:])
            uniformes.each {u->
                datos[it.nombre].put(u.descripcion,0)
            }
        }
        datos.put("TOTAL GENERAL",[:])
        uniformes.each {u->
            datos["TOTAL GENERAL"].put(u.descripcion,0)
        }
        def dotaciones = PedidoUniformes.findAllBySupervisorInListAndPeriodo(supervisores,periodo)
        dotaciones.each {d->
            if(d.estado=="A"){
                SubDetallePedido.findAllByPedido(d).each {sd->
                    datos[d.supervisor.nombre][sd.uniforme.descripcion]+=sd.cantidad
                    datos["TOTAL GENERAL"][sd.uniforme.descripcion]+=sd.cantidad
                }

            }
        }
        [datos:datos,uniformes:uniformes]
    }

    def dotacionesPorSupervisorPdf(){
        def periodo = PeriodoDotacion.findByCodigo(params.periodo)
        def supervisor =Inspector.findByCodigo(params.supervisor)

        def pedidos = PedidoUniformes.findAll("from PedidoUniformes where supervisor=${supervisor.id} and periodo=${periodo.codigo} and estado='A'")
        pedidos=pedidos.sort{it.estacion.codigo}
        def datos = [:]
        pedidos.each {p->
            def sd = SubDetallePedido.findAllByPedido(p)
            sd=sd.sort{it.uniforme.descripcion}
            datos.put(p.estacion.nombre,[:])
            def actual = datos[p.estacion.nombre]
            sd.each {s->
                if(!actual[s.uniforme.descripcion]){
                    def tmp = [:]
                    tmp.put([s.talla.talla,s.cantidad])
                    actual.put(s.uniforme.descripcion,tmp)
                }else{
                    if(!actual[s.uniforme.descripcion][s.talla.talla]){
                        def tmp = [:]
                        tmp.put(s.talla.talla,s.cantidad)
                        actual[s.uniforme.descripcion].put(s.talla.talla,s.cantidad)
                    }else{
                        actual[s.uniforme.descripcion][s.talla.talla]+=s.cantidad
                    }
                }
            }
        }
        [supervisor:supervisor,datos: datos]
    }

    def dotacionesPorUniformePdf(){
        def periodo = PeriodoDotacion.findByCodigo(params.periodo)
        def uniforme = Uniforme.findByCodigo(params.uniforme)
        def pedidos = PedidoUniformes.findAllByPeriodoAndEstado(periodo,"A")
        def tallas =  Tallas.findAllByCodigoInList(UniformeTalla.findAllByUniforme(uniforme).codigo)
        def datos = [:]
        def supervisores = Inspector.list([sort: "nombre"])
        def total = 0
        supervisores.each {
            datos.put(it.nombre,[:])
            tallas.each {t->
                datos[it.nombre].put(t.talla,0)
            }
        }
        datos.put("TOTAL GENERAL",[:])
        tallas.each {u->
            datos["TOTAL GENERAL"].put(u.talla,0)
        }

        SubDetallePedido.findAllByPedidoInListAndUniforme(pedidos,uniforme).each {sd->
            datos[sd.pedido.supervisor.nombre][sd.talla.talla]+=sd.cantidad
            datos["TOTAL GENERAL"][sd.talla.talla]+=sd.cantidad
            total+=sd.cantidad
        }
        [datos:datos,tallas:tallas,total:total,uniforme:uniforme]
    }


}
