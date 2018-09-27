<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#setting url_escaping_charset="UTF-8"/>
    <#function lengthB str>
        <#if !str?exists || str?length == 0>
            <#return 0/>
        </#if>
        <#local strLength = 0/>
        <#list 0..str?length - 1 as i>
            <#local strLength = strLength + (str[i..i]?url?split("%")?size > 2)?string(2, 1)?number/>
        </#list>
        <#return strLength/>
    </#function>
    <@table.table id="listTable" style="width:100%" sortable="true" id="apply">
        <@table.thead>
            <@table.td text=""/>
            <@table.sortTd text="活动名称" id="roomApply.activityName"/>
            <@table.td text="所借教室" width="18%"/>
            <@table.sortTd text="使用日期" id="roomApply.applyTime.dateBegin" width="16%"/>
            <@table.sortTd text="使用时间" id="roomApply.applyTime.timeBegin" width="9%"/>
            <@table.sortTd text="借用人" id="roomApply.borrower.user.userName" width="10%"/>
            <@table.td text="借用人部门" width="10%"/>
            <@table.td text="审核人" id="roomApply.approveBy.userName" width="8%"/>
            <@table.sortTd text="申请时间" id="roomApply.applyAt" width="10%"/>
        </@>
        <@table.tbody datas=roomApplies?if_exists;apply>
            <@table.selectTd type="radio" id="roomApplyId" value=apply.id/>
            <td<#if (lengthB(apply.activityName) > 14)> title="${(apply.activityName)?default("")}"</#if> nowrap><A href="?method=info&roomApplyId=${apply.id}"><span style="display:block;width:100px;overflow:hidden;text-overflow:ellipsis;">${(apply.activityName)?default("")}</span></A></td>
            <td<#if (lengthB(apply.classroomNames) > 20)> title="${apply.classroomNames?html}"</#if> nowrap><span style="display:block;width:130px;overflow:hidden;text-overflow:ellipsis;">${apply.classroomNames?default("")?html}</span></td>
            <td>${(apply.applyTime.dateBegin)?string("yyyy-MM-dd")}～${(apply.applyTime.dateEnd)?string("yyyy-MM-dd")}</td>
            <#assign timeBegin = apply.applyTime.timeBegin?replace(":", "")/>
            <#assign timeEnd = apply.applyTime.timeEnd?replace(":", "")/>
            <td>${timeBegin[0..1]}:${timeBegin[2..3]}～${timeEnd[0..1]}:${timeEnd[2..3]}</td>
            <td>${(apply.borrower.user.userName)?if_exists}</td>
            <td>${(thisObject.getUserDepartment(apply.borrower.user.name).name)?if_exists}</td>
            <td>${apply.approveBy.userName}</td>
            <td>${(apply.applyAt?string("yyyy-MM-dd HH:mm"))?default("")}</td>
        </@>
    </@>
    <input type="hidden" name="requestParamter" value="${requestParamter?if_exists}">
    <@htm.actionForm name="actionForm" action="ecuplDepartmentRoomApply.do" entity="roomApply" onsubmit="return false;"/>
    <script>
        var bar = new ToolBar("bar","教室审核结果",null,true,true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("<@msg.message key="action.info"/>", "info()");
        bar.addItem("<@msg.message key="action.delete"/>", "form.target='_self';remove()");
        <#--
        <#if (RequestParameters['lookContent'])?exists>
            <#if RequestParameters['lookContent'] == '1'>
                bar.addItem("审核分配", "form.target='';singleAction('applyRoomSetting')", "update.gif");
                bar.addItem("<@msg.message key="action.edit"/>", "form.target='';singleAction('editApply')");
            <#elseif RequestParameters['lookContent'] == '2'>
                bar.addItem("<@msg.message key="action.edit"/>", "form.target='';singleAction('editApply')");
                bar.addItem("<@msg.message key="action.edit"/>分配", "form.target='';singleAction('applyRoomSetting')", "update.gif");
                bar.addItem("<@msg.message key="action.edit"/>费用", "form.target='';singleAction('adjustFeeForm')", "update.gif");
                bar.addItem("取消分配", "cancelApply()", "update.gif");
            </#if>
        </#if>
        -->
        bar.addItem("<@msg.message key="action.export"/>", "exportData()");

        function printApply(selectStyle) {
            window.open("ecuplDepartmentRoomApply.do?method=print&selectStyle=" + selectStyle);
        }
        function cancelApply(){
            var roomId = getSelectId("roomApplyId");
            if (null == roomId || "" == roomId) {
                alert("你没有选择要操作的记录！");
                return;
            }
            if(confirm("确定要取消该申请已分配的教室吗？")){
                addInput(form, "remark", "");
                singleAction('cancel');
            }
        }
        <#include "exportDatasJS.ftl"/>
        
        parent.document.searchRoomApplyApproveForm["toPageNo"].value = "${pageNo}";
        parent.document.searchRoomApplyApproveForm["toPageSize"].value = "${pageSize}";
    </script>
</body>
<#include "/templates/foot.ftl"/>