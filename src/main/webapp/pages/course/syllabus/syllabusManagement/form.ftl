<#include "/templates/head.ftl"/>
<script lanuage="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<body>
    <table id="bar" width="100%"></table>
    <table class="formTable" width="60%" align="center" style="vertical-align:middle">
        <form method="post" action="" name="actionForm" onsubmit="return false;" enctype="multipart/form-data">
        <tr height="25px">
            <td class="darkColumn" colspan="2" style="font-weight:bold;text-align:center">课程大纲绑定设置</td>
        </tr>
        <tr height="25px">
            <td class="title" width="20%">课程代码：</td>
            <td>${syllabus.course.code}</td>
        </tr>
        <tr height="25px">
            <td class="title">课程名称：</td>
            <td>${syllabus.course.name}</td>
        </tr>
        <#if (syllabus.id)?exists>
        <tr height="25px">
            <td class="title" id="f_path">当前绑定文件：</td>
            <td><a href="syllabusManagement.do?method=download&syllabusId=${syllabus.id}">${syllabus.name}</a></td>
        </tr>
        </#if>
        <tr height="25px">
            <td class="title" id="f_path"><span style="color:red;font-weight:bold">*</span>绑定文件：</td>
            <td><input id="path" type="file" name="syllabus.path" class="buttonStyle" style="width:300px"/></td>
        </tr>
        <tr height="25px">
            <td class="darkColumn" colspan="2" style="text-align:center"><button id="saveButton" onclick="save()">保存</button></td>
        </tr>
        </form>
    </table>
    <script>
        var oBar = new ToolBar("bar", "课程大纲绑定维护", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addItem("返回", "parent.search()", "backward.gif");
        
        var oForm = document.actionForm;
        
        function save() {
            var aFields = {
                "syllabus.path":{"l":"绑定文件", "r":true, "t":"f_path"}
            };
            var oValidator = new validator(oForm, aFields, null);
            if (oValidator.exec()) {
                var oSaveButton = document.getElementById("saveButton");
                oSaveButton.disabled = true;
                oSaveButton.value = "正在保存中...";
                oSaveButton.style.width = "180px";
                
                oForm.action = "syllabusManagement.do?method=save&syllabus.id=${(syllabus.id)?if_exists}&syllabus.course.id=${syllabus.course.id}&params=${(RequestParameters["params"]?replace("&", "%26"))?if_exists}";
                oForm.target = "_self"
                oForm.submit();
            }
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>