<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table class="infoTable" width="100%">
        <tr>
            <td class="title" style="width:20%">院系/部门代码</td>
            <td class="content" style="width:30%">${applyRoomInDepartment.department.code}</td>
            <td class="title" style="width:20%">院系/部门名称</td>
            <td class="content">${applyRoomInDepartment.department.name}</td>
        </tr>
        <tr>
            <td class="title">可借教室</td>
            <td class="content" colspan="3" style="text-align:justify;text-justify:inter-ideograph"><#list applyRoomInDepartment.rooms?sort_by("name") as room>${room.name}<#if room_has_next>，</#if></#list></td>
        </tr>
        <tr>
            <td class="title">首次分配人</td>
            <td class="content">${applyRoomInDepartment.createdBy.userName}</td>
            <td class="title">最终分配人</td>
            <td class="content">${applyRoomInDepartment.updatedBy.userName}</td>
        </tr>
        <tr>
            <td class="title">首次分配时间</td>
            <td class="content">${applyRoomInDepartment.createdOn?string("yyyy-MM-dd hh:mm:ss")}</td>
            <td class="title">最终分配时间</td>
            <td class="content">${applyRoomInDepartment.updatedOn?string("yyyy-MM-dd hh:mm:ss")}</td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "院系分配可借教室明细查看", null, true, true);
        bar.addBack();
    </script>
</body>
<#include "/templates/foot.ftl"/>
