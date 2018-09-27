<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="frameTable" width="100%" height="95%">
        <tr valign="top">
            <form method="post" action="" name="actionForm" onsubmit="return false;">
               <input type="hidden" value="apply.applyAt desc" name="orderBy">
            <td class="frameTable_view" width="20%">
                <#include "searchForm.ftl"/>
            </td>
            </form>
            <td><iframe id="pageIframe" name="pageIframe" src="#" width="100%" height="100%" frameborder="0" scrolling="no"></iframe></td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "学生主要信息修改审核", null, true, true);
        bar.addHelp();
        var form = document.actionForm;
        function search() {
            form.action = "studentInfoAlterAudit.do?method=search";
            form.target = "pageIframe";
            form.submit();
        }
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/>
