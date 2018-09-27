<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<#assign labInfo>教室借用开关</#assign>
<#include "/templates/help.ftl"/>
    <table class="frameTable_title">
     <tr>
      <td class="infoTitle"></td>
      <form name="paramsForm" method="post" action="" onsubmit="return false;">
      <input type="hidden" name="roomOccupySwitch.calendar.id" value="${calendar.id}"/>
      <#include "/pages/course/calendar.ftl"/>
     </tr>
   </form>
  </table>
  <table class="frameTable" height="85%">
	    <tr>
	     <td class="frameTable_content">
	           <iframe src="#" id="paramsListFrame" name="paramsListFrame" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" height="100%" width="100%"></iframe>
	     </td>
	  </tr>
    </table>
    <script>
        var form = document.paramsForm;
        
        function search() {
            form.action = "roomApplySwitch.do?method=search";
            form.target = "paramsListFrame";
            form.submit();
        }
        
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/>