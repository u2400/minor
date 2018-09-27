<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="infoTable">
        <tr>
            <td class="darkColumn" style="text-align:center;font-weight:bold">教学任务</td>
        </tr>
    </table>
    <table class="infoTable">
        <tr>
            <td class="title" style="width:20%">课程序号</td>
            <td width="30%">${task.seqNo}</td>
            <td class="title" style="width:20%">课程名称</td>
            <td>${task.course.name}</td>
        </tr>
        <tr>
            <td class="title" style="width:20%">学生类别</td>
            <td>${task.calendar.studentType.name}</td>
            <td class="title" style="width:20%">教学日历</td>
            <td>${task.calendar.year}&nbsp;${task.calendar.term}</td>
        </tr>
    </table>
    <div style="height:25px"></div>
    <table class="listTable" width="100%" align="center" style="text-align:center">
        <tr class="darkColumn">
            <td width="10%">书号</td>
            <td width="20%">教材名称</td>
            <td>作者</td>
            <td><@msg.message key="entity.press"/></td>
            <td width="12%">出版时间</td>
            <td width="10%">定价</td>
            <td width="10%">折扣</td>
        </tr>
        <#list task.requirement.textbooks as textbook>
        <tr<#if textbook_index % 2 == 1> class="grayStyle"</#if>>
            <td>${textbook.code}</td>
            <td>${textbook.name}</td>
            <td>${textbook.auth}</td>
            <td><@i18nName textbook.press/></td>
            <td>${textbook.publishedOn?string("yyyy-MM")}</td>
            <td>${textbook.price}</td>
            <td>${textbook.onSell?if_exists}</td>
        </tr>
        </#list>
    </table>
    <script>
        var bar = new ToolBar("bar", "指定教材查看", null, true, true);
        bar.addBack();
    </script>
</body>
<#include "/templates/foot.ftl"/>