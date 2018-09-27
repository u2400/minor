<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="frameTable" width="100%" height="90%">
        <tr valign="top">
            <form method="post" action="" name="actionForm" onsubmit="return false;">
            <td class="frameTable_view" width="200px">
                <#include "searchForm.ftl"/>
            </td>
            </form>
            <td><iframe id="pageIframe" name="pageIframe" src="#" marginwidth="0" marginheight="0"  width="100%" height="95%" frameborder="0" scrolling="no"></iframe></td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "分配院系可借用的教师", null, true, true);
        bar.addBlankItem();
        
        var form = document.actionForm;
        
        function search() {
            form.action = "applyRoomInDepartment.do?method=search";
            form.target = "pageIframe";
            form.submit();
        }
        
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/>