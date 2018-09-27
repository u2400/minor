<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="teaching_list" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="scheduleId"/>
            <@table.sortTd text="课程序号" id="schedule.task.seqNo" width="10%"/>
            <@table.sortTd text="课程代码" id="schedule.task.course.code" width="10%"/>
            <@table.sortTd text="课程名称" id="schedule.task.course.name" width="20%"/>
            <@table.sortTd text="绑定文件" id="schedule.name"/>
            <@table.sortTd text="绑定人" id="schedule.uploadBy.userName"/>
            <@table.sortTd text="绑定时间" id="schedule.uploadAt"/>
        </@>
        <@table.tbody datas=schedules;schedule>
            <@table.selectTd id="scheduleId" value=schedule.id/>
            <td>${schedule.task.seqNo}</td>
            <td>${schedule.task.course.code}</td>
            <td>${schedule.task.course.name}</td>
            <td><a href="teachingScheduleManagement.do?method=download&scheduleId=${schedule.id}">${(schedule.name)?if_exists}</a></td>
            <td>${schedule.uploadBy.userName}</td>
            <td>${schedule.uploadAt?string("yyyy-MM-dd HH:mm:ss")}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="scheduleId" value=""/>
        <input type="hidden" name="scheduleIds" value=""/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "已绑定教学进度列表", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addItem("指定进度", "edit()", "update.gif");
        
        var oForm = document.actionForm;
        
        function initData() {
            oForm["scheduleId"].value = oForm["scheduleIds"].value = "";
        }
        
        function edit() {
            initData();
            
            var iScheduleId = getSelectId("scheduleId");
            if (null == iScheduleId || undefined == iScheduleId || "" == iScheduleId || iScheduleId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            
            oForm.action = "teachingScheduleManagement.do?method=edit";
            oForm["scheduleId"].value = iScheduleId;
            oForm.target = "_self";
            oForm.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>