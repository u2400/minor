<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body>
    <table id="bar" width="100%"></table>
    <#assign mustBeFull><span style="font-weight:bold;color:red">*</span></#assign>
    <table class="formTable" width="80%" align="center">
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="placeSwitch.id" value="${(placeSwitch.id)?if_exists}"/>
            <input type="hidden" name="placeSwitchId" value="${(placeSwitch.id)?if_exists}"/>
        <tr>
            <td class="darkColumn" colspan="2" style="text-align:center;font-weight:bold">毕业实习基地开关</td>
        </tr>
        <tr>
            <td id="f_name" class="title" width="25%">${mustBeFull}开关名称：</td>
            <td><input type="text" name="placeSwitch.name" value="${(placeSwitch.name?html)?if_exists}" maxlength="100" style="width:300px"/></td>
        </tr>
        <tr>
            <td id="f_grades" class="title" width="25%">${mustBeFull}年级：</td>
            <td><input type="text" name="placeSwitch.grades" value="${(placeSwitch.grades?html)?if_exists}" maxlength="100" style="width:300px"/>（一个或多少，用“,”分隔）</td>
        </tr>
        <tr>
            <td id="f_beginOn" class="title">${mustBeFull}开始日期：</td>
            <td><input id="placeSwitch.beginOn" type="text" name="placeSwitch.beginOn" value="${(placeSwitch.beginOn?string("yyyy-MM-dd"))?if_exists}" maxlength="10" style="width:300px" readOnly onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'placeSwitch.endOn\')}'})"/></td>
        </tr>
        <tr>
            <td id="f_endOn" class="title">${mustBeFull}截止日期：</td>
            <td><input id="placeSwitch.endOn" type="text" name="placeSwitch.endOn" value="${(placeSwitch.endOn?string("yyyy-MM-dd"))?if_exists}" maxlength="10" style="width:300px" readOnly onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'placeSwitch.beginOn\')}'})"/></td>
        </tr>
        <tr>
            <td id="f_stdTypeIds" class="title">${mustBeFull}学生类别：</td>
            <td>
                <div id="stdType_frontstage" style="display:block">
                    <input type="text" name="stdTypeNames" value="<#list (placeSwitch.stdTypes)?if_exists as stdType>${stdType.name}<#if stdType_has_next>,</#if></#list>" style="width:300px" readOnly/>
                    <button onclick="openSource('stdType_frontstage', 'stdType_backstage')">选择</button>
                </div>
                <div id="stdType_backstage" style="display:none">
                    <select name="stdTypeSources" multiple style="width:300px;height:100px" onclick="choiceItems('stdTypeNames', 'stdTypeSources', 'stdTypeIds')">
                        <#list (stdTypes?sort_by("name"))?if_exists as stdType>
                        <option value="${stdType.id}"<#if (placeSwitch.stdTypes)?exists && placeSwitch.stdTypes?seq_contains(stdType)> selected</#if>>${stdType.name}</option>
                        </#list>
                    </select>
                    <br>
                    <button onclick="closeSource('stdType_frontstage', 'stdType_backstage')">确定</button>
                </div>
                <input type="hidden" name="stdTypeIds" value="<#list (placeSwitch.stdTypes)?if_exists as stdType>${stdType.id}<#if stdType_has_next>,</#if></#list>"/>
            </td>
        </tr>
        <tr>
            <td id="f_departmentIds" class="title">${mustBeFull}院系：</td>
            <td>
                <div id="department_frontstage" style="display:block">
                    <input type="text" name="departmentNames" value="<#list (placeSwitch.departments)?if_exists as department>${department.name}<#if department_has_next>,</#if></#list>" style="width:300px" readOnly/>
                    <button onclick="openSource('department_frontstage', 'department_backstage')">选择</button>
                </div>
                <div id="department_backstage" style="display:none">
                    <select name="departmentSources" multiple style="width:300px;height:200px" onclick="choiceItems('departmentNames', 'departmentSources', 'departmentIds')">
                        <#list (departments?sort_by("name"))?if_exists as department>
                        <option value="${department.id}"<#if (placeSwitch.departments)?exists && placeSwitch.departments?seq_contains(department)> selected</#if>>${department.name}</option>
                        </#list>
                    </select>
                    <br>
                    <button onclick="closeSource('department_frontstage', 'department_backstage')">确定</button>
                </div>
                <input type="hidden" name="departmentIds" value="<#list (placeSwitch.departments)?if_exists as department>${department.id}<#if department_has_next>,</#if></#list>"/>
            </td>
        </tr>
        <tr>
            <td class="title">是否使用：</td>
            <td>
                <select name="placeSwitch.open" style="width:300px">
                    <option value="1">使用</option>
                    <option value="0" selected>禁用</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="darkColumn" colspan="2" style="text-align:center">
                <button id="saveButton" onclick="save()">保存</button>
                <span style="width:10px"></span>
                <button onclick="this.form.reset()">重置</button>
            </td>
        </tr>
        </form>
    </table>
    <script>
        var bar = new ToolBar("bar", "毕业实习基地开关维护", null, true, true)
        bar.setMessage('<@getMessage/>');
        bar.addBack();
        
        var form = document.actionForm;
        
        var isExecuting = false;
        
        form["placeSwitch.open"].value = "${(placeSwitch.open)?default(false)?string(1, 0)}";
        
        function controlSaveButton() {
            document.getElementById("saveButton").disabled = "none" == document.getElementById("stdType_frontstage").style.display || "none" == document.getElementById("department_frontstage").style.display;
        }
        
        function openSource(frontStage_name, backStage_name) {
            document.getElementById(frontStage_name).style.display = "none";
            document.getElementById(backStage_name).style.display = "block";
            controlSaveButton();
        }
        
        function closeSource(frontStage_name, backStage_name) {
            document.getElementById(frontStage_name).style.display = "block";
            document.getElementById(backStage_name).style.display = "none";
            controlSaveButton();
        }
        
        function choiceItems(frontStage_name, backStage_name, storage_name) {
            var frongObj = form[frontStage_name];
            var backObj = form[backStage_name];
            var storageObj = form[storage_name];
            
            var frontValue = "";
            var backValue = "";
            
            for (var i = 0; i < backObj.options.length; i++) {
                if (backObj.options[i].selected) {
                    if (null != frontValue && "" != frontValue) {
                        frontValue += ",";
                    }
                    frontValue += backObj.options[i].text;
                    
                    if (null != backValue && "" != backValue) {
                        backValue += ",";
                    }
                    backValue += backObj.options[i].value;
                }
            }
            
            frongObj.value = frontValue;
            storageObj.value = backValue;
        }
        
        function save() {
            if (isExecuting) {
                alert("当前操作正在执行中...");
                return;
            }
            var a_fields = {
                "placeSwitch.name":{"l":"名称", "r":true, "t":"f_name"},
                "placeSwitch.grades":{"l":"年级", "r":true, "t":"f_grades"},
                "placeSwitch.beginOn":{"l":"开始日期", "r":true, "t":"f_beginOn"},
                "placeSwitch.endOn":{"l":"截止日期", "r":true, "t":"f_endOn"},
                "stdTypeIds":{"l":"学生类别", "r":true, "t":"f_stdTypeIds"},
                "departmentIds":{"l":"院系", "r":true, "t":"f_departmentIds"}
            };
            var v = new validator(form, a_fields, null);
            if (v.exec()) {
                var matchResult = form["placeSwitch.grades"].value.match(new RegExp(",,", "gm"));
                if (null != matchResult || "," == form["placeSwitch.grades"].value.substr(0, 1) || "," == form["placeSwitch.grades"].value.substr(form["placeSwitch.grades"].value.length - 1, 1)) {
                    alert("当前设置的“年级”无效。");
                    return;
                }
                form.action = "placeTakeSwitch.do?method=save";
                form.target = "_self";
                form.submit();
                isExecuting = true;
            }
        }
        
        window.history.back = function () {
            form.action = "placeTakeSwitch.do?method=index";
            form.target = "_self";
            form.submit();
        };
        window.history.go = function () {
            window.history.back();
        };
    </script>
</body>
<#include "/templates/foot.ftl"/>