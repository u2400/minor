<#---------------------------------------------Head--------------------------------------------->
<#--校方规定的上课标准规则-->
<#assign timeStandars = [
    {"name":"第1-2节8:00/9:30", "startAt":800, "endAt":930},
    {"name":"第3-4节9:50/11:20", "startAt":950, "endAt":1120},
    {"name":"第7-8节13:30/15:00", "startAt":1330, "endAt":1500},
    {"name":"第9-10节15:20/16:50", "startAt":1520, "endAt":1650}
]/>

<#---------------------------------------------Main--------------------------------------------->

<#--组装可能显示的数据-->
<#assign activityMap = {}/>
<#list (tasks?sort_by("seqNo"))?if_exists as task>
    <#list getActivitiesInTask(task) as activity>
        <#assign timeStandarsInTask = getTimeStandar(activity)/>
        <!--${(timeStandarsInTask?size)?default(0)}-->
        <#--只处理在“校方规定的上课标准规则”范围内的教学任务-->
        <#list timeStandarsInTask?if_exists as timeStandar>
            <#assign adminClassTaskMap = activityMap[timeStandar.name]?if_exists/>
            <#if !adminClassTaskMap?exists>
                <#assign adminClassTaskMap = {}/>
            </#if>
            <#assign weekActivityMap = adminClassTaskMap[activity.time.weekId?string]?if_exists/>
            <#if !weekActivityMap?exists || weekActivityMap?size == 0>
                <#assign weekActivityMap = []/>
            </#if>
            <#if (task.teachClass.adminClasses?size)?default(0) == 0>
                <#assign weekActivityMap = weekActivityMap + [{"key":"-_" + task.seqNo, "adminClass":{"name":""}, "activity":activity}]/>
            <#else>
                <#list task.teachClass.adminClasses?sort_by("name") as adminClass>
                    <#assign weekActivityMap = weekActivityMap + [{"key":adminClass.name + "_" + task.seqNo, "adminClass":adminClass, "activity":activity}]/>
                </#list>
            </#if>
            <#assign adminClassTaskMap = adminClassTaskMap + {activity.time.weekId?string:weekActivityMap?sort_by("key")}/>
            <#assign activityMap = activityMap + {timeStandar.name:adminClassTaskMap}/>
        </#list>
    </#list>
</#list>

<#---------------------------------------Function / Macro--------------------------------------->

<#--根据指定的教学任务，获得上课标准和对应的教学活动-->
<#function getTimeStandar activity>
    <#local timeStandarsInTask = []/>
    <#list timeStandars as timeStandar>
        <#if activity.time.startTime lte timeStandar.endAt && activity.time.endTime gte timeStandar.startAt>
            <#local timeStandarsInTask = timeStandarsInTask + [timeStandar]/>
        </#if>
    </#list>
    <#return timeStandarsInTask/>
</#function>

<#--根据指定的教学任务，不重复的教学活动-->
<#function getActivitiesInTask task>
    <#local activityMap = {}/>
    <#list task.arrangeInfo.activities as activity>
        <#local activityMap = activityMap + {activity.task.id + "_" + activity.time.weekId + "_" + activity.time.startTime + "_" + activity.time.endTime + "_":activity}/>
    </#list>
    <#local activities = []/>
    <#list activityMap?keys as key>
        <#local activities = activities + [activityMap[key]]/>
    </#list>
    <#return activities/>
</#function>

<#--判断是否要下一条记录-->
<#function has_next adminClassTaskMap>
    <#list adminClassTaskMap?keys as weekId>
        <#if (adminClassTaskMap[weekId]?size)?default(0) == 0>
            <#return true/>
        </#if>
    </#list>
    <#return false/>
</#function>

<#--统计某一时间段最大记录数-->
<#function getMaxSize adminClassTaskMap>
    <#if (adminClassTaskMap?keys?size)?default(0) == 0> 
        <#return 0/>
    </#if>
    <#local maxSize = 0/>
    <#list adminClassTaskMap?keys as weekId>
        <#if (adminClassTaskMap[weekId?string]?size)?default(0) gt maxSize>
            <#local maxSize = (adminClassTaskMap[weekId?string]?size)?default(0)/>
        </#if>
    </#list>
    <#return maxSize/>
</#function>

