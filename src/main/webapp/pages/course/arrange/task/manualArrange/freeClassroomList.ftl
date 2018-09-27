<#include "/templates/head.ftl"/>
<body>
 <@table.table id="listTable" style="width:100%" sortable="true">
   <@table.thead>
    <@table.td text="" width="2%"/>
    <@table.sortTd name="attr.infoname" id="room.name"/>
    <@table.sortTd name="common.schoolDistrict" id="room.schoolDistrict.name"/>
    <@table.sortTd name="common.building" id="room.building.name"/>
    <@table.sortTd name="common.classroomConfigType" id="room.configType"/>
    <@table.sortTd name="attr.capacityOfCourse" id="room.capacityOfCourse" width="15%"/>
    <@table.sortTd width="15%" text="容量" id="classroom.capacity"/>
   </@>
   <@table.tbody datas=rooms?if_exists;classroom>
      <td><input name="classroomId" value="${classroom.id}" type="radio" onchange="setRoom(this, '${classroom.name}', '<@i18nName classroom.schoolDistrict?if_exists/>', '<@i18nName classroom.building?if_exists/>', '<@i18nName classroom.configType/>', ${classroom.capacityOfCourse?default(0)})"/></td>
      <td>${classroom.name}</td>
      <td><@i18nName classroom.schoolDistrict?if_exists/></td>
      <td><@i18nName classroom.building?if_exists/></td>
      <td><@i18nName classroom.configType/></td>
      <td>${classroom.capacityOfCourse?default(0)}</td>
      <td>${(classroom.capacity)?default(0)}</td>
   </@table.tbody>
 </@table.table>
 <script>
    function setRoom(radioObj, roomName, roomWithPlace, roomBuilding, roomType, roomTheNumberOf) {
        var form = parent.document.actionForm;
        var selectedRoomSPAN = parent.$("selectedRoom");
        if (radioObj.checked) {
            
            form["toRoomId"].value =  radioObj.value;
            selectedRoomSPAN.innerHTML = roomWithPlace + " " + roomBuilding + " " + roomName + "（" + roomType + "）";
            form["maxStdCount"].value = roomTheNumberOf;
        } else {
            selectedRoomSPAN.innerHTML = parent.document.actionForm["toRoomId"].value = "";
            form["maxStdCount"].value = 0;
        }
    }
 </script>
</body>
<#include "/templates/head.ftl"/>