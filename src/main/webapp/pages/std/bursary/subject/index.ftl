<#include "/templates/head.ftl"/>

<BODY LEFTMARGIN="0" TOPMARGIN="0" >
<table id="subjectBar"></table> 
   <table class="frameTable" height="90%">
   <tr>
    <td style="width:160px" class="frameTable_view">
      <form name="searchForm" action="bursarySubject.do?method=search" target="subjectListFrame" method="post" onsubmit="return false;">
      <#include "searchForm.ftl"/>
      </form>
    </td>
    <td valign="top">
	  <iframe  src="#" 
	     id="subjectListFrame" name="subjectListFrame" 
	     marginwidth="0" marginheight="0" scrolling="no"
	     frameborder="0"  height="100%" width="100%">
	  </iframe>
    </td>
   </tr>
  </table>


  <script language="javascript">
    var bar = new ToolBar('subjectBar','助学金申请填写内容维护',null,true,true);
    bar.setMessage('<@getMessage/>');
    bar.addItem("<@bean.message key="action.add"/>", "add()");
    bar.addItem("<@bean.message key="action.modify"/>", "edit()");
    bar.addItem("删除", "remove()");
    
    function getIds(){
       return(getRadioValue(subjectListFrame.document.getElementsByName("subjectId")));
    }
    var form = document.searchForm;
    var action="bursarySubject.do";
    function search(pageNo,pageSize,orderBy){
       form.action=action+"?method=search";
       goToPage(form,pageNo,pageSize,orderBy);
    }
    search();
    function add(){
       form.action=action+"?method=edit&subjectId=";
       form.submit();
    }
    function edit(){
       var ids = getIds();
       if(ids==""||isMultiId(ids)) {
         alert('请选择一个');
       } else {
         form.action= action + "?method=edit&subjectId=" + ids;
         form.submit();
       }
   }
    function remove() {
       var ids = getIds();
       if (ids=="" || isMultiId(ids)) {
         alert('请选择一个');
         return;
       }
       if (confirm("确定要删除吗？")) {
         form.action= action + "?method=remove&subjectId=" + ids;
         form.submit();
       }
   }
  </script>
</body>
<#include "/templates/foot.ftl"/>