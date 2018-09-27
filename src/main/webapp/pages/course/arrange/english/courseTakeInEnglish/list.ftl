<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="courseTakeTable" width="100%" sortable="true">
        <@table.thead>
            <@table.selectAllTd id="courseTakeId"/>
            <@table.sortTd text="学号" id="courseTake.student.code"/>
            <@table.sortTd text="姓名" id="courseTake.student.name" width="8%"/>
            <@table.td text="行政班"/>
            <@table.sortTd text="课程序号" id="courseTake.task.seqNo"/>
            <@table.sortTd text="课程代码" id="courseTake.task.course.code"/>
            <@table.sortTd text="课程名称" id="courseTake.task.course.name"/>
            <@table.sortTd text="课程类别" id="courseTake.task.courseType.name"/>
            <@table.td text="实际/要求语种" width="14%"/>
            <@table.td text="实际/计划" width="9%"/>
            <@table.td text="授课教师"/>
            <@table.sortTd text="修读类别" id="courseTake.courseTakeType.name" width="7%"/>
        </@>
        <script>var courseTakeMap = {};</script>
        <@table.tbody datas=courseTakes;courseTake>
            <@table.selectTd id="courseTakeId" value=courseTake.id/>
            <td>${courseTake.student.code}</td>
            <td>${courseTake.student.name}</td>
            <td>${(courseTake.student.adminClasses?first.name)}</td>
            <td>${courseTake.task.seqNo}</td>
            <script>courseTakeMap["${courseTake.id}"] = "${courseTake.student.id}";</script>
            <td>${courseTake.task.course.code}</td>
            <td>${courseTake.task.course.name}</td>
            <td>${courseTake.task.courseType.name}</td>
            <td>${(courseTake.student.languageAbility.name)?default("-")}/<#if (courseTake.task.requirement.languageAbilities?size)?default(0) gt 0><#list courseTake.task.requirement.languageAbilities as ability>${ability.name}<#if ability_has_next>，</#if></#list><#else>-</#if></td>
            <td>${(courseTake.task.teachClass.courseTakes?size)?default(0)}/${courseTake.task.teachClass.planStdCount?default(0)}</td>
            <td>${(courseTake.task.arrangeInfo.teacherNames)?default(0)}</td>
            <td>${courseTake.courseTakeType.name}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm1" onsubmit="return false;">
        <input type="hidden" name="calendarId" value="${RequestParameters["courseTake.task.calendar.id"]}"/>
        <input type="hidden" name="courseTakeId" value=""/>
        <input type="hidden" name="courseTakeIds" value=""/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <form method="post" action="" name="actionForm2" onsubmit="return false;">
        <input type="hidden" name="calendarId" value="${RequestParameters["courseTake.task.calendar.id"]}"/>
        <#list RequestParameters?keys as key>
            <#if !filterKeys?seq_contains(key)>
        <input type="hidden" name="${key?replace("courseTake.", "")}" value="${RequestParameters[key]?if_exists}"/>
            </#if>
        </#list>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "已分配学生名单列表${(RequestParameters["statMode"]?default("1") == "1")?string("<span style=\\\"color:blue\\\">(匹配)</span>", "<span style=\\\"color:red\\\">(不匹配)</span>")}", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("转移", "changeTake()", "update.gif");
        bar.addItem("删除", "remove()");
        <#if RequestParameters["statMode"]?default("1") == "1">
        bar.addItem("初始化学生", "initConfirm()");
        </#if>
        
        var form1 = document.actionForm1;
        var form2 = document.actionForm2;
        
        function changeTake() {
            var courseTakeIds = getSelectId("courseTakeId");
            if (isEmpty(courseTakeIds)) {
                alert("请选择要操作的记录。");
                return;
            }
            if (isInvalidTakeIds(courseTakeIds)) {
                alert("选择无效：\n　　选择的记录中存在有重复的学生。");
                return;
            }
            form1.action = "courseTakeInEnglish.do?method=changeTake";
            form1.target = "_self";
            form1["courseTakeIds"].value = courseTakeIds;
            form1.submit();
        }
        
        function isInvalidTakeIds(courseTakeIds) {
            if (isEmpty(courseTakeIds)) {
                return false;
            }
            
            var takeIdSeq = courseTakeIds.split(",");
            var currStudentCount = {};
            for (var i = 0; i < takeIdSeq.length; i++) {
                if (isEmpty(currStudentCount[courseTakeMap[takeIdSeq[i]]])) {
                    currStudentCount[courseTakeMap[takeIdSeq[i]]] = 1;
                } else {
                    currStudentCount[courseTakeMap[takeIdSeq[i]]]++;
                    if (currStudentCount[courseTakeMap[takeIdSeq[i]]] > 1) {
                        return true;
                    }
                }
            }
            
            return false;
        }
        
        function remove() {
            var courseTakeIds = getSelectId("courseTakeId");
            if (isEmpty(courseTakeIds)) {
                alert("请选择要操作的记录。");
                return;
            }
            if (confirm("确定要删除所选记录吗？")) {
                form1.action = "courseTakeInEnglish.do?method=changeTakeRemove";
                form1.target = "_self";
                form1["courseTakeIds"].value = courseTakeIds;
                form1.submit();
            }
        }
        
        function initConfirm() {
            form2.action = "courseTakeInEnglish.do?method=initConfirm";
            form2.target = "_self";
            form2.submit();
        }
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>