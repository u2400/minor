<#include "/templates/head.ftl"/>
<BODY> 
    <table id="taskBar"></table>
    <table class="frameTable_title">
        <tr>
          <form name="actionForm"  method="post" action="?method=index" onsubmit="return false;">
            <td></td>
            <input type="hidden" name="config.calendar.id" value="${calendar.id}" />
            <#include "/pages/course/calendar.ftl"/>
          </form>
        </tr>
    </table>
    <#list configs as config>
    <table class="infoTable">
        <tr>
            <td class="title">年级</td>
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
            <#list config.subjects as s>${s.name} ${s.minScore}达标 课程代码:${s.courseCodes}  <a href="?method=editSubject&subjectId=${s.id}">修改</a>&nbsp;<a href="?method=removeSubject&subjectId=${s.id}">删除</a> <br/></#list>
            <a href="?method=editSubject&subject.config.id=${config.id}">增加</a>
            </td>
        </tr>
        <tr>
            <td class="title">面试信息</td>
            <td colspan="3">
            <#list config.interviewInfos as i>${i.room.name} 最多${i.maxviewer}(已报名${statMaps[config.id?string][i.id?string]!0})人 ${i.beginAt?string("yyyy-MM-dd HH:mm")}-${i.endAt?string("HH:mm")}
            <a href="?method=editInterview&interviewId=${i.id}">修改</a>&nbsp;<a href="?method=removeInterview&interviewId=${i.id}">删除</a>
            <br/></#list>
            <a href="?method=editInterview&interview.config.id=${config.id}">增加</a>
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
    </table>
    </#list>
	<script>
		var bar=new ToolBar("taskBar","英语升降级配置",null,true,true);
		bar.setMessage('<@getMessage/>');
		<#if (configs?size>0)>
		bar.addItem("修改","editConfig(${configs?first.id})");
		<#else>
		bar.addItem("新增","editConfig()");
		</#if>
		function editConfig(configId){
			var form =document.actionForm;
			form.action="?method=edit";
			if(configId) addInput(form,"configId",configId);
			form.submit();
		}
	</script>
</body>
<#include "/templates/foot.ftl"/> 
  