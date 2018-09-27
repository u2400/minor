<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="infoTable" width="100%">
        <tr>
            <td class="title" style="width:8%">课程序号</td>
            <td style="width:10%">${task.seqNo}</td>
            <td class="title" style="width:8%">课程代码</td>
            <td style="width:15%">${task.course.code}</td>
            <td class="title" style="width:8%">课程名称</td>
            <td style="width:15%">${task.course.name}</td>
            <td class="title" style="width:15%">年级</td>
            <td>${(task.teachClass.enrollTurn)?if_exists}</td>
        </tr>
        <tr>
            <td class="title">学分</td>
            <td>${task.course.credits}</td>
            <td class="title">课程类别</td>
            <td>${task.courseType.name}</td>
            <td class="title">语种要求</td>
            <td><#if (task.requirement.languageAbilities?size)?default(0) gt 0><#list task.requirement.languageAbilities as ability>${ability.name}<#if ability_has_next>，</#if></#list><#else>-</#if></td>
            <td class="title">人数情况(实/计)</td>
            <td>${(task.teachClass.courseTakes?size)?default(0)}/${task.teachClass.planStdCount?default(0)}</td>
        </tr>
        <tr>
            <td class="title">上课信息</td>
            <td colspan="7">${task.arrangeInfo.digest(task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],":day :units :weeks :room")?replace(" ,", ", ")?replace(" <br>", ", ")?trim}</td>
        </tr>
    </table>
    <br>
    <div style="font-size:10pt;color:red">注：没有等级的学生，请联系“管理员”。</div>
    <br>
    <@table.table id="takeTable" width="100%" sortable="true">
        <@table.thead>
            <@table.selectAllTd id="takeId"/>
            <@table.sortTd text="学号" id="take.student.code"/>
            <@table.sortTd text="姓名" id="take.student.name" width="12%"/>
            <@table.td text="行政班"/>
            <@table.sortTd text="年级" id="take.student.enrollYear" width="10%"/>
            <@table.sortTd text="院系" id="take.student.department.name"/>
            <@table.sortTd text="专业" id="take.student.firstMajor.name" width="15%"/>
            <@table.td text="专业方向"/>
            <@table.td text="语种能力" width="10%"/>
        </@>
        <@table.tbody datas=takes;take>
            <#if (take.student.languageAbility.name)?exists>
            <@table.selectTd id="takeId" value=take.id/>
            <#else>
            <td class="select"></td>
            </#if>
            <td>${take.student.code}</td>
            <td>${take.student.name}</td>
            <td>${(take.student.adminClasses?first.name)?if_exists}</td>
            <td>${take.student.enrollYear}</td>
            <td>${take.student.department.name}</td>
            <td>${(take.student.firstMajor.name)?if_exists}</td>
            <td>${(take.student.firstAspect.name)?if_exists}</td>
            <td>${(take.student.languageAbility.name)?if_exists}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="courseTakeId" value=""/>
        <input type="hidden" name="courseTakeIds" value=""/>
        <input type="hidden" name="path" value="courseTakeSearch"/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "上课名单", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("转移", "changeTake()", "update.gif");
        bar.addItem("删除", "remove()");
        bar.addItem("返回列表", "backSearch()", "backward.gif");
        
        var form = document.actionForm;
        
        function changeTake() {
            var takeId = getSelectId("takeId");
            if (isEmpty(takeId) || takeId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            form.action = "courseTakeInEnglish.do?method=changeTake";
            form.target = "_self";
            form["courseTakeId"].value = takeId;
            form.submit();
        }
        
        function remove() {
            var takeIds = getSelectId("takeId");
            if (isEmpty(takeIds)) {
                alert("请选择要操作的记录。");
                return;
            }
            if (confirm("确定要删除所选记录吗？")) {
                form.action = "courseTakeInEnglish.do?method=changeTakeRemove";
                form.target = "_self";
                form["courseTakeIds"].value =takeIds;
                form.submit();
            }
        }
        
        function backSearch() {
            try {
                parent.vacancyStat();
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
