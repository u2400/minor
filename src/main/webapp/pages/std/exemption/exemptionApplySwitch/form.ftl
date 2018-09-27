<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<script src='dwr/interface/stdGrade.js'></script>
<script src='dwr/interface/courseDao.js'></script>
<body>
    <table id="bar"></table>
    <table class="formTable" width="100%" align="center">
    <form method="post" action="" name="actionForm">
        <input type="hidden" name="applySwitch.id" value="${(applySwitch.id)?if_exists}"/>
        <tr>
            <td class="darkColumn" style="text-align:center;font-weight:bold" colspan="4">申请开关维护</td>
        </tr>
        <tr>
            <td id="f_stdTypeId" class="title" width="20%"><span style="color:red;font-weight:bold">*</span>学生类别：</td>
            <td width="30%">
                <select id="stdType" name="studentTypeId" style="width:200px;">
                    <option value="${(applySwitch.calendar.studentType.id)?if_exists}">...</option>
                </select>
            </td>
            <td id="f_year" class="title" width="20%"><span style="color:red;font-weight:bold">*</span>学年度/学期：</td>
            <td>
                <select id="year" name="year" style="width:100px;">
                    <option value="${(applySwitch.calendar.year)?if_exists}">...</option>
                </select>
                /
                <select id="term" name="term" style="width:100px;">
                    <option value="${(applySwitch.calendar.term)?if_exists}">...</option>
                </select>
            </td>
        </tr>
        <tr>
            <td id="f_fromAt" class="title"><span style="color:red;font-weight:bold">*</span>开始时间：</td>
            <td><input type="text" id="applySwitch.fromAt" name="applySwitch.fromAt" value="${(applySwitch.fromAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}" readOnly style="width:200px" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'applySwitch.endAt\')}'})"/></td>
            <td id="f_endAt" class="title"><span style="color:red;font-weight:bold">*</span>结束时间：</td>
            <td><input type="text" id="applySwitch.endAt" name="applySwitch.endAt" value="${(applySwitch.endAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}" readOnly style="width:200px" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'applySwitch.fromAt\')}'})"/></td>
        </tr>
        <tr>
            <td class="darkColumn" style="text-align:center" colspan="4"><button onclick="save()">提交</button><span style="width:10px"></span><button onclick="this.form.reset()">重置</button></td>
        </tr>
    </form>
    </table>
    <#include "/templates/calendarSelect.ftl"/>
    <script>
        var oBar = new ToolBar("bar", "推免申请开关维护", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addBack();
        
        var oForm = document.actionForm;
        
        function save() {
            var aFields = {
                "applySwitch.fromAt":{"l":"开始时间", "r":true, "t":"f_fromAt"},
                "applySwitch.endAt":{"l":"结束时间", "r":true, "t":"f_endAt"}
            };
            var oValidator = new validator(oForm, aFields, null);
            if (oValidator.exec()) {
                oForm.action = "exemptionApplySwitch.do?method=save";
                oForm.target = "_self";
                oForm.submit();
            }
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>