    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="taskId" value=""/>
        <input type="hidden" name="taskIds" value=""/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "${pageTitle?default("教学进度绑定情况列表")?js_string}", null, true, true);
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
