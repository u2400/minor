<#include "/templates/head.ftl"/>
<BODY>
 <table id="myBar"></table>
 
 <table class="frameTable" width="100%">
   <tr>
    <td width="20%" class="frameTable_view">
    <form name="searchForm" method="post" target="contentListFrame">
      <#assign extraSearchOptions><#include "../../base.ftl"/><@stateSelect "course"/></#assign>
	  <#include "courseSearchTable.ftl">
	  <table><tr height="350px"><td></td></tr></table>
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
  <script language="JavaScript" type="text/JavaScript" src="<@msg.message key="js.baseinfo"/>"></script>
  <script language="javascript">
    type="course";
    labelInfo="<@bean.message key="page.courseListFrame.label" />";
    search();
    searchCourse=search;
    function initToolBarHook(bar){
       menu1 =bar.addItem("上传",'upload()','action.gif');
       menu1 =bar.addItem("下载",'downloadTemplate()','download.gif');
      
    }
    function upload(){
    	form.action="courseOutline.do?method=loadUploadPage";
    	form.submit();
    }
    function downloadTemplate(){
      self.location="dataTemplate.do?method=download&document.id=50";
    }

    initBaseInfoBar1();
  </script>
  </body>
<#include "/templates/foot.ftl"/>