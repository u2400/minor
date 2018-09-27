<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/itemSelect.js"></script>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
 <table id="myBar"></table>
   <table border="0"  class="frameTable_title" width="100%">
      <tr height="22px">
       <td></td>      
      <form name="calendarForm" target="teachTaskListFrame" method="post" action="requirePrefer.do?method=index" onsubmit="return false;">
      <input type="hidden" name="listWhat" value="listTask"/>
      <input type="hidden" name="teacher.id" value="${teacher.id}"/>
      <#include "/pages/course/calendar.ftl"/>
     </form>
      </tr>
     </table>
     <table border="0"  class="frameTable" width="100%" height="90%" >  
      <tr>
        <td valign="top" class="frameTable_view" width="20%" style="font-size:10pt">
	      <table  width="100%" id ="viewTables" style="font-size:10pt">
	      <tr>
		      <td  class="infoTitle" align="left" valign="bottom">
		       <img src="images/action/info.gif" align="top"/>
		          <B>教材/要求</B>      
		      </td>
		  <tr>
		    <tr>
		      <td  colspan="8" style="font-size:0px">
		          <img src="images/action/keyline.gif" height="2" width="100%" align="top">
		      </td>
		   </tr>
	       <tr>
	         <td class="padding" id="defaultItem" onclick="search(this,'taskRequire')"  onmouseover="MouseOver(event)" onmouseout="MouseOut(event)">
	         &nbsp;&nbsp;<image src="images/action/list.gif">教材设置
	         </td>
	       </tr>
	       <tr>
	         <td class="padding"  onclick="search(this,'preferRequire')"  onmouseover="MouseOver(event)" onmouseout="MouseOut(event)">
	         &nbsp;&nbsp;<image src="images/action/list.gif">要求偏好
	         </td>
	       </tr>
		  </table>
	  <td>
      <td valign="top" colspan="12">
	     <iframe  src="#"
	     id="teachTaskListFrame" name="teachTaskListFrame" 
	     marginwidth="0" marginheight="0" scrolling="no"
	     frameborder="0"  height="100%" width="100%">
	     </iframe>
      </td>
      </tr>
     </table>
 <script>
   var bar = new ToolBar("myBar","<@bean.message key="info.taskRequirement.management" />",null,true,true);
   bar.addHelp("<@msg.message key="action.help"/>");
   form=document.calendarForm;
   action="requirePrefer.do";
   document.getElementById("defaultItem").onclick();
   function search(td,what){
      clearSelected(viewTables,td);
      setSelectedRow(viewTables,td);
      if(what=="taskRequire"){
         form.action=action+"?method=taskList";
      }else if(what =="preferRequire"){
         form.action=action+"?method=preferList"
      }
      form.target="teachTaskListFrame";
      form.submit();
   }
 </script> 
 </body>
<#include "/templates/foot.ftl"/> 
  