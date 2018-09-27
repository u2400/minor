<#include "/templates/head.ftl"/>
<body>
    <table id="bar"></table>
<@table.table width="100%" sortable="true" id="listTable">
   <@table.thead>
  	  <@table.selectAllTd id="taskId"/>
      <@table.sortTd id="task.seqNo" width="8%" name="attr.taskNo"/>
      <@table.sortTd id="task.course.name" width="20%" name="attr.courseName"/>
      <#if userCategory?exists && (userCategory == 3 || userCategory != 3 && switch?exists && switch.isPublished)><@table.td name="task.arrangeInfo"/></#if>
      <@table.td text="教学班" width="10%"/>
      <@table.td width="15%" name="entity.teacher"/>
      <@table.sortTd width="4%" id="task.teachClass.stdCount" name="attr.stdNum"/>
      <@table.sortTd width="4%" id="task.course.credits" name="attr.credit"/>
      <@table.sortTd width="4%" id="task.arrangeInfo.weekUnits" text="周时"/>
      <@table.sortTd width="4%" id="task.arrangeInfo.weeks" text="周数"/>
    </@>
    <@table.tbody datas=tasks;task>
      <@table.selectTd id="taskId" value=task.id/>
      <td><A href="javascript:arrangeView(${task.id})" title="点击显示单个教学任务具体安排">${task.seqNo?if_exists}</a></td>
      <td><a href="#" onclick="courseInfo(${task.course.id})"><@i18nName task.course/></a></td>
      <#if userCategory?exists && (userCategory == 3 || userCategory != 3 && switch?exists && switch.isPublished)><td>${arrangeInfo[task.id?string]}</td></#if>
      <td title="${task.teachClass.name?html}" nowrap><span style="display:block;width:160px;overflow:hidden;text-overflow:ellipsis;">${task.teachClass.name?html}</span></td>
      <td><@getTeacherNames task.arrangeInfo.teachers/></td>
      <td>${task.teachClass.stdCount}</td>
      <td>${task.course.credits}</td>
      <td>${task.arrangeInfo.weekUnits}</td>
      <td>${task.arrangeInfo.weeks}</td>
    </@>
</@>
<form method="post" action="" name="actionForm" onsubmit="return false;">
    <#--下面的两个仅课程使用-->
    <input type="hidden" name="courseId" value=""/>
    <input type="hidden" name="type" value="course"/>
</form>
<script>
    var bar = new ToolBar("bar","课程列表",null,true,true);
    bar.setMessage('<@getMessage/>');
    bar.addBlankItem();
    
    var form = document.actionForm;
    
    function arrangeView(taskId) {
        if (${(!(userCategory == 3 || userCategory != 3 && switch?exists && switch.isPublished))?string("true", "false")}) {
            alert("当前学期的排课结果还未发布。");
            return;
        }
        form.action = "courseTable.do?method=taskTable";
        addInput(form, "task.id", taskId, "hidden");
        form.target = "_blank";
        form.submit();
    }
    
    function courseInfo(courseId) {
        var form = document.actionForm;
        form.action = "teachTaskSearch.do?method=courseInfo";
        form["courseId"].value = courseId;
        form.target = "_blank";
        form.submit();
    }
</script>
</body>
<#include "/templates/foot.ftl"/>