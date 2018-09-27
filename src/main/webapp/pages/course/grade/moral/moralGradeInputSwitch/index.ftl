<#include "/templates/head.ftl"/>
<BODY> 
    <table id="moralSwitchBar"></table>
    <table class="frameTable_title">
     <tr>
       <td style="width:50px"></td>
       <td ></td>
       <form name="moralSwitchForm" target="moralSwitchListFrame" method="post" action="?method=index" onsubmit="return false;">
       <input name="moralGradeInputSwitch.calendar.id" value="${calendar.id}" type="hidden"/>
       <#include "../calendar.ftl" />
       </form>
     </tr>
    </table>
    <#include "/pages/components/initAspectSelectData.ftl"/>
    <table class="frameTable">
        <tr>
            <td valign="top" bgcolor="white">
                <iframe  src="#" id="moralSwitchListFrame" name="moralSwitchListFrame" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0"  height="100%" width="100%"></iframe>
            </td>
        </tr>
    </table>
	<script>
		var bar=new ToolBar("moralSwitchBar","德育成绩录入开关管理",null,true,true);
        search();
        function search(pageNo,pageSize,orderBy){
            var form = document.moralSwitchForm;
            form.action = "?method=search";
            form.target="moralSwitchListFrame";
            goToPage(form,pageNo,pageSize,orderBy);
        }
	</script>
</body>
<#include "/templates/foot.ftl"/> 
