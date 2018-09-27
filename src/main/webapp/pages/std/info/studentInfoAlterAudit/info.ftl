<#include "/templates/head.ftl"/>
<body>
	<table id="myBar" width="100%" ></table>
	<table width="85%" align="center">
		<tr>
			<td>
				<table class="infoTable">
					<tr>
						<th colspan="5">学生信息变更情况</th>
					</tr>
				</table>
				
				<table class="infoTable">
				   	<tr>
				     	<td class="title" width="20%">变更项：</td>
				     	<td width="40%">变更前</td>
				     	<td width="40%">变更后</td>
				   	</tr>
				   	<#list apply.items as item>
				   	<tr>
				     	<td class="title">${item.meta.name}：</td>
				     	<td>${studentInfoAlterApplyService.getString(item.meta,item.oldValue)!}</td>
				     	<td>${studentInfoAlterApplyService.getString(item.meta,item.newValue)!}</td>
				   	</tr>
				   	</#list>
				   	<tr>
				     	<td class="title">提交信息：</td>
				     	<td colspan="3">${apply.applyAt?string("yyyy-MM-dd HH:mm")} IP：${apply.ip}</td>
				   	</tr>
				   	<#if apply.auditor??>
				   	<tr>
				     	<td class="title">审核信息：</td>
				     	<td colspan="3">${apply.auditor.name} ${apply.auditAt?string("yy-MM-dd HH:mm")} </td>
				   	</tr>
				   	</#if>
				</table>
	<br><br>
	<script>
	    var bar =new ToolBar("myBar","学生信息变更概况",null,true,true);
	    bar.addPrint("<@msg.message key="action.print"/>");
	    bar.addBackOrClose("<@msg.message key="action.back"/>", "<@msg.message key="action.close"/>");
	</script>
<body>
<#include "/templates/foot.ftl"/>