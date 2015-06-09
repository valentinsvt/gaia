package gaia

import com.itextpdf.text.BaseColor
import com.itextpdf.text.Chunk
import com.itextpdf.text.Document
import com.itextpdf.text.Element
import com.itextpdf.text.ExceptionConverter
import com.itextpdf.text.Font
import com.itextpdf.text.Image
import com.itextpdf.text.Paragraph
import com.itextpdf.text.Phrase
import com.itextpdf.text.Rectangle
import com.itextpdf.text.pdf.BaseFont
import com.itextpdf.text.pdf.ColumnText
import com.itextpdf.text.pdf.PdfAction
import com.itextpdf.text.pdf.PdfContentByte
import com.itextpdf.text.pdf.PdfPCell
import com.itextpdf.text.pdf.PdfPTable
import com.itextpdf.text.pdf.PdfPageEvent
import com.itextpdf.text.pdf.PdfWriter

/**
 * Created by ZAPATAV on 6/3/2015.
 */
class HeaderFooter implements PdfPageEvent{
    protected Phrase headerP;
    protected PdfPTable footer;
    def total
    def helv
    def r
    def img
    def fecha
    Font header = new Font(Font.FontFamily.HELVETICA  , 12,Font.UNDERLINE | Font.BOLD);
    Font titulo = new Font(Font.FontFamily.HELVETICA    , 10,Font.BOLD);
    Font contenido = new Font(Font.FontFamily.HELVETICA, 8);
    public HeaderFooter(row,img,fecha,usuario) {
        this.r=row
        this.img=img
        this.fecha=fecha

        footer = new PdfPTable(1);
        footer.setTotalWidth(300);
        footer.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
        def cell = new PdfPCell(new Paragraph("Impreso el "+new Date().format("dd-MM-yyyy")+", generado por: "+usuario,contenido));
        cell.setBorder(0)
        footer.addCell(cell)


    }
    public void onEndPage(PdfWriter writer, Document document) {
        PdfContentByte cb = writer.getDirectContent();
        if (document.getPageNumber() > 1) {
//            ColumnText.showTextAligned(cb,
//                    Element.ALIGN_CENTER, header,(float)
//                    ((document.right() - document.left()) / 2
//                            + document.leftMargin()), (float)(document.top() + 10),(float) 0);


        }
        footer.writeSelectedRows(0, -1,
                (float)((document.right() - document.left() - 300) /2
                        + document.leftMargin()),
                (float) (document.bottom() - 10), cb);
    }
    public void onOpenDocument(PdfWriter writer, Document document) {
        total = writer.getDirectContent().createTemplate(100, 100);
        total.setBoundingBox(new Rectangle(-20, -20, 100, 100));
        try {
            helv = BaseFont.createFont(BaseFont.HELVETICA,
                    BaseFont.WINANSI, BaseFont.NOT_EMBEDDED);
        } catch (Exception e) {
            throw new ExceptionConverter(e);
        }
    }

    @Override
    void onStartPage(PdfWriter pdfWriter, Document document) {
        PdfContentByte cb = pdfWriter.getDirectContent();
        if (document.getPageNumber() > 1) {
//            ColumnText.showTextAligned(cb,
//                    Element.ALIGN_CENTER, header,(float)
//                    ((document.right() - document.left()) / 2
//                            + document.leftMargin()), (float)(document.top() + 10),(float) 0);

            String imageUrl = this.img;
            Image image = Image.getInstance( new File('/images/logo-login.png').readBytes());
//            Image image = Image.getInstance( new File('./web-app//images/logo-login.png').readBytes());
            image.setAbsolutePosition(40f, 722f);
            document.add(image);
            Paragraph p = new Paragraph("TASAS REFERENCIALES",header);
            p.setAlignment(Element.ALIGN_RIGHT);
            document.add(p);
            p = new Paragraph(""+r["TASA1"],contenido);
            p.setAlignment(Element.ALIGN_RIGHT);
            document.add(p);
            p = new Paragraph(""+r["TASA2"],contenido);
            p.setAlignment(Element.ALIGN_RIGHT);
            document.add(p);
//        p = new Paragraph(""+r["TASA3"],contenido);
//        p.setAlignment(Element.ALIGN_RIGHT);
//        document.add(p);
            p = new Paragraph(""+r["TASA4"],contenido);
            p.setAlignment(Element.ALIGN_RIGHT);
            document.add(p);
            document.add(new Paragraph("\n"));
            document.add(new Paragraph("\n"));

            /*Estado de cuenta*/

            p = new Paragraph("ESTADO DE CUENTA: " + fecha.format("MMMM-yyyy"), titulo);
            p.setAlignment(Element.ALIGN_LEFT);
            document.add(p);
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
            cell = new PdfPCell(new Paragraph(r["CLIENTE_FACTURA"], contenido));
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
        }
    }

    public void onCloseDocument(PdfWriter writer, Document document) {
        total.beginText();
        total.setFontAndSize(helv, 12);
        total.setTextMatrix(0, 0);
        total.showText(String.valueOf(writer.getPageNumber() - 1));
        total.endText();
    }

    @Override
    void onParagraph(PdfWriter pdfWriter, Document document, float v) {

    }

    @Override
    void onParagraphEnd(PdfWriter pdfWriter, Document document, float v) {

    }

    @Override
    void onChapter(PdfWriter pdfWriter, Document document, float v, Paragraph elements) {

    }

    @Override
    void onChapterEnd(PdfWriter pdfWriter, Document document, float v) {

    }

    @Override
    void onSection(PdfWriter pdfWriter, Document document, float v, int i, Paragraph elements) {

    }

    @Override
    void onSectionEnd(PdfWriter pdfWriter, Document document, float v) {

    }

    @Override
    void onGenericTag(PdfWriter pdfWriter, Document document, com.itextpdf.text.Rectangle rectangle, String s) {

    }



}
