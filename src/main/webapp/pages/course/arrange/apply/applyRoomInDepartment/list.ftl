<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="applyRoomInDepartmentTable" width="100%" sortable="true">
        <@table.thead>
            <@table.selectAllTd id="applyRoomInDepartmentId"/>
            <@table.sortTd text="院系/部门" id="applyRoomInDepartment.department.name" width="20%"/>
            <@table.td text="可借教室" width="40%"/>
            <@table.sortTd text="分配人" id="applyRoomInDepartment.updatedBy.userName"/>
            <@table.sortTd text="分配时间" id="applyRoomInDepartment.updatedOn" width="20%"/>
        </@>
        <@table.tbody datas=applyRoomInDepartments;applyRoomInDepartment>
            <@table.selectTd id="applyRoomInDepartmentId" value=applyRoomInDepartment.id/>
            <td><a href="#" onclick="info('${applyRoomInDepartment.id}')">${applyRoomInDepartment.department.name}(${applyRoomInDepartment.department.code})</a></td>
            <td style="text-align:justify;text-justify:inter-ideograph"><#list (applyRoomInDepartment.rooms?sort_by("name"))?if_exists as room>${room.name}<#if room_has_next>，</#if></#list></td>
            <td>${applyRoomInDepartment.updatedBy.userName}</td>
            <td>${applyRoomInDepartment.updatedOn?string("yyyy-MM-dd hh:mm:ss")}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <#assign filterKeys = ["method", "pageNo", "pageSize", "applyRoomInDepartmentId", "applyRoomInDepartmentIds", "params"]/>
        <input type="hidden" name="applyRoomInDepartmentId" value=""/>
        <input type="hidden" name="applyRoomInDepartmentIds" value=""/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>"/>
    </form>
    <form method="post" action="" name="searchActionForm" onsubmit="return false;">
        <input type="hidden" name="applyRoomInDepartmentId" value=""/>
        <input type="hidden" name="applyRoomInDepartmentIds" value=""/>
        <#list RequestParameters?keys as key>
            <#if !filterKeys?seq_contains(key)>
        <input type="hidden" name="${key}" value="${RequestParameters[key]?if_exists}"/>
            </#if>
        </#list>
        <input type="hidden" name="toPageNo" value="${pageNo}"/>
        <input type="hidden" name="toPageSize" value="${pageSize}"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "院系分配可借教室情况列表", null, true ,true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("新增", "add()");
        bar.addItem("修改", "edit()");
        bar.addItem("查看", "info()");
        bar.addItem("删除", "remove()");
        
        var form = document.actionForm;
        var searchForm = document.searchActionForm;
        
        function initData() {
            form["applyRoomInDepartmentId"].value = "";
            form["applyRoomInDepartmentIds"].value = "";
            searchForm["applyRoomInDepartmentId"].value = "";
            searchForm["applyRoomInDepartmentIds"].value = "";
        }
        
        function add() {
            initData();
            searchForm.action = "applyRoomInDepartment.do?method=edit";
            searchForm.target = "_self";
            searchForm.submit();
        }
        
        function edit() {
            initData();
            var applyRoomInDepartmentId = getSelectId("applyRoomInDepartmentId");
            if (isEmpty(applyRoomInDepartmentId) || isMultiId(applyRoomInDepartmentId)) {
                alert("请选择一条要操作的记录。");
                return;
            }
            searchForm.action = "applyRoomInDepartment.do?method=edit";
            searchForm.target = "_self";
            searchForm["applyRoomInDepartmentId"].value = applyRoomInDepartmentId;
            searchForm.submit();
        }
        
        function info(objectId) {
            initData();
            var applyRoomInDepartmentId = null;
            if (isEmpty(objectId)) {
                applyRoomInDepartmentId = getSelectId("applyRoomInDepartmentId");
            } else {
                applyRoomInDepartmentId = objectId;
            }
            if (isEmpty(applyRoomInDepartmentId) || isMultiId(applyRoomInDepartmentId)) {
                alert("请选择一条要操作的记录。");
                return;
            }
            form.action = "applyRoomInDepartment.do?method=info";
            form.target = "_self";
            form["applyRoomInDepartmentId"].value = applyRoomInDepartmentId;
            form.submit();
        }
        
        function remove() {
            initData();
            var applyRoomInDepartmentIds = getSelectIds("applyRoomInDepartmentId");
            if (isEmpty(applyRoomInDepartmentIds)) {
                alert("请选择要操作的记录。");
                return;
            }
            if (confirm("确定要删除所选记录吗？")) {
                form.action = "applyRoomInDepartment.do?method=remove";
                form.target = "_self";
                form["applyRoomInDepartmentIds"].value = applyRoomInDepartmentIds;
                form.submit();
            }
        }
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>