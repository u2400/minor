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
<#list (groups?sort_by("name"))?if_exists as group>
    <#assign activities = []/>
    <#list group.directTasks as task>
        <#assign activities = getActivitiesInTask(task)/>
        <#if activities?size != 0>
            <#break/>
        </#if>
    </#list>
    <#list activities as activity>
        <#assign units = unitsInActivity(activity)/>
        <#list units as unit>
            <#assign weekActivityMap = activityMap[unit]?if_exists/>
            <#assign groupsInWeek = weekActivityMap[activity.time.weekId?string]?if_exists/>
            <#if !groupsInWeek?exists || groupsInWeek?size == 0>
                <#assign groupsInWeek = []/>
            </#if>
            <#assign groupsInWeek = groupsInWeek + [group]/>
            <#assign weekActivityMap = weekActivityMap + {activity.time.weekId?string:groupsInWeek}/>
            <#assign activityMap = activityMap + {unit:weekActivityMap}/>
        </#list>
    </#list>
</#list>


<#---------------------------------------Function / Macro--------------------------------------->

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

<#--统计某个“活动”占的“小节”情况-->
<#function unitsInActivity activity>
    <#local timeStandarInActiviy = []/>
    <#list timeStandars as timeStandar>
        <#if activity.time.startTime lte timeStandar.endAt && activity.time.endTime gte timeStandar.startAt>
            <#local timeStandarInActiviy = timeStandarInActiviy + [timeStandar.name]/>
        </#if>
    </#list>
    <#return timeStandarInActiviy/>
</#function>

<#--统计某一时间段最大记录数-->
<#function getMaxSize weekActivityMap>
    <#if (weekActivityMap?keys?size)?default(0) == 0> 
        <#return 0/>
    </#if>
    <#local maxSize = 0/>
    <#list weekActivityMap?keys as weekValue>
        <#local groupTaskCount  = 0/>
        <#list weekActivityMap[weekValue] as group>
            <#local groupTaskCount  = groupTaskCount + group.taskList?size/>
        </#list>
        <#if groupTaskCount gt maxSize>
            <#local maxSize = groupTaskCount/>
        </#if>
    </#list>
    <#return maxSize/>
</#function>

