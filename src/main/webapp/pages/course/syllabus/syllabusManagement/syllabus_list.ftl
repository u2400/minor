<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="syllabus_list" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="syllabusId"/>
            <@table.sortTd text="课程代码" id="syllabus.course.code" width="10%"/>
            <@table.sortTd text="课程名称" id="syllabus.course.name" width="20%"/>
            <@table.sortTd text="绑定文件" id="syllabus.name"/>
            <@table.td text="绑定人" id="syllabus.uploadBy.userName"/>
            <@table.td text="绑定时间" id="syllabus.uploadAt"/>
        </@>
        <@table.tbody datas=syllabuses;syllabus>
            <@table.selectTd id="syllabusId" value=syllabus.id/>
            <td>${syllabus.course.code}</td>
            <td>${syllabus.course.name}</td>
            <td><a href="syllabusManagement.do?method=download&syllabusId=${syllabus.id}">${(syllabus.name)?if_exists}</a></td>
            <td>${syllabus.uploadBy.userName}</td>
            <td>${syllabus.uploadAt?string("yyyy-MM-dd HH:mm:ss")}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="syllabusId" value=""/>
        <input type="hidden" name="syllabusIds" value=""/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "已绑定课程大纲列表", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addItem("设置绑定", "edit()", "update.gif");
        
        var oForm = document.actionForm;
        
        function initData() {
            oForm["syllabusIds"].value = oForm["syllabusIds"].value = "";
        }
        
        function edit() {
            initData();
            
            var iSyllabusId = getSelectId("syllabusId");
            if (null == iSyllabusId || undefined == iSyllabusId || "" == iSyllabusId || iSyllabusId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            
            oForm.action = "syllabusManagement.do?method=edit";
            oForm["syllabusId"].value = iSyllabusId;
            oForm.target = "_self";
            oForm.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>