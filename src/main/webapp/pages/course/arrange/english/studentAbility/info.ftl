<#include "/templates/head.ftl"/>
<script lanuage="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<body>
    <table id="bar" width="100%"></table>
    <table class="infoTable" width="100%">
        <tr>
            <td class="title" style="width:20%">学号</td>
            <td width="30%">${student.code}</td>
            <td class="title" style="width:20%">姓名</td>
            <td>${student.name}</td>
        </tr>
        <tr>
            <td class="title" style="width:10%">年级</td>
            <td>${student.enrollYear}</td>
            <td class="title" style="width:10%">学制</td>
            <td>${(student.schoolingLength)?if_exists}</td>
        </tr>
        <tr>
            <td class="title">性别</td>
            <td>${(student.basicInfo.gender.name)?if_exists}</td>
            <td class="title">国籍</td>
            <td>${(student.basicInfo.country.name)?if_exists}</td>
        </tr>
        <tr>
            <td class="title">民族</td>
            <td>${(student.basicInfo.nation.name)?if_exists}</td>
            <td class="title">是否毕业</td>
            <td>${(student.degreeInfo.graduateOn)?exists?string("是", "否")}</td>
        </tr>
        <tr>
            <td class="title">院系</td>
            <td>${student.department.name}</td>
            <td class="title">班级</td>
            <td><#list student.adminClasses?if_exists as adminClass>${adminClass.name}(${adminClass.code})<#if adminClass_has_next>, </#if></#list></td>
        </tr>
        <tr>
            <td class="title">专业</td>
            <td>${student.firstMajor.name}</td>
            <td class="title">专业方向</td>
            <td>${(student.firstAspect.name)?if_exists}</td>
        </tr>
        <tr>
            <td class="title">语种能力</td>
            <td>${(student.languageAbility.name)?if_exists}</td>
            <td class="title">语种成绩</td>
            <td>${(student.scoreInLanguage)?if_exists}</td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "学生英语等级查看", null, true, true);
        bar.addBack();
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>