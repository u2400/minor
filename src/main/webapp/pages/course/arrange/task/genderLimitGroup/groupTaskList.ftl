
 <table width="100%" border="0" class="listTable">
    <tr align="center" class="darkColumn">
      <td class="select">
        <input type="checkbox" onClick="toggleCheckBox(document.getElementsByName('taskId'),event);"/>
      </td>
      <td width="7%"><@bean.message key="attr.taskNo"/></td>
      <td width="7%"><@bean.message key="attr.courseNo"/></td>
      <td width="10%"><@bean.message key="attr.courseName"/></td>
      <td width="12%"><@bean.message key="entity.courseType"/></td>
      <td width="10%"><@bean.message key="entity.teacher"/></td>
      <td width="10%"><@bean.message key="attr.roomConfigOfTask"/></td>
      <td width="10%">计划(男/女)</td>
      <td width="10%">实际(男/女)</td>
      <td width="5%">单项</td>
    </tr>
    <#list taskGroup.taskList?sort_by(["course","id"]) as task>
   	  <#if task_index%2==1><#assign class="grayStyle"></#if>
	  <#if task_index%2==0><#assign class="brightStyle"></#if>
     <tr class="${class}" align="center" onmouseover="swapOverTR(this,this.className)"
      onmouseout="swapOutTR(this)" onclick="onRowChange(event)">
      <td  class="select">
        <input type="checkBox" name="taskId" value="${task.id}"/>
      </td>
      <td><#if task.arrangeInfo.isArrangeComplete ==false>${task.seqNo?if_exists}<#else><A href="courseTable.do?method=taskTable&task.id=${task.id}">${task.seqNo?if_exists}</a></#if></td>
      <td>${task.course.code}</td>
      <td><A href="teachTask.do?method=info&task.id=${task.id}" title="<@bean.message key="info.task.info"/>"><@i18nName task.course/></A></td>
      <td><@i18nName task.courseType/></td>
      <td><@getTeacherNames task.arrangeInfo.teachers/></td>
      <td><@i18nName task.requirement.roomConfigType/></td>
      <#assign maleLimit = task.teachClass.getGenderLimitGroup(MALE)?if_exists/>
      <#assign femaleLimit = task.teachClass.getGenderLimitGroup(FEMALE)?if_exists/>
      <td>${task.teachClass.planStdCount}(${(maleLimit.limitCount)?default("-")}/${(femaleLimit.limitCount)?default("-")})</td>
      <td>${task.teachClass.stdCount}(${(maleLimit.count)?default(0)}/${(femaleLimit.count)?default(0)})</td>
      <td>${task.remark?if_exists}</td>
    </tr>
	</#list>
	</table>