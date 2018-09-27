<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="studentInEnglishTable" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="studentId"/>
            <@table.sortTd text="学号" id="student.code"/>
            <@table.sortTd text="姓名" id="student.name"/>
            <@table.sortTd text="年级" id="student.enrollYear" width="8%"/>
            <@table.sortTd text="学制" id="student.schoolingLength" width="8%"/>
            <@table.sortTd text="院系" id="student.department.name"/>
            <@table.sortTd text="专业" id="student.firstMajor.name"/>
            <@table.td text="专业方向"/>
            <@table.td text="语种能力" width="10%"/>
            <@table.sortTd text="语种成绩" id="student.scoreInLanguage" width="10%"/>
        </@>
        <@table.tbody datas=students;student>
            <@table.selectTd id="studentId" value=student.id/>
            <td><a href="#" onclick="info('${student.id}')">${student.code}</a></td>
            <td>${student.name}</td>
            <td>${student.enrollYear}</td>
            <td>${(student.schoolingLength)?if_exists}</td>
            <td>${student.department.name}</td>
            <td>${student.firstMajor.name}</td>
            <td>${(student.firstAspect.name)?if_exists}</td>
            <td>${(student.languageAbility.name)?if_exists}</td>
            <td>${(student.scoreInLanguage)?if_exists}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="studentId" value=""/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key>&${key}=${RequestParameters[key]?if_exists}</#list>"/>
    </form>
    <form method="post" action="" name="searchForm" onsubmit="return false;">
        <input type="hidden" name="keys" value="code,name,enrollYear,schoolingLength,department.name,firstMajor.name,firstAspect.name,firstMajorClass.name,languageAbility.name,scoreInLanguage"/>
        <input type="hidden" name="titles" value="学号,姓名,年级,学制,院系,专业,专业方向,行政班,语种能力,语种成绩"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "学生列表", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("查看", "info()");
        bar.addItem("导出", "exportData()");
        
        var form = document.actionForm;
        var sForm = document.searchForm;
        
        function initData() {
            form["studentId"].value = "";
        }
        
        function info(studentId) {
            initData();
            var studentId_ = studentId;
            if (isEmpty(studentId_)) {
                studentId_ = getSelectId("studentId");
            }
            if (isEmpty(studentId_) || studentId_.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            form.action = "studentAbilityQuery.do?method=info";
            form.target = "_self";
            form["studentId"].value = studentId_;
            form.submit();
        }
        function exportData() {
            sForm.action = "studentAbilityQuery.do?method=export";
            sForm.target = "_self";
            sForm.submit();
        }
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>