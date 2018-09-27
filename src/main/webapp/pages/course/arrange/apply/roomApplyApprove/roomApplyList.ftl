	<#assign cycleName={'1':'天','2':'周','4':'月'}/>
	<@table.table id="listTable" style="width:100%" sortable="true" id="apply">
		<@table.thead>
		    <@table.td text=""/>
		    <@table.sortTd text="活动名称" id="roomApply.activityName"/>
		    <@table.sortTd text="活动类型" id="roomApply.activityType.name" width="10%"/>
		    <@table.sortTd text="营利性" id="roomApply.isFree" width="8%"/>
		    <#if RequestParameters["lookContent"]?default("0") == "2">
		    <@table.td text="使用教室类型" width="13%"/>
		    <@table.td text="所借教室"/>
		    </#if>
		    <@table.sortTd text="主讲人" id="roomApply.leading" width="10%"/>
		    <@table.sortTd text="申请时间" id="roomApply.applyAt" width="12%"/>
		    <@table.sortTd text="归口审核" id="roomApply.isDepartApproved" width="8%"/>
		    <@table.sortTd text="物管审核" id="roomApply.isApproved" width="8%"/>
	   	</@>
		<@table.tbody datas=roomApplies?if_exists;apply>
	      	<@table.selectTd type="radio" id="roomApplyId" value=apply.id/>
	      	<td title="${(apply.activityName)?default("")}" nowrap><A href="?method=info&roomApplyId=${apply.id}"><span style="display:block;width:100px;overflow:hidden;text-overflow:ellipsis;">${(apply.activityName)?default("")}</span></A></td>
	      	<td>${(apply.activityType.name)?default("")}</td>
	      	<td>${(apply.isFree?string("非营利", "营利"))?default("")}</td>
	      	<#if RequestParameters["lookContent"]?default("0") == "2">
	      	<td title="${(apply.classroomTypeNames)?default("")}" nowrap><span style="display:block;width:100px;overflow:hidden;text-overflow:ellipsis;">${(apply.classroomTypeNames)?default("")}</span></td>
	      	<td title="${apply.classroomNames?default("")?html}" nowrap><span style="display:block;width:120px;overflow:hidden;text-overflow:ellipsis;">${apply.classroomNames?default("")?html}</span></td>
	      	</#if>
	      	<td>${(apply.leading)?default("")}</td>
	      	<td>${(apply.applyAt?string("yyyy-MM-dd HH:mm"))?default("")}</td>
	      	<td title="${apply.departApprovedRemark?default("")}">${(apply.isDepartApproved?string("审核通过","审核未通过"))?default("待审核")}<input type="hidden" id="${"depart"+apply.id}" value="${(apply.isDepartApproved?string("审核通过","审核未通过"))?default("待审核")}"/></td>
	      	<td title="${apply.approvedRemark?default("")}">${(apply.isApproved?string("审核通过","审核未通过"))?default("待审核")}<input type="hidden" id="${"approve"+apply.id}" value="${(apply.isApproved?string("审核通过","审核未通过"))?default("待审核")}"/></td>
		</@>
	</@>
