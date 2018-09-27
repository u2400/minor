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
                <td><input name="classroom.name" value="${RequestParameters['classroom.name']?if_exists}" maxlength="10" style="width:100px"/></td>
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
            </#if>
            <tr>
                <td class="title" id="f_begin_end" align="right">${mustFullFlagHTML}教室使用日期：</td>
                <td colspan="3" style="font-family:宋体"><input type="text" name="roomApply.applyTime.dateBegin" value="" onfocus="calendar();onunload()" size="10" maxlength="10"/> - <input type="text" name="roomApply.applyTime.dateEnd" value="" onfocus="calendar();onunload()" size="10" maxlength="10"/>(例如：${Session["nowDate"]?string("yyyy-MM-dd")}，表示：${Session["nowDate"]?string("yyyy年MM月dd日")})</td>
            </tr>
            <tr>
                <td class="title" id="f_beginTime_endTime" align="right">${mustFullFlagHTML}教室使用时间点：</td>
                <td colspan="3" style="font-family:宋体"><input type="text" name="roomApply.applyTime.timeBegin" value="" size="10" class="LabeledInput" format="Time" maxlength="4"/> - <input type="text" name="roomApply.applyTime.timeEnd" size="10" maxlength="4"/>(例如：${Session["nowDate"]?string("HHmm")}，表示：${Session["nowDate"]?string("H:mm")})</td>
            </tr>
            <input type="hidden" name="roomApply.applyTime.cycleCount" value="1"/>
            <input type="hidden" name="roomApply.applyTime.cycleType" value="1"/>
            <tr>
                <td class="darkColumn" colspan="4" style="text-align:center">
                    <button id="searchButton" onClick="searchFreeApply()">查询</button>
                    &nbsp;&nbsp;
                    <button id="resetButton" onClick="this.form.reset()">重填</button>
                </td>
            </tr>
            <input type="hidden" name="classroomIds" value=""/>
        </form>
    </table>
    <div style="height:10px"></div>
    <div id="freeRoomListBarDiv" style="width:100%;display:none">
        <table id="bar2" width="100%"></table>
    </div>
    <div id="freeRoomListTableDiv" style="width:100%;height:60%;display:none;overflow-y:auto;overflow-x:no">
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
        
        form["classroom.building.id"].value = "${RequestParameters["classroom.building.id"]?default("")}";
        
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
                form.action = "roomApply.do?method=freeRoomList";
                form.target = "roomIframe";
                form.submit();
                form["classroom.name"].readOnly = form["classroom.building.id"].disabled = form["roomApply.applyTime.dateBegin"].disabled = form["roomApply.applyTime.dateEnd"].disabled = form["roomApply.applyTime.timeBegin"].disabled = form["roomApply.applyTime.timeEnd"].disabled = document.getElementById("searchButton").disabled = document.getElementById("resetButton").disabled = true;
            }
        }
        
        function beforeApply() {
            var a_fields = {
                'roomApply.applyTime.dateBegin':{'l':'教室使用日期的“起始日期”', 'r':true, 't':'f_begin_end','f':'date'},
                'roomApply.applyTime.dateEnd':{'l':'教室使用日期的“结束日期”', 'r':true, 't':'f_begin_end','f':'date'},
                'roomApply.applyTime.timeBegin':{'l':'教室使用的“开始”时间点', 'r':true, 't':'f_beginTime_endTime','f':'shortTimeNoBreakSign'},
                'roomApply.applyTime.timeEnd':{'l':'教室使用的“结束”时间点', 'r':true, 't':'f_beginTime_endTime','f':'shortTimeNoBreakSign'}
            };
            var v = new validator(form, a_fields, null);
            return v.exec();
        }
        
        function closeDiv() {
            document.getElementById("freeRoomListBarDiv").style.display = document.getElementById("freeRoomListTableDiv").style.display = "none";
            form["classroom.name"].readOnly = form["classroom.building.id"].disabled = form["roomApply.applyTime.dateBegin"].disabled = form["roomApply.applyTime.dateEnd"].disabled = form["roomApply.applyTime.timeBegin"].disabled = form["roomApply.applyTime.timeEnd"].disabled = document.getElementById("searchButton").disabled = document.getElementById("resetButton").disabled = false;
            window.onunload();
        }
    
        function quickApplySetting() {
            var classroomIds = getCheckBoxValue(roomIframe.document.getElementsByName("classroomId"));
            if (beforeApply()) {
                if (null == classroomIds || "" == classroomIds) {
                    alert("请选择要申请的教室。");
                    return;
                }
                form.action = "roomApply.do?method=quickApplySetting";
                form.target = "_self";
                form["classroomIds"].value = classroomIds;
                form["classroom.name"].readOnly = form["classroom.building.id"].disabled = form["roomApply.applyTime.dateBegin"].disabled = form["roomApply.applyTime.dateEnd"].disabled = form["roomApply.applyTime.timeBegin"].disabled = form["roomApply.applyTime.timeEnd"].disabled = document.getElementById("searchButton").disabled = document.getElementById("resetButton").disabled = false;
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