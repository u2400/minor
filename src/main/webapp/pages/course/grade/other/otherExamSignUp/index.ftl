<#include "/templates/head.ftl"/>
<body>
 <table id="gradeBar"></table>
  <table width="100%" border="0" height="100%" class="frameTable">
    <form name="searchForm" method="post" action="" onsubmit="return false;">
    <tr>
        <td style="width:20%" valign="top" class="frameTable_view">
            <#include "searchForm.ftl"/>
        </td>
        <input type="hidden" name="document.id" value="21"/>
        <input type="hidden" name="templateDocumentId" value="21"/>
        <input type="hidden" name="importTitle" value="报名上传"/>
    </form>
     <td valign="top">
	     <iframe src="#" id="gradeFrame" name="gradeFrame" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" height="100%" width="100%"></iframe>
     </td>
    </tr>
  <table>
<script>
    var bar=new ToolBar("gradeBar","校内外考试报名管理",null,true,true);
    bar.addItem("导入", "importData()");
    bar.addItem("导入模板", "importDownload()", "download.gif");
    
    var form = document.searchForm;
    var action="otherExamSignUp.do"
    function search(pageNo,pageSize,orderBy){
	   form.action = action+"?method=search";
	   form.target="gradeFrame";
       goToPage(form,pageNo,pageSize,orderBy);
    }
    
    function importData() {
        form.action = "otherExamSignUp.do?method=importForm";
        form.target = "gradeFrame";
        form.submit();
    }
    
    function importDownload() {
        form.action = "dataTemplate.do?method=download";
        form.target = "_self";
        form.submit();
    }
    
    search();
</script> 
</body>
<#include "/templates/foot.ftl"/> 