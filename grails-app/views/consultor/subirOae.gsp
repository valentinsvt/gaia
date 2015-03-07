<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 02/03/2015
  Time: 22:01
--%>

<g:form name="frmUpload" enctype="multipart/form-data" method="post" action="subirPdf" >
    <g:hiddenField name="id" value="${idCon}"/>
    <div class="container ui-corner-all" style="min-height: 100px; width: 600px; margin-left: 200px">
        <b>Archivo OAE:</b>  <input type="file" class="ui-corner-all" name="file" id="file" size="70"/>
    </div>
</g:form>
<div class="alert alert-danger" style="width: 300px; margin-left: 140px">
    * El archivo a cargar solo puede ser de tipo PDF
</div>