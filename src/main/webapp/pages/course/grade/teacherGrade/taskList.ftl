 <@table.table width="100%">
	    <@table.thead>
	      <@table.selectAllTd id="taskId"/>
	      <@table.td name="attr.taskNo"/>
	      <@table.td name="attr.courseName"/>
	      <@table.td name="entity.courseType"/>
	      <@table.td text="教学班" width="20%"/>
	      <@table.td name="attr.credit"/>
	      <@table.td name="attr.weeks"/>
	      <@table.td name="attr.weekHour"/>
	      <@table.td name="task.studentNum"/>
	      <@table.td name="attr.GP"/>
	      <@table.td name="info.operation"/>
	    </@>
	    <@table.tbody datas=tasks?sort_by("seqNo");task>
	   	  <@table.selectTd id="taskId" value="${task.id}" type="checkbox"/>
	      <td><A href="courseTableForTeacher.do?method=taskTable&task.id=${task.id}"  title="<@bean.message key="info.courseTable.lookFormTaskTip"/>"><U>${task.seqNo?if_exists}</U></a></td>
	      <td><A href="teachTaskSearch.do?method=info&task.id=${task.id}" title="<@bean.message key="info.task.info"/>"><U><@i18nName task.course/></U></a></td>
	      <td><@i18nName task.courseType/></td>
	      <td title="${task.teachClass.name?html}" nowrap><span style="display:block;width:250px;overflow:hidden;text-overflow:ellipsis;"><#if task.teachClass.gender?exists>(<@i18nName task.teachClass.gender/>)</#if>${task.teachClass.name?html}</span></td>
	      <td>${task.course.credits}</td>
	      <td>${task.arrangeInfo.weeks}</td>
	      <td>${task.arrangeInfo.weekUnits}</td>
	      <td><A href="teacherTask.do?method=printDutyStdList&teachTaskIds=${task.id}" target="_blank"><U>${task.teachClass.stdCount}</U></A></td>
	      <td><#if task.requirement.isGuaPai == true><@bean.message key="common.yes" /> <#else> <@bean.message key="common.no" /> </#if></td>
	      <td>
	          <#if (task.gradeState.isConfirmed(GAGrade))?default(false)>
	             <A href="#" onclick="printTeachClassGrade(${task.id})"><U><@msg.message key="action.print"/></U></A>
	          <#else>
	            <#if canInput>
	              <A href="#" onclick="inputGrade(${task.id})"><U><@msg.message key="grade.input"/></U></A>
	            <#else>
	                未开放录入
	            </#if>
	          </#if>
	      </td>
	    </@>
    </@>