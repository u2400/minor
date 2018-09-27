<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body>
    <table id="bar" width="100%"></table>
    <#assign mustBeFull_HTML><span style="color:red;font-weight:bold">*</span></#assign>
    <table class="formTable" width="60%" align="center" style="vertical-align:middle">
        <tr>
            <td class="darkColumn" style="font-weight:bold;text-align:center" colspan="2">免试攻读硕士学位研究生申请表</td>
        </tr>
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="eResult.id" value="${(eResult.id)?if_exists}"/>
            <input type="hidden" name="eResult.student.id" value="${student.id}"/>
        <tr height="26px">
            <td id="f_schoolName" class="title" width="35%">${mustBeFull_HTML}申请学校名称：</td>
            <td><input type="text" name="eResult.schoolName" value="${(eResult.schoolName)?if_exists}" maxlength="100" style="width:200px"/></td>
        </tr>
        <tr height="26px">
            <td class="title">申请类型：</td>
            <td>
                <#if applyTypes?exists && applyTypes?size != 0>
                <#list applyTypes as applyType><input id="applyType_${applyType.id}_" type="radio" name="eResult.applyType.id" value="${applyType.id}"<#if (eResult.applyType.id)?exists && eResult.applyType.id == applyType.id || applyType_index == 0> checked</#if>/><label for="applyType_${applyType.id}_">${applyType.name}</label><#if applyType_has_next><span style="width:10px"></span></#if></#list>
                <#else>
                <span style="color:red">（当前系统没有设置“推免申请类型”，请系统学校。）</span>
                <input type="hidden" name="eResult.applyType.id" value=""/>
                </#if>
            </td>
        </tr>
        <tr height="26px">
            <td id="f_majorName" class="title">${mustBeFull_HTML}申请专业（方向）名称：</td>
            <td><input type="text" name="eResult.majorName" value="${(eResult.majorName)?if_exists}" maxlength="100" style="width:200px"/></td>
        </tr>
        <tr height="26px">
            <td id="f_majorName" class="title">学年学期：</td>
            <td>${calendar.year}&nbsp;${calendar.term}<input type="hidden" name="eResult.calendar.id" value="${calendar.id}"/></td>
        </tr>
        <tr height="26px">
            <td class="title">愿否专业（方向）调剂：</td>
            <td><input id="isAllowMajor_1" type="radio" name="eResult.isAllowMajor" value="1"<#if (eResult.isAllowMajor)?default(false)> checked</#if>/><label for="isAllowMajor_1">愿</label><span style="width:10px"></span><input id="isAllowMajor_0" type="radio" name="eResult.isAllowMajor" value="0"<#if !(eResult.isAllowMajor)?default(false)> checked</#if>/><label for="isAllowMajor_0">否</label></td>
        </tr>
        <tr height="26px">
            <td class="title">本人只愿意接受学术型推免资格：</td>
            <td><input id="isAllowAcademic_1" type="radio" name="eResult.isAllowAcademic" value="1"<#if (eResult.isAllowAcademic)?default(false)> checked</#if>/><label for="isAllowAcademic_1">愿</label><span style="width:10px"></span><input id="isAllowAcademic_0" type="radio" name="eResult.isAllowAcademic" value="0"<#if !(eResult.isAllowAcademic)?default(false)> checked</#if>/><label for="isAllowAcademic_0">否</label></td>
        </tr>
        <!--tr height="26px">
            <td class="title">本人接受调剂为专业学位推免资格：</td>
            <td><input id="isAllowDegree_1" type="radio" name="eResult.isAllowDegree" value="1"<#if (eResult.isAllowDegree)?default(false)> checked</#if>/><label for="isAllowDegree_1">愿</label><span style="width:10px"></span><input id="isAllowDegree_0" type="radio" name="eResult.isAllowDegree" value="0"<#if !(eResult.isAllowDegree)?default(false)> checked</#if>/><label for="isAllowDegree_0">否</label></td>
            
        </tr-->
            <tr height="26px">
            <td class="title">获奖信息：</td>
            <td><textarea name="eResult.awardText" rows="3" cols="35">${(eResult.awardText)!}</textarea>(最多250个字符)</td>
        </tr>
        
         <tr height="26px">
            <td class="title">成果信息：</td>
            <td><textarea name="eResult.resultText" rows="3" cols="35">${(eResult.resultText)!}</textarea>(最多250个字符)</td>
        </tr>
        
        <tr>
            <td class="darkColumn" style="text-align:center" colspan="2"><button onclick="save()">提交</button></td>
        </tr>
        </form>
    </table>
    <script>
        var oBar = new ToolBar("bar", "我的推免申请", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addBack();
        
        var oForm = document.actionForm;
        
        function save() {
            var aFields = {
                "eResult.schoolName":{"l":"申请学校名称", "r":true, "t":"f_schoolName"},
                "eResult.majorName":{"l":"申请专业（方向）名称", "r":true, "t":"f_majorName"}
            };
            
            var oValidator = new validator(oForm, aFields, null);
            if (oValidator.exec()) {
                oForm.action = "exemptionApply.do?method=save";
                oForm.target = "_self";
                oForm.submit();
            }
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>