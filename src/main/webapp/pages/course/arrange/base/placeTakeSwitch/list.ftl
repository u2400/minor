<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#assign statusMap = {"1":"有效期内", "2":"无效期内", "3":"已过期"}/>
    <@table.table id="switchPlaceList" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="switchPlaceId"/>
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
        <@table.tbody datas=switchPlaces;switchPlace>
            <@table.selectTd id="switchPlaceId" value=switchPlace.id/>
            <td>${switchPlace.place.id}</td>
            <td>${switchPlace.place.name?html}</td>
            <td>${switchPlace.place.addressInfo?html}</td>
            <td>${switchPlace.place.corporation.name?html}</td>
            <td>${(switchPlace.place.isInSchool)?string("校内", "校外")}</td>
            <td>${switchPlace.place.assignOn?string("yyyy-MM-dd")}</td>
            <td>${switchPlace.place.department.name?html}</td>
            <td>${switchPlace.place.planStdCount}</td>
            <td>${switchPlace.limitCount}</td>
            <td><a href="#" onclick="info(${switchPlace.id})" title="点击此处查询学生名单">${switchPlace.stdCount}</a></td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="switchPlaceId" value=""/>
        <input type="hidden" name="switchPlaceIds" value=""/>
        <input type="hidden" name="placeSwitchId" value="${placeSwitch.id}"/>
        <input type="hidden" name="keys" value="no,student.department.name,student.firstMajorClass.name,student.code,student.name,student.basicInfo.gender.name,student.basicInfo.politicVisage.name,student.studentStatusInfo.originalAddress,switchPlace.place.name,switchPlace.place.addressInfo,student.basicInfo.mobile,student.basicInfo.phone"/>
        <input type="hidden" name="titles" value="序号,学院,班级,学号,姓名,性别,政治面貌,生源地,实习单位名称,实习单位所在省,学生联系方式,备用联系方式"/>
        <input type="hidden" name="fileName" value="${placeSwitch.name}_汇总导出"/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params1" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "毕业实习基地", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addItem("上限人数", "edit()", "update.gif");
        oBar.addItem("学生名单", "info()");
        oBar.addItem("汇总导出", "exportData()", "excel.png");
        
        var oForm = document.actionForm;
        
        function initData() {
            oForm["switchPlaceId"].value = oForm["switchPlaceIds"].value = "";
        }
        
        function edit() {
            initData();
            var sSwitchPlaceIds = getSelectIds("switchPlaceId");
            if (null == sSwitchPlaceIds || undefined == sSwitchPlaceIds || "" == sSwitchPlaceIds) {
                alert("请选择要操作的记录。");
                return;
            }
            oForm.action = "placeTakeSwitch.do?method=limitCountEdit";
            oForm.target = "_self";
            oForm["switchPlaceIds"].value = sSwitchPlaceIds;
            oForm.submit();
        }
        
        function info(iRecordId) {
            initData();
            var iSwitchPlaceId = iRecordId;
            if (null == iSwitchPlaceId || undefined == iSwitchPlaceId || "" == iSwitchPlaceId) {
                iSwitchPlaceId = getSelectId("switchPlaceId");
                if (null == iSwitchPlaceId || undefined == iSwitchPlaceId || "" == iSwitchPlaceId || iSwitchPlaceId.split(",").length != 1) {
                    alert("请选择一条要操作的记录。");
                    return;
                }
            }
            oForm.action = "placeTakeSwitch.do?method=info";
            oForm.target = "_self";
            oForm["switchPlaceId"].value = iSwitchPlaceId;
            oForm.submit();
        }
        
        function exportData() {
            initData();
            oForm.action = "placeTakeSwitch.do?method=export";
            oForm.target = "_self";
            oForm.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>