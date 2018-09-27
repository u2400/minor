<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#include "placeList.ftl"/>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="placeId" value=""/>
        <input type="hidden" name="placeIds" value=""/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key>&${key}=${RequestParameters[key]?if_exists}</#list>"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "基地基础信息", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("添加", "add()");
        bar.addItem("修改", "edit()");
        bar.addItem("查看", "info()");
        bar.addItem("删除", "remove()");
        
        var form = document.actionForm;
        
        function initData() {
            form["placeId"].value = "";
            form["placeIds"].value = "";
        }
        
        function add() {
            initData();
            form.action = "graduatePlace.do?method=edit";
            form.target = "_self";
            form.submit();
        }
        
        function edit() {
            initData();
            var placeId = getSelectId("placeId");
            if (null == placeId || "" == placeId || placeId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            if (checkEnabled(placeId)) {
                form.action = "graduatePlace.do?method=edit";
                form.target = "_self";
                form["placeId"].value = placeId;
                form.submit();
            }
        }
        
        function checkEnabled(placeIds) {
            var objectIds = placeIds.split(",");
            for (var i = 0; i < objectIds.length; i++) {
                if (placeMap[objectIds[i]].enabled) {
                    alert("不能操作“是否确认”为“是”的记录。");
                    return false;
                }
            }
            return true;
        }
        
        function info() {
            initData();
            var placeId = getSelectId("placeId");
            if (null == placeId || "" == placeId || placeId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            form.action = "graduatePlace.do?method=info";
            form.target = "_self";
            form["placeId"].value = placeId;
            form.submit();
        }
        
        function remove() {
            initData();
            var placeIds = getSelectId("placeId");
            if (null == placeIds || "" == placeIds) {
                alert("请选择要操作的记录。");
                return;
            }
            if (checkEnabled(placeIds) && confirm("确定要删除所有记录吗？")) {
                form.action = "graduatePlace.do?method=remove";
                form.target = "_self";
                form["placeIds"].value = placeIds;
                form.submit();
            }
        }
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>