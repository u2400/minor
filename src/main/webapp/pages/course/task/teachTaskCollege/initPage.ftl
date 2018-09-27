    <#--华政教学任务默认值-->
    <#assign defaultMap = {}/>
    <#if !task.id?exists>
        <#--开课院系默认值-->
        <#if (teacher.department.isTeaching)?default(false)>
            <#assign defaultMap = defaultMap + {'teachDepartId':(teacher.department.id)?default("")}/>
        </#if>
        <#--教学班院系默认值-->
        <#--手工设定教学班院系：全校-->
        <#assign defaultMap = defaultMap + {'teachClassDepart':{"id":"1", "name":"全校"}}/>
        <#--从数据库中获得正确之值-->
        <#list teacherDepartList as department>
            <#if department.id == 1>
                <#assign defaultMap = defaultMap + {'teachClassDepart':{"id":"1", "name":department.name}}/>
                <#break/>
            </#if>
        </#list>
        <#--设备要求默认值：多媒体教室-->
        <#assign defaultMap = defaultMap + {'roomTypeId':"57"}/>
        <#--校区默认值：松江校区-->
        <#assign defaultMap = defaultMap + {'schoolDistrict':"2"}/>
    </#if>
    <#-------------------------------------------->
    <#assign formElementWidth = "150px"/>
