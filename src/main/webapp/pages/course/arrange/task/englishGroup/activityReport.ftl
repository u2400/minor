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
    
    <#assign indexes = {}/>
    
    <table class="listTable" style="text-align:center;word-break:break-all" width="${tableWidth}px">
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
                <#assign indexes = indexes + {i?string:{"groupIndex":0, "taskIndex":0}}/>
            <td width="${tdWidthes[1]}px">班级</td>
            <td width="${tdWidthes[2]}px">教师</td>
            <td width="${tdWidthes[3]}px">课程序号</td>
            <td width="${tdWidthes[4]}px">项目</td>
            <td width="${tdWidthes[5]}px">选课上限（男/女）</td>
            <td width="${tdWidthes[6]}px">选课人数（男/女）</td>
            </#list>
        </tr>
        <#list timeStandars as timeStandar>
            <#assign weekActivityMap = activityMap[timeStandar.name]?if_exists/>
            <#assign maxSize = getMaxSize(weekActivityMap)/>
        <tr height="25px">
            <td style="text-align:left<#if maxSize gt 1>;vertical-align:top" rowspan="${maxSize}</#if>">${timeStandar.name}</td>
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
                        <#assign group = (weekActivityMap[weekId?string][indexes[weekId?string].groupIndex])?if_exists/>
                        <#assign tasks = group.taskList?if_exists/>
                        <#if (tasks[indexes[weekId?string].taskIndex])?exists>
                            <#if indexes[weekId?string].taskIndex == 0>
            <td width="${tdWidthes[1]}px"<#if tasks?size gt 1> rowspan="${tasks?size}"</#if>><#list group.adminClasses?if_exists as adminClass>${adminClass.name}<#if adminClass_has_next><br></#if></#list></td>
                            </#if>
            <td width="${tdWidthes[2]}px">${(tasks[indexes[weekId?string].taskIndex].arrangeInfo.teacherNames)?if_exists}</td>
            <td width="${tdWidthes[3]}px">${tasks[indexes[weekId?string].taskIndex].seqNo}</td>
            <td width="${tdWidthes[4]}px">${((tasks[indexes[weekId?string].taskIndex].remark?html)?if_exists)}</td>
            <td width="${tdWidthes[5]}px">${(tasks[indexes[weekId?string].taskIndex].teachClass.getGenderLimitGroup(1).limitCount)?default(0)}/${(tasks[indexes[weekId?string].taskIndex].teachClass.getGenderLimitGroup(2).limitCount)?default(0)}</td>
            <td width="${tdWidthes[6]}px">${genderCountsMap[group.id?string][tasks[indexes[weekId?string].taskIndex].id?string].maleCount}/${genderCountsMap[group.id?string][tasks[indexes[weekId?string].taskIndex].id?string].femaleCount}</td>
                            <#assign indexes = indexes + {weekId?string:{"groupIndex":(indexes[weekId?string].taskIndex + 1 gte tasks?size)?string(indexes[weekId?string].groupIndex + 1, indexes[weekId?string].groupIndex)?number, "taskIndex":(indexes[weekId?string].taskIndex + 1 gte tasks?size)?string(0, indexes[weekId?string].taskIndex + 1)?number}}/>
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
        <tr height="25px">
                    </#if>
                </#list>
            </#if>
        </tr>
            <#list 1..5 as i>
                <#assign indexes = indexes + {i?string:{"groupIndex":0, "taskIndex":0}}/>
            </#list>
        </#list>
    </table>
    <script>
        var bar = new ToolBar("bar", "上课二维表", null, true, true);
        bar.addPrint();
        bar.addClose();
    </script>
</body>
<#include "/templates/foot.ftl"/>