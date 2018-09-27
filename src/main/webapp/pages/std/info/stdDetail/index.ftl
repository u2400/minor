<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/itemSelect.js"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/Common.js"></script>
<body>
<table id="backBar"></table>
<script>
   	var bar = new ToolBar('backBar','<@msg.message key="std.personalInfo"/>',null,true,true);
   	bar.setMessage('<@getMessage/>');
   	bar.addHelp("<@msg.message key="action.help"/>");
</script>
   <table width="100%" height="93%" class="frameTable">
   <tr>
   <td valign="top" class="frameTable_view" width="20%" style="font-size:10pt">
      <table width="100%" id ="viewTables" style="font-size:10pt">
      <tr>
	     <td class="infoTitle" align="left" valign="bottom">
	       	<img src="images/action/info.gif" align="top"/>
	        <B><@msg.message key="std.infoType"/></B>      
	     </td>
	  <tr>
	    <tr>
	      <td colspan="8" style="font-size:0px">
	          <img src="images/action/keyline.gif" height="2" width="100%" align="top">
	      </td>
	   </tr>
       <tr>
         <td class="padding" id="defaultItem" onclick="info(this,'stdInfo')" onmouseover="MouseOver(event)" onmouseout="MouseOut(event)">
         &nbsp;&nbsp;<image src="images/action/list.gif" align="bottom"><@msg.message key="std.survey"/>
         </td>
       </tr>
       <tr>
         <td class="padding"  onclick="info(this,'basicInfo')"  onmouseover="MouseOver(event)" onmouseout="MouseOut(event)">
         &nbsp;&nbsp;<image src="images/action/list.gif"><@msg.message key="std.baseInfo"/>(可提交修改)
         </td>
       </tr>
       <tr>
         <td class="padding"  onclick="info(this,'statusInfo')"  onmouseover="MouseOver(event)" onmouseout="MouseOut(event)">
         &nbsp;&nbsp;<image src="images/action/list.gif"><@msg.message key="std.statusInfo"/>
         </td>
       </tr>
       <#if std.abroadStudentInfo?exists>
       <tr>
         <td class="padding"  onclick="info(this,'abroadInfo')"  onmouseover="MouseOver(event)" onmouseout="MouseOut(event)">
         &nbsp;&nbsp;<image src="images/action/list.gif"><@msg.message key="std.certificateInfo"/>
         </td>
       </tr>
       </#if>
       <tr>
         <td class="padding"  onclick="info(this,'degreeInfo')"  onmouseover="MouseOver(event)" onmouseout="MouseOut(event)">
         &nbsp;&nbsp;<image src="images/action/list.gif"><@msg.message key="std.degreeInfo"/>
         </td>
       </tr>
	  </table>
	<td>
	<td valign="top">
     	<iframe name="statFrame" src="#" width="100%" height="100%" frameborder="0" ></iframe>
	</td>
</table>
<form name="infoForm" method="post" action="" onsubmit="return false;"></form>
<script>
   document.getElementById("defaultItem").onclick();   
   function info(td,kind){
      clearSelected(viewTables,td);
      setSelectedRow(viewTables,td);
      var form = document.infoForm;
      form.action="stdDetail.do?method=info&kind="+kind;
      form.target="statFrame";
      form.submit();
   }
</script>
</body>
<#include "/templates/foot.ftl"/>