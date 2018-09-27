 <@table.table  width="100%" border="0">
   <@table.thead >
      <td width="1%"></td>
      <td width="6%"><@bean.message key="course.no" /></td>
      <td><@bean.message key="course.titleName"/></td>
      <td><@msg.message key="entity.courseType"/></td>
      <td><@bean.message key="attr.credit" /></td>
      <td><@bean.message key="attr.weeks" /></td>
      <td><@bean.message key="attr.weekHour"/></td>
      <td><@msg.message key="task.firstCourseTime"/></td>
      <td><@msg.message key="task.arrangeInfo"/></td>
      <td><@msg.message key="task.studentNum"/></td>
      <td><@bean.message key="attr.GP"/></td>
      <td width="6%"><@msg.message key="attr.teachLangType"/></td>
      <td width="4%"><@msg.message key="attr.startWeek"/></td>
      <td width="5%">教材</td>
      <td width="5%">进度</td>
    </@>
    <@table.tbody datas=taskList?sort_by(["courseType","name"]);task>
      <@table.selectTd  type="radio" id="taskId" value="${task.id}"/>
      <td><A href="courseTableForTeacher.do?method=taskTable&task.id=${task.id}"  title="<@bean.message key="info.courseTable.lookFormTaskTip"/>"><U>${task.seqNo?if_exists}</U></a></td>
      <td><A href="#" onclick="javascript:taskInfo('${task.id}')" title="<@bean.message key="info.task.info"/>"><U><@i18nName task.course/></U></a></td>
      <td><@i18nName task.courseType/></td>
      <td>${task.course.credits}</td>
      <td>${task.arrangeInfo.weeks}</td>
      <td>${task.arrangeInfo.weekUnits}</td>
      <#if isArrangeSwitch?string("true","false")="true">
      	<#assign date =task.firstCourseTime?if_exists>
	 	<#if date?string!="">
	 	<td>${date?string("yyyy-MM-dd")}<br>${date?string("HH:mm")}</td>
	 	<#else><td></td>
	 	</#if>
       <td>
        ${task.arrangeInfo.digest(task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],":teacher2:day:units节 :weeks周" + ((isArrangeSwitch)?default(false) && (isArrangeAddress)?default(false))?string(" :room", ""))}
       </td>
       <#else>
       <td></td>
       <td></td>
      </#if>
      <td><A href="teacherTask.do?method=printDutyStdList&teachTaskIds=${task.id}" target="_blank"><U>${task.teachClass.stdCount}</U></A></td>
      <td><#if task.requirement.isGuaPai == true><@bean.message key="common.yes" /> <#else> <@bean.message key="common.no" /> </#if></td>
      <td><@i18nName (task.requirement.teachLangType)?if_exists/></td>
      <td>${task.arrangeInfo.weekStart}</td>
      <td><#if (task.requirement.textbooks)?exists && (task.requirement.textbooks)?size != 0><a href="#" onclick="bookInfo('${task.id}')">指定</a></#if></td>
      <td title="${(scheduleMap[task.id?string].name)?if_exists}" nowrap><span style="display:block;width:50px;overflow:hidden;text-overflow:ellipsis">${(scheduleMap[task.id?string].name)?if_exists}</span></td>
    </@>
 </@>
    <table id="courseTableBar" width="100%"></table>
    <script>
       var bar = new ToolBar("courseTableBar","<@msg.message key="entity.courseTable"/>",null,true,true);
       bar.addItem("<@msg.message key="action.print"/>","courseTableForTeacher.do?method=courseTable&setting.kind=teacher&ids=${teacher.id}&setting.forCalendar=0&calendar.id=${calendar.id}","print.gif");
    </script>
    </script>
	<#include "courseTableContent.ftl"/>
	<#include "../../arrange/task/courseTable/courseTableRemark.ftl"/>
	<table>
	 <font color="red" size='4'>注：由于学生退课及系统随机筛选等原因，选课期间课程人数实时变动，课程真实选课人数以下学期开学初最后一轮选课结束后为准。<br>
	 如到长宁校区上课的老师请按照以下“长宁校区上课时间表”安排时间
	<br>
	 </font>
	</table>