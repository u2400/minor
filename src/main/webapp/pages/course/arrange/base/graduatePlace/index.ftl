<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="frameTable" width="100%">
        <tr valign="top">
            <form method="post" action="" name="actionForm" onsubmit="return false">
            <td class="frameTable_view" width="180px">
                <#include "searchForm.ftl"/>
            </td>
            </form>
            <td><iframe id="pageIframe" name="pageIframe" src="#" marginwidth="0" marginheight="0" frameborder="0" height="100%" width="100%" scrolling="no"></iframe></td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "毕业实习基地基础信息维护", null, true, true);
        bar.addBlankItem();
        
        var form = document.actionForm;
        
        function search() {
            form.action = "graduatePlace.do?method=search";
            form.target = "pageIframe";
            form.submit();
        }
        
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/>