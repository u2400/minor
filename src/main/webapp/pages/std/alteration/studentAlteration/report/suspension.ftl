<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#include "reportHead.ftl"/>
    <#list alterations as alteration>
    <table id="alteration_${alteration_index}" align="center" style="line-height:32pt;width:140mm;text-align:justify;text-justify:inter-ideograph;font-family:楷体_GB2312;;font-size:16pt" cellpadding="0" cellspacing="0">
        <tr>
            <td style="text-align:center;font-family:华文行楷,楷体_GB2312;font-size:42pt;line-height:60pt;"><@i18nName systemConfig.school/></td>
        </tr>
        <#assign semesterDurationValue = semesterDuration(alteration)/>
        <#assign dateline = getAddMonthDate(alteration.alterBeginOn, 3)/>
        <tr>
            <td style="text-align:center;font-family:华文行楷,楷体_GB2312;padding-top:12pt;padding-bottom:12pt;font-size:24pt;letter-spacing:-0.5pt" nowrap>关于同意${alteration.std.name}同学${alteration.mode.name}${semesterDurationValue}的决定</td>
        </tr>
        <tr height="50px">
            <td></td>
        </tr>
        <tr>
            <td style="text-align:right">华政教务休[${dateline[0..3]?default("&nbsp;&nbsp;&nbsp;&nbsp;")}]${alteration.seqNo?default("0")?substring(alteration.seqNo?length - 4)?number}号</td>
        </tr>
        <tr height="25px">
            <td></td>
        </tr>
        <tr style="text-indent:33pt;">
            <td>${alteration.std.name}，${alteration.std.gender.name}，学号：${alteration.std.code}，${(alteration.beforeStatus.department.name)?default(alteration.std.department.name)}
            ${endWithReplaceString((alteration.beforeStatus.speciality.name)?default((alteration.std.firstMajor.name)?default("")), "专业")}
            ${endWithReplaceString((alteration.beforeStatus.aspect.name)?default((alteration.std.firstAspect.name)?if_exists), "方向")}
            ${(alteration.beforeStatus.adminClass.code)?default((alteration.std.adminClasses?first.code)?default("&nbsp;&nbsp;&nbsp;&nbsp;"))}班学生。该生因健康原因，向学校提出申请${alteration.mode.name}${semesterDurationValue}。</td>
        </tr>
        <tr style="text-indent:33pt;letter-spacing:-0.5pt">
            <td>根据<@i18nName systemConfig.school/>《全日制本科生学分制学籍管理规定》第六章第三十一条之规定及卫生科建议，同意${alteration.std.name}同学${alteration.mode.name}${semesterDurationValue}。${alteration.mode.name}年限自${alteration.alterBeginOn?string("yyyy年M月")}至${(alteration.alterEndOn?string("yyyy年M月"))?default("----年--月")}止。</td>
        </tr>
        <tr height="32pt">
            <td></td>
        </tr>
        <tr style="text-indent:33pt">
            <td>特此决定</td>
        </tr>
        <tr height="96pt">
            <td></td>
        </tr>
        <tr>
            <td style="text-align:right"><@i18nName systemConfig.school/>教务处</td>
        </tr>
        <tr>
            <td style="text-align:right">${to_chineseNumber(dateline[0..3], true)}年${to_chineseNumber(dateline[4..5]?number?string, false)}月${to_chineseNumber(dateline[6..7]?number?string, false)}日</td>
        </tr>
    </table>
        <#if alteration_has_next>
    <div style='page-break-after: always'><br style="height:0; line-height:0"/></div>
        </#if>
    </#list>
    <script>
        var bar = new ToolBar("bar", "休学决定", null, true, true);
        //bar.addItem("显示/隐藏边线", "displayPageLine()");
        bar.addPrint();
        bar.addClose();
        
        function displayPageLine() {
            for (var i = 0; i > -1; i++) {
                var tableObj = document.getElementById("alteration_" + i);
                if (isEmpty(tableObj)) {
                    break;
                }
                if (isEmpty(tableObj.style.borderWidth)) {
                    tableObj.style.borderWidth = "1px";
                    tableObj.style.borderColor = "red";
                    tableObj.style.borderStyle = "solid";
                } else {
                    tableObj.style.borderWidth = tableObj.style.borderColor = tableObj.style.borderStyle = null;
                }
            }
        }
    </script>
</body>
<#assign marginMM_Value = 31.7/>
<#include "reportFoot.ftl"/>
<#include "/templates/foot.ftl"/>