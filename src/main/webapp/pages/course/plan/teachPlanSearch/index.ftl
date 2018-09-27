<#include "/templates/head.ftl"/>
<table id="teachPlanSearchBar"></table>
<script>
  var bar = new ToolBar("teachPlanSearchBar",'<@msg.message key="plan.planSearch"/>',null,true,true);
  bar.setMessage('<@getMessage/>')
  bar.addItem("<@bean.message key="action.look"/>",'getPlanInfo()');
</script>
   <table class="frameTable">
   <#if (stdTypeList?first.id)?exists>
   <tr valign="top">
    <td width="20%" class="frameTable_view">
      <#if RequestParameters['withAuthority']?exists>
         <#if RequestParameters['withAuthority']='1'><#include "../planSearchForm.ftl"/></#if>
      <#else>
         <#include "../planPublicSearchForm.ftl"/>
      </#if>
    </td>
    <td>
	 <iframe  src="#"
	     id="planListFrame" name="planListFrame"
	     marginwidth="0" marginheight="0" scrolling="no"
	     frameborder="0"  height="100%" width="100%">
	  </iframe>
    </td>
   </tr>
  </table>
 <script language="JavaScript" type="text/JavaScript" src="scripts/course/TeachPlan.js"></script>
 <script>
    multi=false;
    withAuthority=false;
    searchTeachPlan();
  </script>  
   <#else>
   <center><h1><font color="red">请联系管理员配置“学生类别”。</font></h1></center>
   </#if>
  </body>

<#include "/templates/foot.ftl"/>