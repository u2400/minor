<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="actionBar"></table>
<#if applies?size!=0>
<#list applies as apply>
	<table  width="90%" align="center">
	<tr><td>
	<table class="infoTable" align="center">
	   <tr class="darkColumn">
	     <td align="center" colspan="4">已有英语升降级记录&nbsp;&nbsp;<#if !apply.passed && apply.config.timeSuitable><a href="?method=remove&config.id=${apply.config.id}"><B>取消申请</B></a></#if></td>
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
			<td style="font-size:12pt">${apply.interview.room.name}</td>
			<td class="title">面试时间</td>
			<td style="font-size:12pt">${apply.interview.beginAt?string("yyyy-MM-dd HH:mm")}～${apply.interview.endAt?string("HH:mm")}</td>
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
	</td></tr></table>
</#list>
<#else>
	<p align="center">你还没有申请过英语升降级.</p>
</#if>
<#list configs as config>
<br/>
    <table class="formTable" align="center" width="90%">
    	<tr class="darkColumn">
	     <td align="center" colspan="4">英语升降级报名</td>
	   </tr>
        <tr>
            <td class="title" width="20%">年级</td>
            <td>${config.grade}</td>
            <td class="title">报名等级</td>
            <td><#list config.abilities as b>${b.name}<#if b_has_next>,</#if></#list></td>
        </tr>
        <tr>
            <td class="title">开始时间</td>
            <td>${config.beginAt?string("yyyy-MM-dd HH:mm:ss")}</td>
            <td class="title">截止时间</td>
            <td>${config.endAt?string("yyyy-MM-dd HH:mm:ss")}</td>
        </tr>
        <tr>
            <td class="title">科目</td>
            <td colspan="3">
            <#list config.subjects as s>${s.name} ${s.minScore}达标 课程代码:${s.courseCodes}  
            <br/></#list>
            </td>
        </tr>
        <tr>
            <td class="title">可选面试地点和时间</td>
            <td colspan="3">
            <#list config.interviewInfos?sort_by(["room","name"]) as i>${i.room.name} 最多${i.maxviewer}人 ${i.beginAt?string("yyyy-MM-dd HH:mm")}-${i.endAt?string("HH:mm")}
            <br/></#list>
            </td>
        </tr>
        <tr>
            <td class="title">升级提示</td>
            <td colspan="3">${config.upgradeNotice}</td>
        </tr>
        <tr>
            <td class="title">降级提示</td>
            <td colspan="3">${config.degradeNotice}</td>
        </tr>
        <tr>
            <td class="title">操作</td>
            <td colspan="3"><a href="?method=signupForm&config.id=${config.id}&isUpgrade=1"><B>申请升级</B></a>&nbsp;&nbsp;
            <a href="?method=signupForm&config.id=${config.id}&isUpgrade=0"><B>申请降级</B></a>
            </td>
        </tr>
    </table>
    </#list>
<script>
  var bar =new ToolBar("actionBar","英语升降级报名",null,true,true);
  bar.setMessage('<@getMessage/>');
  bar.addBack();
  
  function search(pageNo,pageSize,orderBy){
   		var applyForm =document.applyForm;
   		applyForm.action="?method=search";
        goToPage(applyForm,pageNo,pageSize,orderBy);
  }
  search();
</script>
</body>
<#include "/templates/foot.ftl"/> 