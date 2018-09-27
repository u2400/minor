   <script>
   var contents = new Object();
    <#list tasks as task>
       contents['${task.id}']='${task.arrangeInfo.digest(task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],":day :units :weeks :room")?replace(" ,", "<br>")?trim}';
    </#list>
    function displayArrangeResult(taskId){
      var msg="没有安排。"
      if(null!=contents[taskId])
         msg = contents[taskId];
      toolTip(msg,'#000000', '#FFFF00',250);
    }
    </script>