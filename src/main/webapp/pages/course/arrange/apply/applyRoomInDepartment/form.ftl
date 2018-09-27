<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@msg.message key="validator.js.url"/>"></script>
<body>
    <table id="bar1" width="100%"></table>
    <#assign mustFullFlagHTML><span style="color:red">*</span></#assign>
    <table id="applyRoomTableObj" class="formTable" width="100%">
        <tr>
            <td colspan="5" class="darkColumn" style="font-weight:bold;text-align:center">院系可借教室分配表</td>
        </tr>
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="applyRoomInDepartment.id" value="${(applyRoomInDepartment.id)?if_exists}"/>
        <tr height="25px">
            <td class="title" width="20%" id="f_departmentId">${mustFullFlagHTML}院系/部门</td>
            <td width="30%" colspan="2">
                <@htm.i18nSelect datas=departments selected=(applyRoomInDepartment.department.id?string)?default("") name="applyRoomInDepartment.department.id" style="width:100%">
                    <option value="">...</option>
                </@>
            </td>
            <td class="title" width="20%">分配人：</td>
            <td>${operator.userName}</td>
        </tr>
        <tr height="25px">
            <td class="title" rowspan="2" id="f_roomIds">${mustFullFlagHTML}可借教室：</td>
            <td style="border-bottom-width:0px;border-right-width:0px;text-align:center" width="15%">
                <button id="addRoomButton" onclick="addRoom()">添加教室</button>
            </td>
            <td style="border-bottom-width:0px;border-right-width:0px;text-align:center">
                <button id="cleanRoomButton" onclick="cleanRoom()">清空教室</button>
            </td>
            <td colspan="2" style="border-bottom-width:0px;text-align:center"></td>
        </tr>
        <tr height="25px">
            <td colspan="5">
                <textarea name="roomName" style="width:100%;height:100px;text-align:justify;text-justify:inter-ideograph" readOnly><#list (applyRoomInDepartment.rooms?sort_by("name"))?if_exists as room>${room.name}<#if room_has_next>,</#if></#list></textarea>
                <input type="hidden" name="roomIds" value="<#list (applyRoomInDepartment.rooms?sort_by("name"))?if_exists as room>${room.id}<#if room_has_next>,</#if></#list>"/>
            </td>
        </tr>
            
            <input type="hidden" name="orderBy" value="room.name asc"/>
        </form>
        <tr>
            <td colspan="5" class="darkColumn" style="text-align:center"><button id="saveObj" onclick="save()">保存</button></td>
        </tr>
    </table>
    <div style="height:10px"></div>
    <div id="roomDistributionBarDiv" style="width:100%;display:none">
        <table id="bar2" width="100%"></table>
    </div>
    <div id="roomDistributionTableDiv" style="width:100%;height:100%;display:none;overflow-y:auto;overflow-x:no">
        <table width="100%" height="100%" cellspace="0" cellpadding="0">
            <tr valign="top">
                <td width="100%" height="100%"><iframe id="roomIframe" name="roomIframe" src="#" marginwidth="0" marginheight="0"  width="100%" height="100%" frameborder="0" scrolling="auto"></iframe></td>
            </tr>
        </table>
    </div>
    <form method="post" action="" name="searchBackForm" onsubmit="return false;">
        <#assign filterKeys = ["method", "applyRoomInDepartmentId", "applyRoomInDepartmentIds", "pageNo", "pageSize", "toPageNo", "toPageSize", "params"]/>
        <#list RequestParameters?keys as key>
            <#if !filterKeys?seq_contains(key)>
        <input type="hidden" name="${key}" value="${RequestParameters[key]?if_exists}"/>
            </#if>
        </#list>
        <input type="hidden" name="pageNo" value="${RequestParameters["toPageNo"]?if_exists}"/>
        <input type="hidden" name="pageSize" value="${RequestParameters["toPageSize"]?if_exists}"/>
    </form>
    <script>
        var bar1 = new ToolBar("bar1", "院系可借教室分配", null, true, true);
        bar1.addItem("返回", "toBack()", "backward.gif");
        
        var bar2 = new ToolBar("bar2", "院系可分配的教室", null, true, true)
        bar2.addItem("选中添加", "addSomeRooms()");
        bar2.addItem("全部添加", "addAllRooms()");
        bar2.addItem("关闭", "closeDiv()");
        
        var form = document.actionForm;
        var searchForm = document.searchBackForm;
        
        function addRoom() {
            document.getElementById("addRoomButton").disabled = document.getElementById("cleanRoomButton").disabled = document.getElementById("saveObj").disabled = true;
            form.action = "applyRoomInDepartment.do?method=roomSearch";
            form.target = "roomIframe";
            form.submit();
        }
        
        function cleanRoom() {
            form["roomIds"].value = form["roomName"].value = "";
        }
        
        function addSomeRooms() {
            var selectedRoomIds = getCheckBoxValue(roomIframe.document.getElementsByName("roomId"));
            if (isEmpty(selectedRoomIds)) {
                alert("请选择需要分配的可借教室。");
                return;
            }
            var roomIdsArray = (selectedRoomIds + "").split(",");
            var roomNames = "";
            for (var i = 0; i < roomIdsArray.length; i++) {
                roomNames += roomIframe.roomMap[roomIdsArray[i]].name;
                if (i + 1 < roomIdsArray.length) {
                    roomNames += "，";
                }
            }
            form["roomIds"].value += ("" == cleanSpaces(form["roomIds"].value) ? "" : ",") + selectedRoomIds;
            form["roomName"].value += ("" == cleanSpaces(form["roomName"].value) ? "" : "，") + roomNames;
            closeDiv();
        }
        
        function addAllRooms() {
            var roomIds = "";
            var roomNames = "";
            for (var roomIdKey in roomIframe.roomsInAllMap) {
                roomNames += roomIframe.roomsInAllMap[roomIdKey].name + "，";
                roomIds += roomIdKey + ",";
            }
            if (isEmpty(roomNames) || isEmpty(roomIds)) {
                closeDiv();
                return;
            }
            form["roomIds"].value += ("" == cleanSpaces(form["roomIds"].value) ? "" : ",") + (roomIds + "").substring(0, roomIds.length - 1);
            form["roomName"].value += ("" == cleanSpaces(form["roomName"].value) ? "" : "，") + (roomNames + "").substring(0, roomNames.length - 1);
            closeDiv();
        }
        
        function closeDiv() {
            document.getElementById("roomDistributionBarDiv").style.display = document.getElementById("roomDistributionTableDiv").style.display = "none";
            document.getElementById("addRoomButton").disabled = document.getElementById("cleanRoomButton").disabled = document.getElementById("saveObj").disabled = false;
        }
        
        function save() {
            var a_fields = {
                'applyRoomInDepartment.department.id':{'l':'院系/部门', 'r':true, 't':'f_departmentId'},
                'roomIds':{'l':'可借教室', 'r':true, 't':'f_roomIds'}
            };
            var v = new validator(form, a_fields, null);
            if (v.exec()) {
                form.action = "applyRoomInDepartment.do?method=save";
                form.target = "_self";
                form.submit();
            }
        }
        
        function toBack() {
            searchForm.action = "applyRoomInDepartment.do?method=search";
            searchForm.target = "_self";
            searchForm.submit();
        }
        
        window.onresize = function(event) {
            document.getElementById("roomDistributionTableDiv").style.height = (parent.document.body.clientHeight - document.getElementById("applyRoomTableObj").clientTop - document.getElementById("applyRoomTableObj").clientHeight - 200) + "px";
        } 
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>