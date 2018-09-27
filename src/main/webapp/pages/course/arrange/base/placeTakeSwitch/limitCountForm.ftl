<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#assign statusMap = {"1":"有效期内", "2":"无效期内", "3":"已过期"}/>
    <@table.table id="switchPlaceList" sortable="false" width="100%">
        <@table.thead>
            <@table.sortTd text="序号" id="switchPlace.place.id" width="5%"/>
            <@table.sortTd text="单位名称" id="switchPlace.place.name" width="15%"/>
            <@table.sortTd text="单位所在地" id="switchPlace.place.addressInfo"/>
            <@table.sortTd text="单位类型" id="switchPlace.place.corporation.name" width="8%"/>
            <@table.sortTd text="是否校内" id="switchPlace.place.isInSchool" width="8%"/>
            <@table.sortTd text="签约日期" id="place.assignOn" width="10%"/>
            <@table.sortTd text="所属部门" id="switchPlace.place.department.name" width="10%"/>
            <@table.sortTd text="计划人数" id="switchPlace.place.planStdCount" width="7%"/>
            <@table.sortTd text="上限人数" id="switchPlace.limitCount" width="7%"/>
            <@table.sortTd text="实际人数" id="switchPlace.stdCount" width="7%"/>
        </@>
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="switchPlaceIds" value="${RequestParameters["switchPlaceIds"]}"/>
        <@table.tbody datas=switchPlaces;switchPlace,switchPlace_index>
            <input type="hidden" name="switchPlace${switchPlace.id}.id" value="${switchPlace.id}"/>
            <td>${switchPlace.place.id}</td>
            <td>${switchPlace.place.name?html}</td>
            <td>${switchPlace.place.addressInfo?html}</td>
            <td>${switchPlace.place.corporation.name?html}</td>
            <td>${(switchPlace.place.isInSchool)?string("校内", "校外")}</td>
            <td>${switchPlace.place.assignOn?string("yyyy-MM-dd")}</td>
            <td>${switchPlace.place.department.name?html}</td>
            <td>${switchPlace.place.planStdCount}</td>
            <td><input type="text" name="switchPlace${switchPlace.id}.limitCount" value="${switchPlace.limitCount}" style="width:100px"/></td>
            <td>${switchPlace.stdCount}</td>
        </@>
            <input type="hidden" name="params" value="${RequestParameters["params1"]?if_exists}"/>
        </form>
    </@>
    <script>
        var oBar = new ToolBar("bar", "毕业实习基地选课上限人数维护", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addItem("保存", "save()");
        oBar.addBack();
        
        var oForm = document.actionForm;
        
        function save() {
            oForm.action = "placeTakeSwitch.do?method=limitCountSave";
            oForm.target = "_self";
            oForm.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>