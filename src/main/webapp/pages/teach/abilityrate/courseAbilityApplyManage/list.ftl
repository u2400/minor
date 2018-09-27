<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
	<table id="courseTakeBar"></table>
	<@table.table id="listTable" sortable="true" width="100%">
	  <@table.thead>
	   <@table.selectAllTd id="applyId"/>
	   <@table.sortTd id="apply.std.code" name="std.code"/>
	   <@table.sortTd id="apply.std.name" name="attr.personName"/>
	   <@table.sortTd id="apply.std.department.name" text="学院"/>
	   <@table.sortTd id="apply.std.firstMajor.name" text="专业"/>
	   <@table.sortTd id="apply.std.firstAspect.name" text="方向"/>
	   <@table.sortTd id="apply.applyAbility.name" text="申请级别"/>
	   <#if RequestParameters['isUpgrade']=='1'>
	   <@table.sortTd id="apply.interview.room.name" text="面试地点"/>
	   <@table.sortTd id="apply.interview.beginAt" text="面试时间"/>
	   </#if>
	   <@table.sortTd id="apply.passed" text="通过否"/>
	  </@>
	  <@table.tbody datas=applies;apply>
	    <@table.selectTd id="applyId" type="checkbox" value=apply.id/>
	    <td>${apply.std.code}</td>
	    <td><a href="?method=info&applyId=${apply.id}">${apply.std.name?if_exists}</a></td>
	    <td>${apply.std.department.name}</td>
	    <td>${apply.std.firstMajor.name}</td>
	    <td>${(apply.std.firstAspect.name)!}</td>
	    <td>${apply.applyAbility.name}</td>
	    <#if RequestParameters['isUpgrade']=='1'>
	    <td>${apply.interview.room.name}</td>
	    <td>${apply.interview.beginAt?string("MM-dd HH:mm")}~${apply.interview.endAt?string("HH:mm")}</td>
	    </#if>
	    <td>${apply.passed?string('是','否')}</td>
	  </@>
  </@>
  <#if applies?size!=0>
  <#assign config=applies?first.config/>
  </#if>
  <@htm.actionForm name="actionForm" entity="apply" action="courseAbilityApplyManage.do">
  	<#if applies?size!=0>
  	<input type="hidden" name="keys" value="std.code,std.name,std.department.name,std.firstMajor.name,std.firstAspect.name,applyAbility.name<#list config.subjects as s>,grade.${s.id}</#list>,mobilephone,address,interview.room.name,interview.beginAt,interview.endAt" />
  	<input type="hidden" name="titles" value="学号,姓名,院系,专业,方向,申请级别<#list config.subjects as s>,${s.name}</#list>,联系手机,联系方式,面试地点,面试开始时间,面试结束时间" />
  	</#if>
  </@>
  <script>
	    var byWhat = '${RequestParameters['orderBy']?default("null")}';
	    var bar = new ToolBar("courseTakeBar","<#if RequestParameters['isUpgrade']=='1'>升级<#else>降级</#if>申请名单列表",null,true,true);
	    bar.setMessage('<@getMessage/>');
	    bar.addItem("<@bean.message key="action.info"/>","info()");
	    <#if RequestParameters['isUpgrade']=='1'>
	    bar.addItem("<@msg.message key="action.edit"/>","edit()");
	    </#if>
	    bar.addItem("审核通过","multiAction('approve','审核通过将更改学生的英语等级，确定操作？')");
	    bar.addItem("审核不通过","multiAction('withdraw','审核通过将还原学生的英语等级，确定操作？')");
	    <#if applies?size!=0>
	    bar.addItem("<@msg.message key="action.export"/>","exportList()");
	    </#if>
	    bar.addItem("<@bean.message key="action.delete"/>","remove()");
  </script>
</body>
<#include "/templates/foot.ftl"/>

