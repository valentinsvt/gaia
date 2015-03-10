<%--
  Created by IntelliJ IDEA.
  User: Fabricio
  Date: 02/03/2015
  Time: 22:01
--%>

<g:form name="frmUpload" enctype="multipart/form-data" method="post" action="subirPdf">
    <g:hiddenField name="id" value="${idCon}"/>
    <div class="row">
        <div class="col-md-3">
            <label>Archivo OAE:</label>
        </div>
        <div class="col-md-8">
            <input type="file" class="ui-corner-all" name="file" id="file" size="70"/>
        </div>

    </div>
</g:form>
<div class="alert alert-danger" style="width: 300px; margin-left: 140px;margin-top: 20px">
    * El archivo a cargar solo puede ser de tipo PDF
</div>