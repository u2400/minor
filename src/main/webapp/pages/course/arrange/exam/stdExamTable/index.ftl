<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="taskListBar" width="100%"> </table>
<script>
   var bar = new ToolBar("taskListBar","<@msg.message key="info.courseList"/>",null,true,true);
   bar.setMessage('<@getMessage/>');
</script>
   <table class="frameTable_title" width="100%" border="0">
    <form name="calendarForm" action="stdExamTable.do?method=index" method="post">
    <input type="hidden" name="pageNo" value="1" /> 
     <tr style="font-size: 10pt;" align="left">
     <td>&nbsp;</td>
     <td><@msg.message key="common.examType"/>:
           <#assign examTypes=examTypes?sort_by("code")>
           <select name="examType.id" onchange="changeExamType(this.value);">
             <#list examTypes as examType>
             <option value="${examType.id}"><@i18nName examType/></option>	
             </#list>
          </select>
     </td>
     <td>&nbsp;<@bean.message key="attr.yearAndTerm"/></td>
        <#include "/pages/course/calendar.ftl"/>
        </form>
        </tr>
    </table>
    <table width="100%" height="90%" class="frameTable">
       <tr><td valign="top">
	     <iframe  src="stdExamTable.do?method=examTable&calendar.id=${calendar.id}&examType.id=${examTypes?first.id}"
	     id="examTableFrame" name="examTableFrame" scrolling="no"
	     marginwidth="0" marginheight="0" frameborder="0"  height="100%" width="100%">
	     </iframe>
        </td></tr>
    </table>
    <script>
       function changeExamType(examTypeId){
           var form =document.calendarForm;
           form.action="stdExamTable.do?method=examTable&calendar.id=${calendar.id}&examType.id="+examTypeId;
           form.target="examTableFrame";
           form.submit();
       }
    </script>
</body>
<#include "/templates/foot.ftl"/>