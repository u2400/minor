<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="infoTable" width="100%">
        <tr>
            <td class="title" style="width:8%">课程序号</td>
            <td style="width:10%">${task.seqNo}</td>
            <td class="title" style="width:8%">课程代码</td>
            <td style="width:15%">${task.course.code}</td>
            <td class="title" style="width:8%">课程名称</td>
            <td style="width:15%">${task.course.name}</td>
            <td class="title" style="width:15%">年级</td>
            <td>${(task.teachClass.enrollTurn)?if_exists}</td>
        </tr>
        <tr>
            <td class="title">学分</td>
            <td>${task.course.credits}</td>
            <td class="title">课程类别</td>
            <td>${task.courseType.name}</td>
            <td class="title">语种要求</td>
            <td><#if (task.requirement.languageAbilities?size)?default(0) gt 0><#list task.requirement.languageAbilities as ability>${ability.name}<#if ability_has_next>，</#if></#list><#else>-</#if></td>
            <td class="title">人数情况(实/计)</td>
            <td>${(task.teachClass.courseTakes?size)?default(0)}/${task.teachClass.planStdCount?default(0)}</td>
        </tr>
        <tr>
            <td class="title">上课信息</td>
            <td colspan="7">${task.arrangeInfo.digest(task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],":day :units :weeks :room")?replace(" ,", ", ")?replace(" <br>", ", ")?trim}</td>
        </tr>
    </table>
    <br>
    <#if validStudents?size == 0>
    <div style="width:100%;text-align:center;color:red;font-size:16pt;font-weight:bold">当前没有可以添加的学生！<br>（原因：1. 没有设置或匹配的等级；2. 匹配的学生已经加完了；3. 教学任务没有排课）</div>
    <#else>
        <@table.table id="validStudentTable" sortable="true" width="100%">
            <@table.thead>
                <@table.selectAllTd id="studentId"/>
                <@table.sortTd text="学号" id="student.code" width="10%"/>
                <@table.sortTd text="姓名" id="student.name" width="10%"/>
                <@table.sortTd text="年级" id="student.enrollYear" width="10%"/>
                <@table.sortTd text="院系" id="student.department.name"/>
                <@table.sortTd text="专业" id="student.firstMajor.name"/>
                <@table.sortTd text="专业方向" id="student.firstAspect.name"/>
                <@table.td text="行政班" width="10%"/>
                <@table.sortTd text="语种能力" id="student.languageAbility.name" width="10%"/>
            </@>
            <@table.tbody datas=validStudents;validStudent>
                <@table.selectTd id="studentId" value=validStudent.id/>
                <td>${validStudent.code}</td>
                <td>${validStudent.name}</td>
                <td>${validStudent.enrollYear}</td>
                <td>${validStudent.department.name}</td>
                <td>${(validStudent.firstMajor.name)?if_exists}</td>
                <td>${(validStudent.firstAspect.name)?if_exists}</td>
                <td>${(validStudent.adminClasses?first.name)?if_exists}</td>
                <td>${validStudent.languageAbility.name}</td>
            </@>
        </@>
    </#if>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="taskId" value="${task.id}"/>
        <input type="hidden" name="calendarId" value="${task.calendar.id}"/>
        <input type="hidden" name="studentIds" value=""/>
        <input type="hidden" name="source" value="${RequestParameters["source"]}"/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="&calendarId=${task.calendar.id}&source=${RequestParameters["source"]}"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "可添加的学生名单", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("添加", "addStudent()");
        bar.addItem("返回列表", "backSearch()", "backward.gif");
        
        var form = document.actionForm;
        
        function addStudent() {
            var studentIds = getSelectId("studentId");
            if (isEmpty(studentIds)) {
                alert("请选择要添加的学生。");
                return;
            }
            var addSize = studentIds.split(",").length;
            var validSize = ${task.teachClass.planStdCount?default(0)} - ${(task.teachClass.courseTakes?size)?default(0)};
            if (validSize < 0) {
                validSize = 0;
            }
            if (${(task.teachClass.courseTakes?size)?default(0)} + addSize > ${task.teachClass.planStdCount?default(0)}) {
                alert(autoWardString("当前教学任务只能添加 " + validSize + " 位学生，而现在选择了 " + addSize + " 位学生。", 50));
                return;
            }
            form.action = "courseTakeInEnglish.do?method=addStudent";
            form.target = "_self";
            form["studentIds"].value = studentIds;
            form.submit();
        }
        
        function backSearch() {
            try {
                parent.vacancyStat();
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
