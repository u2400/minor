<#include "/templates/head.ftl"/>
<body>
	<table id="bar" width="100%"></table>
    <@table.table id="listTable" style="width:100%" sortable="true" id="apply">
        <@table.thead>
            <@table.td text=""/>
            <@table.sortTd text="活动名称" id="roomApply.activityName"/>
            <@table.td text="所借教室" width="20%"/>
            <@table.sortTd text="使用日期" id="roomApply.applyTime.dateBegin"/>
            <@table.sortTd text="使用时间" id="roomApply.applyTime.dateBegin"/>
            <@table.sortTd text="借用人" id="apply.borrower.user.userName" width="10%"/>
            <@table.td text="借用人部门" width="10%"/>
            <@table.sortTd text="申请时间" id="roomApply.applyAt" width="12%"/>
        </@>
        <@table.tbody datas=roomApplies?if_exists;apply>
            <@table.selectTd type="radio" id="roomApplyId" value=apply.id/>
            <td title="${(apply.activityName)?default("")}" nowrap><A href="?method=info&roomApplyId=${apply.id}"><span style="display:block;width:100px;overflow:hidden;text-overflow:ellipsis;">${(apply.activityName)?default("")}</span></A></td>
            <td title="${apply.classroomNames?default("")?html}" nowrap><span style="display:block;width:150px;overflow:hidden;text-overflow:ellipsis;">${apply.classroomNames?default("")?html}</span></td>
            <td>${(apply.applyTime.dateBegin)?string("yyyy-MM-dd")}～${(apply.applyTime.dateEnd)?string("yyyy-MM-dd")}</td>
            <#assign timeBegin = apply.applyTime.timeBegin?replace(":", "")/>
            <#assign timeEnd = apply.applyTime.timeEnd?replace(":", "")/>
            <td>${timeBegin[0..1]}:${timeBegin[2..3]}～${timeEnd[0..1]}:${timeEnd[2..3]}</td>
            <td>${apply.borrower.user.userName}</td>
            <td>${(thisObject.getUserDepartment(apply.borrower.user.name).name)?if_exists}</td>
            <td>${(apply.applyAt?string("yyyy-MM-dd HH:mm"))?default("")}</td>
        </@>
    </@>
	<@htm.actionForm name="actionForm" action="roomApply.do" entity="roomApply" onsubmit="return false;"/>
 	<script>
		var bar = new ToolBar("bar","我已申请的记录",null,true,true);
		bar.setMessage('<@getMessage/>');
		bar.addItem("<@msg.message key="action.info"/>", "form.target='';info()");
 	</script>	
</body>
<#include "/templates/foot.ftl"/>