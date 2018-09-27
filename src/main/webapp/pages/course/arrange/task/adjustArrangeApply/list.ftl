<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#include "adjustList.ftl"/>
    <form method="post" action="" name="actionForm" submit="return false;">
        <input type="hidden" name="adjustId" value=""/>
        <input type="hidden" name="adjustIds" value=""/>
        <input type="hidden" name="adjust.task.calendar.id" value="${RequestParameters["adjust.task.calendar.id"]}"/>
        <input type="hidden" name="adjust.teacher.id" value="${RequestParameters["adjust.teacher.id"]}"/>
        <#assign filterKeys=["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "申请记录列表", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("新增", "add()");
        bar.addItem("修改", "edit()");
        bar.addItem("查看", "info()");
        bar.addItem("删除", "remove()");
        
        var form = document.actionForm;
        
        function initData() {
            form["adjustId"].value = "";
            form["adjustIds"].value = "";
        }
        
        function add() {
            initData();
            form.action = "adjustArrangeApply.do?method=edit";
            form.target = "_self";
            form.submit();
        }
        
        function edit() {
            initData();
            var adjustId = getSelectId("adjustId");
            if (null == adjustId || "" == adjustId || adjustId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            
            if (adjustMap[adjustId]) {
                alert("不能修改已审批的记录。");
                return;
            }
            
            form.action = "adjustArrangeApply.do?method=edit";
            form.target = "_self";
            form["adjustId"].value = adjustId;
            form.submit();
        }
        
        function info() {
            initData();
            var adjustId = getSelectId("adjustId");
            if (null == adjustId || "" == adjustId || adjustId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            
            form.action = "adjustArrangeApply.do?method=info";
            form.target = "_self";
            form["adjustId"].value = adjustId;
            form.submit();
        }
        
        function remove() {
            initData();
            var adjustIds = getSelectId("adjustId");
            if (null == adjustIds || "" == adjustIds) {
                alert("请选择要操作的记录。");
                return;
            }
            
            var adjustIds_ = adjustIds.split(",");
            for (var i = 0; i < adjustIds_.length; i++) {
                if (adjustMap[adjustIds_[i]]) {
                    alert("不能删除已审批的记录。");
                    return;
                }
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