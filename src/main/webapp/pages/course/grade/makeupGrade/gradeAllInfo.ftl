<#include "/templates/head.ftl"/>
<body>
    <table id="bar"></table>
    <@table.table width="100%" align="center" sortable="true" id="allCourseGradeInfo">
        <@table.thead>
            <@table.sortTd text="学号" id="courseGrade.std.code" width="10%"/>
            <@table.sortTd text="姓名" id="courseGrade.std.name" width="10%"/>
            <@table.sortTd text="课程代码" id="courseGrade.course.code" width="10%"/>
            <@table.sortTd text="课程名称" id="courseGrade.course.name" width="20%"/>
            <@table.td text="补考成绩"/>
            <@table.td text="缓考成绩"/>
            <@table.sortTd text="最终成绩" id="courseGrade.score"/>
            <@table.sortTd text="总评成绩" id="courseGrade.GA"/>
        </@>
        <@table.tbody datas=courseGrades;courseGrade>
            <td>${courseGrade.std.code}</td>
            <td>${courseGrade.std.name}</td>
            <td>${courseGrade.course.code}</td>
            <td>${courseGrade.course.name}</td>
            <td>${(courseGrade.getExamGrade(DELAY).scoreDisplay)?if_exists}</td>
            <td>${(courseGrade.getExamGrade(MAKEUP).scoreDisplay)?if_exists}</td>
            <td>${courseGrade.getScoreDisplay(FINAL)}</td>
            <td>${courseGrade.getScoreDisplay(GA)}</td>
        </@>
    </@>
    <#assign pageTitle = calendar.studentType.name + " " + calendar.year + " " + (calendar.term + "学期")?replace("学期学期", "学期")/>
    <#assign filterKeys = ["method", "pageNo", "pageSize"]/>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <#list RequestParameters?keys as key>
            <#if !filterKeys?seq_contains(key)>
        <input type="hidden" name="${key}" value="${RequestParameters[key]?if_exists}"/>
            </#if>
        </#list>
        <input type="hidden" name="keys" value="std.code,std.name,std.enrollYear,std.department.name,std.firstMajor.name,std.firstAspect.name,std.firstMajorClass.name,taskSeqNo,course.code,course.name,courseType.name,markStyle.name,makeup.score,delayed.score,GA,score,credit,GP,someExamStatusNames,isPass"/>
        <input type="hidden" name="titles" value="学号,姓名,年级,院系,专业,专业方向,所在班级,课程序号,课程代码,课程名称,课程类别,成绩记录方式,补考成绩,缓考成绩,总评成绩,最终成绩,获得学分,绩点,考试情况(依次：补考，缓考，平时，期中，期末),是否通过"/>
        <input type="hidden" name="fileName" value="${pageTitle?replace(" ", "_")?replace("-", "_")}_学生补缓考成绩"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "补缓考成绩查看（${pageTitle}）", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("导出成绩", "exportData()");
        bar.addClose();
        
        var form = document.actionForm;
        
        function exportData() {
            form.action = "makeupGrade.do?method=export";
            form.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>
