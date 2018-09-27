<#include "/templates/head.ftl"/>
<body>
    <script>
        var roomMap = {};
        var roomsInAllMap = {};
    </script>
    <@table.table width="100%"  id="listTable" sortable="true">
        <@table.thead>
            <@table.selectAllTd id="roomId"/>
            <@table.sortTd width="8%" name="attr.code" id="room.code"/>
            <@table.sortTd width="15%" name="attr.infoname" id="room.name"/>
            <@table.sortTd name="entity.building" id="room.building.name"/>
            <@table.sortTd width="15%" name="entity.classroomConfigType" id="room.configType.name"/>
            <@table.sortTd width="15%" name="attr.capacityOfExam" id="room.capacityOfExam"/>
            <@table.sortTd width="15%" name="attr.capacityOfCourse" id="room.capacityOfCourse"/>
            <@table.sortTd width="10%" text="容量" id="room.capacity"/>
        </@>
        <@table.tbody datas=rooms;room>
            <@table.selectTd id="roomId" value=room.id/>
            <td>${room.code}</td>
            <td>${room.name}</td>
            <script>roomMap["${room.id}"] = {"code":"${room.code}", "name":"${room.name}"};</script>
            <td><@i18nName room.building?if_exists/></td>
            <td><@i18nName room.configType/></td>
            <td>${room.capacityOfExam?if_exists}</td>
            <td>${room.capacityOfCourse?if_exists}</td>
            <td>${(room.capacity)?default(0)}</td>
        </@>
    </@>
    <script>
        parent.document.getElementById("roomDistributionBarDiv").style.display = parent.document.getElementById("roomDistributionTableDiv").style.display = "block";
        <#list roomsInAll as room>
        roomsInAllMap["${room.id}"] = {"code":"${room.code}", "name":"${room.name}"};
        </#list>
    </script>
</body>
<#include "/templates/foot.ftl"/>
