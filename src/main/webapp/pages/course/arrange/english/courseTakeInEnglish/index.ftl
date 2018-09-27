<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="frameTable_title" width="100%">
        <form method="post" action="" name="actionForm" onsubmit="return false;">
        <tr>
            <td width="10%" style="text-align:right">统计状态：</td>
            <td width="10%">
                <select name="statMode" style="width:100%" onchange="search()">
                    <option value="1" selected>匹配</option>
                    <option value="0">不匹配</option>
                </select>
            </td>
            <td style="width:0mm">|</td>
            <td>
                <input type="hidden" name="courseTake.task.calendar.id" value="${calendar.id}"/>
                <#include "/pages/course/calendar.ftl"/>
            </td>
        </tr>
    </table>
    <table class="frameTable" width="100%" height="90%">
        <tr valign="top">
            <td class="frameTable_view" width="20%"><#include "searchForm.ftl"/></td>
            <input type="hidden" name="source" value="index"/>
        </form>
            <td><iframe id="pageIframe" name="pageIframe" name="#" width="100%" height="90%" frameborder="0" scrolling="no"></iframe></td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "英语等级上课名单（教学班）", null, true, true);
        var menu1 = bar.addMenu("未选名单", "unCourseTake()");
        menu1.addItem("教学班不满统计", "vacancyStat()");
        
        var form = document.actionForm;
        
        function search() {
            form.action = "courseTakeInEnglish.do?method=search";
            form.target = "pageIframe";
            form.submit();
        }
        
        function unCourseTake() {
            form.action = "courseTakeInEnglish.do?method=validStudentSearch";
            form.target = "pageIframe";
            form.submit();
        }
        
        function vacancyStat() {
            form.action = "courseTakeInEnglish.do?method=vacancyStat";
            form.target = "pageIframe";
            form.submit();
        }
        
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/>