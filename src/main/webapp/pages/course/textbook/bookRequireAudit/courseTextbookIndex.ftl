<#include "/templates/head.ftl"/>
<BODY>
 <table id="myBar"></table>
 <table class="frameTable" width="100%">
   <tr>
    <td width="20%" class="frameTable_view">
    <form name="searchForm" method="post" target="contentListFrame">
	  <table width="100%" onkeypress="DWRUtil.onReturn(event, searchCourse)">
    <tr>
      <td colspan="2" class="infoTitle" align="left" valign="bottom">
       <img src="images/action/info.gif" align="top"/>
          <B><@msg.message key="baseinfo.searchCourse"/></B>
      </td>
    <tr>
      <td colspan="2" style="font-size:0px">
          <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
      </td>
    </tr>
    <tr><td class="infoTitle">课程代码:</td><td><input type="text" name="course.code" style="width:100px;" maxlength="32"/></td></tr>
    <tr><td>课程名称:</td><td><input type="text" name="course.name" style="width:100px;" maxlength="30"/></td></tr>
    <tr><td>教材名称:</td><td><input type="text" name="textbook.name" style="width:100px;" maxlength="30"/></td></tr>
    <tr height="50px">
        <td colspan="2" align="center">
            <button onclick="search()" accesskey="Q"><@bean.message key="action.query"/>(<U>Q</U>)</button>
        </td>
    </tr>
  </table>
     </form>
    </td>
    <td valign="top">
      <iframe src="#" 
     id="contentListFrame" name="contentListFrame" 
     marginwidth="0" marginheight="0" scrolling="no"
     frameborder="0" height="100%" width="100%">
     </iframe>
    </td>
   </tr>
  </table>
  <script language="javascript">
    var bar=new ToolBar('myBar','课程默认教材维护',null,true,true);
	bar.setMessage('<@getMessage/>');
	menu1 =bar.addMenu("导入","importData()");
    menu1.addItem("下载模板","downloadTemplate()","download.gif");
    bar.addHelp()
    
	var action="bookRequireAudit.do"
	var form =document.searchForm;
	function search(){
	  form.action=action+"?method=courseTextbookList"
	  form.submit();
	}
	search();
    function importData(){
       form.action="bookRequireAudit.do?method=importForm";
       addInput(form,"importTitle","课程教材数据上传");
       form.submit();
    }
    function downloadTemplate(){
      self.location="dataTemplate.do?method=download&path=course_textbook.xls";
    }
  </script>
  </body>
<#include "/templates/foot.ftl"/>