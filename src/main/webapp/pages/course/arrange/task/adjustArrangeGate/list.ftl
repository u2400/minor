<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#assign barTitleMap = {"null":"调停申请列表", "1":"调停审批通过列表", "0":"调停审批未过列表", "final":"调停已分配教室列表"}/>
    <#include "../adjustArrangeApply/adjustList.ftl"/>
    <form method="post" action="" name="actionForm" submit="return false;">
        <input type="hidden" name="adjustId" value=""/>
        <input type="hidden" name="adjustIds" value=""/>
        <input type="hidden" name="isPassed" value=""/>
        <input type="hidden" name="isAdmin" value="1"/>
        <input type="hidden" name="keys" value="task.seqNo,task.course.code,task.course.name,task.arrangeInfo.teachDepart.name,teacher.code,teacher.name,beenInfo,status,applyInfo,isPassed,auditBy.name,passedAt,room.name,finalReason,finalBy.name,finalAt,createdAt,updatedAt"/>
        <input type="hidden" name="titles" value="课程序号,课程代码,课程名称,开课院系,申请教师工号,申请教师姓名,原上课信息,调(1)停(2)状态,申请说明,是否通过,审批人,审批时间,分配教室,终审理由,终审人,终审时间,记录创建时间,记录修改时间,备注"/>
        <#assign filterKeys=["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "${barTitleMap[RequestParameters["adjust.isPassed"]?default("null")]?default("调停审批全部记录")}", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("查看", "info()");
        bar.addItem("导出", "exportData()");
        <#if RequestParameters["adjust.isPassed"]?default("null") == "null">
        bar.addItem("通过", "settingPassed(1)");
        bar.addItem("未过", "settingPassed(0)");
        bar.addItem("删除", "remove()");
        <#elseif RequestParameters["adjust.isPassed"] == "1">
        bar.addItem("未过", "settingPassed(0)");
        <#elseif RequestParameters["adjust.isPassed"] == "0">
        bar.addItem("通过", "settingPassed(1)");
        </#if>
        
        var form = document.actionForm;
        
        function initData() {
            form["adjustId"].value = "";
            form["adjustIds"].value = "";
            form["isPassed"].value = "";
        }
        
        function settingPassed(isPassed) {
            initData();
            var adjustIds = getSelectId("adjustId");
            if (null == adjustIds || "" == adjustIds) {
                alert("请选择要操作的记录。");
                return;
            }
            
            form.action = "adjustArrangeGate.do?method=settingPassed";
            form.target = "_self";
            form["isPassed"].value = isPassed;
            form["adjustIds"].value = adjustIds;
            form.submit();
        }
        
        function info() {
            initData();
            var adjustId = getSelectId("adjustId");
            if (null == adjustId || "" == adjustId || adjustId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            
            form.action = "adjustArrangeGate.do?method=info";
            form.target = "_self";
            form["adjustId"].value = adjustId;
            form.submit();
        }
        
        function exportData() {
            form.action = "adjustArrangeGate.do?method=export";
            form.target = "_self";
            form.submit();
        }
        
        function remove() {
            initData();
            var adjustIds = getSelectId("adjustId");
            if (null == adjustIds || "" == adjustIds) {
                alert("请选择要操作的记录。");
                return;
            }
            
            if (confirm("确认要删除所选记录吗？")) {
                form.action = "adjustArrangeApply.do?method=remove";
                form.target = "_self";
                form["adjustIds"].value = adjustIds;
                form.submit();
            }
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>