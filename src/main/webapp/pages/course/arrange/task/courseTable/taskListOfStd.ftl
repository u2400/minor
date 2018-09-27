<#if isStudent?default(false)>
<script language="JavaScript" type="text/JavaScript" src="scripts/prompt.js"></script>
<div id="toolTipLayer" style="position:absolute; visibility: hidden"></div> 
<script>var remarkContents = new Object();</script>
<script>initToolTips();</script>
</#if>
 <table width="100%" class="listTable">
    <tr align="center" class="darkColumn">
      <td width="1%"></td>
      <td width="6%"><@msg.message key="attr.courseNo"/></td>
      <td width="6%"><@bean.message key="attr.taskNo"/></td>
      <td width="9%"><@bean.message key="entity.teacher"/></td>
      <td width="25%"><@bean.message key="attr.courseName"/></td>
      <td width="12%"><@msg.message key="entity.courseType"/></td>
      <td width="6%"><@bean.message key="attr.weekHour"/></td>
      <td width="6%"><@bean.message key="attr.credit"/></td>
      <td width="12%"><@msg.message key="task.firstCourseTime"/></td>
      <td><@bean.message key="attr.GP"/></td>
      <td width="6%"><@msg.message key="attr.teachLangType"/></td>
      <td width="6%"><@msg.message key="attr.startWeek"/></td>
      <td><@msg.message key="attr.remark"/></td>
    </tr>
    <#list taskList?sort_by(["courseType","name"]) as task>
   	  <#if task_index%2==1 ><#assign class="grayStyle"/></#if>
	  <#if task_index%2==0 ><#assign class="brightStyle"/></#if>
     <tr class="${class}" align="center" onmouseover="swapOverTR(this,this.className)<#if isStudent?default(false)>;displayRemark('${task.id},${task.course.id}')</#if>" onmouseout="swapOutTR(this)<#if isStudent?default(false)>;eraseRemark('${task.id},${task.course.id}')</#if>">
      <td>${task_index+1}</td>
      <td>${task.course.code}</td>
      <td><A href="courseTableForStd.do?method=taskTable&task.id=${task.id}" title="<@bean.message key="info.courseTable.lookFormTaskTip"/>">${task.seqNo?if_exists}</a></td>
      <td><#if userCategory != 3><#list task.arrangeInfo.teachers as teacher><A href="teacherSearch.do?method=info&teacher.id=${teacher.id}">${teacher.name}</A><#if teacher_has_next>, </#if></#list><#else><@getTeacherNames task.arrangeInfo.teachers/></#if></td>
      <td><a href="#" onclick="courseInfo(${task.course.id})"><@i18nName task.course/></a></td>
      <td><@i18nName task.courseType/></td>
      <td>${task.arrangeInfo.weekUnits}</td>
      <td>${task.course.credits}</td>
      <td><#if userCategory == 3 || userCategory != 3 && switch?exists && switch.isPublished>${task.firstCourseTime?if_exists}</#if></td>
      <td><#if task.requirement.isGuaPai == true><@bean.message key="common.yes" /> <#else> <@bean.message key="common.no" /> </#if></td>
      <td><@i18nName (task.requirement.teachLangType)?if_exists/></td>
      <td>${task.arrangeInfo.weekStart}</td>
      <td>${task.remark?if_exists}</td>
    </tr>
    <#if isStudent?default(false)>
    <script>remarkContents['${task.id},${task.course.id}']={'remark':'${("教学班：" + task.teachClass.name?js_string)?if_exists}'};</script>
    </#if>
	</#list>
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