<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="exemptionResultTable" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="resultId"/>
            <@table.sortTd text="学号" id="result.student.code"/>
            <@table.sortTd text="姓名" id="result.student.name" width="15%"/>
            <@table.td text="所在班级" width="8%"/>
            <@table.sortTd text="所在学院" id="result.student.department.name"/>
            <@table.sortTd text="专业" id="result.student.firstMajor.name"/>
            <@table.sortTd text="专业方向" id="result.student.firstAspect.name"/>
            <@table.sortTd text="申请类型" id="result.applyType.name"/>
            <@table.sortTd text="学年学期" id="result.calendar.start" width="8%"/>
            <@table.sortTd text="是否专业学位调剂" id="result.isAllowDegree"/>
        </@>
        <@table.tbody datas=results;result>
            <@table.selectTd id="resultId" value=result.id/>
            <td>${result.student.code}</td>
            <td>${result.student.name}</td>
            <td>${(result.student.firstMajorClass.name)?if_exists}</td>
            <td>${result.student.department.name}</td>
            <td>${(result.student.firstMajor.name)?if_exists}</td>
            <td>${(result.student.firstAspect.name)?if_exists}</td>
            <td>${(result.applyType.name)?if_exists}</td>
            <td>${result.calendar.year}&nbsp;${result.calendar.term}</td>
            <td>${(result.isAllowDegree?string("愿意", "不愿"))?if_exists}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="keys" value="seqNo,student.name,student.code,student.firstMajorClass.name,student.basicInfo.gender.name,student.basicInfo.politicVisage.name,student.department.name,student.major_field,calendar.year_term,gpa,ect4,ect6,applyType.name,isAllowDegree"/>
        <input type="hidden" name="titles" value="序号,姓名,学号,班级,性别,政治面貌,所在学院,专业（方向）,学年学期,课程平均绩点,四级外语成绩,六级外语成绩,学术型/专业学位,是否愿意调剂为专业学位"/>
        <input type="hidden" name="fileName" value="推免申请结果导出"/>
        <#list RequestParameters?keys as key>
            <#assign filterKeys = ["method"]/>
            <#if !filterKeys?seq_contains(key)>
        <input type="hidden" name="${key}" value="${RequestParameters[key]?if_exists}"/>
            </#if>
        </#list>
    </form>
    <script>
        var oBar = new ToolBar("bar", "推免申请结果列表", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addItem("导出", "exportData()");
        
        var oForm = document.actionForm;
        
        function exportData() {
            oForm.action = "exemptionManagement.do?method=export";
            oForm.target = "_self";
            oForm.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>