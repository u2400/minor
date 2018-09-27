    <#assign adjustStatusMap = {"1":"调课", "2":"停课"}/>
    <script>var adjustMap = {};</script>
    <@table.table id="adjustTable" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="adjustId"/>
            <@table.sortTd text="课程序号" id="adjust.task.seqNo"/>
            <@table.sortTd text="课程代码" id="adjust.task.course.code"/>
            <@table.sortTd text="课程名称" id="adjust.task.course.name"/>
            <@table.sortTd text="申请教师" id="adjust.teacher.name"/>
            <@table.sortTd text="原上课信息" id="adjust.beenInfo" width="120px"/>
            <@table.sortTd text="调停状态" id="adjust.status"/>
            <@table.sortTd text="申请说明" id="adjust.applyInfo"/>
            <@table.sortTd text="审批状态" id="adjust.isPassed"/>
            <@table.td text="分配教室" id="adjust.room.name"/>
            <@table.sortTd text="终审状态" id="adjust.isFinal"/>
        </@>
        <@table.tbody datas=adjusts;adjust>
            <@table.selectTd id="adjustId" value=adjust.id/>
            <td>${adjust.task.seqNo}</td>
            <td>${adjust.task.course.code}</td>
            <td>${adjust.task.course.name}</td>
            <td>${adjust.teacher.name}</td>
            <td>${adjust.beenInfo}</td>
            <td>${adjustStatusMap[adjust.status?default(1)?string]}</td>
            <td>${adjust.applyInfo?html?replace("\n", "<br>")}</td>
            <td><#if adjust.isPassed?exists>${adjust.isPassed?string("<span style=\"color:green\">通过<span>", "<span style=\"color:red\">未过</span>")}<#else>未审批</#if></td>
            <td>${(adjust.room.name)?if_exists}</td>
            <td><#if adjust.isFinalOk?exists>${adjust.isFinalOk?string("<span style=\"color:green\">通过<span>", "<span style=\"color:red\">驳回</span>")}<#else>未终审</#if></td>
            <script>adjustMap["${adjust.id}"] = ${adjust.isPassed?exists?string};</script>
        </@>
    </@>
