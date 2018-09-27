<#include "/templates/head.ftl"/>
<body >
  <table id="taskBar"></table>
  <#--
    <#assign taskIds=""/>
    <#list tasks as task><#assign taskIds = taskIds + task.id/><#if task_has_next><#assign taskIds = taskIds + ","/></#if></#list>
    （当前记录数/总操作记录：${tasks?size}/${RequestParameters["totalSize"]}）
  -->
<script>
     <#assign pageName><font face="宋体">教学任务操作</font></#assign>
     var bar = new ToolBar("taskBar", "${pageName?js_string}", null, true, false);
     bar.setMessage('<@getMessage/>');
     bar.addItem('<@bean.message key="action.delete"/>', 'removeTeachTask()');
</script>
  <#include "/pages/course/task/teachTaskList.ftl"/>
  <form name="actionForm" method="post" action="" onsubmit="return false;">
     <input type="hidden" name="task.calendar.id" value="${RequestParameters['task.calendar.id']?default(RequestParameters['calendar.id'])}"/>
     <input type="hidden" name="calendar.id" value="${RequestParameters['task.calendar.id']?default(RequestParameters['calendar.id'])}"/>
     <input type="hidden" name="params" value=""/>
     <input type="hidden" name="toBeText" value="toBeText"/>
  </form>
  <script>
    var form = document.actionForm;
    function checkConfirmIdSeq(idSeq){
       var idArray = idSeq.split(",");
       for(var i=0;i<idArray.length;i++){
          if(checkConfirm(idArray[i])) {
            alert("选择的教学任务中包含已经确认的，请选择未确认的任务");
            return false;
          }
       }
       return true;
    }
    function checkConfirm(id){
        return document.getElementById(id).value!=0;
    }
    function query(){
        var form = document.taskListForm;
        form.action="courseTakeForTask.do?method=listWithTeachTask";
        form.target = "_self";
        addInput(form, "taskIds", "${RequestParameters['taskIds']?default(taskIds)}", "hidden");
        form.submit();
    }
    function removeTeachTask(){
        ids = getSelectIds("taskId");
        if (ids=="") {
            alert("<@bean.message key="prompt.task.selector"/>");
            return;
        }
        if (!checkConfirmIdSeq(ids)) {
            return;
        }
        if (!confirm("将要删除选定的 " + countId(ids) + " 个任务。\n<@bean.message key="prompt.task.delete"/>")) {
            return;
        }
        form.action = "teachTask.do?method=remove&taskIds=" + ids;
        form.submit();
    }
  </script>
</body> 
<#include "/templates/foot.ftl"/>