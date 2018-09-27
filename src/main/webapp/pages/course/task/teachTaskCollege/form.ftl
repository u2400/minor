<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<script src="dwr/interface/taskActivityService.js"></script>
<body style="Z-index: 1">
    <#assign labInfo><@bean.message key="entity.teachTask"/>基本信息</#assign>
    <#include "/templates/back.ftl"/>
    <#--华政教学任务默认值-->
    <#include "initPage.ftl"/>
    <#-------------------------------------------->
    <table width="100%" align="center" class="formTable">
        <form name="teachTaskForm" action="" method="post" onsubmit="return false;">
        <input type="hidden" name="forward" value="${RequestParameters['forward']?if_exists}"/>
        <input type="hidden" name="params" value="${RequestParameters['params']?if_exists}"/>
        <tr class="darkColumn">
            <td align="center" colspan="4"><@bean.message key="entity.teachTask"/> <@bean.message key="common.baseInfo"/></td>
        </tr>
        <tr>
            <input type="hidden" value="${task.id?if_exists}" name="task.id"/>
            <input type="hidden" value="${task.course.id}" name="task.course.id"/>
            <input type="hidden" value="${task.course.code}" name="task.course.code"/>
            <input type="hidden" value="<@i18nName task.course/>" name="task.course.name"/>
            <td class="title" width="16%" id="f_name">&nbsp;<@bean.message key="attr.courseName"/>：</td>
            <td class="content" width="34%"><@i18nName task.course/></td>
            <td class="title" width="16%" id="f_name">&nbsp;<@bean.message key="attr.yearAndTerm"/>：</td>
            <td class="content">${task.calendar.year}&nbsp;${task.calendar.term}</td>
            <input type="hidden" value="${task.calendar.id}" name="task.calendar.id"/>
        </tr>
        <tr>
            <td class="title" id="f_name">&nbsp;<@bean.message key="entity.courseType"/>：</td>
            <td class="content">
                <select name="task.courseType.id" style="width:155px">
                    <#list sort_byI18nName(courseTypeList) as courseType>
                        <option value="${courseType.id}"<#if (task.courseType.id)?exists><#if task.courseType.id == courseType.id> selected</#if><#elseif !(task.course.extInfo.courseType.id)?exists><#if courseType_index == 0> selected</#if><#else><#if !(task.id)?exists><#if task.course.extInfo.courseType.id == courseType.id>selected<#elseif courseType_index == 0> selected</#if><#else><#if task.courseType.id?exists && courseType.id == task.courseType.id> selected<#elseif courseType_index == 0> selected</#if></#if></#if>><@i18nName courseType/></option>
                    </#list>
                </select>
            </td>
            <td class="title">
              是否需要指定学生
            </td>
            <td>
               <@htm.select2 name="task.teachClass.isStdNeedAssign" selected=(task.teachClass.isStdNeedAssign?string("1","0"))?default('0') hasAll=false />
            </td>
        </tr>
        <tr>
            <td class="title"></td>
            <td class="content">如果没有设置课程的课程类别（即，课程性质），则默认为列选第一项。</td>
            <td class="title"></td>
            <td class="content"></td>
        </tr>
        <tr class="darkColumn">
            <td colspan="4">&nbsp;教学班信息</td>
        </tr>
        <tr>
            <td class="title"  id="f_enrollTurn">&nbsp;<@bean.message key="attr.enrollTurn"/>：</td>
            <td class="content">
                <input name="task.teachClass.enrollTurn" maxlength="7" style="width:${formElementWidth}" value="${task.teachClass.enrollTurn?if_exists}">
            </td>
            <td class="title" id="f_teachClassName">&nbsp;<@bean.message key="entity.teachClass"/><font color="red">*</font>：</td>
            <td class="content">
            <input name="task.teachClass.name" maxLength="20" style="width:130px" value="${task.teachClass.name?html}"/><input name="autoReName" type="checkbox" checked/>根据行政班命名
            </td>
        </tr>
        <tr>
            <td class="title" width="20%" id="f_name">&nbsp;<@bean.message key="entity.studentType"/>：</td>
            <td class="content" width="20%">
                <select id="stdTypeOfSpeciality" name="task.teachClass.stdType.id" style="width:${formElementWidth}">
                    <option value="${task.teachClass.stdType.id}"><@i18nName task.teachClass.stdType/></option>
                </select>
            </td>
            <td class="title" id="f_adminClassName" rowspan="7">&nbsp;<@bean.message key="entity.adminClass"/>：</td>
            <td class="content" rowspan="7" valign="top">
                <table>
                    <tr>
                        <td style="border-style:none" rowspan="2">
                                <select name="adminClassSelect" id="adminClassSelect" multiple style="width:${formElementWidth};height:200px">
                                    <#list (task.teachClass.adminClasses)?sort_by("name") as adminClass>
                                        <option value="${adminClass.id}">${adminClass.name}</option>
                                    </#list>
                                </select>
                        </td>
                        <td style="border-style:none">
                            <input type="hidden" name="adminClassIds" value="<#list task.teachClass.adminClasses as adminClass>${adminClass.id},</#list>"/>
                            <input type="button" class="buttonStyle" value="<@msg.message key="action.add"/>" onClick="changeAdminClasses(this.form)"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="border-style:none">
                            <input type="button" class="buttonStyle" value="<@msg.message key="action.delete"/>" onClick="removeAdminClasses()"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="title" id="f_depart">&nbsp;<@bean.message key="entity.college"/><font color="red">*</font>：</td>
            <td class="content">
                <select id="department" name="task.teachClass.depart.id" style="width:${formElementWidth}">
                    <option value="<#if (task.id)?exists>${task.teachClass.depart.id}<#else>1</#if>">${(task.teachClass.depart.name)?default((defaultMap["teachClassDepart"]["name"])?default(""))}</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="title" id="f_speciality">&nbsp;<@bean.message key="entity.speciality"/>：</td>
            <td class="content">
                <select id="speciality" name="task.teachClass.speciality.id" style="width:${formElementWidth}">
                    <option value="${task.teachClass.speciality?if_exists.id?if_exists}"><@i18nName task.teachClass.speciality?if_exists/></option>
                </select>
            </td>
        </tr> 
        <tr>
            <td class="title" id="f_aspect">&nbsp;<@bean.message key="entity.specialityAspect"/>：</td>
            <td class="content">
                <select id="specialityAspect" name="task.teachClass.aspect.id" style="width:${formElementWidth}">
                    <option value="${task.teachClass.aspect?if_exists.id?if_exists}"><@i18nName task.teachClass.aspect?if_exists/></option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="title" align="center">性别：</td>
            <td class="content">
                <select name="task.teachClass.gender.id" style="width:${formElementWidth}">
                    <option value="">全部</option>
                <#list genderList?sort_by("code") as gender>
                    <option value="${gender.id}">${gender.name}</option>
                </#list>
            </td>
            <script>document.teachTaskForm["task.teachClass.gender.id"].value = "${(task.teachClass.gender.id)?if_exists}";</script>
        </tr>
        <tr>
            <td id="f_planStdCount" class="title">&nbsp;<@bean.message key="attr.planStdCount"/><font color="red">*</font>：</td>
            <td class="content">
                <input name="task.teachClass.planStdCount" value="${task.teachClass.planStdCount?if_exists}" size=1/>
                <input type="checkbox" name="calcStdCount"/>根据行政班计算
            </td>
        </tr>
        <tr>
            <td class="title">选课上限<font color="red">*</font>：</td>
            <td class="content">
                <select name="task.teachClass.isUpperLimit" style="width:${formElementWidth}">
                    <option value="1" select>以计划人数为上限</option>
                    <option value="0">不设上限</option>
                </select>
                <script>document.teachTaskForm["task.teachClass.isUpperLimit"].value = "${(task.teachClass.isUpperLimit)?default(false)?string(1, 0)}";</script>
            </td>
        </tr>
        <tr class="darkColumn">
            <td colspan="4">&nbsp;课程安排信息</td>
        </tr>
        <tr>
            <td class="title" id="f_teachDepart">&nbsp<@bean.message key="attr.teachDepart"/><font color="red">*</font>：</td>
            <td class="content">
                <select name="task.arrangeInfo.teachDepart.id" style="width:155px">
                    <#list teachDepartList?sort_by("code") as oneTeachDepart>
                        <option value="${oneTeachDepart.id?if_exists}" <#if task.arrangeInfo.teachDepart.id?exists && task.arrangeInfo.teachDepart.id == oneTeachDepart.id || defaultMap["teachDepartId"]?default("")?string == oneTeachDepart.id?string>selected</#if>><@i18nName oneTeachDepart/></option>
                    </#list>
                </select>
            </td>
            <td class="title" id="f_schoolDistrict">&nbsp<@bean.message key="entity.schoolDistrict"/>：</td>
            <td class="content"><@htm.i18nSelect datas=schoolDistrictList selected=(task.arrangeInfo.schoolDistrict.id)?default(defaultMap["schoolDistrict"]?default(""))?string name="task.arrangeInfo.schoolDistrict.id" style="width:155px"><option value=""></option></@></td>
        </tr>
        <tr>
            <td class="title" id="f_name">&nbsp;<@bean.message key="entity.teacher"/>：</td>
            <td class="content" colspan="3">
                <input type="hidden" name="teacherIds" value="<#list task.arrangeInfo.teachers as teacher>${teacher.id},</#list>"/>
                <label id="teacherNames"><@getTeacherNames task.arrangeInfo.teachers/></label>
                <br>
                <select id="teachDepartment" style="width:150px">
                    <option value="${(teacherDepart.id)?if_exists}"></option>
                </select>
                <select id="teacher" name="teacherId" style="width:220px" onchange="checkHasTaskForTeacher()">
                    <option value="${(teacher.id)?if_exists}"></option>
                </select>
                <input type="button" class="buttonStyle" value="<@bean.message key="action.clear"/>" onClick="cleanTeacher()"/>
                <input type="button" class="buttonStyle" value="<@bean.message key="action.add"/>" onClick="addTeacher();"/>
                <#if (task.arrangeInfo.isArrangeComplete)?default(false)><br><font color="blue">课程已排好，如需更换教师请在排课管理中更换，除非一定要更换。</font></#if>
            </td>
        </tr>
        <tr>
            <td class="title" id="f_weeks">&nbsp;<@bean.message key="attr.weeks"/><font color="red">*</font>：</td>
            <td class="content"><input name="task.arrangeInfo.weeks" style="width:30px" value="<#if task.arrangeInfo.weeks?exists>${task.arrangeInfo.weeks}<#else>18</#if>" maxLength="3"/>
            <#assign continuedWeek><@bean.message key="attr.continuedWeek"/></#assign>
            <#assign oddWeek><@bean.message key="attr.oddWeek"/></#assign>
            <#assign evenWeek><@bean.message key="attr.evenWeek"/></#assign>
            <#assign randomWeek><@bean.message key="attr.randomWeek"/></#assign>
            <#assign weekCycle=["${continuedWeek}","${oddWeek}","${evenWeek}","${randomWeek}"] />
                <select name="task.arrangeInfo.weekCycle"  style="width:100px" >
                    <#list weekCycle as sycle>
                        <option value="${sycle_index + 1}" <#if task.arrangeInfo.weekCycle?exists && (sycle_index +1) ==task.arrangeInfo.weekCycle> selected </#if>>${sycle}</option>
                    </#list>
                </select>
            </td>
            <td class="title"  id="f_weekUnits">&nbsp;<@bean.message key="attr.weekHour"/><font color="red">*</font>：</td>
            <td class="content"><input name="task.arrangeInfo.weekUnits" style="width:30px" value="${task.arrangeInfo.weekUnits}" maxLength="3"/>&nbsp;&nbsp;(总课时：${(task.course.extInfo.period)?default(0)})</td>
        </tr>
        <tr>
            <td id="f_weekStart" class="title">&nbsp;<@bean.message key="attr.startWeek"/><font color="red">*</font>：</td>
            <td class="content"><input name="task.arrangeInfo.weekStart" style="width:30px" value="${task.arrangeInfo.weekStart?if_exists}" maxLength="3"/></td>
            <td class="title" id="f_courseUnits">&nbsp;<@bean.message key="attr.unit"/><font color="red">*</font>：</td>
            <td class="content"><input name="task.arrangeInfo.courseUnits" style="width:30px" value="<#if !(task.id)?exists>${task.arrangeInfo.weekUnits?if_exists}<#else>${task.arrangeInfo.courseUnits?if_exists}</#if>" maxLength="3"/></td>
        </tr>
        <tr class="darkColumn">
            <td colspan="4">&nbsp;课程要求信息</td>
        </tr>
        <tr>
            <td class="title" id="f_name">&nbsp;<@bean.message key="attr.roomConfigOfTask"/>：</td>
            <td class="content">
                <select name="task.requirement.roomConfigType.id" style="width:155px">
                    <#list configTypeList as config>
                        <option value="${config.id}"<#if (task.requirement.roomConfigType.id)?if_exists?string == config.id?string || defaultMap["roomTypeId"]?default("") == config.id?string> selected</#if>><@i18nName config/></option>
                    </#list>
                </select>
            </td>
            <td class="title"  id="f_name">&nbsp;<@bean.message key="attr.bilingualGuaPai"/>：</td>
            <td class="content">
                <@htm.i18nSelect datas=teachLangTypes  name="task.requirement.teachLangType.id" selected=(task.requirement.teachLangType.id)?default(1)?string  style="width:80px"/>
                <input type="hidden" name="task.requirement.isGuaPai" value="<#if task.requirement.isGuaPai?if_exists==true>1<#else>0</#if>"/>
                <input name="isGuaPai" type="checkbox" onchange="changeCheckBoxValue(this.form,'task.requirement.isGuaPai');"
                <#if task.requirement.isGuaPai?if_exists==true>
                    checked
                </#if>/><@bean.message key="attr.isGuaPai"/>
            </td>
        </tr>
        <tr class="darkColumn">
            <td colspan="4"><input type="checkbox" id="otherInfoCheckBox" checked onClick="displayDiv('otherInfo', this.id)"/>其他信息</td>
        </tr>
        <tr>
            <td colspan="4">
                <div id="otherInfo" style="display:block">
                    <table class="formTable" width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="title" id="f_remark" width="16%">&nbsp;<@bean.message key="attr.remark"/>：</td>
                            <td colspan="2" class="content" width="43%">
                                <input type="text" name="task.remark" cols="55" value="${task.remark?if_exists?html}" style="width:350px"/>
                            </td>
                            <td>用于填写选课要求信息。</td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr class="darkColumn">
            <td colspan="6" align="center">
                <input type="button" value="<@bean.message key="action.submit"/>" name="saveButton" onClick="save(this.form)" class="buttonStyle"/>&nbsp;
                <input type="reset" name="resetButton" value="<@bean.message key="action.reset"/>" class="buttonStyle"/>
            </td>
        </tr>
            <input type="hidden" name="practiceCourse" value="${RequestParameters["practiceCourse"]?if_exists}"/>
            <#assign params = RequestParameters["params"]?default("")?split("&")/>
            <input type="hidden" name="params" value="<#if (params?size > 0)><#list 1..(params?size - 1) as i><#if !params[i]?default("")?contains("task.id")>${"&" + params[i]?default("")}</#if></#list></#if>"/>
        </form>
    </table>
    <div id="adminClassDIV" style="Z-index:0;display:none;width:350px;height:180px;position:absolute;top:230px;left:300px;border:solid;border-width:1px;background-color:white">
        <iframe src="#" id="adminClassListFrame" name="adminClassListFrame" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" height="100%" width="100%"></iframe>
    </div>
    <script language="javascript">
        var action = "";
        function save(form){
            if (${(task.arrangeInfo.isArrangeComplete?string("true", "false"))?default("false")} && form["teacherIds"].value != "<#list task.arrangeInfo.teachers as teacher>${teacher.id},</#list>" && !confirm("课已经排完，是否一定要修改教师？")) {
                return;
            }
            form.action = action + "?method=save";
            var a_fields = {
                'task.teachClass.name':{'l':'<@bean.message key="entity.teachClass"/>', 'r':true, 't':'f_teachClassName'},
                'task.arrangeInfo.weeks':{'l':'<@bean.message key="attr.weeks"/>', 'r':true, 'f':'integer', 't':'f_weeks'},
                'task.arrangeInfo.weekUnits':{'l':'<@bean.message key="attr.weekHour"/>', 'r':true, 'f':'unsignedReal', 't':'f_weekUnits'},
                'task.arrangeInfo.courseUnits':{'l':'<@bean.message key="attr.unitPerCourse"/>', 'r':true, 'f':'integer', 't':'f_courseUnits'},
                'task.arrangeInfo.weekStart':{'l':'<@bean.message key="attr.startWeek"/>', 'r':true, 'f':'integer', 't':'f_weekStart'},
                'task.teachClass.planStdCount':{'l':'<@bean.message key="attr.planStdCount"/>', 'r':true, 'f':'integer', 't':'f_planStdCount'},
                'task.arrangeInfo.teachDepart.id':{'l':'<@bean.message key="attr.teachDepart"/>', 'r':true, 't':'f_teachDepart'},
                'task.teachClass.depart.id':{'l':'<@bean.message key="entity.college"/>', 'r':true, 't':'f_depart'},
                'task.teachClass.enrollTurn':{'l':'<@bean.message key="attr.enrollTurn"/>', 'r':false, 't':'f_enrollTurn', 'f':'yearMonth'},
                'task.remark':{'l':'<@bean.message key="attr.remark"/>', 'r':false, 't':'f_remark', 'mx':100}
            };
         
            var v = new validator(form, a_fields, null);
            if (v.exec()) {
                if (hasTask && !confirm("当前所选教师有课，添加会冲突，要继续吗？")) {
	                return;
	            }
                if (parseInt(form['task.arrangeInfo.weeks'].value) + parseInt(form['task.arrangeInfo.weekStart'].value) - 1 > ${task.calendar.weeks}) {
                   alert("起始周和总周数之和不能超过教学日历中的${task.calendar.weeks}周");
                    return;
                }
                if (parseInt(form["task.arrangeInfo.weeks"].value) * parseInt(form["task.arrangeInfo.weekUnits"].value) != ${(task.course.extInfo.period)?default(0)}) {
                    alert("周数乘以周课时必须等于总课时。");
                    return;
                }
                form.submit();
            }
        }
        
        function displayDiv(divId, checkBoxId) {
            document.getElementById(divId).style.display = $(checkBoxId).checked ? "block" : "none";
        }
    
        function changeCheckBoxValue(form, checkboxName) {
            if(event.srcElement.checked) {
                form[checkboxName].value = "1";
            } else {
                form[checkboxName].value = "0";
            }
        }
        
        function changeAdminClasses(form) {
            if(form['task.teachClass.enrollTurn'].value != "") {
                if(!isYearMonth(form['task.teachClass.enrollTurn'].value)) {
                    alert("<@bean.message key="error.enrollTurn"/>");
                    return;
                }
            }
            
            var params = "";
            if (form['task.teachClass.stdType.id'].value != "") {
                params += "&adminClass.stdType.id=" + form['task.teachClass.stdType.id'].value;
            }
            if (form['task.teachClass.enrollTurn'].value != "") {
                params+="&adminClass.enrollYear=" + form['task.teachClass.enrollTurn'].value;
            }
            if(form['task.teachClass.depart.id'].value != "") {
                params += "&adminClass.department.id=" + form['task.teachClass.depart.id'].value;
            }
            if (form['task.teachClass.speciality.id'].value != "") {
                params += "&adminClass.speciality.id=" + form['task.teachClass.speciality.id'].value;
            }
            if (form['task.teachClass.aspect.id'].value != "") {
                params += "&adminClass.aspect.id=" + form['task.teachClass.aspect.id'].value;
            }
            
            adminClassDIV.style.display = "block";
            adminClassListFrame.location = "?method=listClassForTask&adminClassIds=" + form['adminClassIds'].value + params;
        }
        
        function setAdminClasses(adminClassIds, adminClassNames) {
            var select = document.getElementById("adminClassSelect");
            var adminClassIdArray = adminClassIds.split(",");
            var adminClassNameArray = adminClassNames.split(",");
            for(var i = 0; i < adminClassIdArray.length; i++){
                if("" != adminClassIdArray[i]) {
                    var op = new Option(adminClassNameArray[i], adminClassIdArray[i]);
                    if(!hasOption(select, op)) {
                        select.options[select.options.length] = op;
                    }
                }
            }
            
            var form = document.teachTaskForm;
            form['adminClassIds'].value = getAllOptionValue(select);
            adminClassDIV.style.display = "none";
        }
        
        function removeAdminClasses() {
            var select = document.getElementById("adminClassSelect");
          
            var selectAdminClassIds = getSelectedOptionValue(select);
            if("" == selectAdminClassIds) {
                alert("请选择班级进行删除");
                return;
            } else {
                removeSelectedOption(select);
                var form = document.teachTaskForm;
                form['adminClassIds'].value = getAllOptionValue(select);
            }
        }
        
        function cancelSetAdminClasses() {
            adminClassDIV.style.display = "none";
        }
        function cleanTeacher() {
            if (${(task.arrangeInfo.isArrangeComplete?string("true", "false"))?default("false")} && !confirm("课已经排完，是否一定要修改教师？")) {
                return;
            }
            document.teachTaskForm['teacherIds'].value='';
            $('teacherNames').innerHTML='';
        }
        function addTeacher() {
            if (${(task.arrangeInfo.isArrangeComplete?string("true", "false"))?default("false")} && !confirm("课已经排完，是否一定要修改教师？")) {
                return;
            }
            if (hasTask && !confirm("当前所选教师有课，添加会冲突，要继续吗？")) {
                return;
            }
            var teacher = document.getElementById('teacher');
            if(teacher.value != "") {
                if(document.teachTaskForm['teacherIds'].value.indexOf(teacher.value) == -1) {
                    document.teachTaskForm['teacherIds'].value += teacher.value + ",";
                    if ("" != $("teacherNames").innerHTML) {
                        $("teacherNames").innerHTML += ",&nbsp;";
                    }
                    $("teacherNames").innerHTML += DWRUtil.getText('teacher');
                }
            }
        }
        
        function checkHasTaskForTeacher() {
        	if(!${(task.id)?exists?string("true", "false")} || <#if (task.id)?exists && task.arrangeInfo.activities?size == 0>true<#else>false</#if>){
        		return;
        	}
            taskActivityService.isBeenTaskForTeacher(hasTaskForTeacher, ${task.calendar.id}, $("teacher").value, ${(task.id)?default(-1)});
        }
        
        var hasTask = false;
        function hasTaskForTeacher(data) {
            if (data) {
                alert("当前所选择的教师有课，请另作选择。");
                hasTask = true;
                return;
            }
            hasTask = false;
        }
        <#--全局变量，用于三联动的元素宽度-->
        var inputElementWidth = "${formElementWidth}";
    </script>
    <#include "/templates/stdTypeDepart3Select.ftl"/>
    <#assign departmentList = teacherDepartList/>
    <#include "/templates/departTeacher2Select.ftl"/>
</body>
<#include "/templates/foot.ftl"/>