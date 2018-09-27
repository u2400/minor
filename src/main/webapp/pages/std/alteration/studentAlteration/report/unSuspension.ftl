<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#include "reportHead.ftl"/>
    <#list alterations as alteration>
    <table id="alteration_${alteration_index}" align="center" style="line-height:32pt;width:146mm;text-align:justify;text-justify:inter-ideograph;font-family:楷体_GB2312;;font-size:16pt" cellpadding="0" cellspacing="0">
        <tr>
            <td style="text-align:center;font-family:华文行楷,楷体_GB2312;font-size:42pt;line-height:60pt;"><@i18nName systemConfig.school/></td>
        </tr>
        <tr>
            <td style="text-align:center;font-family:华文行楷,楷体_GB2312;line-height:48pt;font-size:24pt">关于同意${(alteration.std.name)?default("　　　")}同学${alteration.mode.name}的决定</td>
        </tr>
        <tr height="50px">
            <td></td>
        </tr>
        <#assign dateline = getAddMonthDate(alteration.alterBeginOn, 3)/>
        <tr>
            <td style="text-align:right">华政教务复[${dateline[0..3]?default("&nbsp;&nbsp;&nbsp;&nbsp;")}]${alteration.seqNo?default("0")?substring(alteration.seqNo?length - 4)?number}号</td>
        </tr>
        <tr height="25px">
            <td></td>
        </tr>
        <tr style="text-indent:33pt">
            <td>${alteration.std.name}，${alteration.std.gender.name}，学号：${alteration.std.code}，${(alteration.beforeStatus.department.name)?default(alteration.std.department.name)}
            ${endWithReplaceString((alteration.beforeStatus.speciality.name)?default(alteration.std.firstMajor.name), "专业")}
            ${endWithReplaceString((alteration.beforeStatus.aspect.name)?default((alteration.std.firstAspect.name)?if_exists), "方向")}
            ${(alteration.beforeStatus.adminClass.code)?default((alteration.std.adminClasses?first.code)?if_exists)}班学生。该生因健康原因，曾于&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;起休学，现经医务科复查，该生已基本痊愈。</td>
        </tr>
        <tr style="text-indent:33pt">
            <td>根据<@i18nName systemConfig.school/>《全日制本科生学分制学籍管理规定》第六章第三十六条之规定，经本人申请，准予${alteration.std.name}同学自${(alteration.alterBeginOn?string("yyyy年M月"))?default("－－－－年－－月")}起复学，编入${(alteration.afterStatus.department.name)?default("&nbsp;&nbsp;&nbsp;&nbsp;")}${(alteration.afterStatus.adminClass.code)?default("&nbsp;&nbsp;&nbsp;&nbsp;")}班继续学习。</td>
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
        var bar = new ToolBar("bar", "复学决定", null, true, true);
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