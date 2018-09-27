<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table style="width:170mm;text-align:center" align="center">
        <tr>
            <td>
                <#list applications as application>
                <table style="width:184.6mm;font-size:14pt;text-align:center" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="font-weight:bold"><@i18nName systemConfig.school/>全日制本科生转专业（方向）申请表</td>
                    </tr>
                </table>
                <div style="height:18pt"></div>
                <table class="listTable" style="width:100%;font-size:12pt" align="center" cellpadding="0" cellspacing="0">
                    <tr style="text-align:center" height="36pt">
                        <td width="15.5%">姓名</td>
                        <td width="14.5%">${application.std.name}</td>
                        <td width="8.5%">学号</td>
                        <td width="13.5%">${application.std.code}</td>
                        <td width="15.5%">性别</td>
                        <td width="8.5%">${application.std.gender.name}</td>
                        <td width="10.5%">班级</td>
                        <td width="13.5%">${(application.std.adminClasses?first.name)}</td>
                    </tr>
                    <tr style="text-align:center" height="36pt">
                        <td>手机</td>
                        <td colspan="3">${(application.std.basicInfo.mobile)?if_exists}</td>
                        <td>住址电话</td>
                        <td colspan="3">${(application.std.basicInfo.phone)?if_exists}</td>
                    </tr>
                    <tr style="text-align:center" height="36pt">
                        <td>所在院系</td>
                        <td<#if (application.major.department.name?length)?default(0) gt 6> style="font-size:9pt"</#if>>${(application.major.department.name)?if_exists}</td>
                        <td colspan="2">所学专业</td>
                        <td<#if (application.major.name?length)?default(0) gt 6> style="font-size:9pt"</#if>>${(application.major.name)?if_exists}</td>
                        <td colspan="2">专业方向</td>
                        <td<#if (application.std.firstAspect.name?length)?default(0) gt 6> style="font-size:9pt"</#if>>${(application.std.firstAspect.name)?if_exists}</td>
                    </tr>
                    <tr style="text-align:center" height="36pt">
                        <td>拟转入院系</td>
                        <td<#if (application.majorPlan.major.department.name?length)?default(0) gt 6> style="font-size:9pt"</#if>>${(application.majorPlan.major.department.name)?if_exists}</td>
                        <td colspan="2">拟转入专业</td>
                        <td<#if (application.majorPlan.major.name?length)?default(0) gt 6> style="font-size:9pt"</#if>>${(application.majorPlan.major.name)?if_exists}</td>
                        <td colspan="2">拟转入方向</td>
                        <td<#if (application.majorPlan.majorField.name?length)?default(0) gt 6> style="font-size:9pt"</#if>>${(application.majorPlan.majorField.name)?if_exists}</td>
                    </tr>
                    <tr height="36pt">
                        <td style="padding-left:6pt" colspan="5"><span style="letter-spacing:6pt">第一学年平均学分绩点</span>（学校填写）</td>
                        <td style="padding-left:6pt" colspan="3">${(thisObj.gradePointService.statStdGPAByYear(application.std, firstMajorType, true).GPList[0].GPA?string("0.00"))?if_exists}</td>
                    </tr>
                    <tr height="36pt">
                        <td style="padding-left:6pt" colspan="5"><span style="letter-spacing:6pt">学分绩点排名</span>（学校填写）</td>
                        <td style="padding-left:6pt" colspan="3"></td>
                    </tr>
                    <tr height="24pt">
                        <td style="padding-left:12pt;border-bottom-width:0px" colspan="8">转专业（方向）理由，并提供相应材料（附后）：</td>
                    </tr>
                    <tr height="48pt">
                        <td colspan="8" style="border-top-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="4" style="border-top-width:0px;border-right-width:0px;border-bottom-width:0px"></td>
                        <td colspan="2" style="border-width:0px">申请人签名</td>
                        <td colspan="2" style="border-top-width:0px;border-left-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="5" style="border-top-width:0px;border-right-width:0px"></td>
                        <td colspan="3" style="letter-spacing:24pt;border-top-width:0px;border-left-width:0px">年月日</td>
                    </tr>
                    <tr height="24pt">
                        <td style="padding-left:12pt;border-bottom-width:0px" colspan="8">学生所在院系推荐意见：</td>
                    </tr>
                    <tr height="48pt">
                        <td colspan="8" style="border-top-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="4" style="border-top-width:0px;border-right-width:0px;border-bottom-width:0px"></td>
                        <td colspan="2" style="border-width:0px">签名（盖章）：</td>
                        <td colspan="2" style="border-top-width:0px;border-left-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="5" style="border-top-width:0px;border-right-width:0px"></td>
                        <td colspan="3" style="letter-spacing:24pt;border-top-width:0px;border-left-width:0px">年月日</td>
                    </tr>
                    <tr height="24pt">
                        <td style="padding-left:12pt;border-bottom-width:0px" colspan="8">拟转入院系面试意见：</td>
                    </tr>
                    <tr height="48pt">
                        <td colspan="8" style="border-top-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="4" style="border-top-width:0px;border-right-width:0px;border-bottom-width:0px"></td>
                        <td colspan="2" style="border-width:0px">面试教师签名：</td>
                        <td colspan="2" style="border-top-width:0px;border-left-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="5" style="border-top-width:0px;border-right-width:0px"></td>
                        <td colspan="3" style="letter-spacing:24pt;border-top-width:0px;border-left-width:0px">年月日</td>
                    </tr>
                    <tr height="24pt">
                        <td style="padding-left:12pt;border-bottom-width:0px" colspan="8">拟转入院系意见：</td>
                    </tr>
                    <tr height="48pt">
                        <td colspan="8" style="border-top-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="4" style="border-top-width:0px;border-right-width:0px;border-bottom-width:0px"></td>
                        <td colspan="2" style="border-width:0px">签名（盖章）：</td>
                        <td colspan="2" style="border-top-width:0px;border-left-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="5" style="border-top-width:0px;border-right-width:0px"></td>
                        <td colspan="3" style="letter-spacing:24pt;border-top-width:0px;border-left-width:0px">年月日</td>
                    </tr>
                    <tr height="24pt">
                        <td style="padding-left:12pt;border-bottom-width:0px" colspan="8">教务处意见：</td>
                    </tr>
                    <tr height="48pt">
                        <td colspan="8" style="border-top-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="4" style="border-top-width:0px;border-right-width:0px;border-bottom-width:0px"></td>
                        <td colspan="2" style="border-width:0px">签名（盖章）：</td>
                        <td colspan="2" style="border-top-width:0px;border-left-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="5" style="border-top-width:0px;border-right-width:0px"></td>
                        <td colspan="3" style="letter-spacing:24pt;border-top-width:0px;border-left-width:0px">年月日</td>
                    </tr>
                    <tr height="24pt">
                        <td style="padding-left:12pt;border-bottom-width:0px" colspan="8">学校审批意见：</td>
                    </tr>
                    <tr height="48pt">
                        <td colspan="8" style="border-top-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="4" style="border-top-width:0px;border-right-width:0px;border-bottom-width:0px"></td>
                        <td colspan="2" style="border-width:0px">签名（盖章）：</td>
                        <td colspan="2" style="border-top-width:0px;border-left-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr height="24pt" style="text-align:center">
                        <td colspan="5" style="border-top-width:0px;border-right-width:0px"></td>
                        <td colspan="3" style="letter-spacing:24pt;border-top-width:0px;border-left-width:0px">年月日</td>
                    </tr>
                </table>
                    <#if application_has_next>
                <div style='page-break-after: always'><br style="height:0; line-height:0"/></div>
                    </#if>
                </#list>
            </td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "申请表", null, true, true);
        bar.addPrint();
        bar.addClose();
    </script>
</body>
<object id="factory" style="display:none" viewastext classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="css/smsx.cab#Version=6,2,433,14"></object>
<script>
 function window.onload(){
    try{
       if(typeof factory.printing != 'undefined'){
            factory.printing.header = ""; 
            factory.printing.footer = "";
            factory.printing.leftMargin = factory.printing.topMargin = factory.printing.rightMargin = factory.printing.bottomMargin = 6 * 0.039370078740157;
       }
    }catch(e){
    }
 }
</script>
<#include "/templates/foot.ftl"/>