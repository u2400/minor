<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="course_list" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="courseId"/>
            <@table.sortTd text="课程代码" id="course.code" width="10%"/>
            <@table.sortTd text="课程名称" id="course.name" width="20%"/>
            <@table.sortTd text="课程类别" id="course.extInfo.courseType.name"/>
            <@table.sortTd text="开课院系" id="course.extInfo.department.name"/>
            <@table.sortTd text="周课时" id="course.weekHour"/>
        </@>
        <@table.tbody datas=courses;course>
            <@table.selectTd id="courseId" value=course.id/>
            <td>${course.code}</td>
            <td>${course.name}</td>
            <td>${(course.extInfo.courseType.name)?if_exists}</td>
            <td>${(course.extInfo.department.name)?if_exists}</td>
            <td>${(course.weekHour)?if_exists}</td>
        </@>
    </@>
    <#assign pageTitle = "未绑定课程大纲的课程列表"/>
    <#include "list_script.ftl"/>
</body>
<#include "/templates/foot.ftl"/>