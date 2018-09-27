<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="frameTable" width="100%" height="95%">
        <tr valign="top">
            <form method="post" action="" name="actionForm" onsubmit="return false;">
            <td class="frameTable_view" width="20%">
                <#include "searchForm.ftl"/>
            </td>
                <input type="hidden" name="templateDocumentId" value="17"/>
                <input type="hidden" name="document.id" value="17"/>
                <input type="hidden" name="importTitle" value="学生英语等级导入"/>
            </form>
            <td><iframe id="pageIframe" name="pageIframe" src="#" width="100%" height="100%" frameborder="0" scrolling="no"></iframe></td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "学生英语等级管理", null, true, true);
        var menu1 = bar.addMenu("导入", "importData()");
        menu1.addItem("下载模板", "downloadTemplate()");
        
        var form = document.actionForm;
        
        function search() {
            form.action = "studentAbility.do?method=search";
            form.target = "pageIframe";
            form.submit();
        }
        
        function importData() {
            form.action = "studentAbility.do?method=importForm";
            form.target = "pageIframe";
            form.submit();
        }
        
        function downloadTemplate() {
            form.action = "dataTemplate.do?method=download";
            form.target = "_self";
            form.submit();
        }
        
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/>
