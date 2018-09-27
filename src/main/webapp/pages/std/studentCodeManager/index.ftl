<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
    <table id="bar"></table>
    <table class="frameTable">
        <tr valign="top">
            <td class="frameTable_view" width="20%" align="center">
                <form method="post" action="" target="contentFrame" name="actionForm" onsubmit="return false;">
                    <#include "/pages/components/initAspectSelectData.ftl"/>
                    <#include "searchForm.ftl"/>
                </form>
            </td>
            <td>
                <iframe name="contentFrame" id="contentFrame" src="#" width="100%" frameborder="0" scrolling="no"></iframe>
            </td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "学号维护", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addHelp("<@msg.message key="action.help"/>");

        var form = document.actionForm;
        function search() {
           form.action="studentCodeManager.do?method=search";
           form.target="contentFrame";
           form.submit();
        }
        search();
    </script>
<#include "/templates/foot.ftl"/>