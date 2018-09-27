<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/CascadeSelect.js"></script> 
<BODY LEFTMARGIN="0" TOPMARGIN="0">
    <table id="bar1" width="100%"></table>
    <#assign mustFullFlagHTML><span style="color:red">*</span></#assign>
    <table id="freeRoomHomeTable" class="formTable" align="center" width="100%">
        <form action="" method="post" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="requestParamter" value="${requestParamter?if_exists}">
            <tr>
                <td class="darkColumn" colspan="4" style="text-align:center;font-weight:bold">空闲教室查询</td>
            </tr>
            <tr>
                <td class="title">教室名称：</td>
                <td><input name="classroom.name" value="" maxlength="10" style="width:100px"/></td>
                <td class="title"><@bean.message key="entity.building"/>：</td>
                <td >
                    <select name="classroom.building.id" style="width:120px;">
                        <option value="">...</option>
                        <#list buildings as building>
                        <option value="${building.id}">${building.name}</option>
                        </#list>
                    </select>
                </td>
            </tr>
            <#if buildings?size == 0>
            <tr>
                <td colspan="4" style="color:red;font-family:宋体;font-weight:bold">(当前用户没有指定院系，或不是教务处和系统管理员，故没有可借的教室。)</td>
            </tr>
            <#else>
            <tr>
                <td class="title">教室设备配置：</td>
                <td>
                    <@htm.i18nSelect datas=classroomTypes selected=RequestParameters["classroom.configType.id"]?default("") name="classroom.configType.id" style="width:120px;">
                        <option value="">...</option>
                    </@>
                </td>
                <td class="title">校区：</td>
                <td>
                    <@htm.i18nSelect datas=campuses selected=RequestParameters["classroom.schoolDistrict.id"]?default("") name="classroom.schoolDistrict.id" style="width:120px;">
                        <option value="">...</option>
                    </@>
                </td>
            </tr>
            <tr>
                <td class="title" id="f_capacity">容量：</td>
                <td><input name="capacity" value="" maxlength="10" style="width:100px"/></td>
                <td class="title" id="f_capacityOfExam">考试人数(≥)：</td>
                <td><input name="capacityOfExam" value="" maxlength="10" style="width:100px"/></td>
            </tr>
            </#if>
            <tr>
                <td class="title" id="f_begin_end" align="right">${mustFullFlagHTML}教室使用日期：</td>
                <td colspan="3" style="font-family:宋体"><input type="text" name="roomApply.applyTime.dateBegin" value="" onfocus="calendar();onunload()" size="10" maxlength="10"/> - <input type="text" name="roomApply.applyTime.dateEnd" value="" onfocus="calendar();onunload()" size="10" maxlength="10"/>(例如：${Session["nowDate"]?string("yyyy-MM-dd")}，表示：${Session["nowDate"]?string("yyyy年MM月dd日")})</td>
            </tr>
            <tr>
                <td class="title" id="f_beginTime_endTime" align="right">${mustFullFlagHTML}教室使用时间点：</td>
                <td colspan="3" style="font-family:宋体"><input type="text" name="roomApply.applyTime.timeBegin" value="" size="10" class="LabeledInput" format="Time" maxlength="4"/> - <input type="text" name="roomApply.applyTime.timeEnd" size="10" maxlength="4"/>(例如：${Session["nowDate"]?string("HHmm")}，表示：${Session["nowDate"]?string("H:mm")})</td>
            </tr>
            <#if buildings?size != 0>
            <tr>
                <td class="title" id="f_cycleCount">时间周期：</td>
                <td colspan="3"><input type="text" name="roomApply.applyTime.cycleCount" style="width:50px" value="1" maxlength="2" onblur="this.value = isEmpty(this.value) ? 1 : this.value"/>/天<input type="hidden" name="roomApply.applyTime.cycleType" value="1"/></td>
            </tr>
            </#if>
            <tr>
                <td class="darkColumn" colspan="4" style="text-align:center">
                    <button id="searchButton" onClick="searchFreeApply()">查询</button>
                    &nbsp;&nbsp;
                    <button id="resetButton" onClick="this.form.reset()">重填</button>
                </td>
            </tr>
            <input type="hidden" name="classroomIds" value=""/>
            <#assign filterKeys = ["method"]/>
            <input type="hidden" name="params1" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
        </form>
    </table>
    <div style="height:10px"></div>
    <div id="freeRoomListBarDiv" style="width:100%;display:none">
        <table id="bar2" width="100%"></table>
    </div>
    <div id="freeRoomListTableDiv" style="width:100%;height:45%;display:none;overflow-y:auto;overflow-x:no">
        <table width="100%" height="100%" cellspace="0" cellpadding="0">
            <tr valign="top">
                <td><iframe id="roomIframe" name="roomIframe" src="#" marginwidth="0" marginheight="0" width="100%" height="100%" frameborder="0" scrolling="no"></iframe></td>
            </tr>
        </table>
    </div>
    <script>
        var bar1 = new ToolBar("bar1", "教室借用管理", null, true, true);
        bar1.setMessage('<@getMessage/>');
        bar1.addBlankItem();
        
        var bar2 = new ToolBar("bar2", "空闲教室查询", null, true, true);
        bar2.addItem("借用教室", "quickApplySetting()", "new.gif");
        bar2.addItem("关闭查询", "closeDiv()");
        
        var form = document.actionForm;
        
        form["roomApply.applyTime.cycleType"].value = "1";
        
        var now = new Date();
        var yyyyMMdd = (now.getFullYear() * 100 + now.getMonth() + 1) * 100 + now.getDate();
        var mmss = now.getHours() * 100 + now.getMinutes();
        
        function searchFreeApply() {
            var errorInfo="";
            if (beforeApply()) {
                var dateBeginValue = parseInt(form['roomApply.applyTime.dateBegin'].value.replace(new RegExp("-", "gm"), ""), 10);
                var dateEndValue = parseInt(form['roomApply.applyTime.dateEnd'].value.replace(new RegExp("-", "gm"), ""), 10);
                if(dateBeginValue > dateEndValue || dateBeginValue < yyyyMMdd){
                   alert(autoWardString("借用日期无效或过期，请选择将来时间。", 28));return;
                }
                var timeBeginValue = parseInt(form['roomApply.applyTime.timeBegin'].value, 10);
                var timeEndValue = parseInt(form['roomApply.applyTime.timeEnd'].value, 10);
                if(timeBeginValue >= timeEndValue || dateBeginValue <= yyyyMMdd && timeBeginValue <= mmss){
                   alert(autoWardString("借用时间区间无效或过期，请正确设置时间区间并填写将来时间。", 28));return;
                }
                form.action = "ecuplDepartmentRoomApply.do?method=freeRoomList";
                form.target = "roomIframe";
                form.submit();
                operationSwitch(true);
            }
        }
        
        <#include "applySwitchJS.ftl"/>
        function beforeApply() {
            ${isAllowApplyJS(applySwitches)}
            if (!isAllowApply) {
                alert("当前借用教室时间还未开放\n或已经结束。");
                return false;
            }
            var a_fields = {
                'capacity':{'l':'听课人数', 'r':false, 't':'f_capacity','f':'positiveInteger'},
                'capacityOfExam':{'l':'考试人数', 'r':false, 't':'f_capacityOfExam','f':'positiveInteger'},
                'roomApply.applyTime.dateBegin':{'l':'教室使用日期的“起始日期”', 'r':true, 't':'f_begin_end','f':'date'},
                'roomApply.applyTime.dateEnd':{'l':'教室使用日期的“结束日期”', 'r':true, 't':'f_begin_end','f':'date'},
                'roomApply.applyTime.timeBegin':{'l':'教室使用的“开始”时间点', 'r':true, 't':'f_beginTime_endTime','f':'shortTimeNoBreakSign'},
                'roomApply.applyTime.timeEnd':{'l':'教室使用的“结束”时间点', 'r':true, 't':'f_beginTime_endTime','f':'shortTimeNoBreakSign'}
            };
            var v = new validator(form, a_fields, null);
            return v.exec();
        }
        
        function operationSwitch(isTrue) {
            for (var i = 0; i < form.length; i++) {
                //alert((form[i].name || form[i].id) + " : " + form[i].type);
                switch (form[i].type) {
                    case "text":
                        form[i].readOnly = isTrue;
                        break;
                    case "select-one":
                    case "button":
                    case "submit":
                    case "reset":
                        form[i].disabled = isTrue;
                        break;
                }
            }
        }
        
        function closeDiv() {
            document.getElementById("freeRoomListBarDiv").style.display = document.getElementById("freeRoomListTableDiv").style.display = "none";
            operationSwitch(false);
            window.onunload();
        }
    
        function quickApplySetting() {
            var classroomIds = getCheckBoxValue(roomIframe.document.getElementsByName("classroomId"));
            if (beforeApply()) {
                if (null == classroomIds || "" == classroomIds) {
                    alert("请选择要申请的教室。");
                    return;
                }
                form.action = "ecuplDepartmentRoomApply.do?method=quickApplySetting";
                form.target = "_self";
                form["classroomIds"].value = classroomIds;
                operationSwitch(false);
                form.submit();
            }
        }
        
        window.onresize = function (event) {
            window.onunload();
            document.getElementById("freeRoomListTableDiv").style.height = (document.body.clientHeight - document.getElementById("freeRoomHomeTable").clientTop - document.getElementById("freeRoomHomeTable").clientHeight - 80) + "px";
        }
        
        window.onload = function() {
            closeDiv();
        }
        
        window.onunload = function() {
            try {
                parent.document.getElementById("displayFrame").style.height = "100%";
            } catch (e) {
                parent.document.getElementById("contentFrame").style.height = "100%";
            }
        }
    </script>
</BODY>
<#include "/templates/foot.ftl"/>