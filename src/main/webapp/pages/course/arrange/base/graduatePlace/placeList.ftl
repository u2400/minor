    <#assign statusMap = {"1":"有效期内", "2":"无效期内", "3":"已过期"}/>
    <script>var placeMap = {};</script>
    <@table.table id="placeTable" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="placeId"/>
            <@table.sortTd text="序号" id="place.id" width="5%" title="序号"/>
            <@table.sortTd text="单位名称" id="place.name" width="15%"/>
            <@table.sortTd text="单位所在地" id="place.addressInfo"/>
            <@table.sortTd text="单位类型" id="place.corporation.name" width="8%"/>
            <@table.sortTd text="是否校内" id="place.isInSchool" width="8%"/>
            <@table.sortTd text="签约日期" id="place.assignOn" width="10%"/>
            <@table.sortTd text="合作协议状态" id="place.status" width="12%"/>
            <@table.sortTd text="所属部门" id="place.department.name" width="10%"/>
            <@table.sortTd text="接收人数" id="place.planStdCount" width="7%"/>
            <@table.sortTd text="是否确认" id="place.enabled" width="7%"/>
        </@>
        <@table.tbody datas=places;place>
            <@table.selectTd id="placeId" value=place.id/>
            <td>${place.id}</td>
            <td>${place.name?html}</td>
            <td>${place.addressInfo?html}</td>
            <td>${place.corporation.name?html}</td>
            <td>${(place.isInSchool)?string("校内", "校外")}</td>
            <td>${place.assignOn?string("yyyy-MM-dd")}</td>
            <td>${statusMap[place.status?string]?if_exists}</td>
            <td>${place.department.name?html}</td>
            <td>${place.planStdCount}</td>
            <td>${place.enabled?string("是", "否")}</td>
            <script>placeMap["${place.id}"] = {"enabled":${place.enabled?string}};</script>
        </@>
    </@>