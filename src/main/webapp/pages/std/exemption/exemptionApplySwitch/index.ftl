<#include "/templates/head.ftl"/>
<body>
    <table id="bar"></table>
    <script>var oApplySwitchMap = {};</script>
    <@table.table id="applySwitchTable" width="100%" sortable="true">
        <@table.thead>
            <@table.selectAllTd id="applySwitchId"/>
            <@table.sortTd text="学年学期" id="applySwitch.calendar.year"/>
            <@table.sortTd text="开始时间" id="applySwitch.fromAt"/>
            <@table.sortTd text="结束时间" id="applySwitch.endAt"/>
        </@>
        <@table.tbody datas=applySwitches;applySwitch>
            <@table.selectTd id="applySwitchId" value=applySwitch.id/>
            <td>${applySwitch.calendar.year}&nbsp;${applySwitch.calendar.term}</td>
            <td>${applySwitch.fromAt?string("yyyy-MM-dd HH:mm:ss")}</td>
            <td>${applySwitch.endAt?string("yyyy-MM-dd HH:mm:ss")}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm">
        <input type="hidden" name="applySwitchId" value=""/>
        <input type="hidden" name="applySwitchIds" value=""/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "推免申请开关", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addItem("添加", "add()");
        oBar.addItem("修改", "edit()");
        oBar.addItem("删除", "remove()");
        
        var oForm = document.actionForm;
        
        function initData() {
            oForm["applySwitchId"].value = oForm["applySwitchIds"].value = "";
        }
        
        function add() {
            initData();
            oForm.action = "exemptionApplySwitch.do?method=edit";
            oForm.target = "_self";
            oForm.submit();
        }
        
        function edit() {
            initData();
            
            var iApplySwitchId = getSelectId("applySwitchId");
            if (null == iApplySwitchId || undefined == iApplySwitchId || "" == iApplySwitchId || iApplySwitchId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            oForm.action = "exemptionApplySwitch.do?method=edit";
            oForm.target = "_self";
            oForm["applySwitchId"].value = iApplySwitchId;
            oForm.submit();
        }
        
        function remove() {
            initData();
            
            var iApplySwitchIds = getSelectIds("applySwitchId");
            if (null == iApplySwitchIds || undefined == iApplySwitchIds || "" == iApplySwitchIds) {
                alert("请选择要操作的记录。");
                return;
            }
            if (confirm("确定要删除所选择的记录吗？")) {
                oForm.action = "exemptionApplySwitch.do?method=remove";
                oForm.target = "_self";
                oForm["applySwitchIds"].value = iApplySwitchIds;
                oForm.submit();
            }
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>