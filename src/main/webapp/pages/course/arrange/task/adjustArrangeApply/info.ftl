<#include "/templates/head.ftl"/>
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
            <td class="title">创建时间：</td>
            <td>${adjust.createdAt?string("yyyy-MM-dd HH:mm:ss")}</td>
            <td class="title">修改时间：</td>
            <td>${adjust.updatedAt?string("yyyy-MM-dd HH:mm:ss")}</td>
        </tr>
        <tr>
            <td class="title">备注：</td>
            <td colspan="3">${(adjust.remark?html?replace("\n", "<br>"))?if_exists}</td>
        </tr>
        <tr>
            <td class="darkColumn" colspan="4" style="text-align:center;font-weight:bold">调停课审批信息</td>
        </tr>
        <tr>
            <td class="title">审批状态：</td>
            <td><#if adjust.isPassed?exists>${adjust.isPassed?string("<span style=\"color:green\">通过<span>", "<span style=\"color:red\">未过</span>")}<#else>未审批</#if></td>
            <td class="title">审批人：</td>
            <td>${(adjust.auditBy.userName + "(" + adjust.auditBy.name + ")")?if_exists}</td>
        </tr>
        <tr>
            <td class="title">审批时间：</td>
            <td>${(adjust.passedAt?string((RequestParameters["isAdmin"]?default("") == "1")?string("yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd")))?if_exists}</td>
            <td class="title"></td>
            <td></td>
        <tr>
            <td class="darkColumn" colspan="4" style="text-align:center;font-weight:bold">调停课分配信息</td>
        </tr>
        <tr>
            <td class="title">分配教室：</td>
            <td>${(adjust.room.name)?if_exists}</td>
            <td class="title">终审人：</td>
            <td>${(adjust.finalBy.userName + "(" + adjust.finalBy.name + ")")?if_exists}</td>
        </tr>
        <tr>
            <td class="title">终审状态：</td>
            <td><#if adjust.isFinalOk?exists>${adjust.isFinalOk?string("<span style=\"color:green\">通过<span>", "<span style=\"color:red\">驳回</span>")}<#else>未终审</#if></td>
            <td class="title">终审时间：</td>
            <td>${(adjust.finalAt?string((RequestParameters["isAdmin"]?default("") == "1")?string("yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd")))?if_exists}</td>
        </tr>
        <tr>
            <td class="title">终审理由：</td>
            <td colspan="3">${(adjust.finalReason?html?replace("\n", "<br>"))?if_exists}</td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "查看调停课申请", null, true, true);
        bar.addBack();
    </script>
</body>
<#include "/templates/foot.ftl"/>