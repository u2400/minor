<#include "/templates/head.ftl"/>
<script src="dwr/interface/departmentDAO.js?ver=9"></script>
<script src="dwr/interface/examActivityService.js"></script>
<script src='dwr/interface/teacherDAO.js'></script>
<body>
    <table id="bar"></table>
    <#assign teachers = taskGroup.teachers/>
    <#assign beenTeacherIds><#list teachers as teacher>${teacher.id},</#list></#assign>
    <#assign beenTeacherNames><#list teachers as teacher>${teacher.name}<#if teacher_has_next>,</#if></#list></#assign>
    <table class="formTable" width="100%">
        <tr>
            <td class="darkColumn" style="text-align:center;font-weight:bold">添加老师</td>
        </tr>
    </table>
    <table class="formTable" width="100%">
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="taskGroup.id" value="${taskGroup.id}"/>
        <tr>
            <td class="title">已有教师(添加/修改结果)：</td>
            <td><label id="teacherNames" width="100%">${beenTeacherNames}</label><input type="hidden" name="teacherIds" value="${beenTeacherIds}"/></td>
        </tr>
        <tr>
            <td class="title" width="10%">院系/部门：</td>
            <td width="40%">
                <select id="department" onmouseover="displayDepartList(${taskGroup.id}, this.form['teacherIds'].value);" onChange="displayTeacherList(${taskGroup.id}, this.value, this.form['teacherIds'].value)" style="width:220px">
                    <option value=""></option>
                </select>
                <button onclick="resetTeacher()">还原</button>
            </td>
        </tr>
        <tr>
            <td class="title">教师：</td>
            <td>
                <select id="teacher" style="width:220px">
                    <option value=""></option>
                </select>
                <button onclick="addTeacher()">添加</button>
            </td>
        </tr>
        </form>
    </table>
    <table class="formTable" width="100%">
        <tr>
            <td class="darkColumn" align="center"><button onclick="save()">保存</button></td>
        </tr>
    </table>
    <div style="height:100px"></div>
    <script>
        var bar = new ToolBar("bar", "[${taskGroup.name}]排课组添加老师", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("保存", "save()");
        bar.addBackOrClose("<@msg.message key="action.back"/>", "<@msg.message key="action.close"/>");
        
        var form = document.actionForm;
        
        function addTeacher() {
            var teacher = $('teacher');
            if (null == teacher.value || "" == teacher.value) {
                alert("请选择要添加的老师。");
                return;
            }
            if(form['teacherIds'].value.indexOf("," + teacher.value + ",") == -1) {
                form['teacherIds'].value += teacher.value + ",";
                if ("" != $("teacherNames").innerHTML) {
                    $("teacherNames").innerHTML += ",";
                }
                $("teacherNames").innerHTML += DWRUtil.getText('teacher');
            }
            teacher.options.remove(teacher.selectedIndex);
            teacher.selectedIndex = 0;
            document.getElementById("department").onmouseover();
        }
        
        function resetTeacher() {
            form['teacherIds'].value = "<#if beenTeacherIds?exists && beenTeacherIds != "">,</#if>${beenTeacherIds}";
            $('teacherNames').innerHTML = "${beenTeacherNames}";
        }
        
        resetTeacher();
        
        function save() {
            var ddd = $("teacherNames").innerHTML.match(new RegExp(",", "gi"));
            var teacherCount = (((ddd == null) ? 0 : ddd.length) + 1) - ${taskGroup.taskList?size};
            if (teacherCount == 0) {
                alert("当前没有添加老师，无需保存。");
                return;
            }
            if (confirm("[${taskGroup.name}]排课组添加（含克隆任务）或循环填充" + teacherCount + "位任课教师到教学任务中，如果\n1. 当新增的教师人数小于未设置教师的教学任务数，\n　 则系统将仅循环填充这些教师，不作任务克隆；\n2. 当新增的教师人数与未设置教师的教学任务数一致，\n　 则系统将一任务一教师填充；\n3. 当新增的教师人数大于未设置教师的教学任务数，\n　 则系统将先补足未设置教师的教学任务，余下将以\n　 组任意一条教学任务为源，作一克隆教学任务一教\n　 师处理；\n4. 当组中的教学任务都设置教师，此时所新增的教师\n　则以组任意一条教学任务为源，作一克隆教学任务\n　 一教师处理。\n\n要继续吗？")) {
                form.action = "englishGroup.do?method=saveGroup";
                form.target = "_parent";
                form.submit();
            }
        }
    </script>
    <script language="JavaScript" type="text/JavaScript" src="scripts/course/DepartTeacher.js"></script>
</body>
<#include "/templates/foot.ftl"/>