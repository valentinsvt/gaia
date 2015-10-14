package gaia.reportes.dotacion
import com.itextpdf.text.BaseColor
import com.itextpdf.text.Document
import com.itextpdf.text.Element
import com.itextpdf.text.Font
import com.itextpdf.text.Image
import com.itextpdf.text.Paragraph
import com.itextpdf.text.pdf.PdfContentByte
import com.itextpdf.text.pdf.PdfPCell
import com.itextpdf.text.pdf.PdfPTable
import com.itextpdf.text.pdf.PdfWriter
import com.lowagie.text.pdf.PdfTable
import gaia.Contratos.esicc.Dotacion
import gaia.Contratos.esicc.PeriodoDotacion
import gaia.HeaderFooter
import gaia.documentos.Inspector
import gaia.seguridad.Shield
import gaia.uniformes.PedidoUniformes
import gaia.uniformes.SubDetallePedido

class ActasController extends Shield{

    def actas(){
        def periodos = PeriodoDotacion.list([sort: 'codigo',order: 'desc'])
        def sups = Inspector.list([sort: 'nombre'])
        [periodos:periodos,sups:sups]
    }


    def actasPorSupervisor() {
        def sup = Inspector.get(params.sup)
        def per= PeriodoDotacion.findByCodigo(params.periodo)
        Document document = new Document();
        def meses =['01':"Enero",'02':"Febrero",'03':"Marzo",'04':"Abril",'05':"Mayo",'06':"Junio",'07':"Julio",'08':"Agosto",'09':"Septiembre",'10':"Octubre",'11':"Noviembre",'12':"Diciembre"]
        def nombre = "actas-de-${sup.nombre}.pdf"
        def fecha = new Date()
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        def writer = PdfWriter.getInstance(document, baos);
        def img = grailsApplication.mainContext.getResource('/images/favicons/apple-touch-icon-57x57.png').getFile()
        Font header = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font titulo = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD);
        Font tituloB = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD);
        tituloB.setColor(255,255,255)
        Font contenido = new Font(Font.FontFamily.HELVETICA, 8);
        document.setMargins(40,40,20,50)
//        def hf = new HeaderFooter(img.readBytes(),null, fecha, session.usuario.login,"",null)
//        writer.setPageEvent(hf);
        document.open();
        Image image = Image.getInstance(img.readBytes());
        image.setAbsolutePosition(40f, 765f);
        document.add(image);



        PedidoUniformes.findAllBySupervisorAndPeriodo(sup,per).each {pedido->
            if(pedido.estado=="A"){
                document.add(image)
                Paragraph p = new Paragraph("PETROLEOS Y SERVICIOS", header);
                p.setAlignment(Element.ALIGN_LEFT);
                p.setIndentationLeft(94)
                document.add(p);
                p = new Paragraph("Dirección: Av. 6 de Diciembre \n" +
                        "N30-182 y Alpallana, Quito" , contenido);
                p.setAlignment(Element.ALIGN_LEFT);
                p.setIndentationLeft(94)
                document.add(p);
                p = new Paragraph("Telefono: (593) (2) 381-9680", contenido);
                p.setAlignment(Element.ALIGN_LEFT);
                p.setIndentationLeft(94)
                document.add(p);
                document.add(new Paragraph("\n"));
                p = new Paragraph("ACTA DE ENTREGA RECEPCIÓN",titulo)
                p.setAlignment(Element.ALIGN_CENTER);
                document.add(p)
                document.add(new Paragraph("\n"));
                p = new Paragraph("A los ${fecha.format('dd')} días de ${meses[fecha.format('MM')]} del ${fecha.format('yyyy')}, se realiza la entrega recepción de la" +
                        " dotación de uniforme para la " +
                        "${pedido.estacion.nombre}, según se detalla a continuación:",contenido)
                document.add(p)
                document.add(new Paragraph("\n"));
                document.add(new Paragraph("\n"));
                def tabla = new PdfPTable(3)
                tabla.setWidthPercentage(100.toFloat())
                int[] anchos = [60, 20, 20];
                tabla.setWidths(anchos)
                def cell = new PdfPCell(new Paragraph("Uniforme", tituloB));
                cell.setBackgroundColor(new BaseColor(0,110,183))

                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph("Talla", tituloB));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER)
                cell.setBackgroundColor(new BaseColor(0,110,183))
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph("Cantidad", tituloB));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER)
                cell.setBackgroundColor(new BaseColor(0,110,183))
                tabla.addCell(cell);
                def datos = [:]
                SubDetallePedido.findAllByPedido(pedido).each {s->
                    if(!datos[""+s.uniforme.descripcion]){
                        datos.put(""+s.uniforme.descripcion,[:])
                    }
                    if(!datos[""+s.uniforme.descripcion][s.talla.talla]){
                        datos[""+s.uniforme.descripcion].put(s.talla.talla,s.cantidad)
                    }else{
                        datos[""+s.uniforme.descripcion][s.talla.talla]+=s.cantidad
                    }
                }
                def anterior = null
                datos.eachWithIndex{s,i->
                    s.value.eachWithIndex {j,k->
                        if(k==0) {
                            cell = new PdfPCell(new Paragraph("" + s.key, contenido));
//                        cell.setBorder(0)
                            tabla.addCell(cell);
                        }else{
                            cell = new PdfPCell(new Paragraph("", contenido));
//                        cell.setBorder(0)
                            tabla.addCell(cell);
                        }
                        cell = new PdfPCell(new Paragraph(""+j.key, contenido));
//                    cell.setBorder(0)
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER)
                        tabla.addCell(cell);
                        cell = new PdfPCell(new Paragraph(""+j.value, contenido));
//                    cell.setBorder(0)
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER)
                        tabla.addCell(cell);
                    }
                }
                document.add(tabla)
                document.add(new Paragraph("\n"));
                tabla = new PdfPTable(5)
                tabla.setWidthPercentage(100.toFloat())
                anchos = [32,1, 33,1, 33];
                tabla.setWidths(anchos)
                cell = new PdfPCell(new Paragraph("Entrega por Petróleos y servicios", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_LEFT)
                cell.setColspan(4)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph("Recibe por ${pedido.estacion.nombre}", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_LEFT)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph("\n\n\n\n\n"));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_LEFT)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph(""));
                cell.setBorder(0)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph("\n\n\n\n\n"));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_LEFT)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph(""));
                cell.setBorder(0)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph("\n\n\n\n\n"));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_LEFT)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph("ING. DIEGO PÉREZ REINOSO\nCoordinador administrativo",contenido));
                cell.setBorder(0)
                cell.setBorderWidthTop(1)
                cell.setHorizontalAlignment(Element.ALIGN_LEFT)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph(""));
                cell.setBorder(0)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph("SR. ${sup.nombre}\nSupervisor promotor",contenido));
                cell.setBorder(0)
                cell.setBorderWidthTop(1)
                cell.setHorizontalAlignment(Element.ALIGN_LEFT)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph(""));
                cell.setBorder(0)
                tabla.addCell(cell);
                cell = new PdfPCell(new Paragraph("SR.\nC.C.",contenido));
                cell.setBorder(0)
                cell.setBorderWidthTop(1)
                cell.setHorizontalAlignment(Element.ALIGN_LEFT)
                tabla.addCell(cell);
                document.add(tabla)
                document.add(new Paragraph("\n"));
                document.add(new Paragraph("El representante de la E/S certifica que los objetos recibidos están de acuerdo con su pedido, y que ha sido informado de " +
                        "que tales objetos tienen garantía del proveedor, por lo que, en caso de deterioro dentro de los primeros seis meses, tiene el " +
                        "derecho de pedir su cambio, para lo cual enregará al Supervisor Promotor el objeto defectuoso y Petróleos y Servicios por " +
                        "medio del mismo Supervisor Promotor le entregará el reemplazo",contenido));
                document.add(new Paragraph("\n"));
                document.add(new Paragraph("Por ${pedido.estacion.nombre}",titulo))
                document.add(new Paragraph("Sr.",titulo))
                document.newPage()
            }

        }



        document.close();
        def b = baos.toByteArray()
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }
}
