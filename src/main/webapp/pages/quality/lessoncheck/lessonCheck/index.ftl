<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
 <#assign labInfo>督导组听课信息列表</#assign>
 <#include "/templates/help.ftl"/>
    <table  class="frameTable_title">
        <tr>
	        <td style="width:50px"><font color="blue"><@bean.message key="action.advancedQuery"/></font></td>
            <td>|</td>
           <form name="teachAccidentForm" method="post" action="lessonCheck.do?method=index" onsubmit="return false;">
            <input type="hidden" name="lessonCheck.calendar.id" value="${calendar.id}" />
            <#include "/pages/course/calendar.ftl"/>
        </tr>
    </table>
    <table class="frameTable_title">
        <tr>
            <td valign="top"  style="width:160px" class="frameTable_view">
                <#include "searchTable.ftl"/>
            </td>
          </form>
            <td valign="top" bgcolor="white">
                <iframe  src="#" id="teachAccidentQueryFrame" name="teachAccidentQueryFrame" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"  height="100%" width="100%"></iframe>
            </td>
        </tr>
    </table>
 <script language="javascript">
    var form=document.teachAccidentForm;
    action="lessonCheck.do";
 	function search(){
       form.action=action="?method=search";
       form.target="teachAccidentQueryFrame";
       form.submit();
 	}
 	search();
 </script>
<#include "/templates/foot.ftl"/>