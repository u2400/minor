 <script>var taskMap = {};</script>
 <@table.table width="100%" sortable="true" id="listTable" headIndex="1">
   <form name="taskListForm" action="" method="post" onsubmit="return false;">
    <input type="hidden" name="method" value="search">
    <tr bgcolor="#ffffff" onKeyDown="javascript:enterQuery(event)">
      <td align="center" width="3%" >
        <img src="images/action/search.png"  align="top" onClick="query()" alt="<@bean.message key="info.filterInResult"/>"/>
      </td>
      <td ><input style="width:100%" type="text" name="task.seqNo" maxlength="32" value="${RequestParameters['task.seqNo']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.course.code" maxlength="32" value="${RequestParameters['task.course.code']?if_exists}"/></td>
      <#if localName?index_of("en")==-1>
      <td ><input style="width:100%" type="text" name="task.course.name" maxlength="20" value="${RequestParameters['task.course.name']?if_exists}"/></td>
      <#else>
      <td ><input style="width:100%" type="text" name="task.course.engName" maxlength="100" value="${RequestParameters['task.course.engName']?if_exists}"/></td>
      </#if>
      <td><input style="width:100%" type="text" name="task.courseType.name" maxlength="32" value="${RequestParameters['task.courseType.name']?if_exists}"/></td>
      <td ><input style="width:100%" type="text" name="task.teachClass.name" maxlength="20" value="${RequestParameters['task.teachClass.name']?if_exists}"/></td>
      <td ><input style="width:100%" type="text" name="teacher.name" maxlength="20" value="${RequestParameters['teacher.name']?if_exists}"/></td>
      <td ><input style="width:100%" type="text" name="task.teachClass.planStdCount" maxlength="5" value="${RequestParameters['task.teachClass.planStdCount']?if_exists}"/></td>      
      <td><input style="width:100%" type="text" name="task.course.credits" maxlength="3" value="${RequestParameters['task.course.credits']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.arrangeInfo.weekUnits" maxlength="3" value="${RequestParameters['task.arrangeInfo.weekUnits']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.arrangeInfo.weeks" maxlength="3" value="${RequestParameters['task.arrangeInfo.weeks']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.arrangeInfo.overallUnits" maxlength="3" value="${RequestParameters['task.arrangeInfo.overallUnits']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.taskGroup.name" maxlength="20" value="${RequestParameters['task.taskGroup.name']?if_exists}"/></td>
    </tr>
  	</form>
  	<@table.thead>
  	  <@table.selectAllTd id="taskId"/>
      <@table.sortTd id="task.seqNo" width="8%" name="attr.taskNo"/>
      <@table.sortTd id="task.course.code" name="attr.courseNo" width="8%"/>
      <@table.sortTd id="task.course.name" width="20%" name="attr.courseName"/>
      <@table.sortTd id="task.courseType.name" width="15%" name="entity.courseType"/>
      <@table.sortTd id="task.teachClass.name" width="15%" name="entity.teachClass"/>
      <@table.td width="10%" name="entity.teacher"/>
      <@table.sortTd width="4%" id="task.teachClass.planStdCount" name="teachTask.planStudents"/>
      <@table.sortTd width="4%" id="task.course.credits" name="attr.credit"/>
      <@table.sortTd width="4%" id="task.arrangeInfo.weekUnits" name="teachTask.weeksPerHour"/>
      <@table.sortTd width="4%" id="task.arrangeInfo.weeks" name="attr.weeks"/>
      <@table.sortTd width="4%" id="task.arrangeInfo.overallUnits" name="attr.creditHour"/>
      <@table.sortTd name="attr.groupName" id="task.taskGroup.name"/>
    </@>
    <@table.tbody datas=tasks;task>
      <@table.selectTd id="taskId" value=task.id/>
      <td><#if task.arrangeInfo.isArrangeComplete ==false>${task.seqNo?if_exists}<#else><A href="courseTable.do?method=taskTable&task.id=${task.id}" title="查看课程安排">${task.seqNo?if_exists}</a></#if></td>
      <td id="course_${task.id}">${task.course.code}</td>
      <td title="<@i18nName task.course/>" nowrap><span style="display:block;width:130px;overflow:hidden;text-overflow:ellipsis"><A href="?method=info&task.id=${task.id}" title="<@i18nName task.course/>"><@i18nName task.course/></A></span></td>
      <td title="<@i18nName task.courseType/>" nowrap><span style="display:block;width:100px;overflow:hidden;text-overflow:ellipsis"><@i18nName task.courseType/></span></td>
      <td><#if task.teachClass.gender?exists>(<@i18nName task.teachClass.gender/>)</#if>${task.teachClass.name?html}</td>
      <script>taskMap["${task.id}"] = {"courseCode":"${task.course.code}", "teachClassName":"${task.teachClass.name?js_string}"}</script>
      <#--
      <td title="${task.teachClass.name?html}" nowrap><span style="display:block;width:60px;overflow:hidden;text-overflow:ellipsis;"><#if task.teachClass.gender?exists>(<@i18nName task.teachClass.gender/>)</#if>${task.teachClass.name?html}</span></td>
      -->
      <td id="teacher${task.id}" title="<@getTeacherNames task.arrangeInfo.teachers/>" nowrap><span style="display:block;width:60px;overflow:hidden;text-overflow:ellipsis"><@getTeacherNames task.arrangeInfo.teachers/></span></td>
      <td><A href="?method=printStdListForDuty&teachTaskIds=${task.id}" title="查看学生名单" target="_blank">${task.teachClass.planStdCount}</A></td>
      <td>${task.course.credits}</td>
      <td>${task.arrangeInfo.weekUnits}</td>
      <td>${task.arrangeInfo.weeks}</td>
      <td><input type="hidden" name="${task.id}" id="${task.id}" value="<#if task.isConfirm == true>1<#else>0</#if>"/>${task.arrangeInfo.overallUnits}</td>
      <td title="${(task.taskGroup.name)?if_exists?html}" nowrap><span style="display:block;width:70px;overflow:hidden;text-overflow:ellipsis;">${(task.taskGroup.name)?if_exists?html}</span></td>
    </@>
  </@>
  <script>function enterQuery(event) {if (portableEvent(event).keyCode == 13)query();}</script>
