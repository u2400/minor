<#include "/templates/head.ftl"/>
<script src="scripts/validator.js"></script>
<body>
    <table id="bar" width="100%"></table>
    <#assign adjustStatusMap = {"1":"调课", "2":"停课"}/>
    <table class="infoTable" width="100%">
        <tr>
            <td class="darkColumn" colspan="4" style="text-align:center;font-weight:bold"><span style="color:blue">${adjust.teacher.name}</span>调停课申请信息</td>
        </tr>
        <tr>
            <td class="title" style="width:20%">课程序号：</td>
            <td width="30%">${adjust.task.seqNo}</td>
            <td class="title" style="width:20%">课程：</td>
            <td>${adjust.task.course.name}(${adjust.task.course.code})</td>
        </tr>
        <tr>
            <td class="title">开课学院：</td>
            <td>${adjust.task.arrangeInfo.teachDepart.name}</td>
            <td class="title">申请种类：</td>
            <td>${adjustStatusMap[adjust.status?default(1)?string]}</td>
        </tr>
        <tr>
            <td class="title">原上课信息：</td>
            <td colspan="3">${adjust.task.arrangeInfo.digest(adjust.task.calendar)}</td>
        </tr>
        <tr>
            <td class="title">申请说明：</td>
            <td colspan="3">${adjust.applyInfo?html?replace("\n", "<br>")}</td>
        </tr>
        <tr>
            <td class="title">备注：</td>
            <td colspan="3">${(adjust.remark?html?replace("\n", "<br>"))?if_exists}</td>
        </tr>
    </table>
    <table class="formTable" width="100%">
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="adjust.id" value="${adjust.id}"/>
            <input type="hidden" name="params" value="${RequestParameters["params"]}"/>
        <tr>
            <td colspan="4" class="darkColumn" style="font-weight:bold;text-align:center">最终审批</td>
        </tr>
        <tr>
            <td class="title" width="20%">终审状态：</td>
            <td width="30%"><input id="adjust" type="radio" name="adjust.isFinalOk" value="1"/><label for="adjust">通过</label>&nbsp;<input id="stop" type="radio" name="adjust.isFinalOk" value="0" checked/><label for="stop">驳回</label></td>
            <td class="title" width="20%">分配教室：</td>
            <td>
                <select name="adjust.room.id" style="width:200px">
                    <option value="" selected>...</option>
                    <#list rooms?sort_by("name") as room>
                    <option value="${room.id}">${room.name}</option>
                    </#list>
                </select>
            </td>
        </tr>
        <tr>
            <td class="title" id="f_finalReason">终审理由<span style="font-weight:bold;color:red">*</span>：</td>
            <td colspan="3"><textarea name="adjust.finalReason" style="width:500px;height:50px"></textarea>（250个字符）</td>
        </tr>
        <tr>
            <td colspan="4" class="darkColumn" style="text-align:center"><button onclick="finalAudit()">终审</button></td>
        </tr>
        </form>
    </table>
    <script>
        var bar = new ToolBar("bar", "调停课申请终审", null, true, true);
        bar.addBack();
        
        var form = document.actionForm;
        
        function finalAudit() {
            var a_fields = {
                "adjust.finalReason":{"l":"终审理由", "r":true, "t":"f_finalReason", "mx":250}
            };
            var v = new validator(form, a_fields, null);
            if (v.exec() && confirm("确定如此终审吗？")) {
                form.action = "adjustArrangeManage.do?method=finalAudit";
                form.target = "_self";
                form.submit();
            }
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>