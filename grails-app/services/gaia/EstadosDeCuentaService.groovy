package gaia

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
import gaia.financiero.EstadoDeCuenta
import groovy.sql.Sql
import org.codehaus.groovy.grails.web.context.ServletContextHolder as SCH
import org.springframework.util.StringUtils

import java.math.RoundingMode
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import java.text.NumberFormat

class EstadosDeCuentaService {
    static transactional = false
    def dataSource_erp
    def grailsApplication
    def meses =["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
    def generaPdf(EstadoDeCuenta estado){
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        //println "g "+ formatNumber(number: 0.52, minFractionDigits: 2)
        def fecha = new  Date().parse("ddMMyyyy","01"+estado.mes)
        Calendar calendar = GregorianCalendar.instance
        calendar.set(fecha.format("yyyy").toInteger(), fecha.format("MM").toInteger()-1, fecha.format("dd").toInteger())
        def ldom = calendar.getActualMaximum(GregorianCalendar.DAY_OF_MONTH)
        fecha= new  Date().parse("ddMMyyyy",ldom+estado.mes)
        def codigo = estado.cliente.codigo
        def r = generaEstadoDeCuenta(codigo,fecha)
        def garantias = garantias(codigo,fecha)
        def facturasPorVencer = facturasPorVencer(codigo, fecha)
        def facturasVencidas = facturasVencidas(codigo, fecha)
        def cheques = chequesDetalle(codigo, fecha)
        def chequesProtestados = chequesProtestados(codigo, fecha)
        def prorroga = prorroga(codigo, fecha)
//        println "datos estado "+r
        if(!r) {
            estado.ultimaEjecucion=new Date()
            estado.mensaje=" Sql retorno NULL"
            estado.save(flush: true)
            return null
        }
        try {
            Document document = new Document();
            def path = SCH.servletContext.getRealPath("/") + "estadosDeCuenta/" + estado.cliente.codigo + "/"
            def pathLocal = "estadosDeCuenta/" + estado.cliente.codigo + "/"
            new File(path).mkdirs()
            def nombre = "EDC-${estado.cliente.codigo}-${estado.mes}-${new Date().format('ddMMyyyyHHmmss')}.pdf"
            def writer = PdfWriter.getInstance(document, new FileOutputStream(path + nombre));
            def img ="./images/logo-login.png";
//            def img ="./web-app/images/logo-login.png";
            //  println "fecha " + fecha + "  codigo  " + codigo + " img  " + img
            writer.setPageEvent(new HeaderFooter(r, img, fecha,estado.usuario));
            Font header = new Font(Font.FontFamily.HELVETICA, 12, Font.UNDERLINE | Font.BOLD);
            Font titulo = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD);
            Font contenido = new Font(Font.FontFamily.HELVETICA, 8);
            document.open();
            String imageUrl = "./images/logo-login.png";
//            String imageUrl = "./web-app/images/logo-login.png";
            Image image = Image.getInstance( new File('./images/logo-login.png').readBytes());
//            Image image = Image.getInstance( new File('./web-app/images/logo-login.png').readBytes());
            image.setAbsolutePosition(40f, 722f);
            document.add(image);
            Paragraph p = new Paragraph("TASAS REFERENCIALES", header);
            p.setAlignment(Element.ALIGN_RIGHT);
            document.add(p);
            p = new Paragraph("" + r["TASA1"], contenido);
            p.setAlignment(Element.ALIGN_RIGHT);
            document.add(p);
            p = new Paragraph("" + r["TASA2"], contenido);
            p.setAlignment(Element.ALIGN_RIGHT);
            document.add(p);
//        p = new Paragraph(""+r["TASA3"],contenido);
//        p.setAlignment(Element.ALIGN_RIGHT);
//        document.add(p);
            p = new Paragraph("" + r["TASA4"], contenido);
            p.setAlignment(Element.ALIGN_RIGHT);
            document.add(p);
            document.add(new Paragraph("\n"));
            document.add(new Paragraph("\n"));

            /*Estado de cuenta*/

            p = new Paragraph("ESTADO DE CUENTA: " + meses[fecha.format("MM").toInteger()-1].toUpperCase()+" DEL "+fecha.format("yyyy"), titulo);
            p.setAlignment(Element.ALIGN_LEFT);
            document.add(p);
            PdfContentByte cb = writer.getDirectContent();
            cb.saveState();
            cb.setColorStroke(BaseColor.BLACK);
            cb.rectangle(38, 590, 520, 100);
            cb.stroke();
            cb.restoreState();
            document.add(new Paragraph("\n"));
            PdfPTable table = new PdfPTable(4);
            table.setWidthPercentage(95.toFloat())
            int[] anchos = [17, 38, 15, 30];
            table.setWidths(anchos)
            PdfPCell cell = new PdfPCell(new Paragraph("CLIENTE", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(estado.cliente.nombre, contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("OFICIAL CTA.", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(r["OFICIAL"], contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("CÓDIGO", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("${r['CODIGO_CLIENTE']}", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("EXT " + r["EXTOFIC"] + " " + r["CIUOFIC"], contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("DIRECCIÓN", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(r["DIRECCION_CLIENTE"], contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("TELÉFONO", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(r["TELEFONO_CLIENTE"], contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("SUPERVISOR", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(r["SUPERVISOR"], contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("PROPIETARIO", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(r["NOMBRE_PROPIETARIO"], contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("CEL. " + r["CELL_SUPERVISOR"], contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("RUC", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(r["RUC_CLIENTE"], contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            document.add(table)
            document.add(new Paragraph("\n"));
            /*Fin estado de cuenta*/
            def fechaMesAntes = r['FECHA_INICIO'].minus(1)

            /*Contingencia*/
            def total = 0
            p = new Paragraph("FONDO DE CONTINGENCIA", titulo);
            p.setAlignment(Element.ALIGN_CENTER);
            document.add(p);
            table = new PdfPTable(4);
            table.setWidthPercentage(95.toFloat())
            anchos = [55, 15, 15, 15];
            table.setWidths(anchos)
            cell = new PdfPCell(new Paragraph("Saldo al ${fechaMesAntes.format('dd/MM/yyyy')}", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("" + formatNumber(number: r["FC_SALDOANTERIOR"], minFractionDigits: 2), titulo));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total += r["FC_SALDOANTERIOR"] //TODO verificar
            cell = new PdfPCell(new Paragraph("(+) APORTES DEL MES", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("" + formatNumber(number: r["FC_APORTEMES"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total += r["FC_APORTEMES"]
            cell = new PdfPCell(new Paragraph("(-) RETIROS", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FC_RETIRO"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total -= r["FC_RETIRO"]
            cell = new PdfPCell(new Paragraph("(+) INTERES GANADOS", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FC_INTERESGANADO"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total += r["FC_INTERESGANADO"]
            cell = new PdfPCell(new Paragraph("(-) 5% RETENCIÓN", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FC_5RETENCION"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total -= r["FC_5RETENCION"]
            cell = new PdfPCell(new Paragraph("(-) 2% RETENCIÓN", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FC_2RETENCION"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total -= r["FC_2RETENCION"]
            cell = new PdfPCell(new Paragraph("(+) PAGOS DIRECTOS", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FC_PAGODIRECTO"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total += r["FC_PAGODIRECTO"]
            cell = new PdfPCell(new Paragraph("(+) NOTAS DE CRÉDITO", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FC_NOTASCREDITO"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total += r["FC_NOTASCREDITO"]
            cell = new PdfPCell(new Paragraph("(-) NOTAS DE DEBITO", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FC_NOTASDEBITO"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total -= r["FC_NOTASDEBITO"]

            cell = new PdfPCell(new Paragraph("Saldo al ${r['FECHA_FIN'].format('dd/MM/yyyy')}", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: total, minFractionDigits: 2), titulo));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);

            document.add(table)
            /*fin contingencia*/

            /*asistencia*/
            total = 0
            document.add(new Paragraph("\n"));
            p = new Paragraph("ASISTENCIA ECONÓMICA", titulo);
            p.setAlignment(Element.ALIGN_CENTER);
            document.add(p);
            table = new PdfPTable(4);
            table.setWidthPercentage(95.toFloat())
            anchos = [55, 15, 15, 15];
            table.setWidths(anchos)
            cell = new PdfPCell(new Paragraph("Saldo al ${fechaMesAntes.format('dd/MM/yyyy')}", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PR_SALDOANTERIOR"], minFractionDigits: 2), titulo));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total += r["PR_SALDOANTERIOR"] /*TODO verificar*/
            cell = new PdfPCell(new Paragraph("(-) DESCUENTO VIA GALONAJE", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PR_DCTOGALONAJE"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total -= r["PR_DCTOGALONAJE"]

            cell = new PdfPCell(new Paragraph("\t CAPITAL", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PR_CAPITAL"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph("\t INTERES", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PR_INTERES"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            total +=  r["PR_INTERES"]
            cell = new PdfPCell(new Paragraph("\t\t SALDO DE CAPITAL", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PR_CAPITAL"] + r["PR_INTERES"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph("(+) ENTREGAS DE CAPITAL", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PR_ENTREGACAPITAL"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total += r["PR_ENTREGACAPITAL"]
            cell = new PdfPCell(new Paragraph("(-) PAGOS DIRECTOS", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PR_PAGODIRECTO"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total -= r["PR_PAGODIRECTO"]

            cell = new PdfPCell(new Paragraph("(+) NOTAS DE CRÉDITO", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PR_NOTASCREDITO"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total += r["PR_NOTASCREDITO"]
            cell = new PdfPCell(new Paragraph("(-) NOTAS DE DEBITO", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", contenido));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PR_NOTASDEBITO"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            total -= r["PR_NOTASDEBITO"]
            cell = new PdfPCell(new Paragraph("Saldo al ${r['FECHA_FIN'].format('dd/MM/yyyy')}", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: total, minFractionDigits: 2), titulo));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);

            document.add(table)
            /*fin asistencia*/

            /*Galones*/
            document.add(new Paragraph("\n"));
            p = new Paragraph("VOLÚMEN EN GALONES", titulo);
            p.setAlignment(Element.ALIGN_CENTER);
            document.add(p);
            table = new PdfPTable(6);
            table.setWidthPercentage(95.toFloat())
            anchos = [40, 12, 12, 12, 12, 12];
            table.setWidths(anchos)


            cell = new PdfPCell(new Paragraph("", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("EXTRA", titulo));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("SUPER", titulo));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("DIESEL 2", titulo));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("DIESEL 1", titulo));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("DIESEL PR", titulo));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph("ASIGNADO EN ${meses[fecha.format('MM').toInteger()-1].toUpperCase()}/${fecha.format('yyyy')}", titulo));
            cell.setBorder(0)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["ASI_EXTRA"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["ASI_SUPER"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["ASI_DIESEL2"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["ASI_DIESEL1"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["ASI_DIESELPR"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);


            cell = new PdfPCell(new Paragraph("DESPACHADO EN ${meses[fecha.format('MM').toInteger()-1].toUpperCase()}/${fecha.format('yyyy')}", titulo));
            cell.setBorder(0)

            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FA_EXTRA"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FA_SUPER"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FA_DIESEL2"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FA_DIESEL1"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FA_DIESELPR"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);


            cell = new PdfPCell(new Paragraph("ACUMULADO AL ${fechaMesAntes.format('dd/MM/yyyy')}", titulo));
            cell.setBorder(0)

            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FA_ACEXTRA"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FA_ACSUPER"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FA_ACDIESEL2"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FA_ACDIESEL1"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["FA_ACDIESELPR"], minFractionDigits: 2), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);


            cell = new PdfPCell(new Paragraph("P.V.P. AL "+r["FECHA_CREA"].format("dd/MM/yyyy"), titulo));
            cell.setBorder(0)

            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PVP_EXTRA"], minFractionDigits: 3), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PVP_SUPER"], minFractionDigits: 3), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PVP_DIESEL2"], minFractionDigits: 3), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PVP_DIESEL1"], minFractionDigits: 3), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph(formatNumber(number: r["PVP_DIESELPR"], minFractionDigits: 3), contenido));
            cell.setBorder(0)
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
            table.addCell(cell);
            document.add(table)
            /*Fin galones*/

            /*Garantias*/
            r=garantias
            if(r.size()>0){
                p = new Paragraph("\n", titulo);
                document.add(p);
                p = new Paragraph("GARANTÍAS BANCARIAS", titulo);
                p.setAlignment(Element.ALIGN_CENTER);
                document.add(p);
                table = new PdfPTable(3);
                table.setWidthPercentage(95.toFloat())
                cell = new PdfPCell(new Paragraph("BANCO", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("FECHA VENCIMIENTO", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("MONTO", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(r["DESCRIPCION_BANCO"], contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("" + r["FECHA_VCTO"].format("dd/MM/yyyy"), contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(formatNumber(number: r["MONTO"], minFractionDigits: 3), contenido));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                document.add(table)
            }

            /*fin Garantias*/
            if(facturasVencidas.size()+facturasPorVencer.size()+cheques.size() + chequesProtestados.size()>0)
                document.newPage();

            /*Facturas vencidas*/

            def data = facturasVencidas
            if (data.size() > 0) {
                p = new Paragraph("FACTURAS VENCIDAS", titulo);
                p.setAlignment(Element.ALIGN_CENTER);
                document.add(p);
                table = new PdfPTable(6);
                table.setWidthPercentage(95.toFloat())
                cell = new PdfPCell(new Paragraph("No. Factura", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Fecha Venta", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Fecha Vcto.", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Producto", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Volumen", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Total Factura", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                def totalVolumen = 0
                total = 0
                data.each { d ->
                    cell = new PdfPCell(new Paragraph(d["NUMERO_FACTURA"], contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["FECHA_VENTA"].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["FECHA_VENCIMIENTO"].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["NOMBRE_PRODUCTO"], contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["VOLUMEN_VENTA"], minFractionDigits: 3), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["PAGO_FACTURA"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    totalVolumen+=d["VOLUMEN_VENTA"]
                    total+=d["PAGO_FACTURA"]

                }

                cell = new PdfPCell(new Paragraph("", contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("", contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("", contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("TOTAL GENERAL", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(formatNumber(number: totalVolumen, minFractionDigits: 3), titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(formatNumber(number: total, minFractionDigits: 2), titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);


                document.add(table)
            }

            /*fin Facturas*/

            /*Facturas por vencer*/

            data = facturasPorVencer
            if (data.size() > 0) {
                def totalVolumen = 0
                total = 0
                document.add(new Paragraph("\n"));
                p = new Paragraph("FACTURAS POR VENCER", titulo);
                p.setAlignment(Element.ALIGN_CENTER);
                document.add(p);
                table = new PdfPTable(6);
                table.setWidthPercentage(95.toFloat())
                cell = new PdfPCell(new Paragraph("No. Factura", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Fecha Venta", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Fecha Vcto.", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Producto", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Volumen", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Total Factura", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                data.each { d ->
                    cell = new PdfPCell(new Paragraph(d["NUMERO_FACTURA"], contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["FECHA_VENTA"].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["FECHA_VENCIMIENTO"].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["NOMBRE_PRODUCTO"], contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["VOLUMEN_VENTA"], minFractionDigits: 3), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["PAGO_FACTURA"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    totalVolumen+=d["VOLUMEN_VENTA"]
                    total+=d["PAGO_FACTURA"]
                }
                cell = new PdfPCell(new Paragraph("", contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("", contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("", contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("TOTAL GENERAL", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(formatNumber(number: totalVolumen, minFractionDigits: 3), titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(formatNumber(number: total, minFractionDigits: 2), titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                document.add(table)
            }

            /*fin Facturas*/



            /*Facturas prorroga*/

            data = prorroga
//            println "prroga "+prorroga
            if (data.size() > 0) {
                document.add(new Paragraph("\n"));
                def totalVolumen = 0
                total = 0
                p = new Paragraph("PRORROGA DE FACTURAS", titulo);
                p.setAlignment(Element.ALIGN_CENTER);
                document.add(p);
                table = new PdfPTable(7);
                table.setWidthPercentage(95.toFloat())
                cell = new PdfPCell(new Paragraph("No. Factura", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Fecha Venta", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Fecha Vcto.", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Nuevo Vcto.", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Producto", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Volumen", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Total Factura", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                data.each { d ->
                    cell = new PdfPCell(new Paragraph(d["NUMERO_FACTURA"], contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["FECHA_VENTA"].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["FECHA_VENCIMIENTO"].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["FECHA_PRORROGA"].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["NOMBRE_PRODUCTO"], contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["VOLUMEN_VENTA"], minFractionDigits: 3), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["PAGO_FACTURA"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    totalVolumen+=d["VOLUMEN_VENTA"]
                    total+=d["PAGO_FACTURA"]
                }
                cell = new PdfPCell(new Paragraph("", contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("", contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("", contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("", contenido));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("TOTAL GENERAL", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(formatNumber(number: totalVolumen, minFractionDigits: 3), titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(formatNumber(number: total, minFractionDigits: 2), titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                document.add(table)
            }

            /*fin prorroga*/


            /*Cheques protestados*/

            data = chequesProtestados
            if (data.size() > 0) {
                document.add(new Paragraph("\n"));
                p = new Paragraph("CHEQUES PROTESTADOS", titulo);
                p.setAlignment(Element.ALIGN_CENTER);
                document.add(p);
                table = new PdfPTable(11);
                table.setWidthPercentage(95.toFloat())
                cell = new PdfPCell(new Paragraph("Transacción", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Fecha Tran.", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Saldo ini.", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Valor", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Pagon Int.", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Int. Acum", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Capital", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Saldo Final", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Comisión", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("# Cheque", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Valor final", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                data.each { d ->
                    cell = new PdfPCell(new Paragraph(d["DESCRIPCION"], contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d[""].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["FECHA_TRANSACCION"].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["VALOR_TRANSACCION"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["ABONO"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["PAGO_INTERES"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["INTERES_ACUMULADO"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["CAPITAL"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["SALDO_FINAL"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["INCREMENTO_CAPITAL"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["CHEQUE_NUMERO"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["TOTALF"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);

                }
                document.add(table)
            }

            /*fin cheques protestados*/

            /*Cheques detalle*/

            data = cheques
            if (data.size() > 0) {
                document.add(new Paragraph("\n"));
                p = new Paragraph("DETALLE DE CHEQUES", titulo);
                p.setAlignment(Element.ALIGN_CENTER);
                document.add(p);
                table = new PdfPTable(6);
                table.setWidthPercentage(95.toFloat())
                cell = new PdfPCell(new Paragraph("No. Factura", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Fecha Venta", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Fecha Vcto.", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Producto", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Volumen", titulo));
                cell.setBorder(0)
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph("Total Factura", titulo));
                cell.setBorder(0)
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                table.addCell(cell);
                data.each { d ->
                    cell = new PdfPCell(new Paragraph(d["NUMERO_FACTURA"], contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["FECHA_VENTA"].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["FECHA_VENCIMIENTO"].format("dd/MM/yyyy"), contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(d["NOMBRE_PRODUCTO"], contenido));
                    cell.setBorder(0)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["VOLUMEN_VENTA"], minFractionDigits: 3), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);
                    cell = new PdfPCell(new Paragraph(formatNumber(number: d["PAGO_FACTURA"], minFractionDigits: 2), contenido));
                    cell.setBorder(0)
                    cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
                    table.addCell(cell);

                }
                document.add(table)
            }

            /*fin cheques protestados*/


            document.close();
            estado.path = pathLocal + nombre
            estado.ultimaEjecucion = new Date()
            estado.save(flush: true)
            return true
        }catch (e){
            estado.ultimaEjecucion=new Date()
            estado.mensaje = e.toString()
            estado.path=null
            estado.save(flush:true)
            println "error en generar pdf ${estado.id} "+e
            return false
        }
//        mailService.sendMail {
//            multipart true
//            to "valentinsvt@hotmail.com","david.herdoiza@petroleosyservicios.com"
//            subject "Estado de cuenta PyS";
//            attachBytes "Estado-de-cuenta-${fecha.format('MMyyyy')}.pdf", "application/x-pdf", pdfData
//            body( view:"estadoDeCuenta")
//            inline 'logo','image/png', new File('./web-app/images/logo-login.png').readBytes()
//        }
//        response.setContentType("application/pdf")
//        response.setHeader("Content-disposition", "attachment; filename=" + "prueba.pdf")
//        response.setContentLength(pdfData.length)
//        response.getOutputStream().write(pdfData)
    }

    def prorroga(codigo,fecha){
//        EXEC up_estadocta_vencidas '05/31/2015', '02010006'
        def sql = "EXEC up_estadocta_prorrogas '${fecha.format('MM/dd/yyyy')}' , '${codigo}'"
        def cn = new Sql(dataSource_erp)
        def data = []
//        println "sql "+sql
        cn.eachRow(sql.toString()){r->
//            println "r "+r
            data.add(r.toRowResult())
        }
        return data
    }


    def facturasVencidas(codigo,fecha){
//        EXEC up_estadocta_vencidas '05/31/2015', '02010006'
        def sql = "EXEC up_estadocta_vencidas '${fecha.format('MM/dd/yyyy')}' , '${codigo}'"
        def cn = new Sql(dataSource_erp)
        def data = []
//        println "sql "+sql
        cn.eachRow(sql.toString()){r->
//            println "r "+r
            data.add(r.toRowResult())
        }
        return data
    }

    def facturasPorVencer(codigo,fecha){
//        EXEC up_estadocta_vencidas '05/31/2015', '02010006'
        def sql = "EXEC up_estadocta_novencidas '${fecha.format('MM/dd/yyyy')}' , '${codigo}'"
        def cn = new Sql(dataSource_erp)
        def data = []
//        println "sql "+sql
        cn.eachRow(sql.toString()){r->
//            println "r "+r
            data.add(r.toRowResult())
        }
        return data
    }
    def chequesProtestados(codigo,fecha){
//        EXEC up_rpt_cheques_devpro2 '02010006'
        def sql = "EXEC up_rpt_cheques_devpro2 '${codigo}'"
        def cn = new Sql(dataSource_erp)
        def data = []
//        println "sql "+sql
        cn.eachRow(sql.toString()){r->
           // println "r "+r
            data.add(r.toRowResult())
        }
        return data
    }

    def chequesDetalle(codigo,fecha){
//        EXEC up_rpt_cheques_devpro2 '02010006'
        def sql = "EXEC up_rpt_cheques_devpro3 '${codigo}'"
        def cn = new Sql(dataSource_erp)
        def data = []
//        println "sql "+sql
        cn.eachRow(sql.toString()){r->
            //println "r !detalle "+r
            data.add(r.toRowResult())
        }
        return data
    }

    def garantias(codigo,fecha){
        def row = []
        def sql = "SELECT ESTADOCTA.CODIGO_CLIENTE,   \n" +
                "         ESTADOCTA.MES,   \n" +
                "\t\t\tESTADOCTA.FECHA_INICIO,\n" +
                "\t\t\tESTADOCTA.FECHA_FIN,\n" +
                "         ESTADOCTA.NOMBRE_PROPIETARIO,   \n" +
                "         ESTADOCTA.DIRECCION_CLIENTE,   \n" +
                "         ESTADOCTA.RUC_CLIENTE,   \n" +
                "         ESTADOCTA.TELEFONO_CLIENTE,   \n" +
                "         ESTADOCTA.CLIENTE_FACTURA,   \n" +
                "         ESTADOCTA.SUPERVISOR,   \n" +
                "         ESTADOCTA.CELL_SUPERVISOR,   \n" +
                "         ESTADOCTA.FC_TRANSACC,   \n" +
                "         ESTADOCTA.FC_SALDOANTERIOR,   \n" +
                "         ESTADOCTA.FC_APORTEMES,   \n" +
                "         ESTADOCTA.FC_RETIRO,   \n" +
                "         ESTADOCTA.FC_INTERESGANADO,   \n" +
                "         ESTADOCTA.FC_5RETENCION,   \n" +
                "         ESTADOCTA.FC_2RETENCION,\n"+
                "         ESTADOCTA.FC_PAGODIRECTO,\n"+
                "         ESTADOCTA.FC_NOTASCREDITO,   \n" +
                "         ESTADOCTA.FC_NOTASDEBITO,   \n" +
                "         ESTADOCTA.PR_TRANSACC,   \n" +
                "         ESTADOCTA.PR_SALDOANTERIOR,   \n" +
                "         ESTADOCTA.PR_DCTOGALONAJE,   \n" +
                "         ESTADOCTA.PR_CAPITAL,   \n" +
                "         ESTADOCTA.PR_INTERES,   \n" +
                "         ESTADOCTA.PR_ENTREGACAPITAL,   \n" +
                "         ESTADOCTA.PR_PAGODIRECTO,   \n" +
                "         ESTADOCTA.PR_NOTASCREDITO,   \n" +
                "         ESTADOCTA.PR_NOTASDEBITO,   \n" +
                "         ESTADOCTA.FA_EXTRA,   \n" +
                "         ESTADOCTA.FA_DIESEL2,   \n" +
                "         ESTADOCTA.FA_SUPER,   \n" +
                "         ESTADOCTA.FA_DIESEL1,   \n" +
                "         ESTADOCTA.FA_DIESELPR,   \n" +
                "         CLIENTE.NOMBRE_CLIENTE,\n" +
                "\t\t\tTASA1 = (SELECT TASA1 FROM OFICIALCTA WHERE ESTADO_OFICIAL = 'A'),\n" +
                "\t\t\tTASA2 = (SELECT TASA2 FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A'),\n" +
                "\t\t\tTASA3 = (SELECT TASA3 FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A'),\n" +
                "\t\t\tTASA4 = (SELECT TASA4 FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A'),\n"+
                "\t\t\tOFICIAL = (SELECT NOMBRE_OFICIAL FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A'),\n" +
                "\t\t\tCIUOFIC = (SELECT CIUDAD_OFICIAL FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A') ,\n" +
                "\t\t   EXTOFIC = (SELECT EXTENSION_OFICIAL FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A'),\t\n" +
                "\t\t\tMENSAJE = (SELECT MENSAJE FROM OFICIALCTA WHERE ESTADO_OFICIAL = 'A'),\t\n" +
                "\t\t\tGARANTIACTA.DESCRIPCION_BANCO,\n" +
                "\t\t   GARANTIACTA.MONTO,\n" +
                "\t\t\tGARANTIACTA.FECHA_VCTO\n" +
                "    FROM ESTADOCTA,   \n" +
                "         CLIENTE,\n" +
                "\t\t\tGARANTIACTA  \n" +
                "   WHERE ( CLIENTE.CODIGO_CLIENTE = ESTADOCTA.CODIGO_CLIENTE ) and  \n" +
                "\t\t\t( GARANTIACTA.CODIGO_CLIENTE = ESTADOCTA.CODIGO_CLIENTE ) and\n" +
                "\t\t\t( GARANTIACTA.MES = ESTADOCTA.MES ) and\n" +
                "         ( ESTADOCTA.CODIGO_CLIENTE = '${codigo}' ) and\n" +
                "         ( ESTADOCTA.MES = ${fecha.format('yyyyMM')} )"
        def cn = new Sql(dataSource_erp)
//        println "sql "+sql
        cn.eachRow(sql.toString()){r->
            row = r.toRowResult()
        }
        return row
    }

    def generaEstadoDeCuenta(codigo,fecha){
        def row = []
        def sql = "SELECT ESTADOCTA.CODIGO_CLIENTE,   \n" +
                "         ESTADOCTA.MES,   \n" +
                "\t\t\tESTADOCTA.FECHA_INICIO,\n" +
                "\t\t\tESTADOCTA.FECHA_FIN,\n" +
                "         ESTADOCTA.NOMBRE_PROPIETARIO,   \n" +
                "         ESTADOCTA.DIRECCION_CLIENTE,   \n" +
                "         ESTADOCTA.RUC_CLIENTE,   \n" +
                "         ESTADOCTA.TELEFONO_CLIENTE,   \n" +
                "         ESTADOCTA.CLIENTE_FACTURA,   \n" +
                "         ESTADOCTA.SUPERVISOR,   \n" +
                "         ESTADOCTA.CELL_SUPERVISOR,   \n" +
                "         ESTADOCTA.FC_TRANSACC,   \n" +
                "         ESTADOCTA.FC_SALDOANTERIOR,   \n" +
                "         ESTADOCTA.FC_APORTEMES,   \n" +
                "         ESTADOCTA.FC_RETIRO,   \n" +
                "         ESTADOCTA.FC_INTERESGANADO,   \n" +
                "         ESTADOCTA.FC_5RETENCION,   \n" +
                "         ESTADOCTA.FC_2RETENCION,\n"+
                "         ESTADOCTA.FC_PAGODIRECTO,\n"+
                "         ESTADOCTA.FC_NOTASCREDITO,   \n" +
                "         ESTADOCTA.FC_NOTASDEBITO,   \n" +
                "         ESTADOCTA.PR_TRANSACC,   \n" +
                "         ESTADOCTA.PR_SALDOANTERIOR,   \n" +
                "         ESTADOCTA.PR_DCTOGALONAJE,   \n" +
                "         ESTADOCTA.PR_CAPITAL,   \n" +
                "         ESTADOCTA.PR_INTERES,   \n" +
                "         ESTADOCTA.PR_ENTREGACAPITAL,   \n" +
                "         ESTADOCTA.PR_PAGODIRECTO,   \n" +
                "         ESTADOCTA.PR_NOTASCREDITO,   \n" +
                "         ESTADOCTA.PR_NOTASDEBITO,   \n" +
                "         ESTADOCTA.FA_EXTRA,   \n" +
                "         ESTADOCTA.FA_DIESEL2,   \n" +
                "         ESTADOCTA.FA_SUPER,   \n" +
                "         ESTADOCTA.FA_DIESEL1,   \n" +
                "         ESTADOCTA.FA_DIESELPR,   \n" +
                "         CLIENTE.NOMBRE_CLIENTE,\n" +
                "\t\t\tTASA1 = (SELECT TASA1 FROM OFICIALCTA WHERE ESTADO_OFICIAL = 'A'),\n" +
                "\t\t\tTASA2 = (SELECT TASA2 FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A'),\n" +
                "\t\t\tTASA3 = (SELECT TASA3 FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A'),\n" +
                "\t\t\tTASA4 = (SELECT TASA4 FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A'),\n"+
                "\t\t\tOFICIAL = (SELECT NOMBRE_OFICIAL FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A'),\n" +
                "\t\t\tCIUOFIC = (SELECT CIUDAD_OFICIAL FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A') ,\n" +
                "\t\t   EXTOFIC = (SELECT EXTENSION_OFICIAL FROM OFICIALCTA WHERE ESTADO_OFICIAL =  'A'),\t\n" +
                "\t\t\tMENSAJE = (SELECT MENSAJE FROM OFICIALCTA WHERE ESTADO_OFICIAL = 'A')\t\n" +
                "    FROM ESTADOCTA,   \n" +
                "         CLIENTE\n" +
                "   WHERE ( CLIENTE.CODIGO_CLIENTE = ESTADOCTA.CODIGO_CLIENTE ) and  \n" +
                "         ( ESTADOCTA.CODIGO_CLIENTE = '${codigo}' ) and\n" +
                "         ( ESTADOCTA.MES = ${fecha.format('yyyyMM')} )"
        def cn = new Sql(dataSource_erp)
//        println "sql "+sql
        cn.eachRow(sql.toString()){r->
            row = r.toRowResult()
        }
        //println "row 1 " +row
        def sql2= "SELECT ESTADOCTA.CODIGO_CLIENTE,   \n" +
                "         ESTADOCTA.MES,   \n" +
                "\t\t\tESTADOCTA.FECHA_INICIO,\n" +
                "\t\t\tESTADOCTA.FECHA_FIN,\n" +
                "         ESTADOCTA.NOMBRE_PROPIETARIO,   \n" +
                "         ESTADOCTA.DIRECCION_CLIENTE,   \n" +
                "         ESTADOCTA.RUC_CLIENTE,   \n" +
                "         ESTADOCTA.TELEFONO_CLIENTE,   \n" +
                "         ESTADOCTA.CLIENTE_FACTURA,   \n" +
                "         ESTADOCTA.SUPERVISOR,   \n" +
                "         ESTADOCTA.CELL_SUPERVISOR,   \n" +
                "         ESTADOCTA.FA_EXTRA,   \n" +
                "         ESTADOCTA.FA_DIESEL2,   \n" +
                "         ESTADOCTA.FA_SUPER,   \n" +
                "         ESTADOCTA.FA_DIESEL1,   \n" +
                "         ESTADOCTA.FA_DIESELPR,   \n" +
                "         CLIENTE.NOMBRE_CLIENTE,\n" +
                "         ESTADOCTA.FA_ACEXTRA,   \n" +
                "         ESTADOCTA.FA_ACDIESEL2,   \n" +
                "         ESTADOCTA.FA_ACSUPER,   \n" +
                "         ESTADOCTA.FA_ACDIESEL1,   \n" +
                "         ESTADOCTA.FA_ACDIESELPR,\n" +
                "\t\t\tESTADOCTA.PVP_EXTRA,\n" +
                "\t\t\tESTADOCTA.PVP_DIESEL2,\n" +
                "\t\t\tESTADOCTA.PVP_SUPER,\n" +
                "\t\t\tESTADOCTA.PVP_DIESEL1,\n" +
                "\t\t\tESTADOCTA.PVP_DIESELPR,\n" +
                "\t\t\tESTADOCTA.ASI_EXTRA,\n" +
                "\t\t\tESTADOCTA.ASI_DIESEL2,\n" +
                "\t\t\tESTADOCTA.ASI_SUPER,\n" +
                "\t\t\tESTADOCTA.ASI_DIESEL1,\n" +
                "\t\t\tESTADOCTA.ASI_DIESELPR,\n" +
                "\t\t\tESTADOCTA.FECHA_CREA\n" +
                "    FROM ESTADOCTA,   \n" +
                "         CLIENTE \n" +
                "   WHERE ( CLIENTE.CODIGO_CLIENTE = ESTADOCTA.CODIGO_CLIENTE ) and  \n" +
                "         ( ESTADOCTA.CODIGO_CLIENTE = '${codigo}' ) and\n" +
                "         ( ESTADOCTA.MES = ${fecha.format('yyyyMM')} )"

        cn.eachRow(sql2.toString()){r->
            row += r.toRowResult()
        }
        //println "row 2 "+row
        return row
        cn.close()
    }

    Closure formatNumber = { attrs ->
        if (!attrs.containsKey('number')) {
            return ""+0.00
        }

        def number = attrs.number
        if (number == null) return

        def formatName = attrs.formatName
        def format = attrs.format
        def type = attrs.type
        def locale = resolveLocale(attrs.locale)

        if (type == null) {
            if (!format && formatName) {
                //  format = messageHelper(formatName,null,null,locale)
                if (!format) {

                    format="###,###.##"
                }
            }
            else if (!format) {
                format="###,###.##"
            }
        }

        DecimalFormatSymbols dcfs = locale ? new DecimalFormatSymbols(locale) : new DecimalFormatSymbols()

        DecimalFormat decimalFormat
        if (!type) {
            decimalFormat = new DecimalFormat(format, dcfs)
        }
        else {
            if (type == 'currency') {
                decimalFormat = NumberFormat.getCurrencyInstance(locale)
            }
            else if (type == 'number') {
                decimalFormat = NumberFormat.getNumberInstance(locale)
            }
            else if (type == 'percent') {
                decimalFormat = NumberFormat.getPercentInstance(locale)
            }
            else {
                decimalFormat = NumberFormat.getNumberInstance(locale)
            }
        }

        if (attrs.nan) {
            dcfs.naN = attrs.nan
            decimalFormat.decimalFormatSymbols = dcfs
        }

        // ensure formatting accuracy
        decimalFormat.setParseBigDecimal(true)

        if (attrs.currencyCode != null) {
            Currency currency = Currency.getInstance(attrs.currencyCode as String)
            decimalFormat.setCurrency(currency)
        }
        if (attrs.currencySymbol != null) {
            dcfs = decimalFormat.getDecimalFormatSymbols()
            dcfs.setCurrencySymbol(attrs.currencySymbol as String)
            decimalFormat.setDecimalFormatSymbols(dcfs)
        }
        if (attrs.groupingUsed != null) {
            if (attrs.groupingUsed instanceof Boolean) {
                decimalFormat.setGroupingUsed(attrs.groupingUsed)
            }
            else {
                // accept true, y, 1, yes
                decimalFormat.setGroupingUsed(attrs.groupingUsed.toString().toBoolean() ||
                        attrs.groupingUsed.toString() == 'yes')
            }
        }
        if (attrs.maxIntegerDigits != null) {
            decimalFormat.setMaximumIntegerDigits(attrs.maxIntegerDigits as Integer)
        }
        if (attrs.minIntegerDigits != null) {
            decimalFormat.setMinimumIntegerDigits(attrs.minIntegerDigits as Integer)
        }
        if (attrs.maxFractionDigits != null) {
            decimalFormat.setMaximumFractionDigits(attrs.maxFractionDigits as Integer)
        }
        if (attrs.minFractionDigits != null) {
            decimalFormat.setMinimumFractionDigits(attrs.minFractionDigits as Integer)
        }
        if (attrs.roundingMode != null) {
            def roundingMode = attrs.roundingMode
            if (!(roundingMode instanceof RoundingMode)) {
                roundingMode = RoundingMode.valueOf(roundingMode)
            }
            decimalFormat.setRoundingMode(roundingMode)
        }

        if (!(number instanceof Number)) {
            number = decimalFormat.parse(number as String)
        }

        def formatted
        try {
            formatted = decimalFormat.format(number)
        }
        catch(ArithmeticException e) {
            // if roundingMode is UNNECESSARY and ArithemeticException raises, just return original number formatted with default number formatting
            formatted = NumberFormat.getNumberInstance(locale).format(number)
        }
        return formatted
    }
    static Locale resolveLocale(Object localeAttr) {
        Locale locale
        if (localeAttr instanceof Locale) {
            locale = (Locale)localeAttr
        } else if (localeAttr != null) {
            locale = StringUtils.parseLocaleString(localeAttr.toString())
        }
        if (locale == null) {
            locale = locale = StringUtils.parseLocaleString("es")
            if (locale == null) {
                locale = Locale.getDefault()
            }
        }
        return locale
    }
    def getSupervisores(){
        def sql = "select distinct c.CODIGO_SUPERVISOR,s.NOMBRE_SUPERVISOR\n" +
                "from CLIENTE c,SUPERVISORES s \n" +
                "where   c.CODIGO_SUPERVISOR=s.CODIGO_SUPERVISOR \n" +
                "and  TIPO_CLIENTE=1 \n" +
                "and ESTADO_CLIENTE = 'A' \n" +
                "order by 2"
        def cn = new Sql(dataSource_erp)
        def sups = [:]
        cn.eachRow(sql.toString()){r->
            sups.put(r["CODIGO_SUPERVISOR"],r["NOMBRE_SUPERVISOR"])
        }
        return sups
    }

}
