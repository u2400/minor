<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#assign tdWidthes = ["", "25px", "65px", "65px", "80px", "130px", "100px", "100px"]/>
    <@table.table id="addTakeTable" width="100%" style="vertical-align:middle">
        <@table.thead>
            <td width="${tdWidthes[1]}"></td>
            <@table.td text="课程序号" width=tdWidthes[2]/>
            <@table.td text="课程代码" width=tdWidthes[3]/>
            <@table.td text="课程名称" width=tdWidthes[4]/>
            <@table.td text="课程类别" width=tdWidthes[5]/>
            <@table.td text="语种要求" width=tdWidthes[6]/>
            <@table.td text="实际/计划人数" width=tdWidthes[7]/>
            <@table.td text="上课信息"/>
        </@>
        <script>var taskMap = {};</script>
        <@table.tbody datas=tasks?sort_by("seqNo");task>
            <@table.selectTd type="radio" id="taskId" value=task.id/>
            <td>${task.seqNo}</td>
            <td>${task.course.code}</td>
            <td>${task.course.name}</td>
            <td>${task.courseType.name}</td>
            <td><#if (task.requirement.languageAbilities?size)?default(0) gt 0><#list task.requirement.languageAbilities as ability>${ability.name}<#if ability_has_next><br></#if></#list><#else>-</#if></td>
            <td>${(task.teachClass.courseTakes?size)?default(0)}/${(task.teachClass.planStdCount)?default(0)}</td>
            <script>taskMap["${task.id}"] = {"seqNo":"${task.seqNo}", "takeSize":${(task.teachClass.courseTakes?size)?default(0)}};</script>
            <td>${task.arrangeInfo.digest(task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],":day :units :weeks :room")?replace(" ,", "<br>")?trim}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="taskId" value=""/>
        <input type="hidden" name="source" value="vacancyStat"/>
        <input type="hidden" name="path" value="vacancyStat"/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "教学班(教学任务)不满统计", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("添加学生", "validStudentSearch()", "new.gif");
        bar.addItem("调整学生", "courseTake()", "update.gif");
        bar.addItem("返回列表", "backSearch()", "backward.gif");
        
        var form = document.actionForm;
        
        function validStudentSearch() {
            var taskId = getSelectId("taskId");
            if (isEmpty(taskId)) {
                alert("请选择要操作的记录。");
                return;
            }
            form.action = "courseTakeInEnglish.do?method=validStudentSearch";
            form.target = "_self";
            form["taskId"].value = taskId;
            form.submit();
        }
        
        function courseTake() {
            var taskId = getSelectId("taskId");
            if (isEmpty(taskId)) {
                alert("请选择一条要操作的记录。");
                return;
            }
            if (taskMap[taskId].takeSize == 0) {
                alert(autoWardString("当前课程序号为 " + taskMap[taskId].seqNo +" 教学任务的人数为 0 人，故无需调整。", 50));
                return;
            }
            form.action = "courseTakeInEnglish.do?method=courseTakeSearch";
            form.target = "_self";
            form["taskId"].value = taskId;
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