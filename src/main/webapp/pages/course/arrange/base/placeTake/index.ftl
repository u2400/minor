<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <script>
        var nowAtValue = new Date();
        var nowAt = parseInt(nowAtValue.getFullYear() + "" + (nowAtValue.getMonth() + 101 + "").substr(1) + (nowAtValue.getDate() + 100 + "").substr(1));
    </script>
    <#list placeSwitches as placeSwitch>
    <table class="formTable" width="80%" align="center">
        <tr>
            <td class="title">开头名称：</td>
            <td colspan="3">${placeSwitch.name?html}</td>
        </tr>
        <tr>
            <td class="title">年级：</td>
            <td colspan="3">${placeSwitch.grades?html}</td>
        </tr>
        <tr>
            <td class="title">开始日期：</td>
            <td>${placeSwitch.beginOn?string("yyyy-MM-dd")}</td>
            <td class="title">截止日期：</td>
            <td>${placeSwitch.endOn?string("yyyy-MM-dd")}</td>
        </tr>
        <tr>
            <td class="title" width="20%">学生类别：</td>
            <td width="30%"><#list placeSwitch.stdTypes as stdType>${stdType.name}<#if stdType_has_next>,</#if></#list></td>
            <td class="title" width="20%">是否使用：</td>
            <td>${placeSwitch.open?string("使用", "禁用")}</td>
        </tr>
        <tr>
            <td class="title">院系：</td>
            <td colspan="3"><#list placeSwitch.departments as department>${department.name}<#if department_has_next>,</#if></#list></td>
        </tr>
        <tr>
            <td class="darkColumn" colspan="4" style="text-align:center"><button id="enterPlace${placeSwitch.id}" onclick="search(${placeSwitch.id})">进入</button></td>
        </tr>
    </table>
    <script>document.getElementById("enterPlace${placeSwitch.id}").disabled = ${(!(placeSwitch.open))?string} || nowAt < ${placeSwitch.beginOn?string("yyyyMMdd")} || nowAt > ${placeSwitch.endOn?string("yyyyMMdd")} || ${(!(("," + placeSwitch.grades + ",")?contains("," + student.enrollYear + ",")))?string} || ${(!(placeSwitch.stdTypes?seq_contains(student.type)))?string} || ${(!(placeSwitch.departments?seq_contains(student.department)))?string};</script>
        <#if placeSwitch_has_next>
    <div style="height:20px"></div>
        </#if>
    </#list>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="placeSwitchId" value=""/>
    </form>
    <script>
        var oBar = new ToolBar("bar", "毕业实习基地选择<span style=\"color:blue\">（开关）</span>", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addBlankItem();
        
        var oForm = document.actionForm;
        
        function initData() {
            oForm["placeSwitchId"].value = "";
        }
        
        function search(iPlaceSwitchId) {
            initData();
            oForm.action = "placeTake.do?method=search";
            oForm.target = "_self";
            oForm["placeSwitchId"].value = iPlaceSwitchId;
            oForm.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>