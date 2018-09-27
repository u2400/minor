<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#if placeSwitches?exists && placeSwitches?size != 0>
    <table class="frameTable" width="100%" style="text-align:left">
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="isAdd" value=""/>
        <tr class="darkColumn">
            <td width="70px">基地开关：</td>
            <td>
                <select name="placeSwitchId" style="width:200px" onchange="search()">
                    <#list placeSwitches as placeSwitch>
                    <option value="${placeSwitch.id}"<#if RequestParameters["placeSwitchId"]?default("") == placeSwitch.id?string || placeSwitch_index == 0> selected</#if>>${placeSwitch.name}</option>
                    </#list>
                </select>
            </td>
            <td>
                <table id="bar2" width="100%"></table>
            </td>
        </tr>
            <input type="hidden" name="params" value="&placeSwitchId=${RequestParameters["placeSwitchId"]?default(placeSwitches?first.id)}"/>
        </form>
    </table>
    <table class="frameTable" width="100%">
        <tr valign="top">
            <td><iframe id="pageIframe" name="pageIframe" src="#" width="100%" frameborder="0" scrolling="no"></iframe></td>
        </tr>
    </table>
    <#else>
    <button onclick="addSwitch()" style="height:25px;"><img src="images/action/new.gif"/>新增开关</button>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="isAdd" value="1"/>
    </form>
    </#if>
    <script>
        var oBar = new ToolBar("bar", "毕业实习基地开关管理", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addBlankItem();
        
        var oForm = document.actionForm;
        
        function addSwitch() {
            oForm.action = "placeTakeSwitch.do?method=edit";
            oForm.target = "_self";
            oForm["isAdd"].value = "1";
            oForm.submit();
        }
        <#if placeSwitches?exists && placeSwitches?size != 0>
        
        var oBar2 = new ToolBar("bar2", "", "", false, true);
        oBar2.addItem("添加", "addSwitch()");
        oBar2.addItem("修改", "editSwitch()");
        oBar2.addItem("删除", "removeSwitch()");
        
        function editSwitch() {
            oForm.action = "placeTakeSwitch.do?method=edit";
            oForm.target = "_self";
            oForm["isAdd"].value = "0";
            oForm.submit();
        }
        
        function search() {
            oForm.action = "placeTakeSwitch.do?method=search";
            oForm.target = "pageIframe";
            oForm.submit();
        }
        
        function removeSwitch() {
            if (confirm("确认要删除当前的开关吗？")) {
                form.action = "placeTakeSwitch.do?method=remove";
                form.target = "_self";
                form.submit();
            }
        }
        
        search();
        </#if>
    </script>
</body>
<#include "/templates/foot.ftl"/>
