<#include "/templates/head.ftl"/>
<body>
	<#assign alterYearId>${RequestParameters["alterYearId"]?if_exists}</#assign>
	<#assign alterTerm>${RequestParameters["alterTerm"]?if_exists}</#assign>
	<table id="bar"></table>
	<@table.table id="alertStatResult" width="80%" align="center">
		<@table.thead>
			<@table.td text="变动类型"/>
			<@table.td text="变动次数"/>
		</@>
		<@table.tbody datas=results;result>
			<td><@i18nName result[0]/></td>
			<td>${result[1]}</td>
		</@>
	</@>
	<script>
		var bar = new ToolBar("bar", "<#if alterYearId == "" && alterTerm == "">所有变动时间的<#elseif alterYearId != "" && alterTerm != "">${alterYearId}学年${alterTerm}学期,学籍异动情况的数据统计</#if>统计结果", null, true, true);
		bar.setMessage('<@getMessage/>');
		bar.addPrint("<@msg.message key="action.print"/>");
	</script>
</body>
<#include "/templates/foot.ftl"/>