package gaia.reportes.pintura

import gaia.pintura.DetallePintura
import gaia.pintura.ItemImagen
import org.apache.poi.ss.usermodel.CellStyle
import org.apache.poi.ss.usermodel.ClientAnchor
import org.apache.poi.ss.usermodel.CreationHelper
import org.apache.poi.ss.usermodel.DataFormat
import org.apache.poi.ss.usermodel.Drawing
import org.apache.poi.ss.usermodel.Font
import org.apache.poi.ss.usermodel.Picture
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.util.IOUtils
import org.apache.poi.xssf.usermodel.XSSFCell as Cell
import org.apache.poi.xssf.usermodel.XSSFColor
import org.apache.poi.xssf.usermodel.XSSFRow as Row
import org.apache.poi.xssf.usermodel.XSSFSheet as Sheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook as Workbook
class ReportesExcelPinturaController {

    def tablaExistentesExcel(){
        def inicio = new Date().parse("dd-MM-yyyy",params.desde)
        def fin = new Date().parse("dd-MM-yyyy",params.hasta)
        def det = DetallePintura.findAllByFinBetween(inicio,fin,[sort:"fin"])
        def items = ItemImagen.findAll("from ItemImagen where tipoItem='R' and tipo='N' and padre is not null")
        def itemMan = ItemImagen.findById(3)

        def datos = [:]
        def total = [:]
        total.put("TOTAL",["Mantenimiento":0])
        items.each { i ->
            total["TOTAL"].put(i.descripcion,0)
        }
        det.each {d->
            def totParcial = 0
            def man = d.getTotalGrupo(itemMan)
            totParcial+=man
            if(!datos[d.numeroFactura+"-"+d.numeroAp]){
                def tmp = ["fecha":d.fin]
                tmp.put("Mantenimiento",man)
                tmp.put("estacion",d.cliente.nombre)
                tmp.put("codigo",d.cliente.codigo)
                total["TOTAL"]["Mantenimiento"]+=man
                items.each {i->
                    def valor = d.getTotalItem(i)
                    tmp.put(i.descripcion,valor)
                    total["TOTAL"][i.descripcion]+=valor
                    totParcial+=valor
                }
                if(totParcial>0)
                    datos.put(d.numeroFactura+"-"+d.numeroAp,tmp)
            }else{
                total["TOTAL"]["Mantenimiento"]+=man
                datos[d.numeroFactura+"-"+d.numeroAp]["Mantenimiento"]+=man
                items.each { i ->
                    def valor = d.getTotalItem(i)
                    datos[d.numeroFactura+"-"+d.numeroAp][i.descripcion]+=valor
                    total["TOTAL"][i.descripcion]+=valor
                }
            }
        }

        try {
            def iniRow = 0
            def iniCol = 0

            def curRow = iniRow
            def curCol = iniCol
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Rotulación")
            def abolutePath =request.getSession().getServletContext().getRealPath("/images/logo-login.png")
            InputStream inputStream = new FileInputStream(abolutePath);
            byte[] bytes = IOUtils.toByteArray(inputStream);
            int pictureIdx = wb.addPicture(bytes, Workbook.PICTURE_TYPE_PNG);
            inputStream.close();
            //Returns an object that handles instantiating concrete classes
            CreationHelper helper = wb.getCreationHelper();
            //Creates the top-level drawing patriarch.
            Drawing drawing = sheet.createDrawingPatriarch();
            //Create an anchor that is attached to the worksheet
            ClientAnchor anchor = helper.createClientAnchor();
            //set top-left corner for the image
            anchor.setRow1(0);
            anchor.setCol1(0);
            anchor.setRow2(2);
            anchor.setCol2(2);
            //Creates a picture
            Picture pict = drawing.createPicture(anchor, pictureIdx);
            //Reset the image to the original size
//            pict.resize(1);
            DataFormat format = wb.createDataFormat();
            Font fontTitulo = wb.createFont()
            fontTitulo.setFontHeightInPoints((short) 24)
            fontTitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontTitulo.setBold(true)
            Font fontSubtitulo = wb.createFont()
            fontSubtitulo.setFontHeightInPoints((short) 18)
            fontSubtitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontSubtitulo.setBold(true)

            Font fontHeader = wb.createFont()
            fontHeader.setFontHeightInPoints((short) 10)
            fontHeader.setColor(new XSSFColor(new java.awt.Color(255, 255, 255)))
            fontHeader.setBold(true)

            Font fontFooter = wb.createFont()
            fontFooter.setBold(true)

            // Create a row and put some cells in it. Rows are 0 based.
            Row row = sheet.createRow((short) curRow)
            curRow++
            row.setHeightInPoints(30)
            Row row2 = sheet.createRow((short) curRow)
            curRow += 2
            row2.setHeightInPoints(24)
            curRow++

            CellStyle styleTitulo = wb.createCellStyle()
            styleTitulo.setFont(fontTitulo)
            styleTitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleTitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleSubtitulo = wb.createCellStyle()
            styleSubtitulo.setFont(fontSubtitulo)
            styleSubtitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleSubtitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleHeader = wb.createCellStyle()
            styleHeader.setFont(fontHeader)
            styleHeader.setAlignment(CellStyle.ALIGN_CENTER)
            styleHeader.setVerticalAlignment(CellStyle.VERTICAL_CENTER)
            styleHeader.setFillForegroundColor(new XSSFColor(new java.awt.Color(0, 110, 183)));
            styleHeader.setFillPattern(CellStyle.SOLID_FOREGROUND)
            styleHeader.setBorderRight((short) 1)
            styleHeader.setBorderLeft((short)1)
            styleHeader.setBorderTop((short) 1)
            styleHeader.setBorderBottom((short) 1)
            styleHeader.setWrapText(true);

            CellStyle styleFooter = wb.createCellStyle()
            styleFooter.setFont(fontFooter)
            styleFooter.setDataFormat(format.getFormat("0.00"));

            CellStyle styleTable = wb.createCellStyle()
            styleTable.setDataFormat(format.getFormat("0.00"));

            Cell cellTitulo = row.createCell((short) iniCol)
            cellTitulo.setCellValue("Petróleos y servicios" )
            cellTitulo.setCellStyle(styleTitulo)
            Cell cellSubtitulo = row2.createCell((short) iniCol)
            cellSubtitulo.setCellValue("Rotulación estaciones de servicio del "+inicio.format("dd-MM-yyyy")+" hasta "+fin.format("dd-MM-yyyy"))
            cellSubtitulo.setCellStyle(styleSubtitulo)
            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow, //first row (0-based)
                    iniRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    12  //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    1, //first row (0-based)
                    1, //last row  (0-based)
                    0, //first column (0-based)
                    12  //last column  (0-based)
            ))
            row = sheet.createRow((short) curRow-1)
            Cell celda =  row.createCell((short) 3)
            celda.setCellValue("Mantenimiento")
            celda.setCellStyle(styleHeader)
            celda =  row.createCell((short) 4)
            celda.setCellValue("Elementos nuevos")
            celda.setCellStyle(styleHeader)
            sheet.addMergedRegion(new CellRangeAddress(
                    curRow-1, //first row (0-based)
                    curRow-1, //last row  (0-based)
                    4, //first column (0-based)
                    items.size()+3 //last column  (0-based)
            ))
            row = sheet.createRow((short) curRow)
            curRow++
            def col = 0
            celda =  row.createCell((short) col)
            celda.setCellValue("Código")
            celda.setCellStyle(styleHeader)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Estación")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,9000)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Fecha")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,3500)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Elementos exist.")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,4000)
            col++
            items.each {
                celda =  row.createCell((short) col)
                celda.setCellValue(it.descripcion)
                celda.setCellStyle(styleHeader)
                sheet.setColumnWidth(col,4000)
                col++
            }

            datos.each {d->
                col=0
                row = sheet.createRow((short) curRow)
                curRow++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["codigo"])
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["estacion"])
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["fecha"].format("dd-MM-yyyy"))
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["Mantenimiento"])
                celda.setCellStyle(styleTable)
                col++
                items.each {i->
                    celda =  row.createCell((short) col)
                    celda.setCellValue(d.value[i.descripcion])
                    celda.setCellStyle(styleTable)
                    col++
                }
            }
            col=0
            row = sheet.createRow((short) curRow)
            curRow++
            celda =  row.createCell((short) col)
            celda.setCellValue("TOTAL")
            celda.setCellStyle(styleFooter)
            col+=3
            celda =  row.createCell((short) col)
            celda.setCellValue(total["TOTAL"]["Mantenimiento"])
            celda.setCellStyle(styleFooter)
            col++
            items.each {i->
                celda =  row.createCell((short) col)
                celda.setCellValue(total["TOTAL"][i.descripcion])
                celda.setCellStyle(styleFooter)
                col++
            }

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "rotulacion.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        }catch (e){
            e.printStackTrace()
        }
    }
    def tablaPinturaExcel(){
        def inicio = new Date().parse("dd-MM-yyyy",params.desde)
        def fin = new Date().parse("dd-MM-yyyy",params.hasta)
        def det = DetallePintura.findAllByFinBetween(inicio,fin,[sort:"fin"])
        def itemPintura = ItemImagen.findById(12)
        def datos = [:]
        def total = 0
        def totalM2 = 0
        det.each {d->
            def valores = d.getCantidadYPrecioItem(itemPintura)
            if(valores[0]+valores[1]>0){
                if(!datos[d.numeroFactura+"-"+d.numeroAp]){
                    def tmp = ["fecha":d.fin]
                    tmp.put("Pintura",valores[0])
                    tmp.put("M2",valores[1])
                    tmp.put("Autorización",d.numeroAp)
                    tmp.put("codigo",d.cliente.codigo)
                    tmp.put("estacion",d.cliente.nombre)
                    datos.put(d.cliente.nombre,tmp)
                }else{

                    datos[d.numeroFactura+"-"+d.numeroAp]["Pintura"]+=valores[0]
                    datos[d.numeroFactura+"-"+d.numeroAp]["M2"]+=valores[1]


                }
            }

        }
        try {
            def iniRow = 0
            def iniCol = 0

            def curRow = iniRow
            def curCol = iniCol
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Pintura")
            def abolutePath =request.getSession().getServletContext().getRealPath("/images/logo-login.png")
            InputStream inputStream = new FileInputStream(abolutePath);
            byte[] bytes = IOUtils.toByteArray(inputStream);
            int pictureIdx = wb.addPicture(bytes, Workbook.PICTURE_TYPE_PNG);
            inputStream.close();
            //Returns an object that handles instantiating concrete classes
            CreationHelper helper = wb.getCreationHelper();
            //Creates the top-level drawing patriarch.
            Drawing drawing = sheet.createDrawingPatriarch();
            //Create an anchor that is attached to the worksheet
            ClientAnchor anchor = helper.createClientAnchor();
            //set top-left corner for the image
            anchor.setRow1(0);
            anchor.setCol1(0);
            anchor.setRow2(2);
            anchor.setCol2(2);
            //Creates a picture
            Picture pict = drawing.createPicture(anchor, pictureIdx);
            //Reset the image to the original size
//            pict.resize(1);
            DataFormat format = wb.createDataFormat();
            Font fontTitulo = wb.createFont()
            fontTitulo.setFontHeightInPoints((short) 24)
            fontTitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontTitulo.setBold(true)
            Font fontSubtitulo = wb.createFont()
            fontSubtitulo.setFontHeightInPoints((short) 18)
            fontSubtitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontSubtitulo.setBold(true)

            Font fontHeader = wb.createFont()
            fontHeader.setFontHeightInPoints((short) 10)
            fontHeader.setColor(new XSSFColor(new java.awt.Color(255, 255, 255)))
            fontHeader.setBold(true)

            Font fontFooter = wb.createFont()
            fontFooter.setBold(true)

            // Create a row and put some cells in it. Rows are 0 based.
            Row row = sheet.createRow((short) curRow)
            curRow++
            row.setHeightInPoints(30)
            Row row2 = sheet.createRow((short) curRow+1)
            curRow += 2
            row2.setHeightInPoints(24)
            curRow++

            CellStyle styleTitulo = wb.createCellStyle()
            styleTitulo.setFont(fontTitulo)
            styleTitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleTitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleSubtitulo = wb.createCellStyle()
            styleSubtitulo.setFont(fontSubtitulo)
            styleSubtitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleSubtitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleHeader = wb.createCellStyle()
            styleHeader.setFont(fontHeader)
            styleHeader.setAlignment(CellStyle.ALIGN_CENTER)
            styleHeader.setVerticalAlignment(CellStyle.VERTICAL_CENTER)
            styleHeader.setFillForegroundColor(new XSSFColor(new java.awt.Color(0, 110, 183)));
            styleHeader.setFillPattern(CellStyle.SOLID_FOREGROUND)
            styleHeader.setBorderRight((short) 1)
            styleHeader.setBorderLeft((short)1)
            styleHeader.setBorderTop((short) 1)
            styleHeader.setBorderBottom((short) 1)
            styleHeader.setWrapText(true);

            CellStyle styleFooter = wb.createCellStyle()
            styleFooter.setFont(fontFooter)
            styleFooter.setDataFormat(format.getFormat("0.00"));

            CellStyle styleTable = wb.createCellStyle()
            styleTable.setDataFormat(format.getFormat("0.00"));

            Cell cellTitulo = row.createCell((short) iniCol)
            cellTitulo.setCellValue("Petróleos y servicios" )
            cellTitulo.setCellStyle(styleTitulo)
            Cell cellSubtitulo = row2.createCell((short) iniCol)
            cellSubtitulo.setCellValue("Pintura estaciones de servicio del "+inicio.format("dd-MM-yyyy")+" hasta "+fin.format("dd-MM-yyyy"))
            cellSubtitulo.setCellStyle(styleSubtitulo)
            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow, //first row (0-based)
                    iniRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    12  //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    2, //first row (0-based)
                    2, //last row  (0-based)
                    0, //first column (0-based)
                    12  //last column  (0-based)
            ))

            row = sheet.createRow((short) curRow)
            curRow++
            def col = 0
            def celda =  row.createCell((short) col)
            celda.setCellValue("Código")
            celda.setCellStyle(styleHeader)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Estación")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,9000)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Fecha")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,3500)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("M2")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,4000)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Valor")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,4000)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Autorización")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,4000)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Observaciones")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,15000)
            col++


            datos.each {d->
                total+=d.value["Pintura"]
                totalM2+=d.value["M2"]
                col=0
                row = sheet.createRow((short) curRow)
                curRow++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["codigo"])
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["estacion"])
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["fecha"].format("dd-MM-yyyy"))
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(""+d.value["M2"]+" m2")
                celda.setCellStyle(styleTable)
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["Pintura"])
                celda.setCellStyle(styleTable)
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["Autorización"])
                celda.setCellStyle(styleTable)
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["observaciones"])
                celda.setCellStyle(styleTable)

            }
            col=0
            row = sheet.createRow((short) curRow)
            curRow++
            celda =  row.createCell((short) col)
            celda.setCellValue("TOTAL")
            celda.setCellStyle(styleFooter)
            col+=3
            celda =  row.createCell((short) col)
            celda.setCellValue(""+totalM2+" m2")
            celda.setCellStyle(styleFooter)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue(total)
            celda.setCellStyle(styleFooter)
            def output = response.getOutputStream()
            def header = "attachment; filename=" + "pintura.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        }catch (e){
            e.printStackTrace()
        }
    }

    def tablaPinturaExcelNueva(){
        def inicio = new Date().parse("dd-MM-yyyy",params.desde)
        def fin = new Date().parse("dd-MM-yyyy",params.hasta)
        def det = DetallePintura.findAllByFinBetween(inicio,fin,[sort:"fin"])
        def itemPintura = ItemImagen.findById(11)
        def datos = [:]
        def total = 0
        def totalM2 = 0
        det.each {d->
            def valores = d.getCantidadYPrecioItem(itemPintura)
            if(valores[0]+valores[1]>0){
                if(!datos[d.numeroFactura+"-"+d.numeroAp]){
                    def tmp = ["fecha":d.fin]
                    tmp.put("Pintura",valores[0])
                    tmp.put("M2",valores[1])
                    tmp.put("Autorización",d.numeroAp)
                    tmp.put("codigo",d.cliente.codigo)
                    tmp.put("estacion",d.cliente.nombre)
                    datos.put(d.cliente.nombre,tmp)
                }else{

                    datos[d.numeroFactura+"-"+d.numeroAp]["Pintura"]+=valores[0]
                    datos[d.numeroFactura+"-"+d.numeroAp]["M2"]+=valores[1]


                }
            }

        }
        try {
            def iniRow = 0
            def iniCol = 0

            def curRow = iniRow
            def curCol = iniCol
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Pintura")
            def abolutePath =request.getSession().getServletContext().getRealPath("/images/logo-login.png")
            InputStream inputStream = new FileInputStream(abolutePath);
            byte[] bytes = IOUtils.toByteArray(inputStream);
            int pictureIdx = wb.addPicture(bytes, Workbook.PICTURE_TYPE_PNG);
            inputStream.close();
            //Returns an object that handles instantiating concrete classes
            CreationHelper helper = wb.getCreationHelper();
            //Creates the top-level drawing patriarch.
            Drawing drawing = sheet.createDrawingPatriarch();
            //Create an anchor that is attached to the worksheet
            ClientAnchor anchor = helper.createClientAnchor();
            //set top-left corner for the image
            anchor.setRow1(0);
            anchor.setCol1(0);
            anchor.setRow2(2);
            anchor.setCol2(2);
            //Creates a picture
            Picture pict = drawing.createPicture(anchor, pictureIdx);
            //Reset the image to the original size
//            pict.resize(1);
            DataFormat format = wb.createDataFormat();
            Font fontTitulo = wb.createFont()
            fontTitulo.setFontHeightInPoints((short) 24)
            fontTitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontTitulo.setBold(true)
            Font fontSubtitulo = wb.createFont()
            fontSubtitulo.setFontHeightInPoints((short) 18)
            fontSubtitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontSubtitulo.setBold(true)

            Font fontHeader = wb.createFont()
            fontHeader.setFontHeightInPoints((short) 10)
            fontHeader.setColor(new XSSFColor(new java.awt.Color(255, 255, 255)))
            fontHeader.setBold(true)

            Font fontFooter = wb.createFont()
            fontFooter.setBold(true)

            // Create a row and put some cells in it. Rows are 0 based.
            Row row = sheet.createRow((short) curRow)
            curRow++
            row.setHeightInPoints(30)
            Row row2 = sheet.createRow((short) curRow+1)
            curRow += 2
            row2.setHeightInPoints(24)
            curRow++

            CellStyle styleTitulo = wb.createCellStyle()
            styleTitulo.setFont(fontTitulo)
            styleTitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleTitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleSubtitulo = wb.createCellStyle()
            styleSubtitulo.setFont(fontSubtitulo)
            styleSubtitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleSubtitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleHeader = wb.createCellStyle()
            styleHeader.setFont(fontHeader)
            styleHeader.setAlignment(CellStyle.ALIGN_CENTER)
            styleHeader.setVerticalAlignment(CellStyle.VERTICAL_CENTER)
            styleHeader.setFillForegroundColor(new XSSFColor(new java.awt.Color(0, 110, 183)));
            styleHeader.setFillPattern(CellStyle.SOLID_FOREGROUND)
            styleHeader.setBorderRight((short) 1)
            styleHeader.setBorderLeft((short)1)
            styleHeader.setBorderTop((short) 1)
            styleHeader.setBorderBottom((short) 1)
            styleHeader.setWrapText(true);

            CellStyle styleFooter = wb.createCellStyle()
            styleFooter.setFont(fontFooter)
            styleFooter.setDataFormat(format.getFormat("0.00"));

            CellStyle styleTable = wb.createCellStyle()
            styleTable.setDataFormat(format.getFormat("0.00"));

            Cell cellTitulo = row.createCell((short) iniCol)
            cellTitulo.setCellValue("Petróleos y servicios" )
            cellTitulo.setCellStyle(styleTitulo)
            Cell cellSubtitulo = row2.createCell((short) iniCol)
            cellSubtitulo.setCellValue("Pintura estaciones de servicio nuevas del "+inicio.format("dd-MM-yyyy")+" hasta "+fin.format("dd-MM-yyyy"))
            cellSubtitulo.setCellStyle(styleSubtitulo)
            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow, //first row (0-based)
                    iniRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    12  //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    2, //first row (0-based)
                    2, //last row  (0-based)
                    0, //first column (0-based)
                    12  //last column  (0-based)
            ))

            row = sheet.createRow((short) curRow)
            curRow++
            def col = 0
            def celda =  row.createCell((short) col)
            celda.setCellValue("Código")
            celda.setCellStyle(styleHeader)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Estación")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,9000)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Fecha")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,3500)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("M2")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,4000)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Valor")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,4000)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Autorización")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,4000)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue("Observaciones")
            celda.setCellStyle(styleHeader)
            sheet.setColumnWidth(col,15000)
            col++


            datos.each {d->
                total+=d.value["Pintura"]
                totalM2+=d.value["M2"]
                col=0
                row = sheet.createRow((short) curRow)
                curRow++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["codigo"])
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["estacion"])
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["fecha"].format("dd-MM-yyyy"))
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["M2"])
                celda.setCellStyle(styleTable)
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["Pintura"])
                celda.setCellStyle(styleTable)
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["Autorización"])
                celda.setCellStyle(styleTable)
                col++
                celda =  row.createCell((short) col)
                celda.setCellValue(d.value["observaciones"])
                celda.setCellStyle(styleTable)

            }
            col=0
            row = sheet.createRow((short) curRow)
            curRow++
            celda =  row.createCell((short) col)
            celda.setCellValue("TOTAL")
            celda.setCellStyle(styleFooter)
            col+=3
            celda =  row.createCell((short) col)
            celda.setCellValue(totalM2)
            celda.setCellStyle(styleFooter)
            col++
            celda =  row.createCell((short) col)
            celda.setCellValue(total)
            celda.setCellStyle(styleFooter)
            def output = response.getOutputStream()
            def header = "attachment; filename=" + "pinturaNuevas.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        }catch (e){
            e.printStackTrace()
        }
    }
}
