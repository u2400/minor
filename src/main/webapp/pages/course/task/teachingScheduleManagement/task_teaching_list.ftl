<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <script>var oScheduleMap = {};</script>
    <@table.table id="task_teaching_list" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="taskId"/>
            <@table.sortTd text="课程序号" id="task.seqNo" width="10%"/>
            <@table.sortTd text="课程代码" id="task.course.code" width="10%"/>
            <@table.sortTd text="课程名称" id="task.course.name" width="20%"/>
            <@table.td text="绑定文件"/>
            <@table.td text="绑定人"/>
            <@table.td text="绑定时间"/>
        </@>
        <@table.tbody datas=tasks;task>
            <@table.selectTd id="taskId" value=task.id/>
            <td>${task.seqNo}</td>
            <td>${task.course.code}</td>
            <td>${task.course.name}</td>
            <td>${("<a href=\"teachingScheduleManagement.do?method=download&syllabusId=" + scheduleMap[task.id?string].id + "\">" + scheduleMap[task.id?string].name + "</a>")?if_exists}</td>
            <td>${(scheduleMap[task.id?string].uploadBy.userName)?if_exists}</td>
            <td>${(scheduleMap[task.id?string].uploadAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}</td>
            <#if scheduleMap[task.id?string]?exists>
            <script>oScheduleMap["${task.id}"] = "";</script>
            </#if>
        </@>
    </@>
    <#assign pageTitle = "教学进度绑定情况列表<span style=\"color:blue\">（全部）</span>"/>
    <#include "list_script.ftl"/>
</body>
<#include "/templates/foot.ftl"/>