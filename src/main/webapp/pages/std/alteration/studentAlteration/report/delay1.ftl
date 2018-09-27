<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#include "reportHead.ftl"/>
    <#list alterations as alteration>
    <table id="alteration_${alteration_index}" align="center" style="line-height:32pt;width:157mm;text-align:justify;text-justify:inter-ideograph;font-family:楷体_GB2312;;font-size:16pt" cellpadding="0" cellspacing="0">
        <tr>
            <td style="text-align:center;font-family:华文行楷,楷体_GB2312;font-size:42pt;line-height:60pt;"><@i18nName systemConfig.school/></td>
        </tr>
        <tr>
            <td style="text-align:center;font-family:华文行楷,楷体_GB2312;line-height:48pt;font-size:24pt">关于准予<span style="border-bottom-width:0px;border-bottom-style:solid">${alteration.std.name}</span>${alteration.mode.name}学习年限一年的决定</td>
        </tr>
        <tr height="50px">
            <td></td>
        </tr>
        <#assign dateline = getAddMonthDate(alteration.alterBeginOn, 1)/>
        <tr>
            <td style="text-align:right">华政教务延[<span style="border-bottom-width:0px;border-bottom-style:solid">${dateline[0..3]?default("&nbsp;&nbsp;&nbsp;&nbsp;")}</span>]<span style="border-bottom-width:0px;border-bottom-style:solid">${alteration.seqNo?substring(alteration.seqNo?length - 4)?number}</span>号</td>
        </tr>
        <tr height="25px">
            <td></td>
        </tr>
        <tr style="text-indent:33pt">
            <td><span style="border-bottom-width:0px;border-bottom-style:solid">${alteration.std.name}</span>，<span style="border-bottom-width:0px;border-bottom-style:solid">${alteration.std.gender.name}</span>，学号（<span style="border-bottom-width:0px;border-bottom-style:solid">${alteration.std.code}</span>），系<span style="border-bottom-width:0px;border-bottom-style:solid">${alteration.std.department.name}${(alteration.std.studentStatusInfo.enrollDate?string("yyyy"))?default(alteration.std.enrollYear?substring(0, 4))}</span>级${alteration.std.type.name}。<span style="border-bottom-width:0px;border-bottom-style:solid">${alteration.std.name}</span>在校期间因不符合华东政法大学《全日制本科生学分制学籍管理规定》中相关毕业条件或不符合《授予本科毕业生学士学位实施细则》第四条之规定，向学校提出申请，${alteration.mode.name}学习年限一年。</td>
        </tr>
        <tr style="text-indent:33pt">
            <td>根据<@i18nName systemConfig.school/>《全日制本科生学分制学籍管理规定》第八章第四十三条之规定，经学校批准，决定准予<span style="border-bottom-width:0px;border-bottom-style:solid">${alteration.std.name}</span>${alteration.mode.name}学习年限一年，编入<span style="border-bottom-width:0px;border-bottom-style:solid">${(alteration.afterStatus.adminClass.name)?default("&nbsp;&nbsp;&nbsp;&nbsp;")}</span>班继续学习。${alteration.mode.name}期限自<span style="border-bottom-width:0px;border-bottom-style:solid">${alteration.alterBeginOn?string("yyyy")}</span>年${alteration.alterBeginOn?string("M")}月起至<span style="border-bottom-width:0px;border-bottom-style:solid">${(alteration.alterEndOn?string("yyyy"))?default("&nbsp;&nbsp;&nbsp;&nbsp;")}</span>年${(alteration.alterEndOn?string("M"))?default("&nbsp;&nbsp;")}月止。</td>
        </tr>
        <tr style="text-indent:33pt">
            <td>特此决定</td>
        </tr>
        <tr height="32pt">
            <td></td>
        </tr>
        <tr style="line-height:32pt">
            <td>附：此决定由学生本人保管并附成绩单一份</td>
        </tr>
        <tr height="64pt">
            <td></td>
        </tr>
        <tr>
            <td style="text-align:right"><@i18nName systemConfig.school/>教务处</td>
        </tr>
        <tr>
            <td style="text-align:right"><span style="border-bottom-width:0px;border-bottom-style:solid">${to_chineseNumber(dateline[0..3], true)}年${to_chineseNumber(dateline[4..5]?number?string, false)}月</span></td>
        </tr>
    </table>
        <#if alteration_has_next>
    <div style='page-break-after: always'><br style="height:0; line-height:0"/></div>
        </#if>
    </#list>
    <script>
        var bar = new ToolBar("bar", "延长学习决定（一）", null, true, true);
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
<#assign marginMM_Value = 26/>
<#include "reportFoot.ftl"/>
<#include "/templates/foot.ftl"/>