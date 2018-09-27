 <@table.table  width="100%" id="listTable" sortable="true">
    <@table.thead>
      <@table.selectAllTd id="taskId"/>
      <@table.sortTd id="task.seqNo" width="8%" name="attr.taskNo"/>
      <@table.sortTd id="task.course.code" width="8%" name="attr.courseNo" />
      <@table.sortTd id="task.course.name" width="25%" name="attr.courseName"/>
      <@table.td width="20%" name="entity.teachClass"/>
      <@table.td name="entity.teacher"/>
      <@table.sortTd id="task.teachClass.stdCount" width="5%" name="attr.stdNum"/>
      <@table.sortTd id="task.course.credits" width="5%" name="attr.credit"/>
      <@table.sortTd width="5%" text="周时" id="task.arrangeInfo.weekUnits"/>
      <@table.td width="5%" text="发布"/>
    </@>
    <@table.tbody datas=tasks;task>
      <@table.selectTd type="checkbox" value=task.id id="taskId"/>
      <td><A href="courseTable.do?method=taskTable&task.id=${task.id}" title="查看课程安排">${task.seqNo?if_exists}</A></td>
      <td>${task.course.code}</td>
      <td title="<@i18nName task.course/>" nowrap><span style="display:block;width:150px;overflow:hidden;text-overflow:ellipsis"><A href="teachTaskCollege.do?method=info&task.id=${task.id}" title="<@bean.message key="info.task.info"/>"><@i18nName task.course/></A></span></td>
      <#if task.requirement.isGuaPai>
      <td>挂牌</td>
      <#else>
      <td title="${task.teachClass.name}" nowrap><span style="display:block;width:150px;overflow:hidden;text-overflow:ellipsis">${task.teachClass.name?html}</span></td>
      </#if>
      <td><@getTeacherNames task.arrangeInfo.teachers/></td>
      <td><A href="teachTaskCollege.do?method=printStdListForDuty&teachTaskIds=${task.id}" title="查看学生名单" target="_blank">${task.teachClass.stdCount}</A></td>
      <td>${task.course.credits}</td>
      <td>${task.arrangeInfo.weekUnits}</td>
      <td>${task.gradeState.isPublished(FINAL)?string("是","否")}</td>
    </@>
  </@>