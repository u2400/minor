<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <script>var oSyllabusMap = {};</script>
    <@table.table id="course_syllabus_list" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="courseId"/>
            <@table.sortTd text="课程代码" id="course.code" width="10%"/>
            <@table.sortTd text="课程名称" id="course.name" width="20%"/>
            <@table.td text="绑定文件"/>
            <@table.td text="绑定人"/>
            <@table.td text="绑定时间"/>
        </@>
        <@table.tbody datas=courses;course>
            <@table.selectTd id="courseId" value=course.id/>
            <td>${course.code}</td>
            <td>${course.name}</td>
            <td>${("<a href=\"syllabusManagement.do?method=download&syllabusId=" + syllabusMap[course.id?string].id + "\">" + syllabusMap[course.id?string].name + "</a>")?if_exists}</td>
            <td>${(syllabusMap[course.id?string].uploadBy.userName)?if_exists}</td>
            <td>${(syllabusMap[course.id?string].uploadAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}</td>
            <#if syllabusMap[course.id?string]?exists>
            <script>oSyllabusMap["${course.id}"] = "";</script>
            </#if>
        </@>
    </@>
    <#assign pageTitle = "课程大纲绑定情况列表<span style=\"color:blue\">（全部）</span>"/>
    <#include "list_script.ftl"/>
</body>
<#include "/templates/foot.ftl"/>