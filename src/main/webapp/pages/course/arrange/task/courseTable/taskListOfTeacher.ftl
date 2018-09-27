 <table width="100%" border="0" class="listTable">
    <tr align="center" class="darkColumn">
      <td width="2%"></td>
      <td width="7%"><@bean.message key="attr.taskNo"/></td>
      <td><@bean.message key="attr.courseName"/></td>
      <td width="15%"><@msg.message key="entity.courseType"/></td>
      <td><@bean.message key="entity.teachClass"/></td>
      <td width="5%"><@bean.message key="attr.weekHour"/></td>
      <td width="5%"><@bean.message key="attr.credit"/></td>
      <td width="5%"><@bean.message key="attr.GP"/></td>
      <td width="5%"><@msg.message key="attr.teachLangType"/></td>
      <td width="5%"><@msg.message key="attr.startWeek"/></td>
      <td width="8%">实际人数</td>
    </tr>
    <#list taskList?sort_by("courseType","name") as task>
   	  <#if task_index%2==1 ><#assign class="grayStyle"/></#if>
	  <#if task_index%2==0 ><#assign class="brightStyle"/></#if>
     <tr class="${class}" align="center" onmouseover="swapOverTR(this,this.className)" onmouseout="swapOutTR(this)" >
      <td>${task_index+1}</td> 
      <td><A href="courseTableForTeacher.do?method=taskTable&task.id=${task.id}" title="<@bean.message key="info.courseTable.lookFormTaskTip"/>">${task.seqNo?if_exists}</a></td>
      <td>
       <A href="teachTaskSearch.do?method=info&task.id=${task.id}" title="<@bean.message key="info.task.info"/>">
       <@i18nName task.course/></a>
      </td>
      <td><@i18nName task.courseType/></td>
      <td>${task.teachClass.name}</td>
      <td>${task.arrangeInfo.weekUnits}</td>
      <td>${task.course.credits}</td>
      <td><#if task.requirement.isGuaPai == true><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
      <td><@i18nName (task.requirement.teachLangType)?if_exists/></td>
      <td>${task.arrangeInfo.weekStart}</td>
      <td><A href="teachTask.do?method=printStdListForDuty&teachTaskIds=${task.id}" title="查看学生名单" target="_blank">${task.teachClass.stdCount}</a></td>
    </tr>
	</#list>
	</table>