<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <div>可指定的教学任务：</div>
    <@table.table id="taskTable" width="100%" sortable="false">
        <@table.thead>
            <@table.selectAllTd id="taskId"/>
            <@table.td text="课程序号" width="30%"/>
            <@table.td text="行政班"/>
        </@>
        <@table.tbody datas=tasks;task>
            <@table.selectTd id="taskId" value=task.id/>
            <td>${task.seqNo}</td>
            <td>${(task.teachClass.name)?if_exists}</td>
        </@>
    </@>
    <div style="height:20px"></div>
    <div>学生名单：</div>
    <@table.table id="studentTable" width="100%" sortable="false">
        <@table.thead>
            <@table.selectAllTd id="studentId"/>
            <@table.td text="学号" width="30%"/>
            <@table.td text="姓名" width="30%"/>
            <@table.td text="班级"/>
        </@>
        <@table.tbody datas=students;student>
            <@table.selectTd id="studentId" value=student.id/>
            <td>${student.code}</td>
            <td>${student.name}</td>
            <td>${(student.firstMajorClass.name)?if_exists}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="taskIds" value=""/>
        <input type="hidden" name="studentIds" value=""/>
        <input type="hidden" name="courseId" value=""/>
        <input type="hidden" name="calendarId" value=""/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "未选课学生名单　<span style=\"color:blue\">课程代码：${tasks?first.course.code}　课程名称：${tasks?first.course.name}</span>", null, true, true);
        oBar.addItem("指定", "appoint()");
        oBar.addItem("随机", "random()");
        oBar.addBack();
        
        var oForm = document.actionForm;
        var isExecuting = false;
        
        function initData() {
            oForm["taskIds"].value = oForm["studentIds"].value = oForm["courseId"].value = oForm["calendarId"].value = "";
        }
        
        function appoint() {
            initData();
            if (isExecuting) {
                alert("当前操作正在执行中...");
                return;
            }
            
            var sStudentIds = getSelectIds("studentId");
            if (null == sStudentIds || undefined == sStudentIds || "" == sStudentIds) {
                alert("请选择要操作的学生。");
                return;
            }
            
            var sTaskIds = getSelectIds("taskId");
            if (null == sTaskIds || undefined == sTaskIds || "" == sTaskIds) {
                alert("请选择要操作的教学任务。");
                return;
            }
            
            oForm["studentIds"].value = sStudentIds;
            oForm["taskIds"].value = sTaskIds;
            oForm.action = "teachTask.do?method=appointStd";
            oForm.target = "_self";
            oForm.submit();
            isExecuting = true;
        }
        
        function random() {
            initData();
            if (isExecuting) {
                alert("当前操作正在执行中...");
                return;
            }
            
            var sStudentIds = getSelectIds("studentId");
            if (null == sStudentIds || undefined == sStudentIds || "" == sStudentIds) {
                alert("请选择要操作的学生。");
                return;
            }
            
            oForm["studentIds"].value = sStudentIds;
            oForm["courseId"].value = "${tasks?first.course.id}";
            oForm["calendarId"].value = "${tasks?first.calendar.id}";
            oForm.action = "teachTask.do?method=randomStd";
            oForm.target = "_self";
            oForm.submit();
            isExecuting = true;
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>