<#include "/templates/head.ftl"/>
<BODY> 
    <table id="bursaryBar"></table>
    <table class="frameTable_title">
     <tr>
       <td style="width:50px"/>
          <font color="blue"><@bean.message key="action.advancedQuery"/></font>
       </td>
       <td>|</td>
       <form name="bursaryForm" target="bursaryListFrame" method="post" action="bursaryInstructor.do?method=index" onsubmit="return false;">
       <#include "../calendar.ftl" />
       </form>
     </tr>
    </table>
    <table class="frameTable">
        <tr>
            <td valign="top" width="19%" class="frameTable_view">
                <form name="achivementSearchForm" target="bursaryListFrame" method="post" action="bursaryInstructor.do?method=index" onsubmit="return false;">
                <input type="hidden" name="apply.setting.id" value="${setting.id}"/>
                <#include "searchForm.ftl"/>
                </form>
            </td>
            <td valign="top" bgcolor="white">
                <iframe  src="#" id="bursaryListFrame" name="bursaryListFrame" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0"  height="100%" width="100%"></iframe>
            </td>
        </tr>
    </table>
	<script>
		var bar=new ToolBar("bursaryBar","助学金申请审核——辅导员",null,true,true);
        bar.addHelp("<@msg.message key="action.help"/>");
        function search(pageNo,pageSize,orderBy){
            var form = document.achivementSearchForm;
            form.action = "?method=search";
            form.target="bursaryListFrame";
            goToPage(form,pageNo,pageSize,orderBy);
        }
        search();
	</script>
</body>
<#include "/templates/foot.ftl"/> 
  