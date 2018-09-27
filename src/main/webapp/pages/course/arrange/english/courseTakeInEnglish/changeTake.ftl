<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <script>
        var bar = new ToolBar("bar", "转课移班", null, true, true);
    </script>
    <div class="darkColumn" style="text-align:center;font-weight:bold;font-size:12pt">当前要转换的学生和其上的课程(教学任务)</div>
    <#assign isDisplayedSave = false/>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
    <#assign beeanStudentIds = []/>
    <div id="take_div" style="width:100%;height:150px;overflow-y:auto">
    <#list tasksInStudents?sort_by(["take", "student", "code"]) as tasksInStudent>
        <#if !beeanStudentIds?seq_contains(tasksInStudent.take.student.id)>
            <#if tasksInStudent_index != 0>
        <br>
            </#if>
        <table class="infoTable" width="100%">
            <tr>
                <td class="title" width="10%">学号：</td>
                <td width="10%">${tasksInStudent.take.student.code}</td>
                <td class="title" width="10%">姓名：</td>
                <td width="10%">${tasksInStudent.take.student.name}</td>
                <td class="title" width="10%">行政班：</td>
                <td>${(tasksInStudent.take.student.adminClasses?first.name)?if_exists}</td>
                <td class="title" width="10%">语种能力：</td>
                <td>${(tasksInStudent.take.student.languageAbility.name)?if_exists}</td>
            </tr>
            <tr>
                <td class="title">课程序号：</td>
                <td>${tasksInStudent.take.task.seqNo}</td>
                <td class="title">课程代码：</td>
                <td>${tasksInStudent.take.task.course.code}</td>
                <td class="title">课程名称：</td>
                <td>${tasksInStudent.take.task.course.name}</td>
                <td class="title">语种要求：</td>
                <td><#if (tasksInStudent.take.task.requirement.languageAbilities?size)?default(0) gt 0><#list tasksInStudent.take.task.requirement.languageAbilities as ability>${ability.name}<#if ability_has_next>，</#if></#list><#else>-</#if></td>
            </tr>
            <tr>
                <td class="title">上课信息：</td>
                <td colspan="7">${tasksInStudent.take.task.arrangeInfo.digest(tasksInStudent.take.task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],":day :units :weeks :room")?replace(" ,", ", ")?replace(" <br>", ", ")?trim}</td>
            </tr>
        </table>
        </#if>
    </#list>
    </div>
    <hr>
    <div class="darkColumn" style="text-align:center;font-weight:bold;font-size:12pt">当前可转换的教学任务</div>
    <div style="height:2px"></div>
    <#assign isDisplayeSaveInThis = (tasksInStudents?first.tasks?size)?default(0) != 0/>
    <#assign isDisplayedSave = isDisplayedSave || isDisplayeSaveInThis/>
    <#if isDisplayeSaveInThis>
        <#assign tdWidthes = ["", "25px", "65px", "65px", "80px", "130px", "100px", "100px"]/>
    <table id="taskList_title_table" class="listTable" width="100%" style="text-align:center">
        <tr class="darkColumn">
            <td width="${tdWidthes[1]}"></td>
            <@table.td text="课程序号" width=tdWidthes[2]/>
            <@table.td text="课程代码" width=tdWidthes[3]/>
            <@table.td text="课程名称" width=tdWidthes[4]/>
            <@table.td text="课程类别" width=tdWidthes[5]/>
            <@table.td text="语种要求" width=tdWidthes[6]/>
            <@table.td text="实际/上限" width=tdWidthes[7]/>
            <@table.td text="上课信息"/>
        </tr>
    </table>
    <div id="taskList_div" style="width:100%;height:250px;overflow-y:auto">
        <@table.table id="taskInChange_table" width="100%" style="vertical-align:middle">
            <#list tasksInStudents?first.tasks?sort_by("seqNo") as task>
            <tr class="${(task_index % 2 == 0)?string("brightStyle", "grayStyle")}" align="center" onmouseover="swapOverTR(this,this.className)" onmouseout="swapOutTR(this)" onclick="onRowChange(event)">
                <td class="select" style="width:${tdWidthes[1]}"><input type="radio" name="taskId" value="${task.id}"/></td>
                <td width="${tdWidthes[2]}">${task.seqNo}</td>
                <td width="${tdWidthes[3]}">${task.course.code}</td>
                <td width="${tdWidthes[4]}">${task.course.name}</td>
                <td width="${tdWidthes[5]}">${task.courseType.name}</td>
                <td width="${tdWidthes[6]}"><#if (task.requirement.languageAbilities?size)?default(0) gt 0><#list task.requirement.languageAbilities as ability>${ability.name}<#if ability_has_next><br></#if></#list><#else>-</#if></td>
                <td width="${tdWidthes[7]}">${(task.teachClass.courseTakes?size)?default(0)}/${(task.teachClass.planStdCount)?default(0)}</td>
                <td>${task.arrangeInfo.digest(task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],":day :units :weeks :room")?replace(" ,", "<br>")?trim}</td>
            </tr>
            </#list>
        </@>
    </div>
    <hr width="200px" color="black" size="1" align="left">
<pre style="font-size:12pt">
使用说明：
1. 页面的上半部分为当前学生和其所要上的课程，如果“转移”的学生是多个，则该部分右边会出现“滚动条”。
   通过移动“滚动条”，可以进行浏览学生当前的上课信息。
2. 页面下半部分为要且可“转移”的教学任务，选择一条要转换的教学任务进行“转移”。
3. 这里的操作相当于“批量退课”后同时“批量指定”到所选择的一条教学任务中。
</pre>
    <#else>
    <div style="width:100%;text-align:center;color:red;font-size:16pt;font-weight:bold">当前没有可以转换的教学任务！<br>（原因：人数已满或上课时间冲突）</div>
    </#if>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="takeIds" value="${RequestParameters["courseTakeIds"]}"/>
        <input type="hidden" name="path" value="${RequestParameters["path"]?if_exists}"/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
    <#if isDisplayedSave>
        bar.addItem("保存转移", "changeTakeSave()", "save.gif");
    </#if>
    <#if RequestParameters["path"]?default("") == "courseTakeSearch">
        bar.addBack();
    <#else>
        bar.addItem("返回列表", "backSearch()", "backward.gif");
    </#if>
        
        var form = document.actionForm;
        
        function changeTakeSave() {
            if (isEmpty(getSelectId("taskId"))) {
                alert("当前没有(可)设置要转移的教学任务。");
                return;
            }
            if (confirm("确认要如此“转移”吗？")) {
                form.action = "courseTakeInEnglish.do?method=changeTakeSave";
                form.target = "_self";
                form.submit();
            }
        }
        <#if RequestParameters["path"]?default("") != "courseTakeSearch">
        
        function backSearch() {
            try {
                parent.search();
            } catch (e) {
                window.close();
            }
        }
        </#if>
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>