<#include "/templates/head.ftl"/>
<body onload="initForm()">
    <table id="bar"></table>
    <table class="formTable" width="100%">
        <tr>
            <td class="darkColumn" colspan="4" align="center"><b>设置选项</b></td>
        </tr>
        <form method="post" action="?method=batchUpdateCourse" name="actionForm" onsubmit="return false;">
        <@searchParams/>
        <input type="hidden" name="taskIds" value="${RequestParameters['taskIds']}"/>
        <tr>
            <td class="title" width="20%"><input type="checkbox" name="seqNoCheck" value="" onclick="checkState(this, 'seqNoValue')"/>&nbsp;<@msg.message key="attr.courseNo"/>：</td>
            <td width="30%"><input type="text" name="course.code" maxlength="32" id="seqNoValue" value="请输入课程代码" onfocus="this.value=''"/></td>
            <td class="title" width="20%"><input type="checkbox" name="remarkCheck" value="" onclick="checkState(this, 'remarkValue')"/>&nbsp;<@msg.message key="common.remark"/>：</td>
            <td><input type="text" name="task.remark" maxlength="200" id="remarkValue" value="请输入备注" onfocus="this.value=''"/></td>
        </tr>
        <tr>
            <td class="title"><input type="checkbox" name="courseIdCheck" value="" onclick="checkState(this, 'courseIdValue')"/>&nbsp;<@msg.message key="entity.courseType"/>：</td>
            <td colspan="3">
                <select id="courseIdValue" name="course.type.code" style="width:100px">
                    <option value=""><@msg.message key="common.all"/></option>
                        <#list sort_byI18nName(courseTypes) as courseType>
                           <option value="${courseType.id}"><@i18nName courseType/></option>
                        </#list>
                </select>
            </td>
        </tr>
        <tr>
            <td class="title"><input type="checkbox" name="languageAbility_checkbox" value="" onclick="checkState(this, 'languageAbilitiy_')">&nbsp;语种能力：</td>
            <td colspan="3"><#list languageAbilities?sort_by("name") as languageAbilitiy><input type="checkbox" id="languageAbilitiy_${languageAbilitiy.id}" name="languageAbilityId" value="${languageAbilitiy.id}" disabled/><label for="languageAbilitiy_${languageAbilitiy.id}" disabled>${languageAbilitiy.name}</label><#if languageAbilitiy_has_next>&nbsp;</#if></#list></td>
            <input type="hidden" name="languageAbilityIds" value=""/>
        </tr>
        </form>
        <tr>
            <td class="darkColumn" colspan="4" align="center"><button accesskey="S" onclick="save()"><@msg.message key="action.save"/>(<u>S</u>)</button>　<button accesskey="R" onclick="initForm()"><@msg.message key="action.reset"/>(<u>R</u>)</button></td>
        </tr>
    </table>
    <#assign continuedWeek><@msg.message key="attr.continuedWeek"/></#assign>
    <#assign oddWeek><@msg.message key="attr.oddWeek"/></#assign>
    <#assign evenWeek><@msg.message key="attr.evenWeek"/></#assign>
    <#assign randomWeek><@msg.message key="attr.randomWeek"/></#assign>
    <#assign weekCycle={'1':'${continuedWeek}', '2':'${oddWeek}', '3':'${evenWeek}', '4':'${randomWeek}'}/>
    <@table.table width="100%" align="center">
        <@table.thead>
            <@table.td name="attr.courseNo"/>
            <@table.td text="课程名称"/>
            <@table.td name="entity.courseType"/>
            <@table.td name="entity.teachClass"/>
            <@table.td name="entity.teacher"/>
            <@table.td text="占用周"/>
            <@table.td width="12%" text="语种要求"/>
            <@table.td name="attr.credit"/>
        </@>
        <@table.tbody datas=tasks?sort_by("seqNo");task>
            <td>${(task.course.code)?default('')}</td>
            <td>${(task.course.name)?default('')}</td>
            <td>${(task.courseType.name)?default('')}</td>
            <td>${(task.teachClass.name)?default('')}</td>
            <td><@getTeacherNames task.arrangeInfo.teachers/></td>
            <td>${weekCycle[task.arrangeInfo.weekCycle?string]}</td> 
            <td><#list (task.requirement.languageAbilities)?if_exists as languageAbility>${languageAbility.name}<#if languageAbility_has_next><br></#if></#list></td>
            <td>${(task.course.credits)?default('')}</td>
        </@>
    </@>
    <script>
        var bar = new ToolBar("bar", "课程学分", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("<@msg.message key="action.save"/>", "save()");
        bar.addBack("<@msg.message key="action.back"/>");
        
        var info = new Object();
        info["seqNoValue"] = "请输入课程代码";
        info["creditValue"] = "请输入学分";
        info["courseIdValue"] = "";
        info["remarkValue"] = "请输入备注";
        
        var form = document.actionForm;
        
        function initForm() {
            form.reset();
            form['seqNoValue'].disabled = "disabled";
            form['courseIdValue'].disabled = "disabled";
            form['remarkValue'].disabled = "disabled";
        }
        
        function checkState(check, name) {
            if (isNotEmpty(name) && name == "languageAbilitiy_") {
                if (check.checked) {
                   check.value = name;
                } else {
                   check.value = "";
                }
                <#list languageAbilities as languageAbilitiy>
                $(name + "${languageAbilitiy.id}").disabled = !check.checked;
                if (!check.checked) {
                    $(name + "${languageAbilitiy.id}").checked = false;
                }
                </#list>
            } else {
                $(name).disabled=!check.checked;
                if (!check.checked) {
                   check.value = "";
                } else {
                   check.value = name;
                   $(name).focus();
                }
            }
        }
        
        function save() {
            var check1 = form['seqNoCheck'].value;
            var check2 = form['courseIdCheck'].value;
            var check3 = form['remarkCheck'].value;
            var check4 = form['languageAbility_checkbox'].value;
            var checks = check1 + check2 + check3 + check4;
            if (isEmpty(checks)) {
                alert("请至少选择一个设置！");
                return;
            }
            if (isNotEmpty(check1) && isEmpty(form['seqNoValue'].value)) {
                alert("课程代码不能为空！");
                return;
            }
            if (isNotEmpty(check2) && isEmpty(form['courseIdValue'].value)) {
                alert("课程类型不能为全部！");
                return;
            }
            if (isNotEmpty(check3) && isEmpty(form['remarkValue'].value)) {
                alert("备注不能空！");
                return;
            }
            var languageAbilityIds = getSelectIds("languageAbilityId");
            if (isNotEmpty(check4) && isEmpty(languageAbilityIds)) {
                alert("语种能力没有设置！");
                return;
            } else {
                form["languageAbilityIds"].value = languageAbilityIds;
            }
            form.submit();
        }
        
        window.onunload = function() {
            parent.document.getElementById("teachTaskListFrame").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>