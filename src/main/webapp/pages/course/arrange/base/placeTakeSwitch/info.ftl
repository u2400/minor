<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <div style="font-size:10pt;font-weight:bold">毕业实习基地信息：</div>
    <#assign statusMap = {"1":"有效期内", "2":"无效期内", "3":"已过期"}/>
    <@table.table id="thisSwitchPlaceInfo" sortable="false" width="100%">
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
        </@>
        <@table.tbody datas=[switchPlace];switchPlace>
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
        </@>
    </@>
    <div style="height:20px"></div>
    <div style="font-size:10pt;font-weight:bold">本毕业实习基地学生名单：</div>
    <@table.table id="thisSwitchPlaceInfo" sortable="false" width="100%">
        <@table.thead>
            <@table.td text="学号" width="10%"/>
            <@table.td text="姓名"/>
            <@table.td text="年级" width="8%"/>
            <@table.td text="学制" width="5%"/>
            <@table.td text="院系"/>
            <@table.td text="专业"/>
            <@table.td text="专业方向"/>
            <@table.td text="班级" width="10%"/>
            <@table.td text="选上时间" width="10%"/>
        </@>
        <@table.tbody datas=switchPlace.takes;take>
            <td>${take.student.code}</td>
            <td>${take.student.name}</td>
            <td>${take.student.enrollYear}</td>
            <td>${take.student.schoolingLength}</td>
            <td>${take.student.department.name}</td>
            <td>${take.student.firstMajor.name}</td>
            <td>${(take.student.firstAspect.name)?if_exists}</td>
            <td>${(take.student.firstMajorClass.name)?if_exists}</td>
            <td>${take.createdAt?string("yyyy-MM-dd HH:mm")}</td>
        </@>
    </@>
    <script>
        var bar = new ToolBar("bar", "毕业实习基地学生名单", null, true, true)
        bar.setMessage('<@getMessage/>');
        bar.addBack();
    </script>
</body>
<#include "/templates/foot.ftl"/>