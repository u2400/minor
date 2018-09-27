<#include "/templates/head.ftl"/>
<body>
    <table id="bar"></table>
    <#assign pageCaption = calendar.year + "学年" + (calendar.isSmallTerm?string(calendar.term, "第" + calendar.term + "学期")) + "课程质量汇总表"/>
    <#assign conditionValue = ""/>
    <#assign countCond = 0/>
    <#list RequestParameters?keys as key>
        <#if key?starts_with("evaluateTeacher.") && !key?contains("calendar") && RequestParameters[key]?default("") != "">
            <#if key?ends_with(".id")>
                <#assign conditionValue = "（" + RequestParameters["_" + key] + "）" + conditionValue/>
            <#else>
                <#assign conditionValue = "（" + RequestParameters["_" + key] + " 含“" + RequestParameters[key] + "”）" + conditionValue/>
            </#if>
            <#assign countCond = countCond + 1/>
        </#if>
    </#list>
    <#if countCond == 0>
        <#assign conditionValue = "<br>"/>
    </#if>
    <#assign maxTDSize = departmentResult?size/>
    <#assign tdCount = maxTDSize * 4/>
    <#assign tdTitleWidth = 75/>
    <#assign tdWidth = 60/>
    <#assign tableWidth = 5 * tdTitleWidth + (maxTDSize + 1) * tdWidth + tdCount + 110/>
    <#assign isExists = true/>
    <table width="91%" align="center">
        <tr>
            <td style="font-size:13.5pt;font-weight:bold;text-align:center">${pageCaption}<#if conditionValue != ""><br>${conditionValue}</#if></td>
        </tr>
    </table>
    <table class="listTable" width="91%" style="text-align:center" align="center">
        <tr>
            <td width="10%"<#if maxTDSize != 0> rowspan="2"</#if>>全校<br>排名</td>
            <td width="10%"<#if maxTDSize != 0> rowspan="2"</#if>>当前<br>排名</td>
            <#--
            <td width="10%"<#if maxTDSize != 0> rowspan="2"</#if>>教师工号</td>
            -->
            <td width="12%"<#if maxTDSize != 0> rowspan="2"</#if>>教师名称</td>
            <td width="18%"<#if maxTDSize != 0>  rowspan="2"</#if>>课程名称</td>
            <td width="10%"<#if maxTDSize != 0> rowspan="2"</#if>>评教<br>人数</td>
            <#if maxTDSize != 0>
            <td colspan="${maxTDSize}">各项得分</td>
            </#if>
            <td width="15%"<#if maxTDSize != 0> rowspan="2"</#if>>总分</td>
        </tr>
        <#if maxTDSize != 0>
        <tr>
            <#list 1..maxTDSize as i>
            <td width="4%">${i}</td>
            </#list>
        </tr>
        </#if>
        <#assign curAvgScore = {}/>
        <#list teacherResults?sort_by(["rank"]) as evaluateTeacher>
        <tr>
            <td>${evaluateTeacher.rank}</td>
            <td>${rankMap[evaluateTeacher.id?string]}</td>
            <#--
            <td>${evaluateTeacher.teacher.code}</td>
            -->
            <td>${evaluateTeacher.teacher.name}</td>
            <td style="text-align:justify;text-justifyl:inter-ideograph;">${evaluateTeacher.course.name}</td>
            <td>${evaluateTeacher.validTickets?default(0)}</td>
            <#assign total = 0/>
            <#assign isExists = evaluateTeacher.questionsStat?exists && (evaluateTeacher.questionsStat?size > 0)/>
            <#if isExists>
                <#assign questions = evaluateTeacher.questionsStat?sort_by("question", "id")/>
                <#list 1..maxTDSize as i>
                    <#if (questions[i - 1].evgPoints)?exists>
                        <#assign curAvgScore = curAvgScore + {i?string:curAvgScore[i?string]?default(0) + questions[i - 1].evgPoints}/>
                        <#assign total = total + (questions[i - 1].evgPoints)?default(0)/>
            <td>${(questions[i - 1].evgPoints)?default(0)?string("0.00")}</td>
                    <#else>
            <td></td>
                    </#if>
                </#list>
            <#else>
                <#list 1..maxTDSize as i>
            <td width="${tdWidth}px">0.00</td>
                </#list>
            </#if>
            <td>${(total)?default(0)?string("0.00")}</td>
        </tr>
        </#list>
        <tr style="color:#339966">
            <td>平均分</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <#assign total = 0/>
            <#if isExists>
                <#list 1..maxTDSize as i>
                    <#assign value = curAvgScore[i?string]?default(0) / teacherResults?size/>
                    <#assign total = total + value?number/>
            <td>${value?string("0.00")}</td>
                </#list>
            <#else>
                <#list 1..maxTDSize as i>
            <td>0.00</td>
                </#list>
            </#if>
            <td>${total?default(0)?string("0.00")}</td>
        </tr>
        <#--
        <tr>
            <td>学校<br>平均分</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <#assign total = 0/>
            <#if isExists>
                <#list 0..maxTDSize - 1 as i>
                    <#assign total = total + collegeResult[i]?default(0)/>
            <td>${collegeResult[i]?default(0)?string("0.00")}</td>
                </#list>
            <#else>
                <#list 1..maxTDSize as i>
            <td>0.00</td>
                </#list>
            </#if>
            <td>${total?default(0)?string("0.00")}</td>
        </tr>
        -->
    </table>
    <script>
        var bar = new ToolBar("bar", "<font face=\"宋体\">${pageCaption}</font>", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addPrint("<@msg.message key="action.print"/>");
        bar.addBackOrClose("<@msg.message key="action.back"/>", "<@msg.message key="action.close"/>");
    </script>
</body>
<#include "/templates/foot.ftl"/>
<object id="factory" style="display:none" viewastext classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="css/smsx.cab#Version=6,2,433,14"></object> 
<script language="JavaScript" type="text/JavaScript" src="scripts/common/printSetting.js"></script>
