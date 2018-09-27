<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#--构建《上课二维表》数据-->
    <#include "builderActivityReport.ftl"/>
    <#--班级，教师，课程序号，项目，选课上限，选课人数-->
    <#assign tdWidthes = [120, 70, 70, 66, 66, 66, 66]/>
    <#assign tableWidth = 0/>
    <#list tdWidthes as tdWidth>
        <#if tdWidth_index != 0>
            <#assign tableWidth = tableWidth + tdWidth/>
        </#if>
    </#list>
    <#assign tableWidth = tableWidth * 5 + tdWidthes[0]/>
    <table class="listTable" style="text-align:center" width="${tableWidth}px">
        <tr>
            <td width="${tdWidthes[0]}px" rowspan="2">上课时间</td>
            <td colspan="${tdWidthes?size - 1}">周一</td>
            <td colspan="${tdWidthes?size - 1}">周二</td>
            <td colspan="${tdWidthes?size - 1}">周三</td>
            <td colspan="${tdWidthes?size - 1}">周四</td>
            <td colspan="${tdWidthes?size - 1}">周五</td>
        </tr>
        <tr>
            <#list 1..5 as i>
            <td width="${tdWidthes[1]}px">班级</td>
            <td width="${tdWidthes[2]}px">教师</td>
            <td width="${tdWidthes[3]}px">课程序号</td>
            <td width="${tdWidthes[4]}px">项目</td>
            <td width="${tdWidthes[5]}px">选课上限</td>
            <td width="${tdWidthes[6]}px">选课人数</td>
            </#list>
        </tr>
        <#list timeStandars as timeStandar>
            <#assign adminClassTaskMap = activityMap[timeStandar.name]?if_exists/>
            <#assign maxSize = getMaxSize(adminClassTaskMap)/>
        <tr>
            <td style="text-align:left<#if maxSize gt 1>;vertical-align:top" rowspan="${maxSize}</#if>" width="">${timeStandar.name}</td>
            <#if maxSize == 0>
                <#list 1..5 as weekId>
            <td width="${tdWidthes[1]}px"></td>
            <td width="${tdWidthes[2]}px"></td>
            <td width="${tdWidthes[3]}px"></td>
            <td width="${tdWidthes[4]}px"></td>
            <td width="${tdWidthes[5]}px"></td>
            <td width="${tdWidthes[6]}px"></td>
                </#list>
            <#else>
                <#list 0..maxSize - 1 as rowIndex>
                    <#list 1..5 as weekId>
                        <#assign weekActivity = (adminClassTaskMap[weekId?string][rowIndex])?if_exists/>
                        <#if (weekActivity.adminClass)?exists>
            <td width="${tdWidthes[1]}px">${(weekActivity.adminClass.name)?if_exists}</td>
            <td width="${tdWidthes[2]}px">${(weekActivity.activity.task.arrangeInfo.teacherNames)?if_exists}</td>
            <td width="${tdWidthes[3]}px">${weekActivity.activity.task.seqNo}</td>
            <td width="${tdWidthes[4]}px">${((weekActivity.activity.task.remark?html)?if_exists)}</td>
            <td width="${tdWidthes[5]}px">${(weekActivity.activity.task.electInfo.maxStdCount)?if_exists}</td>
            <td width="${tdWidthes[6]}px">${(weekActivity.activity.task.teachClass.courseTakes?size)?default(0)}</td>
                        <#else>
            <td width="${tdWidthes[1]}px"></td>
            <td width="${tdWidthes[2]}px"></td>
            <td width="${tdWidthes[3]}px"></td>
            <td width="${tdWidthes[4]}px"></td>
            <td width="${tdWidthes[5]}px"></td>
            <td width="${tdWidthes[6]}px"></td>
                        </#if>
                    </#list>
                    <#if rowIndex + 1 lt maxSize>
        </tr>
        <tr>
                    </#if>
                </#list>
            </#if>
        </tr>
        </#list>
    </table>
    <script>
        var bar = new ToolBar("bar", "上课二维表", null, true, true);
        bar.addPrint();
        bar.addClose();
    </script>
</body>
<#include "/templates/foot.ftl"/>