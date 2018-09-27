<#include "/templates/head.ftl"/>
<script src='dwr/interface/stdGrade.js'></script>
<script src='dwr/interface/courseDao.js'></script>
<body>
    <table id="bar" width="100%"></table>
    <table class="frameTable" width="100%" height="90%">
        <tr valign="top">
            <td class="frameTable_view" width="20%">
                <form method="post" action="" name="actionForm" onsubmit="return false;">
                <#include "searchForm.ftl"/>
                </form>
            </td>
            <td><iframe id="pageIframe" name="pageIframe" src="#" width="100%" height="100%" frameborder="0" scrolling="no"></iframe></td>
        </tr>
    </table>
    <script>
        var oBar = new ToolBar("bar", "推免申请结果", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addBlankItem();
        
        var oForm = document.actionForm;
        
        function search() {
            oForm.action = "exemptionManagement.do?method=search";
            oForm.target = "pageIframe";
            oForm.submit();
        }
        
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/>