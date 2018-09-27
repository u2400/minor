<#include "/templates/head.ftl"/>
<#import "../cycleType.ftl" as RoomApply/>
<script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<script src='dwr/interface/userDWRService.js'></script>
<style>
input,textarea {
border: 1px solid #333333;
}
</style>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
    <table id="bar"></table>
    <#assign mustFullFlagHTML><span style="color:red">*</span></#assign>
    <table class="formTable" align="center" width="80%">
        <form action="${formActionURL?default("ecuplRoomApplyApprove.do")}?method=freeRoomList" method="post" name="roomApplyForm" onsubmit="return false;">
            <input name="roomIds" type="hidden" value="${RequestParameters["classroomIds"]}"/>
        <tr class="darkColumn" align="center">
            <td colspan="5"><B>教室借用填写表</B></td>
        </tr>
        <tr>
            <td class="title" align="center" rowspan="2" style="text-align:center">借用人</td>
            <td class="title" align="right" width="18%" id="f_userid">${mustFullFlagHTML} 用户帐号：</td>
            <td width="24%"><input type="text" name="userName" value="" maxlength="20" size="15"/><button id="checkUserButton" onclick="checkUser()">查找</button><label id="borrowerUser" style="color:blue"></label></td>
            <input type="hidden" name="userCode" value=""/>
            <td class="title" align="right" width="18%">姓名：</td>
            <td width="24%" id="u_name"></td>
        </tr>
        <tr>
            <td class="title" align="right">班级：</td>
            <td id="u_adminClassName"></td>
            <td class="title" align="right" id="f_mobile">${mustFullFlagHTML} 联系电话：</td>
            <td><input type="text" name="roomApply.borrower.mobile" value="" size="15" maxlength="70"/></td>
        </tr>
        <tr>
            <td class="title" align="center" style="text-align:center">借用用途</td>
            <td class="title" align="right"  id="f_activityName">${mustFullFlagHTML} 活动名称：</td>
            <td colspan="3"><input type="text" name="roomApply.activityName" size="50" maxlength="50" value=""/></td>
        </tr>
        <tr>
            <td class="title" style="text-align:center" style="text-align:center">多媒体使用情况</td>
            <td colspan="4">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td style="border-width:0px;padding-right: 15px"><input id="rq_computer" type="checkbox" name="roomRequest" checked/><label for="rq_computer">电脑</label></td>
                        <td style="border-width:0px;padding-right: 15px"><input id="rq_projector" type="checkbox" name="roomRequest" checked/><label for="rq_projector">投影仪</label></td>
                        <td style="border-width:0px"><input id="rq_amplification_system" type="checkbox" name="roomRequest" checked/><label for="rq_amplification_system">扩音设备</label></td>
                    </tr>
                </table>
                <#--多媒体使用情况其值为：000、001、010、011、100、101、110和111，第一位表示“电脑”状态，第二位表示“投影仪”状态，第三位表示“扩音设备”状态-->
                <input type="hidden" name="roomApply.roomRequest" value=""/>
            </td>
        </tr>
        <tr>
            <td class="title" align="center" rowspan="2" style="text-align:center">借用时间要求</td>
            <td class="title" id="f_begin_end" align="right"><font color="red">*</font>&nbsp;教室使用日期：</td>
            <td colspan="3" style="font-family:宋体"><input type="text" name="roomApply.applyTime.dateBegin" value="${RequestParameters["roomApply.applyTime.dateBegin"][0..9]}" onfocus="calendar();onunload()" size="10" maxlength="10"/> - <input type="text" name="roomApply.applyTime.dateEnd" value="${RequestParameters["roomApply.applyTime.dateEnd"][0..9]}" onfocus="calendar();onunload()" size="10" maxlength="10"/>(例如：${Session["nowDate"]?string("yyyy-MM-dd")}，表示：${Session["nowDate"]?string("yyyy年MM月dd日")})</td>
        </tr>
        <tr>
            <td class="title" id="f_beginTime_endTime" align="right"><font color="red">*</font>&nbsp;教室使用时间：</td>
            <td colspan="3" style="font-family:宋体"><input type="text" name="roomApply.applyTime.timeBegin" value="${RequestParameters["roomApply.applyTime.timeBegin"]}" size="10" class="LabeledInput" value="" format="Time" maxlength="4"/> - <input type="text" name="roomApply.applyTime.timeEnd"  value="${RequestParameters["roomApply.applyTime.timeEnd"]}" size="10" maxlength="4"/>(例如：${Session["nowDate"]?string("HHmm")}，表示：${Session["nowDate"]?string("H:mm")})</td>
        </tr>
        <input type="hidden" name="roomApply.applyTime.cycleCount" value="${RequestParameters["roomApply.applyTime.cycleCount"]?default("1")}"/>
        <input type="hidden" name="roomApply.applyTime.cycleType" value="${RequestParameters["roomApply.applyTime.cycleType"]?default("1")}"/>
        <input type="hidden" name="roomApply.auditDepart.id" value="${(thisObject.getUserDepartment(user.name).id)?default(1)}"/>
        <tr class="darkColumn">
            <td colspan="5" align="center"><button id="applyButton" onClick="apply()">申请</button>&nbsp;&nbsp;<button onClick="formReset()">重填</button></td>
        </tr>
            <input type="hidden" name="params" value="${RequestParameters["params1"]?if_exists}"/>
        </form>
    </table>
    <script>
        var bar = new ToolBar("bar", "快速申请教室借用", null, true, true);
        bar.setMessage('<@getMessage/>');
        <#if formActionURL?exists>
        bar.addBack();
        <#else>
        bar.addBlankItem();
        </#if>
        
        var form = document.roomApplyForm;
        
        function formReset() {
            document.getElementById("u_name").innerHTML = document.getElementById("u_adminClassName").innerHTML = "";
            form.reset();
        }
        
        function checkUser() {
            $("checkUserButton").disabled = "disabled";
            $("borrowerUser").style.color = "red";
            $("borrowerUser").innerHTML = "<br>正在查询中，请稍候...";
            userDWRService.getEamsUser(processResult, form["userName"].value);
        }
        
        function processResult(data) {
            if (null == data || "" == data) {
                form["userCode"].value = "";
                $("borrowerUser").innerHTML = "";
                document.getElementById("u_name").innerHTML = "";
                document.getElementById("u_adminClassName").innerHTML = "";
                $("message").innerHTML = "请输入有效的借用人登录帐号。";
                $("message").style.display = "block";
                $("checkUserButton").disabled = "";
                form["userName"].focus();
                return;
            }
            $("message").style.display = "none";
            $("message").innerHTML = "";
            form["userCode"].value = data.code;
            document.getElementById("u_name").innerHTML = data.name;
            try  {
                document.getElementById("u_adminClassName").innerHTML = data.firstMajorClass.name;
            } catch (e) {
                document.getElementById("u_adminClassName").innerHTML = "";
            }
            $("borrowerUser").innerHTML = "";
            $("checkUserButton").disabled = "";
            adaptFrameSize();
        }
        
        <#include "applySwitchJS.ftl"/>
        function apply() {
            ${isAllowApplyJS(applySwitches)}
            if (!isAllowApply) {
                alert("当前借用教室时间还未开放\n或已经结束。");
                return false;
            }
            if (isEmpty(form["userCode"].value)) {
                alert("请先填写借用人并查询验证。");
                return;
            }
            var a_fields = {
                'roomApply.borrower.mobile':{'l':'联系电话', 'r':true, 't':'f_mobile','f':'unsigned'},
                'roomApply.activityName':{'l':'活动名称', 'r':true, 't':'f_activityName'},
                'roomApply.applyTime.dateBegin':{'l':'教室使用日期的“起始日期”', 'r':true, 't':'f_begin_end','f':'date'},
                'roomApply.applyTime.dateEnd':{'l':'教室使用日期的“结束日期”', 'r':true, 't':'f_begin_end','f':'date'},
                'roomApply.applyTime.timeBegin':{'l':'教室使用的“开始”时间点', 'r':true, 't':'f_beginTime_endTime','f':'shortTimeNoBreakSign'},
                'roomApply.applyTime.timeEnd':{'l':'教室使用的“结束”时间点', 'r':true, 't':'f_beginTime_endTime','f':'shortTimeNoBreakSign'}
            };
            var v = new validator(form, a_fields, null);
            if (v.exec()) {
                var now = new Date();
                var yyyyMMdd = (now.getFullYear() * 100 + now.getMonth() + 1) * 100 + now.getDate();
                var mmss = now.getHours() * 100 + now.getMinutes();
                
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
                
                var roomRequests = document.getElementsByName("roomRequest");
                var roomRequestValue = "";
                for (var i = 0; i < roomRequests.length; i++) {
                    roomRequestValue += roomRequests[i].checked ? "1" : "0";
                }
                form["roomApply.roomRequest"].value = roomRequestValue;
                
                //form["roomApply.applyTime.dateBegin"].value += " " + form["roomApply.applyTime.timeBegin"].value + ":00.000000";
                //form["roomApply.applyTime.dateEnd"].value += " " + form["roomApply.applyTime.timeEnd"].value + ":00.000000";
                form.action = "ecuplDepartmentRoomApply.do?method=quickApply";
                form.target = "";
                form.submit();
            }
        }
    </script>
</BODY>
<#include "/templates/foot.ftl"/>
