<#include "/templates/head.ftl"/>
<body>
    <table id="bar"></table>
    <#if (stdTypeList?first.id)?exists>
    <table class="frameTable" width="100%">
        <tr valign="top">
            <form method="post" action="" name="actionForm" onsubmit="return false;">
            <td class="frameTable_view" width="20%"><#include "searchForm.ftl"/></td>
            </form>
            <td><iframe name="pageIframe" src="#" width="100%" frameborder="0" scrolling="no"></iframe></td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "培养计划课程统计结果", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addBlankItem();
        
        var form = document.actionForm;
        
        function search() {
            form.action = "teachPlanCourseStat.do?method=search";
            form.target = "pageIframe";
            form.submit();
        }
        
        search();
    </script>
     <#else>
   <center><h1><font color="red">请先配置“<a href="studentType.do" target="studentType_window">学生类别</a>”。</font></h1></center>
   <script>
    var bar = new ToolBar("bar", "培养计划课程统计结果", null, true, true);
    bar.addBlankItem();
   </script>
   </#if>
</body>
<#include "/templates/foot.ftl"/>