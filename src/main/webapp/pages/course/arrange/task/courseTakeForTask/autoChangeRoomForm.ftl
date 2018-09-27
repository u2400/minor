<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body>
    <table id="bar" width="100%"></table>
    <#--
    <#assign colspan = 5/>
    <table class="infoTable" style="width:80%" align="center">
        <tr>
            <td class="darkColumn" style="text-align:center;font-weight:bold" colspan="${colspan}">所选要“自动更换”教室的教学任务（课程序号）</td>
        </tr>
        <#assign aTasks = tasks?sort_by("seqNo")/>
        <#list 0..(aTasks?size - 1) as i>
            <#if i == 0>
        <tr>
            <#elseif i % colspan == 0>
        </tr>
        <tr>
            </#if>
            <#if (i + 2) gte colspan * 10>
            <td style="text-align:center" colspan="2">${aTasks[i].seqNo}&nbsp;等&nbsp;${aTasks?size}&nbsp;条教学任务</td>
        </tr>
                <#break/>
            <#else>
            <td style="text-align:center">${aTasks[i].seqNo}</td>
            </#if>
            <#if i == aTasks?size - 1 && i % (colspan - 1) == 0>
        </tr>
            </#if>
        </#list>
        <#if aTasks?size % colspan != 0>
            <#list 1..(colspan - aTasks?size % colspan) as i>
            <td></td>
            </#list>
        </tr>
        </#if>
    </table>
    <br>
    -->
    <table class="formTable" width="80%" align="center">
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="taskIds" value="${RequestParameters["taskIds"]}"/>
        <tr height="25px">
            <td class="darkColumn" style="text-align:center;font-weight:bold" colspan="3">可控教室范围</td>
        </tr>
        <tr>
            <td class="title" width="20%">教学楼：</td>
            <td width="205px" style="border-right-width:0px">
                <select name="buildingId" style="width:200px">
                    <option value="" selected>...</option>
                    <#list buildings as building>
                    <option value="${building.id}">${building.name}</option>
                    </#list>
                </select>
            </td>
            <td></td>
        </tr>
        <tr>
            <td class="title">设备名称：</td>
            <td style="border-right-width:0px">
                <select name="roomTypeId" style="width:200px">
                    <option value="" selected>...</option>
                    <#list roomTypes as roomType>
                    <option value="${roomType.id}">${roomType.name}</option>
                    </#list>
                </select>
            </td>
            <td>默认“同设备名称”，否则按指定的更换</td>
        </tr>
        <tr>
            <td id="f_stdCount" class="title">教室人数：</td>
            <td style="border-right-width:0px"><input type="text" name="minStdCount" value="" maxlength="5" style="width:90px"/>～<input type="text" name="maxStdCount" value="" maxlength="5" style="width:90px"/></td>
            <td style="font-size:8pt;line-height:10pt">默认“最接近人数”；若仅设一个，则另一个视为“0”；<br>若结果不在指定中，则“无法更换”</td>
        </tr>
        <tr height="25px">
            <td class="darkColumn" style="text-align:center" colspan="3">
                <button onclick="autoChange()">自动更换</button>
                <span style="width:20px"></span>
                <button onclick="this.form.reset()">重置</button>
            </td>
        </tr>
        </form>
    </table>
    <script>
        var oBar = new ToolBar("bar", "自动更换教室设置<span style=\"color:blue;font-family:宋体,新宋体\">（当前选择了 ${tasks?size} 条教学任务）</span>", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addBack();
        
        var oForm = document.actionForm;
        
        function autoChange() {
            var aFields = {
                "minStdCount":{"l":"教室人数", "r":false, "t":"f_stdCount", "f":"positiveInteger"},
                "maxStdCount":{"l":"教室人数", "r":false, "t":"f_stdCount", "f":"positiveInteger"}
            };
            var oValidator = new validator(oForm, aFields, null); 
            if (oValidator.exec()) {
                var iMin = parseInt(oForm["minStdCount"].value);
                var iMax = parseInt(oForm["maxStdCount"].value);
                if (iMin >= iMax) {
                    alert("当前所设“教室人数”无效。");
                    return;
                }
                oForm.action = "courseTakeForTask.do?method=autoChangeRoom";
                oForm.submit();
            }
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>