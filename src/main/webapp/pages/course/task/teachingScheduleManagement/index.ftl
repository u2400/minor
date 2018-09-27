<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="frameTable_title" width="100%" border="0">
    <form name="actionForm" action="" method="post" onsubmit="return false;">
        <tr style="font-size: 10pt;" align="left">
            <td></td>
            <td></td>
        <#include "/pages/course/calendar.ftl"/>
        </tr>
    </table>
    <table class="frameTable" width="100%">
        <tr valign="top">
            <td class="frameTable_view" width="20%">
                <input type="hidden" name="schedule.task.calendar.id" value="${(calendar.id)?if_exists}"/>
                <input type="hidden" name="task.calendar.id" value="${(calendar.id)?if_exists}"/>
                <#include "searchForm.ftl"/>
            </td>
    </form>
            <td><iframe id="pageIframe" name="pageIframe" src="#" width="100%" height="100%" frameborder="0" scrolling="no"></iframe></td>
        </tr>
    </table>
    <script>
        var oBar = new ToolBar("bar", "教学进度管理", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addBlankItem();
        
        var oForm = document.actionForm;
        
        function search() {
            oForm.action = "teachingScheduleManagement.do?method=search";
            oForm.target = "pageIframe";
            oForm.submit();
        }
        
        function searchControl(oControl) {
            oForm["schedule.name"].disabled = null != oControl && undefined != oControl && "0" == oControl.value;
            oForm["schedule.name"].value = null != oControl && undefined != oControl && "0" == oControl.value ? "" : oForm["schedule.name"].value;
        }
        
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/>