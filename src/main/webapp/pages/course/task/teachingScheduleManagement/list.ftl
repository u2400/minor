<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <script>var oScheduleMap = {};</script>
    <@table.table id="task_teaching_list" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="taskId"/>
            <@table.sortTd text="课程序号" id="task.seqNo" width="10%"/>
            <@table.sortTd text="课程代码" id="task.course.code" width="10%"/>
            <@table.sortTd text="课程名称" id="task.course.name" width="20%"/>
            <@table.td text="绑定文件"/>
            <@table.td text="绑定人" width="10%"/>
            <@table.td text="绑定时间" width="15%"/>
        </@>
        <@table.tbody datas=tasks;task>
            <@table.selectTd id="taskId" value=task.id/>
            <td>${task.seqNo}</td>
            <td>${task.course.code}</td>
            <td>${task.course.name}</td>
            <td>${("<a href=\"teachingScheduleManagement.do?method=download&syllabusId=" + scheduleMap[task.seqNo].id + "\">" + scheduleMap[task.seqNo].name + "</a>")?if_exists}</td>
            <td>${(scheduleMap[task.seqNo].uploadBy.userName)?if_exists}</td>
            <td>${(scheduleMap[task.seqNo].uploadAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}</td>
            <#if (scheduleMap[task.seqNo])?exists>
            <script>oScheduleMap["${task.id}"] = "";</script>
            </#if>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="taskId" value=""/>
        <input type="hidden" name="taskIds" value=""/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "<#if !RequestParameters["isBinding"]?exists || "" == RequestParameters["isBinding"]>教学进度绑定情况列表<SPAN style=\"COLOR: blue\">（全部）</SPAN><#elseif "1" == RequestParameters["isBinding"]>未绑定教学进度的教学任务列表<#else>已绑定教学进度列表</#if>", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addItem("指定进度", "edit()", "update.gif");
        
        var oForm = document.actionForm;
        
        function initData() {
            oForm["taskId"].value = oForm["taskIds"].value = "";
        }
        
        function edit() {
            initData();
            var iTaskId = getSelectId("taskId");
            
            if (null == iTaskId || undefined == iTaskId || "" == iTaskId || iTaskId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            
            oForm.action = "teachingScheduleManagement.do?method=edit";
            oForm["taskId"].value = iTaskId;
            oForm.target = "_self";
            oForm.submit();
        }
    </script>
    
</body>
<#include "/templates/foot.ftl"/>