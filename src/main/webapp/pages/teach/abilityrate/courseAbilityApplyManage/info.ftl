<#include "/templates/head.ftl"/>
<BODY>
  <table id="ruleBar"></table>
<table class="infoTable" align="center">
		<tr class="darkColumn">
	     <td align="center" colspan="4"><#if (apply.applyAbility.level>apply.originAbility.level)>英语升级申请记录<#else>英语降级申请记录</#if></td>
	   </tr>
	   <tr>
			<td class="title">学号</td>
			<td>${apply.std.code}</td>
			<td class="title">姓名</td>
			<td>${apply.std.name}</td>
		</tr>
		<tr>
			<td class="title">原级别</td>
			<td>${apply.originAbility.name}</td>
			<td class="title">申请级别</td>
			<td>${apply.applyAbility.name}</td>
		</tr>
		<#if (apply.applyAbility.level>apply.originAbility.level)>
		<tr>
			<td class="title">面试地点</td>
			<td>${apply.interview.room.name}</td>
			<td class="title">面试时间</td>
			<td>${apply.interview.beginAt?string("yyyy-MM-dd HH:mm")}～${apply.interview.endAt?string("HH:mm")}</td>
		</tr>
		</#if>
		<tr>
			<td class="title">各科目成绩</td>
			<td colspan="3"><#list apply.grades as g>${g.subject.name} ${g.score!}&nbsp;&nbsp;</#list></td>
		</tr>
		<tr>
			<td class="title">联系手机</td>
			<td>${apply.mobilephone}</td>
			<td class="title">联系地址</td>
			<td>${apply.address}</td>
		</tr>
		<tr>
			<td class="title">是否通过</td>
			<td>${apply.passed?string("是","否")}</td>
			<td class="title">申请时间</td>
			<td>${(apply.updatedAt?string("yyyy-MM-dd HH:mm:ss"))!}</td>
		</tr>
	</table>
	<script language="javascript">
	 var bar=new ToolBar("ruleBar","报名详情",null,true,true);
	 bar.addBack();
	</script>
</body>
<#include "/templates/foot.ftl"/>