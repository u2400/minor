 <@table.table width="100%" sortable="true" id="listTable" headIndex="1">
   <form name="taskListForm" action="" method="post" onsubmit="return false;">
    <#--input type="hidden" name="task.calendar.id" value="${RequestParameters['task.calendar.id']?default(RequestParameters['calendar.id'])}"/-->
    <input type="hidden" name="method" value="search">
    <tr bgcolor="#ffffff" onKeyDown="javascript:enterQuery(event)">
      <td align="center" width="3%">
        <img src="images/action/search.png"  align="top" onClick="query()" alt="<@bean.message key="info.filterInResult"/>"/>
      </td>
      <td><input style="width:100%" type="text" name="task.course.code" maxlength="32" value="${RequestParameters['task.course.code']?if_exists}"/></td>
      <#if localName?index_of("en")==-1>
      <td ><input style="width:100%" type="text" name="task.course.name" maxlength="20" value="${RequestParameters['task.course.name']?if_exists}"/></td>
      <#else>
      <td ><input style="width:100%" type="text" name="task.course.engName" maxlength="100" value="${RequestParameters['task.course.engName']?if_exists}"/></td>
      </#if>
      <td><input style="width:100%" type="text" name="task.courseType.name" maxlength="32" value="${RequestParameters['task.courseType.name']?if_exists}"/></td>
      <td ><input style="width:100%" type="text" name="task.name" maxlength="20" value="${RequestParameters['task.teachClass.name']?if_exists}"/></td>
      <td ><input style="width:100%" type="text" name="task.teacher" maxlength="20" value="${RequestParameters['teacher.name']?if_exists}"/></td>
      <td ><input style="width:100%" type="text" name="task.planStdCount" maxlength="5" value="${RequestParameters['task.teachClass.planStdCount']?if_exists}"/></td>      
      <td><input style="width:100%" type="text" name="task.course.credits" maxlength="3" value="${RequestParameters['task.course.credits']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.calendar.start" maxlength="3" value="${RequestParameters['task.calendar.start']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.arrangeInfo" maxlength="3" value="${RequestParameters['task.arrangeInfo']?if_exists}"/></td>
    </tr>
  	</form>
  	<@table.thead>
  	  <@table.selectAllTd id="taskId"/>
      <@table.sortTd id="task.course.code" name="attr.courseNo" width="10%"/>
      <@table.sortTd id="task.course.name" width="15%" name="attr.courseName"/>
      <@table.sortTd id="task.courseType.name" width="15%" name="entity.courseType"/>
      <@table.sortTd id="task.name" width="15%" name="entity.teachClass"/>
      <@table.sortTd id="task.teacher" width="10%" name="entity.teacher"/>
      <@table.td width="4%"  name="teachTask.planStudents"/>
      <@table.sortTd width="4%" id="task.course.credits" name="attr.credit"/>
      <@table.sortTd width="12%" text="学年学期" id="task.calendar.start"/>
      <@table.sortTd width="15%" text="排课信息" id="task.arrangeInfo"/>
    </@>
    <@table.tbody datas=tasks;task>
      <@table.selectTd id="taskId" value=task.id/>
      <td id="course_${task.id}">${task.course.code}</td>
      <td><@i18nName task.course/></td>
      <td><@i18nName task.courseType/></td>
      <td title="${task.name?html}" nowrap><span style="display:block;width:150px;overflow:hidden;text-overflow:ellipsis;"><#if task.gender?exists>(<@i18nName task.gender/>)</#if>${task.name?html}</span></td>
      <td id="teacher${task.id}">${(task.teacher)!}</td>
      <td><A href="projectClosePlan.do?method=stuList&teachTaskIds=${task.id}" title="查看学生名单" target="_blank">${task.planStdCount}</A></td>
      <td>${task.course.credits}</td>
      <td>${task.calendar.year} ${task.calendar.term}</td>
      <td>${(task.arrangeInfo)?if_exists}</td>
    </@>
  </@>
  <script>function enterQuery(event) {if (portableEvent(event).keyCode == 13)query();}
  
  function query(){
        var form = document.taskListForm; 
      
        form.action="projectClosePlan.do?method=search";	  
	    form.submit();
	}
	
  </script>
