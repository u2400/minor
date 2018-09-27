    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="courseId" value=""/>
        <input type="hidden" name="courseIds" value=""/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "${pageTitle?default("课程大纲绑定情况列表")?js_string}", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addItem("设置绑定", "edit()", "update.gif");
        
        var oForm = document.actionForm;
        
        function initData() {
            oForm["courseId"].value = oForm["courseIds"].value = "";
        }
        
        function edit() {
            initData();
            var iCourseId = getSelectId("courseId");
            
            if (null == iCourseId || undefined == iCourseId || "" == iCourseId || iCourseId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            
            oForm.action = "syllabusManagement.do?method=edit";
            oForm["courseId"].value = iCourseId;
            oForm.target = "_self";
            oForm.submit();
        }
    </script>
