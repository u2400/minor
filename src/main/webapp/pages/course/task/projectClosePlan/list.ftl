<#include "/templates/head.ftl"/>
<body >
  <table id="taskBar"></table>
  <script>
     var bar = new ToolBar('taskBar', '<@msg.message key="teachTask.list.projectClose"/>', null, true, false);
     bar.setMessage('<@getMessage/>');
     bar.addBlankItem();
</script>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url" />"></script>
  <#include "/pages/course/task/projectClosePlan.ftl"/>
  
  <form name="actionForm" method="post" action="" onsubmit="return false;">
     <#--input type="hidden" name="task.calendar.id" value="${RequestParameters['task.calendar.id']}"/>
     <input type="hidden" name="calendar.id" value="${RequestParameters['task.calendar.id']}"/>
     <input type="hidden" name="params" value=""/-->
  </form>
  <script>
    adaptFrameSize();
  </script>
</body> 
<#include "/templates/foot.ftl"/>