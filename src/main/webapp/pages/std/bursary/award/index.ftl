<#include "/templates/head.ftl"/>

<BODY LEFTMARGIN="0" TOPMARGIN="0" >
<table id="awardBar"></table> 
   <table class="frameTable" height="90%">
   <tr>
    <td style="width:160px" class="frameTable_view">
      <form name="searchForm" action="bursaryAward.do?method=search" target="awardListFrame" method="post" onsubmit="return false;">
      <#include "searchForm.ftl"/>
      </form>
    </td>
    <td valign="top">
	  <iframe  src="#" 
	     id="awardListFrame" name="awardListFrame" 
	     marginwidth="0" marginheight="0" scrolling="no"
	     frameborder="0"  height="100%" width="100%">
	  </iframe>
    </td>
   </tr>
  </table>


  <script language="javascript">
    var bar = new ToolBar('awardBar','助学金奖项维护',null,true,true);
    bar.setMessage('<@getMessage/>');
    bar.addItem("<@bean.message key="action.add"/>", "add()");
    bar.addItem("<@bean.message key="action.modify"/>", "edit()");
    bar.addItem("删除", "remove()");
    bar.addItem("填写内容维护", "subjectList()");
    
    function getIds(){
       return(getRadioValue(awardListFrame.document.getElementsByName("awardId")));
    }
    var form = document.searchForm;
    var action="bursaryAward.do";
    function search(pageNo,pageSize,orderBy){
       form.action=action+"?method=search";
       goToPage(form,pageNo,pageSize,orderBy);
    }
    search();
    function add(){
       form.action=action+"?method=edit&awardId=";
       form.submit();
    }
    function edit(){
       var ids = getIds();
       if(ids==""||isMultiId(ids)) {
         alert('请选择一个');
       } else {
         form.action= action + "?method=edit&awardId=" + ids;
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
         form.action= action + "?method=remove&awardId=" + ids;
         form.submit();
       }
   }
   function subjectList(){
      window.open("bursarySubject.do?method=index");
   }
  </script>
</body>
<#include "/templates/foot.ftl"/>