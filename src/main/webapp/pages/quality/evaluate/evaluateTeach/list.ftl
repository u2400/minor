<#include "/templates/head.ftl"/>
  <@getMessage/>
   <@table.table width="100%" sortable="true" id="listTable" headIndex="1">
	<form name="evaluateForm" method="post" action="" onsubmit="return false;">
    <input type="hidden" name="method" value="search">
    <tr bgcolor="#ffffff" onKeyDown="javascript:enterQuery(event)">
      <td align="center" width="3%" >
        <img src="images/action/search.png"  align="top" onClick="query()" alt="<@bean.message key="info.filterInResult"/>"/>
      </td>
      <td ><input style="width:100%" type="text" name="teachTask.course.code" maxlength="32" value="${RequestParameters['teachTask.course.code']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="teachTask.course.name" maxlength="32" value="${RequestParameters['teachTask.course.name']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="teachTask.arrangeInfo.teachDepart.name" maxlength="32" value="${RequestParameters['teachTask.arrangeInfo.teachDepart.name']?if_exists}"/></td>
      <td ><input style="width:100%" type="text" name="teachTask.teachClass.stdType.name" maxlength="20" value="${RequestParameters['teachTask.teachClass.stdType.name']?if_exists}"/></td>
      <td ><input style="width:100%" type="text" name="teacherName" maxlength="20" value="${RequestParameters['teacherName']?if_exists}"/></td>
      <td ><input style="width:100%" type="text" name="isBeenEvaluation" maxlength="5" value="${RequestParameters['isBeenEvaluation']?if_exists}"/></td>      
      <td></td>
    </tr>
  	</form>
  	<@table.thead>
  	  <@table.selectAllTd id="taskId"/>
      <@table.sortTd id="teachTask.course.code" width="20%" name="attr.courseNo"/>
      <@table.sortTd id="teachTask.course.name" name="attr.courseName" width="20%"/>
      <@table.sortTd id="teachTask.arrangeInfo.teachDepart.name" width="20%" name="attr.teachDepart"/>
      <@table.sortTd id="teachTask.teachClass.stdType.name" width="10%" name="evaluate.forStudent"/>
      <@table.sortTd id="teacher.name" width="10%" name="attr.courseTeacher"/>
      <@table.sortTd id="isBeenEvaluation" width="10%" name="std.isBeenEvaluation"/>
      <@table.sortTd id="" width="10%" name="action.modeOfOperation"/>
    </@>
    <#assign teachTask_index=1>
     <@table.tbody datas=teachTaskList;teachTask>
      <@table.selectTd id="taskId" value=teachTask.id/>
      <#if "1"==evaluateMap[teachTask.id?string+"_0"]?default("0")><#assign flag=true><#else><#assign flag=false></#if>
      	<td>${teachTask.course.code}</td>
		<td><@i18nName teachTask.course/></td>
		<td>${teachTask.arrangeInfo.teachDepart.name?if_exists}</td>
		<td>${teachTask.teachClass.stdType.name?if_exists}</td>
		<td><#list (teachTask.arrangeInfo.teachers)?if_exists as teacher><@i18nName teacher?if_exists/><#if teacher_has_next>,</#if></#list></td>
		<td><#if flag><@msg.message key="evaluate.done"/><#else><font color="red"><@msg.message key="evaluate.noDo"/></font></#if></td>
		<td><input type="hidden" id="evaluate${teachTask_index}" name="evaluate${teachTask_index}" value="${teachTask.id}"><a href="javascript:<#if flag>doEvaluate('update','${teachTask_index}')<#else>doEvaluate('evaluate','${teachTask_index}')</#if>"><font color="blue"><#if flag><@msg.message key="evaluate.update"/><#else><@msg.message key="evaluate.do"/></#if></font></a></td>
   		<#assign teachTask_index=teachTask_index+1>
    </@>
  </@>
 <script language="javascript">
	var form = document.evaluateForm;
	function doEvaluate(value,nodeName){
		var url="";
		var id = document.getElementById("evaluate"+nodeName).value;
		if(id==""){
			alert("<@msg.message key="info.choiceCourseTip"/>");
			return;
		}
		form.action="evaluateTeach.do?method=loadQuestionnaire&calendarYear=${calendar.year!}&calendarTerm=${calendar.term!}";
		addInput(form,"evaluateId",id);
		addInput(form,"evaluateState",value)
		form.submit();
	}
 	 function query(form){
  			var form = document.evaluateForm;
			form.action="evaluateTeach.do?method=search&calendarYear=${calendar.year!}&calendarTerm=${calendar.term!}";
			form.target = "examTableFrame";
			form.submit();
		}
   </script>
	</script>
	  <script>function enterQuery(event) {if (portableEvent(event).keyCode == 13)query();}</script>
<#include "/templates/foot.ftl"/>
