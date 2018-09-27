<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="electRecordBar"></table>
<form name="textbookOrderIndexForm" action="courseTake.do?method=index" target="takeListFrame" method="post" onsubmit="return false;" style="margin-bottom: 0px;">
 <table class="frameTable_title" width="100%" >
  <tr>
   <td>详细查询</td>
   <td>|</td> 
  <input type="hidden" name="courseTake.task.calendar.id" value="${calendar.id}"/>
  <#include "/pages/course/calendar.ftl"/>
  </tr>
 </table>
  </form>
  <form name="textbookOrderForm" method="post">
  <table width="100%" colspacing="0" class="frameTable" height="85%">
    <tr>
     <td valign="top" style="width:160px" class="frameTable_view">
        <#include "searchForm.ftl"/>
        <input type="hidden" name="document.id" value="18"/>
        <input type="hidden" name="kind" value="&calendarId=${calendar.id}"/>
        <input type="hidden" name="importTitle" value="上课名单导入模板"/>
    
     </td>
     <td valign="top">
     <iframe src="#"
     id="takeListFrame" name="takeListFrame"
     marginwidth="0" marginheight="0" scrolling="no"
     frameborder="0" height="100%" width="100%">
     </iframe>
     </td>
    </tr>
  <table>
 <script>
  var bar =new ToolBar("electRecordBar","教材选购管理",null,true,true);
  bar.setMessage('<@getMessage/>');
  bar.addItem("统计教材数量","statOrder()");
  bar.addItem("统计订购开关","orderSetting()");
  var form =document.textbookOrderForm;
  
  function search(pageNo,pageSize,orderBy){
   		form.action="courseTake.do?method=search";
	    form.target = "takeListFrame";
        goToPage(form,pageNo,pageSize,orderBy);
  }
  function collisionStds(){
    if(confirm("是否统计选课冲突学生名单?")){
	    form.action="courseTake.do?method=collisionStdList";
	    form.target = "takeListFrame";
	    form.submit();
    }
  }
  
  function importData() {
    form.action = "courseTake.do?method=importForm&templateDocumentId=18";
    form.target = "takeListFrame";
    form.submit();
  }
  
  function downloadTemplate() {
    form.action = "dataTemplate.do?method=download";
    form.target = "takeListFrame";
    form.submit();
  }
  
  search();
</script>
</body>
<#include "/templates/foot.ftl"/> 
