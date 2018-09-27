<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="infoTable" width="100%">
        <tr>
            <td class="title" style="width:8%">学号</td>
            <td style="width:10%">${student.code}</td>
            <td class="title" style="width:8%">姓名</td>
            <td style="width:20%">${student.name}</td>
            <td class="title" style="width:8%">年级</td>
            <td style="width:15%">${student.enrollYear}</td>
            <td class="title" style="width:8%">院系</td>
            <td>${student.department.name}</td>
        </tr>
        <tr>
            <td class="title">专业</td>
            <td>${(student.firstMajor.name + "(" + student.firstMajor.code + ")")?if_exists}</td>
            <td class="title">专业方向</td>
            <td>${(student.firstAspect.name + "(" + student.firstAspect.code + ")")?if_exists}</td>
            <td class="title">行政班</td>
            <td><#list (student.adminClasses?sort_by("name"))?if_exists as adminClass>${adminClass.name}(${adminClass.code})<#if adminClass_has_next>, </#if></#list></td>
            <td class="title">语种能力</td>
            <td>${student.languageAbility.name}</td>
        </tr>
    </table>
    <br>
    <#if noTakeTasks?size == 0>
    <div style="width:100%;text-align:center;color:red;font-size:16pt;font-weight:bold">当前没有可以指定的教学任务！<br>（原因：1. 没有设置或匹配的等级；2. 教学任务没有排课）</div>
    <#else>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="studentId" value="${student.id}"/>
        <#assign tdWidthes = ["", "25px", "65px", "65px", "80px", "130px", "100px", "100px"]/>
    <table class="listTable" width="100%" style="text-align:center">
        <tr class="darkColumn">
            <td width="${tdWidthes[1]}"></td>
            <@table.td text="课程序号" width=tdWidthes[2]/>
            <@table.td text="课程代码" width=tdWidthes[3]/>
            <@table.td text="课程名称" width=tdWidthes[4]/>
            <@table.td text="课程类别" width=tdWidthes[5]/>
            <@table.td text="语种要求" width=tdWidthes[6]/>
            <@table.td text="实际/计划人数" width=tdWidthes[7]/>
            <@table.td text="上课信息"/>
        </tr>
    </table>
    <div style="width:100%;height:500px;overflow-y:auto">
        <@table.table id="addTakeTable" width="100%" style="vertical-align:middle">
            <#list noTakeTasks?sort_by("seqNo") as task>
            <tr class="${(task_index % 2 == 0)?string("brightStyle", "grayStyle")}" align="center" onmouseover="swapOverTR(this,this.className)" onmouseout="swapOutTR(this)" onclick="onRowChange(event)">
                <td class="select" style="width:${tdWidthes[1]}"><input type="radio" name="taskId" value="${task.id}"/></td>
                <td width="${tdWidthes[2]}">${task.seqNo}</td>
                <td width="${tdWidthes[3]}">${task.course.code}</td>
                <td width="${tdWidthes[4]}">${task.course.name}</td>
                <td width="${tdWidthes[5]}">${task.courseType.name}</td>
                <td width="${tdWidthes[6]}"><#if (task.requirement.languageAbilities?size)?default(0) gt 0><#list task.requirement.languageAbilities as ability>${ability.name}<#if ability_has_next><br></#if></#list><#else>-</#if></td>
                <td width="${tdWidthes[7]}">${(task.teachClass.courseTakes?size)?default(0)}/${(task.teachClass.planStdCount)?default(0)}</td>
                <td>${task.arrangeInfo.digest(task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],":day :units :weeks :room")?replace(" ,", "<br>")?trim}</td>
            </tr>
            </#list>
        </@>
    </div>
            <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>&student.id=${student.id}"/>
    </form>
    </#if>
    <script>
        var bar = new ToolBar("bar", "指定教学任务", null, true, true);
        bar.setMessage('<@getMessage/>');
        <#if noTakeTasks?size != 0>
        bar.addItem("指定", "addTakeSave()", "save.gif");
        </#if>
        bar.addItem("返回列表", "backSearch()", "backward.gif");
        
        var form = document.actionForm;
        
        function addTakeSave() {
            if (isEmpty(getSelectId("taskId"))) {
                alert("当前没有(可)指定的教学任务。");
                return;
            }
            form.action = "courseTakeInEnglish.do?method=addTakeSave";
            form.target = "_self";
            form.submit();
        }
        
        function backSearch() {
            try {
                parent.unCourseTake();
            } catch (e) {
                window.close();
            }
        }
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>