<#include "/templates/head.ftl"/>

<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="backBar"></table>
<#assign allStdCount = genderCounts.maleCount + genderCounts.femaleCount/>
<script>
   var bar = new ToolBar('backBar','修改组内每个教学任务计划人数,总人数${allStdCount}',null,true,true);
   bar.setMessage('<@getMessage/>');
   bar.addItem("<@msg.message key="action.save"/>","savePlanStdCount()","save.gif");
   bar.addBack('<@bean.message key="action.back"/>');
   
   var taskMap = {};
</script>
 <table width="100%" border="0" class="listTable">
    <form name="taskForm" method="post" action="" onsubmit="return false;">
    <input type="hidden" name="taskGroup.id" value="${taskGroup.id}"/>
    <tr align="center" class="darkColumn">
      <td width="6%"><@bean.message key="attr.taskNo"/></td>
      <td width="7%"><@bean.message key="attr.courseNo"/></td>
      <td width="8%"><@bean.message key="attr.courseName"/></td>
      <td width="12%"><@bean.message key="entity.courseType"/></td>
      <td width="12%"><@bean.message key="entity.teachClass"/></td>
      <td width="6%"><@bean.message key="entity.teacher"/></td>
      <td width="8%">(计/实)人数</td>
      <td width="8%">(计/实)男生</td>
      <td width="8%">(计/实)女生</td>
      <td width="8%">单项</td>
    </tr>
    <#list taskGroup.taskList as task>
   	  <#if task_index%2==1 ><#assign class="grayStyle"/></#if>
	  <#if task_index%2==0 ><#assign class="brightStyle"/></#if>
    <tr class="${class}" align="center">
      <td><#if task.arrangeInfo.isArrangeComplete ==false>${task.seqNo?if_exists}<#else><A href="courseTable.do?method=taskTable&task.id=${task.id}">${task.seqNo?if_exists}</a></#if></td>
      <td>${task.course.code}</td>
      <td><@i18nName task.course/></td>
      <td><@i18nName task.courseType/></td>
      <td title="${task.teachClass.name?html}" nowrap><span style="display:block;width:150px;overflow:hidden;text-overflow:ellipsis;"><#if task.teachClass.gender?exists>(<@i18nName task.teachClass.gender/>)</#if>${task.teachClass.name?html}</span></td>
      <td><@getTeacherNames task.arrangeInfo.teachers/></td>
      <td><input style="width:48%" type="text" id="planStdCount${task_index}" name="planStdCount${task.id}" value="${task.teachClass.planStdCount}">/${task.teachClass.stdCount}</td>
      <#assign maleLimit = task.teachClass.getGenderLimitGroup(MALE)?if_exists/>
      <#assign femaleLimit = task.teachClass.getGenderLimitGroup(FEMALE)?if_exists/>
      <td><input style="width:48%" type="text" id="maleLCount${task_index}" name="maleLCount${task.id}" value="${(maleLimit.limitCount)?if_exists}"/>/${genderCountsForTasks[task.id?string].maleCount}</td>
      <td><input style="width:48%" type="text" id="femaleLCount${task_index}" name="femaleLCount${task.id}" value="${(femaleLimit.limitCount)?if_exists}"/>/${genderCountsForTasks[task.id?string].femaleCount}</td>
      <td><input type="text" name="remark${task.id}" value="${task.remark?if_exists}" style="width:100%"/></td>
    </tr>
	</#list>
  <script>
    taskMap = {"maleCount":${genderCounts.maleCount}, "femaleCount":${genderCounts.femaleCount}};
  </script>
	 <tr align="center" class="darkColumn">
	  <td colspan="10">
	     <input type="radio" name="adjuestMode" id="adjustAll" value=""/>统一调整为：
	     <input type="text" id="avgStdCount" maxlength="7" onfocus="adjustAll.checked=true;" name="avg" value="" onKeyUp="setAll()"/>|
	     <input type="radio" name="adjuestMode" id="avgAll" value="" onclick="if(this.checked)divPlanCount();"/>均分${allStdCount}名学生（其中男生${genderCounts.maleCount}人，女生${genderCounts.femaleCount}人）
	 </tr>	
	</form>
	</table>
   <script type="text/javascript">
     function divPlanCount(){
          var taskCount = ${taskGroup.taskList?size};
          if(taskCount>0){
              var allStdCount = ${allStdCount};
              var totalMCount = taskMap.maleCount;
              var totalFCount = taskMap.femaleCount;
              var remainStdCount = allStdCount % taskCount;
              var remainMCount = totalMCount % taskCount;
              var remainFCount = totalFCount % taskCount;
              for(var i=0;i<taskCount;i++){
                 var oneStdCount = parseInt(allStdCount / taskCount);
                 if (remainStdCount > 0 && i >= taskCount - remainStdCount) {
                    oneStdCount++;
                 }
                 document.getElementById("planStdCount"+i).value = oneStdCount;
                 var oneMCount = parseInt(totalMCount / taskCount);
                 if (remainFCount > 0 && i >= taskCount - remainMCount) {
                    oneMCount++;
                 }
                 document.getElementById("maleLCount"+i).value = oneMCount;
                 var oneFCount = parseInt(totalFCount / taskCount);
                 if (remainFCount > 0 && i >= taskCount - remainFCount) {
                    oneFCount++;
                 }
                 document.getElementById("femaleLCount"+i).value = oneFCount;
              }
          }
     }
     function savePlanStdCount(){
        var form =document.taskForm;
        var newStdCount=new Number(0);
        for(var i=0;i< ${taskGroup.taskList?size};i++){
          var stdCount= document.getElementById("planStdCount"+i).value;
          if(!/^\d+$/.test(stdCount)){alert(stdCount+" 格式不正确，应为正整数");return;}
          newStdCount+=new Number(stdCount)
        }
        if(newStdCount!=${allStdCount}){
           if(!confirm("班级总人数为${allStdCount}\n调整后的人数总数为:"+newStdCount+"\n确定提交该设置?"))
           return;
        }
        form.action="englishGroup.do?method=savePlanCount";
        form.submit();
     }
     function setAll(){   
        if(document.getElementById("adjustAll").checked){
	        var avgStdCount = document.getElementById("avgStdCount");
	        if(/^\d+$/.test(avgStdCount.value))
		        for(var i=0;i<${taskGroup.taskList?size};i++){
		          document.getElementById("planStdCount"+i).value=avgStdCount.value;
		        }
	    }
     }
  </script>
 </body>
<#include "/templates/foot.ftl"/> 