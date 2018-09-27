<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="infoTable" width="100%">
        <tr>
            <td class="title" style="width:8%">学号</td>
            <td style="width:10%">${student.code}</td>
            <td class="title" style="width:8%">姓名</td>
            <td style="width:20%">${student.name}</td>
            <td class="title" style="width:8%">年级</td>
            <td style="width:15%">${student.enrollYear}</td>
            <td class="title" style="width:8%">院系</td>
            <td>${student.department.name}</td>
        </tr>
        <tr>
            <td class="title">专业</td>
            <td>${(student.firstMajor.name + "(" + student.firstMajor.code + ")")?if_exists}</td>
            <td class="title">专业方向</td>
            <td>${(student.firstAspect.name + "(" + student.firstAspect.code + ")")?if_exists}</td>
            <td class="title">行政班</td>
            <td><#list (student.adminClasses?sort_by("name"))?if_exists as adminClass>${adminClass.name}(${adminClass.code})<#if adminClass_has_next>, </#if></#list></td>
            <td class="title">语种能力</td>
            <td>${student.languageAbility.name}</td>
        </tr>
    </table>
    <br>
    <@table.table id="noTakeCourseTable" width="100%">
        <@table.thead>
            <@table.td text="课程代码" width="33%"/>
            <@table.td text="课程名称" width="33%"/>
            <@table.td text="学分"/>
        </@>
        <@table.tbody datas=noTakeCourses?sort_by("code");course>
            <td>${course.code}</td>
            <td>${course.name}</td>
            <td>${course.credits}</td>
        </@>
    </@>
    <script>
        var bar = new ToolBar("bar", "未(漏)选课程查看", null, true, true);
        bar.addBack();
    </script>
</body>
<#include "/templates/foot.ftl"/>
