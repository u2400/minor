<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="frameTable" height="90%">
        <tr valign="top">
            <td class="frameTable_view" width="20%">
                <form method="post" action="" name="actionForm" onsubmit="return false;">
                <#include "searchForm.ftl"/>
                </form>
            </td>
            <td>
                <iframe id="pageIframe" name="pageIframe" src="#" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
            </td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "课程大纲管理", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addBlankItem();
        
        var oForm = document.actionForm;
        
        function search() {
            oForm.action = "syllabusManagement.do?method=search";
            oForm.target = "pageIframe";
            oForm.submit();
        }
        
        function searchControl(oControl) {
            oForm["syllabus.name"].disabled = null != oControl && undefined != oControl && "0" == oControl.value;
            oForm["syllabus.name"].value = null != oControl && undefined != oControl && "0" == oControl.value ? "" : oForm["syllabus.name"].value;
        }
        
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/>