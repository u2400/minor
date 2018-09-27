<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="task_list" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="taskId"/>
            <@table.sortTd text="课程序号" id="task.seqNo" width="10%"/>
            <@table.sortTd text="课程代码" id="task.course.code" width="10%"/>
            <@table.sortTd text="课程名称" id="task.course.name" width="20%"/>
            <@table.sortTd id="task.courseType.name" width="15%" name="entity.courseType"/>
            <@table.sortTd id="task.teachClass.name" width="15%" name="entity.teachClass"/>
            <@table.td width="10%" name="entity.teacher"/>
            <@table.sortTd width="4%" id="task.course.credits" name="attr.credit"/>
        </@>
        <@table.tbody datas=tasks;task>
            <@table.selectTd id="taskId" value=task.id/>
            <td>${task.seqNo}</td>
            <td>${task.course.code}</td>
            <td>${task.course.name}</td>
            <td title="<@i18nName task.courseType/>" nowrap><span style="display:block;width:100px;overflow:hidden;text-overflow:ellipsis"><@i18nName task.courseType/></span></td>
            <td><#if task.teachClass.gender?exists>(<@i18nName task.teachClass.gender/>)</#if>${task.teachClass.name?html}</td>
            <td title="<@getTeacherNames task.arrangeInfo.teachers/>" nowrap><span style="display:block;width:60px;overflow:hidden;text-overflow:ellipsis"><@getTeacherNames task.arrangeInfo.teachers/></span></td>
            <td>${task.course.credits}</td>
        </@>
    </@>
    <#assign pageTitle = "未绑定教学进度的教学任务列表"/>
    <#include "list_script.ftl"/>
</body>
<#include "/templates/foot.ftl"/>