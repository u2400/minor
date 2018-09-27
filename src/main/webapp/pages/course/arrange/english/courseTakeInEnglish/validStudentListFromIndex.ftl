<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="validStudentTable" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="studentId"/>
            <@table.sortTd text="学号" id="student.code" width="10%"/>
            <@table.sortTd text="姓名" id="student.name" width="10%"/>
            <@table.td text="行政班" width="10%"/>
            <@table.sortTd text="语种能力" id="student.languageAbility.name" width="15%"/>
            <@table.td text="未(漏)选课程" width="50%"/>
        </@>
        <@table.tbody datas=validStudents;validStudent>
            <@table.selectTd id="studentId" value=validStudent.id/>
            <td>${validStudent.code}</td>
            <td>${validStudent.name}</td>
            <td>${(validStudent.adminClasses?first.name)?if_exists}</td>
            <td>${validStudent.languageAbility.name}</td>
            <#assign courseNames><#list thisObject.noTakeCourseFind(validStudent, calendarId, realmDeparts)?sort_by("name") as course>${course.name}(${course.code})<#if course_has_next>, </#if></#list></#assign>
            <td title="${courseNames?html}" nowrap><span style="display:block;width:400px;overflow:hidden;text-overflow:ellipsis" onclick="onRowChange(event)">${courseNames}</span></td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="calendarId" value="${calendarId}"/>
        <input type="hidden" name="studentId" value=""/>
        <input type="hidden" name="source" value="${RequestParameters["source"]}"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "未(漏)选名单", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("查看", "info()");
        bar.addItem("指定任务", "addTake()", "new.gif");
        bar.addItem("返回列表", "backSearch()", "backward.gif");
        
        var form = document.actionForm;
        
        function info() {
            var studentId = getSelectId("studentId");
            if (isEmpty(studentId) || studentId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            form.action = "courseTakeInEnglish.do?method=validStudentInfo";
            form.target = "_self";
            form["studentId"].value = studentId;
            form.submit();
        }
        
        function addTake() {
            var studentId = getSelectId("studentId");
            if (isEmpty(studentId) || studentId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            form.action = "courseTakeInEnglish.do?method=addTake";
            form.target = "_self";
            form["studentId"].value = studentId;
            form.submit();
        }
        
        function backSearch() {
            try {
                parent.search();
            } catch (e) {
                window.close();
            }
        }
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>
