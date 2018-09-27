<#include "/templates/head.ftl"/>
<body>
    <table id="bar1" width="100%"></table>
    <script>var oApplySwitchMap = {};</script>
    <@table.table id="applySwitchTable" width="100%" sortable="false">
        <@table.thead>
            <@table.td text="学年学期"/>
            <@table.td text="开始时间"/>
            <@table.td text="结束时间"/>
        </@>
        <@table.tbody datas=applySwitches;applySwitch>
            <td>${applySwitch.calendar.year}&nbsp;${applySwitch.calendar.term}</td>
            <td>${applySwitch.fromAt?string("yyyy-MM-dd HH:mm:ss")}</td>
            <td>${applySwitch.endAt?string("yyyy-MM-dd HH:mm:ss")}</td>
            <script>oApplySwitchMap["${applySwitch.calendar.id}"] = {"fromAt":${applySwitch.fromAt?string("yyyyMMddHHmmss")}, "endAt":${applySwitch.endAt?string("yyyyMMddHHmmss")}};</script>
        </@>
    </@>
    <div style="height:30px"></div>
    <table id="bar2" width="100%"></table>
    <script>var oResultMap = {};</script>
    <#if results?exists && results?size != 0>
    <@table.table id="applyResultTable" width="100%" sortable="false">
        <@table.thead>
            <@table.selectAllTd id="resultId"/>
            <@table.td text="申请学校名称"/>
            <@table.td text="申请类型"/>
            <@table.td text="申请专业（方向）名称"/>
            <@table.td text="学年学期"/>
            <@table.td text="愿否专业（方向）调剂"/>
            <@table.td text="本人只愿意接受学术型推免资格"/>
            <@table.td text="本人接受调剂为专业学位推免资格"/>
        </@>
        <@table.tbody datas=results;result>
            <@table.selectTd id="resultId" value=result.id/>
            <td>${result.schoolName}</td>
            <td>${(result.applyType.name)?default("<span style=\"color:red\">（当前系统没有设置“推免申请类型”，请系统学校。）</span>")}</td>
            <td>${result.majorName}</td>
            <td>${result.calendar.year}&nbsp;${result.calendar.term}</td>
            <td>${result.isAllowMajor?string("愿", "否")}</td>
            <td>${result.isAllowAcademic?string("愿", "否")}</td>
            <td>${result.isAllowDegree?string("愿", "否")}</td>
            <script>oResultMap["${result.id}"] = "${result.calendar.id}";</script>
        </@>
    </@>
    <#else>
    <div style="font-size:12pt">你当时没推免申请过。想申请，请点击<button onclick="apply()">我要申请</button>。</div>
    </#if>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="resultId" value=""/>
    </form>
    <script>
        var oBar1 = new ToolBar("bar1", "推免申请开关", null, true, true);
        oBar1.setMessage('<@getMessage/>');
        oBar1.addBlankItem();
        
        var oBar2 = new ToolBar("bar2", "推免申请情况", null, true, true);
        <#if !results?exists || 0 == results?size>
        oBar2.addItem("我要申请", "apply()", "new.gif");
        </#if>
        <#if results?exists && results?size != 0>
        oBar2.addItem("修改申请", "editApply()", "update.gif");
        oBar2.addItem("生成打印表", "report()", "print.gif");
        </#if>
        
        var oForm = document.actionForm;
        
        function apply() {
            oForm["resultId"].value = "";
            var calendarId = "${(openApplySwitch.calendar.id)?if_exists}";
            if (null == calendarId || undefined == calendarId || "" == calendarId) {
                alert("当时“推免申请”时间还未开放。");
                return;
            }
            var oApplySwitch = oApplySwitchMap[calendarId];
            if (null == oApplySwitch || undefined == oApplySwitch || "" == oApplySwitch || null == oApplySwitch.fromAt || undefined == oApplySwitch.fromAt || "" == oApplySwitch.fromAt) {
                alert("当时“推免申请”时间还未开放。");
                return;
            }
            
            var nowAtValue = new Date();
            var nowAt = parseInt(nowAtValue.getFullYear() + "" + (nowAtValue.getMonth() + 101 + "").substr(1) + (nowAtValue.getDate() + 100 + "").substr(1) + (nowAtValue.getHours() + 100 + "").substr(1) + (nowAtValue.getMinutes() + 100 + "").substr(1)  + (nowAtValue.getSeconds() + 100 + "").substr(1));
            
            if (nowAt < oApplySwitch.fromAt || nowAt > oApplySwitch.endAt) {
                alert("当时“推免申请”时间还未开放。");
                return;
            }
            
            oForm.action = "exemptionApply.do?method=edit";
            oForm.target = "_self";
            oForm.submit();
        }
        
        function editApply() {
            oForm["resultId"].value = "";
            var calendarId = "${(openApplySwitch.calendar.id)?if_exists}";
            if (null == calendarId || undefined == calendarId || "" == calendarId) {
                alert("当时“推免申请”时间还未开放。");
                return;
            }
            var oApplySwitch = oApplySwitchMap[calendarId];
            if (null == oApplySwitch || undefined == oApplySwitch || "" == oApplySwitch || null == oApplySwitch.fromAt || undefined == oApplySwitch.fromAt || "" == oApplySwitch.fromAt) {
                alert("当时“推免申请”时间还未开放。");
                return;
            }
            
            var nowAtValue = new Date();
            var nowAt = parseInt(nowAtValue.getFullYear() + "" + (nowAtValue.getMonth() + 101 + "").substr(1) + (nowAtValue.getDate() + 100 + "").substr(1) + (nowAtValue.getHours() + 100 + "").substr(1) + (nowAtValue.getMinutes() + 100 + "").substr(1)  + (nowAtValue.getSeconds() + 100 + "").substr(1));
            
            if (nowAt < oApplySwitch.fromAt || nowAt > oApplySwitch.endAt) {
                alert("当时“推免申请”时间还未开放。");
                return;
            }
            
            var iResultId = getSelectId("resultId");
            if (null == iResultId || undefined == iResultId || "" == iResultId || iResultId.split(",").length > 1 || nowAt < oApplySwitchMap[oResultMap[iResultId]].fromAt || nowAt > oApplySwitchMap[oResultMap[iResultId]].endAt) {
                alert("请选择一条要修改且对应“推免申请开关”时间正开放的记录。");
                return;
            }
            
            oForm.action = "exemptionApply.do?method=edit";
            oForm.target = "_self";
            oForm["resultId"].value = iResultId;
            oForm.submit();
        }
        
        function report() {
            oForm["resultId"].value = "";
            var iResultId = getSelectId("resultId");
            
            if (null == iResultId || undefined == iResultId || "" == iResultId || iResultId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            oForm.action = "exemptionApply.do?method=report";
            oForm.target = "_blank";
            oForm["resultId"].value = iResultId;
            oForm.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>
