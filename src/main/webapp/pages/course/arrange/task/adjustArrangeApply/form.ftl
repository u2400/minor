<#include "/templates/head.ftl"/>
<script src="dwr/interface/teachTaskService.js"></script>
<script src="scripts/validator.js"></script>
<body>
    <table id="bar" width="100%"></table>
    <table class="formTable" width="100%">
        <tr>
            <td class="darkColumn" colspan="4" style="text-align:center;font-weight:bold">调停课申请</td>
        </tr>
        <#assign redFlag><span style="font-weight:bold;color:red">*</span></#assign>
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="adjust.id" value="${(adjust.id)?if_exists}"/>
            <input type="hidden" name="adjust.task.calendar.id" value="${RequestParameters["adjust.task.calendar.id"]}"/>
            <input type="hidden" name="adjust.teacher.id" value="${RequestParameters["adjust.teacher.id"]}"/>
            <input type="hidden" name="adjust.task.id" value="${(adjust.task.id)?if_exists}"/>
            <input type="hidden" name="adjust.beenInfo" value="${(adjust.beenInfo?html)?if_exists}"/>
            <input type="hidden" name="params" value="${RequestParameters["params"]}"/>
        <tr>
            <td class="title" width="20%" id="f_taskId">课程序号${redFlag}：</td>
            <td width="30%"><input type="text" name="adjust.task.seqNo" value="${(adjust.task.seqNo)?if_exists}" maxlength="10" style="width:200px"/><button onclick="checkTask()">查询</button></td>
            <td class="title" width="20%">课程代码：</td>
            <td id="courseCode_html">${(adjust.task.course.code)?if_exists}</td>
        </tr>
        <tr>
            <td class="title">课程名称：</td>
            <td id="courseName_html">${(adjust.task.course.name)?if_exists}</td>
            <td class="title">申请种类${redFlag}：</td>
            <td><input id="adjust" type="radio" name="adjust.status" value="1"/><label for="adjust">调课</label>&nbsp;<input id="stop" type="radio" name="adjust.status" value="2"/><label for="stop">停课</label></td>
        </tr>
        <tr>
            <td class="title">原上课信息：</td>
            <td colspan="3" id="activityInfo_html">${(adjust.task.arrangeInfo.digest(adjust.task.calendar))?if_exists}</td>
        </tr>
        <tr>
        </tr>
        <tr>
            <td class="title" id="f_applyInfo">申请说明${redFlag}：</td>
            <td colspan="3">
                <textarea name="adjust.applyInfo" style="width:500px;height:50px">${(adjust.applyInfo?html)?if_exists}</textarea>
                （时间、理由，100个字符）
            </td>
        </tr>
        <tr>
            <td class="title" id="f_remark">备注：</td>
            <td colspan="3">
                <textarea name="adjust.remark" style="width:500px;height:50px">${(adjust.remark?html)?if_exists}</textarea>
                （100个字符）
            </td>
        </tr>
        <tr>
            <td class="darkColumn" colspan="4" style="text-align:center"><button onclick="save()">提交</option></td>
        </tr>
        </form>
    </table>
    <script>
        var bar = new ToolBar("bar", "调停课申请", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addBack();
        
        var form = document.actionForm;
        
        function initData() {
            <#if (adjust.status)?default(1) == 1>
            document.getElementById("adjust").checked = true;
            <#else>
            document.getElementById("stop").checked = true;
            </#if>
        }
        
        function checkTask() {
            var seqNo = form["adjust.task.seqNo"].value;
            if (null == seqNo || "" == seqNo) {
                alert("请填写课程序号。");
                return;
            }
            teachTaskService.getTeachTaskWithCalendarDWR(outputTaskInfo, seqNo, form["adjust.task.calendar.id"].value, form["adjust.teacher.id"].value);
        }
        
        function outputTaskInfo(data) {
            if (null == data) {
                alert("请输入有效的课程序号。");
                form["adjust.task.id"].value = form["adjust.beenInfo"].value = document.getElementById("courseCode_html").innerHTML = document.getElementById("courseName_html").innerHTML = document.getElementById("activityInfo_html").innerHTML =  "";
                return;
            }
            document.getElementById("courseCode_html").innerHTML = data["course.code"];
            document.getElementById("courseName_html").innerHTML = data["course.name"];
            form["adjust.beenInfo"].value = document.getElementById("activityInfo_html").innerHTML = data.activityInfo;
            form["adjust.task.id"].value = data.id;
        }
        
        function save() {
            var a_fields = {
                "adjust.task.id":{'l':"课程序号", 'r':true, 't':"f_taskId"},
                "adjust.applyInfo":{'l':"申请说明", 'r':true, 't':"f_applyInfo", 'mx':100},
                "adjust.remark":{'l':"备注", 'r':false, 't':"f_remark", 'mx':100},
            };
            var v = new validator(form, a_fields, null);
            if (v.exec()) {
                form.action = "adjustArrangeApply.do?method=save";
                form.target = "_self";
                form.submit();
            }
        }
        
        initData();
    </script>
</body>
<#include "/templates/foot.ftl"/>