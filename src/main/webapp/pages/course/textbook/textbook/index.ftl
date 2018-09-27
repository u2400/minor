<#include "/templates/head.ftl"/>

<BODY LEFTMARGIN="0" TOPMARGIN="0" >
<table id="textbookBar"></table> 
   <table class="frameTable" height="90%">
   <tr>
    <td style="width:160px" class="frameTable_view">
      <form name="searchForm" action="textbook.do?method=search" target="textbookListFrame" method="post" onsubmit="return false;">
      <#include "searchForm.ftl"/>
      </form>
    </td>
    <td valign="top">
	  <iframe  src="#" 
	     id="textbookListFrame" name="textbookListFrame" 
	     marginwidth="0" marginheight="0" scrolling="no"
	     frameborder="0"  height="100%" width="100%">
	  </iframe>
    </td>
   </tr>
  </table>


  <script language="javascript">
    var bar = new ToolBar('textbookBar','<@msg.message key="textbook.management"/>',null,true,true);
    bar.setMessage('<@getMessage/>');
    bar.addItem("<@bean.message key="action.add"/>", "add()");
    bar.addItem("<@bean.message key="action.modify"/>", "edit()");
    bar.addItem("删除", "remove()");
    menu1 =bar.addMenu("导入","importData()");
    menu1.addItem("下载模板","downloadTemplate()","download.gif");
    bar.addItem("<@bean.message key="action.export"/>", "exportData()");
    bar.addItem("<@msg.message key="entity.press"/>", "pressList()");
    
    function getIds(){
       return(getRadioValue(textbookListFrame.document.getElementsByName("textbookId")));
    }
    
    var form = document.searchForm;
    var action="textbook.do";
    function search(pageNo,pageSize,orderBy){
       form.action=action+"?method=search";
       goToPage(form,pageNo,pageSize,orderBy);
    }
    search();
    function add(){
       form.action=action+"?method=edit&textbookId=";
       form.submit();
    }
    function edit(){
       var ids = getIds();
       if(ids==""||isMultiId(ids)) {
         alert('请选择一个');
       } else {
         form.action= action + "?method=edit&textbookId=" + ids;
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
         form.action= action + "?method=remove&textbookId=" + ids;
         form.submit();
       }
   }
   function exportData(){
      addInput(form,"keys","code,name,auth,press.name,publishedOn,price,onSell");
      addInput(form,"titles","书号,教材名称,作者,出版社,出版时间,定价,折扣");
      form.action=action+"?method=export";
      form.submit();
   }
   function importData(){
       form.action=action+"?method=importForm";
       addInput(form,"importTitle","教材数据上传");
       form.submit();
    }
    function downloadTemplate(){
      self.location="dataTemplate.do?method=download&path=textbook.xls";
    }
   function pressList(){
      window.open("press.do?method=index");
   }
  </script>
</body>
<#include "/templates/foot.ftl"/>