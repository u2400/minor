<#include "/templates/head.ftl"/>
<body>
    <@table.table id="listTable" style="width:100%" sortable="true">
        <@table.thead>
            <@table.selectAllTd id="classroomId"/>
            <@table.sortTd name="attr.infoname" id="classroom.name"/>
            <@table.sortTd name="common.schoolDistrict" id="classroom.schoolDistrict.name"/>
            <@table.sortTd name="common.building" id="classroom.building.name"/>
            <@table.sortTd name="common.classroomConfigType" id="classroom.configType"/>
            <@table.sortTd name="attr.capacityOfExam" id="classroom.capacityOfExam" width="15%"/>
            <@table.sortTd name="attr.capacityOfCourse" id="classroom.capacityOfCourse" width="15%"/>
        </@>
        <@table.tbody datas=rooms?if_exists;classroom>
            <@table.selectTd id="classroomId" value=classroom.id/>
            <td>${classroom.name}</td>
            <td><@i18nName classroom.schoolDistrict?if_exists/></td>
            <td><@i18nName classroom.building?if_exists/></td>
            <td><@i18nName classroom.configType/></td>
            <td>${classroom.capacityOfExam?if_exists}</td>
            <td>${classroom.capacityOfCourse?if_exists}</td>
        </@>
    </@table.table>
    <script>
        parent.document.getElementById("freeRoomListBarDiv").style.display = parent.document.getElementById("freeRoomListTableDiv").style.display = "block";
    </script>
</body>
<#include "/templates/foot.ftl"/>