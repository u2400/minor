<#if isStudent?default(false)>
<script language="JavaScript" type="text/JavaScript" src="scripts/prompt.js"></script>
<div id="toolTipLayer" style="position:absolute; visibility: hidden"></div> 
<script>var remarkContents = new Object();</script>
<script>initToolTips();</script>
</#if>
   <#assign columnHead>
    <tr align="center" class="darkColumn">
      <td width="1%"></td>
      <td width="9%"><@msg.message key="attr.courseNo"/></td>
      <td width="9%"><@bean.message key="attr.taskNo"/></td>
      <td width="9%"><@bean.message key="entity.teacher"/><@msg.message key="attr.personName"/></td>
      <td><@bean.message key="attr.courseName"/></td>
      <td width="12%"><@msg.message key="attr.teachDepart"/></td>
      <td width="5%"><@bean.message key="attr.weekHour"/></td>
      <td width="5%"><@bean.message key="attr.credit"/></td>
      <td width="11%"><@msg.message key="task.firstCourse"/></td>
      <td width="5%"><@bean.message key="attr.GP"/></td>
      <td width="5%"><@msg.message key="attr.teachLangType"/></td>
      <td width="5%"><@msg.message key="attr.startWeek"/></td>
    </tr>
   </#assign>
 <table width="100%" class="listTable">
   ${columnHead}
    <#if table.tasksGroups?exists>
	   <#list table.tasksGroups as group>
	   <tr>
	      <td colspan="12" class="grayStyle">&nbsp;<@i18nName group.type/> <@msg.message key="task.shouldBeElect"/> ${group.credit?default(0)} <@msg.message key="attr.credit"/></td> 
	   </tr>
	 <!-- <#if (group.actualCredit?default(0)!=0)>${columnHead}</#if>-->
	 <#list group.tasks as task>
     <tr align="center" onmouseover="swapOverTR(this,this.className)<#if isStudent?default(false)>;displayRemark('${task.id},${task.course.id}')</#if>" onmouseout="swapOutTR(this)<#if isStudent?default(false)>;eraseRemark('${task.id},${task.course.id}')</#if>">
	      <td>${task_index+1}</td>
      <#if task.requirement.isGuaPai == true>
	      <td>${task.course.code}</td>
	      <td colspan="3"><a href="#" onclick="courseInfo(${task.course.id})"><@i18nName task.course/></a></td>
	      <td><@i18nName task.arrangeInfo.teachDepart/>
	      <td>${task.arrangeInfo.weekUnits}</td>
	      <td>${task.course.credits}</td>

	      <td><#if userCategory == 3 || userCategory != 3 && switch?exists && switch.isPublished>${task.firstCourseTime?if_exists}</#if></td>
	      <td><#if task.requirement.isGuaPai == true><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
	      <td><@i18nName (task.requirement.teachLangType)?if_exists/></td>
	      <td>${task.arrangeInfo.weekStart}</td>
      <#else>
	      <td>${task.course.code}</td>
	      <td><A href="courseTableForStd.do?method=taskTable&task.id=${task.id}" title="<@bean.message key="info.courseTable.lookFormTaskTip"/>">${task.seqNo?if_exists}</a></td>
	      <td><@getTeacherNames task.arrangeInfo.teachers/></td>
	      <td><a href="#" onclick="courseInfo(${task.course.id})"><@i18nName task.course/></a></td>
	      <td><@i18nName task.arrangeInfo.teachDepart/>
	      <td>${task.arrangeInfo.weekUnits}</td>
	      <td>${task.course.credits}</td>

	      <td><#if userCategory == 3 || userCategory != 3 && switch?exists && switch.isPublished>${task.firstCourseTime?if_exists}</#if></td>
	      <td><#if task.requirement.isGuaPai == true><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
	      <td><@i18nName (task.requirement.teachLangType)?if_exists/></td>
	      <td>${task.arrangeInfo.weekStart}</td>
      </#if>
    </tr>
    <#if isStudent?default(false)>
    <script>remarkContents['${task.id},${task.course.id}']={'remark':'${("教学班：" + task.teachClass.name?js_string)?if_exists}'};</script>
    </#if>
	    </#list>
	   </#list>
    </#if>
	</table>
<#if isStudent?default(false)>
<script>
    function displayRemark(taskId){
      if(""!=remarkContents[taskId].remark){
         toolTip(remarkContents[taskId].remark,'#000000', '#FFFF00',250);
      }
    }
    function eraseRemark(taskId){
     if(""!=remarkContents[taskId].remark){
        toolTip();
     }
    }
</script>
</#if>