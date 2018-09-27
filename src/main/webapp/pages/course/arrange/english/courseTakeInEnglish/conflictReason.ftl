<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="conflictReasonTable" sortable="true" width="100%">
        <@table.thead>
            <@table.td text="学号"/>
            <@table.td text="姓名" width="5%"/>
            <@table.td text="行政班" width="5%"/>
            <@table.td text="课程序号" width="8%"/>
            <@table.td text="课程代码" width="8%"/>
            <@table.td text="课程名称" width="8%"/>
            <@table.td text="实际/要求语种" width="15%"/>
            <@table.td text="实际/上限(人数)" width="15%"/>
            <@table.td text="上课信息" width="25%"/>
        </@>
        <#assign content = ""/>
        <#list outSideObjects as outSideObject>
        <tr class="${(outSideObject_index % 2 == 0)?string("brightStyle", "grayStyle")}">
            <td style="text-align:center">${outSideObject.student.code}</td>
            <td style="text-align:center">${outSideObject.student.name}</td>
            <td style="text-align:center">${outSideObject.student.adminClasses?first.name}</td>
            <#if (outSideObject.task)?exists>
            <td style="text-align:center">${outSideObject.task.seqNo}</td>
            <td style="text-align:center">${outSideObject.task.course.code}</td>
            <td style="text-align:center">${outSideObject.task.course.name}</td>
            <td style="text-align:center">${outSideObject.student.languageAbility.name}/<#list outSideObject.task.requirement.languageAbilities as ability>${ability.name}<#if ability_has_next>,</#if></#list></td>
            <td style="text-align:center">${outSideObject.task.teachClass.courseTakes?size}/${(outSideObject.task.teachClass.planStdCount)?default(0)}</td>
            <td style="text-align:center">${outSideObject.task.arrangeInfo.digest(outSideObject.task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],":day :units :weeks :room")?replace(" ,", "<br>")?trim}</td>
                <#assign content = content + (content?length == 0)?string("", "|") + outSideObject.student.id + "_" + outSideObject.task.id/>
            <#else>
            <td colspan="3" style="text-align:center;color:red">没有找到可匹配的教学任务！</td>
            <td style="text-align:center">${outSideObject.student.languageAbility.name}/<span style="color:red">？</span></td>
            <td colspan="2" style="text-align:center;color:red">没有找到可匹配的教学任务！</td>
                <#assign content = content + (content?length == 0)?string("", "|") + outSideObject.student.id + "_"/>
            </#if>
        </tr>
        </#list>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="calendarId" value="${RequestParameters["calendarId"]}"/>
        <input type="hidden" name="content" value="${content?replace("&nbsp;", " ")?replace("<span style=\"color:green;font-weight:bold\">", "")?replace("<span style=\"color:green\">", "")?replace("</span>", "")}"/>
        <input type="hidden" name="exportFlag" value="init"/>
        <input type="hidden" name="keys" value="student.code,student.name,student.adminClass.name,task.seqNo,task.course.code,task.course.name,student_task_languageAbility,stdCount_maxStdCount,arrangeInfo"/>
        <input type="hidden" name="titles" value="学号,姓名,行政班,课程序号,课程代码,课程名称,实际/要求语种,实际/上限(人数),上课信息"/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "初始化分配异常的情况", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("导出", "exportData()");
        bar.addItem("返回列表", "backSearch()", "backward.gif");
        
        var form = document.actionForm;
        
        function change() {
            var student_task_s = getSelectIds("student_task");
            if (isEmpty(student_task_s)) {
                alert("请选择要操作的记录。");
                return;
            }
            form.action = "courseTakeInEnglish.do?method=changeTaskSearch";
            form["student_task_s"].value = student_task_s;
            form.target = "_self";
            form.submit();
        }
        
        function exportData() {
            form.action = "courseTakeInEnglish.do?method=export";
            form.target = "_self";
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