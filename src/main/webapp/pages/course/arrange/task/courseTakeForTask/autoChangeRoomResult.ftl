<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="infoTable" width="100%" style="text-align:center">
        <tr>
            <td class="title" style="text-align:center;width:10%">课程序号</td>
            <td class="title" style="text-align:center;width:10%">课程代码</td>
            <td class="title" style="text-align:center">课程名称</td>
            <td class="title" style="text-align:center;width:10%">实际人数</td>
            <td class="title" style="text-align:center;width:50%">更换情况</td>
        </tr>
        <#list tasks?sort_by("seqNo") as task>
        <tr<#if task_index % 2 == 1> style="background-color:Gainsboro"</#if>>
            <td>${task.seqNo}</td>
            <td>${task.course.code}</td>
            <td>${task.course.name}</td>
            <td>${task.teachClass.courseTakes?size}</td>
            <td>${resultMap[task.id?string]}</td>
        </tr>
        </#list>
    </table>
    <script>
        var bar = new ToolBar("bar", "自动更换教室结果", null, true, true);
        bar.setMessage('<@getMessage/>')
        bar.addItem("返回列表", "parent.searchTask()", "backward.gif");
    </script>
</body>
<#include "/templates/foot.ftl"/>