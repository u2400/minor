<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#assign statusMap = {"1":"有效期内", "2":"无效期内", "3":"已过期"}/>
    <@table.table id="placeSwitch_take" sortable="false" width="100%">
        <@table.thead>
            <@table.td text="序号" width="5%"/>
            <@table.td text="单位名称" width="15%"/>
            <@table.td text="单位所在地"/>
            <@table.td text="单位类型" width="8%"/>
            <@table.td text="是否校内" width="8%"/>
            <@table.td text="签约日期" width="10%"/>
            <@table.td text="所属部门" width="10%"/>
            <@table.td text="计划人数" width="7%"/>
            <@table.td text="上限人数" width="7%"/>
            <@table.td text="实际人数" width="7%"/>
            <@table.td text="操作" width="5%"/>
        </@>
        <@table.tbody datas=placeSwitch.switchPlaces;switchPlace>
            <td>${switchPlace.place.id}</td>
            <td>${switchPlace.place.name?html}</td>
            <td>${switchPlace.place.addressInfo?html}</td>
            <td>${switchPlace.place.corporation.name?html}</td>
            <td>${(switchPlace.place.isInSchool)?string("校内", "校外")}</td>
            <td>${switchPlace.place.assignOn?string("yyyy-MM-dd")}</td>
            <td>${switchPlace.place.department.name?html}</td>
            <td>${switchPlace.place.planStdCount}</td>
            <td>${switchPlace.limitCount}</td>
            <td>${switchPlace.stdCount}</td>
            <td><#if switchPlace.getStudentTake(student)?exists><button onclick="remove(${switchPlace.id}, ${switchPlace.getStudentTake(student).id})">退选</button><#elseif switchPlace.stdCount lt switchPlace.limitCount && !(switchPlace.placeSwitch.hasTake(student))><button onclick="add(${switchPlace.id})">选择</button></#if></td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="switchPlaceId" value=""/>
        <input type="hidden" name="takeId" value=""/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "毕业实习基地选择列表", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addBack();
        
        var oForm = document.actionForm;
        
        function initData() {
            oForm["switchPlaceId"].value = oForm["takeId"].value = "";
        }
        
        function add(iSwitchPlaceId) {
            initData();
            oForm.action = "placeTake.do?method=add";
            oForm.target = "_self";
            oForm["switchPlaceId"].value = iSwitchPlaceId;
            oForm.submit();
        }
        
        function remove(iSwitchPlaceId, iTakeId) {
            initData();
            oForm.action = "placeTake.do?method=remove";
            oForm.target = "_self";
            oForm["switchPlaceId"].value = iSwitchPlaceId;
            oForm["takeId"].value = iTakeId;
            oForm.submit();
        }
        
        window.history.back = function() {
            location = "placeTake.do";
        };
        
        window.history.go = function() {
            history.back();
        };
    </script>
</body>
<#include "/templates/foot.ftl"/>