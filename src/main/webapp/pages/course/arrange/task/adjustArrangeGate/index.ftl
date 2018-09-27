<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="frameTable_title" width="100%">
        <form method="post" action="" name="actionForm" onsubmit="return false;">
        <tr>
            <td></td>
            <input type="hidden" name="adjust.task.calendar.id" value="${calendar.id}"/>
            <#include "/pages/course/calendar.ftl"/>
        </tr>
    </table>
    <table class="frameTable" width="100%" height="90%">
        <tr valign="top">
            <td class="frameTable_view" width="180px">
                <#include "searchForm.ftl"/>
            </td>
        </form>
            <td><iframe id="pageIframe" name="pageIframe" src="#" marginwidth="100%" marginheight="100%" scrolling="no" frameborder="0" height="100%" width="100%"></iframe></td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "调停课审批", null, true, true);
        bar.addBlankItem();
        
        var form = document.actionForm;
        
        function search() {
            form.action = "adjustArrangeGate.do?method=search";
            form.target = "pageIframe";
            form.submit();
        }
        
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/>