<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table width="100%" id="listTable" style="word-break:break-all">
        <@table.thead>
            <@table.td text="开课院系"/>
            <@table.td text="授课教师" width="8%"/>
            <@table.td text="课程代码"/>
            <@table.td text="课程名称" width="10%"/>
            <@table.td text="教学班名称" width="20%"/>
            <@table.td text="教材名称"/>
            <@table.td text="主编"/>
            <@table.td text="出版社及出版时间" width="8%"/>
            <@table.td text="书号"/>
            <@table.td text="选课人数"/>
        </@>
        <@table.tbody datas=results;result>
            <td>${result[0].name}</td>
            <td><#list result[1] as teacher>${teacher.name}<#if teacher_has_next>、</#if></#list></td>
            <td>${result[2].code}</td>
            <td>${result[2].name}</td>
            <td><#if result[3]?exists && result[3]?size != 0><#list result[3] as adminclass>${adminclass.name}<#if adminclass_has_next>&nbsp;</#if></#list><#else>${result[6]}</#if></td>
            <td>${result[4].name}</td>
            <td>${result[4].auth?if_exists}</td>
            <td>${(result[4].press.name)?if_exists}${(result[4].publishedOn?string("yyyy年"))?if_exists}</td>
            <td>${(result[4].code)?if_exists}</td>
            <td>${result[5]}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="require.task.calendar.id" value="${RequestParameters["require.task.calendar.id"]}"/>
        <input type="hidden" name="fileName" value="审核通过教材统计结果导出"/>
        <input type="hidden" name="keys" value="department.name,teacherNames,course.code,course.name,adminClassNames,book.name,book.auth,book.press_publishOn,book.code,takeStudentCount"/>
        <input type="hidden" name="titles" value="开课院系,授课教师,课程代码,课程名称,教学班名称,教材名称,主编,出版社及出版时间,书号,选课人数"/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "统计结果", null, true, true);
        oBar.addItem("通过导出", "exportData()", "excel.png");
        oBar.addPrint();
        
        var oForm = document.actionForm;
        
        function exportData() {
            oForm.action = "bookRequireStat.do?method=export";
            oForm.target = "_self";
            oForm.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>