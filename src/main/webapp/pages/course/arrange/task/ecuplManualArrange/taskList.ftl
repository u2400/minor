<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="pages/course/task/task.js"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/prompt.js"></script>
<style  type="text/css">
<!--
.trans_msg
    {
    filter:alpha(opacity=100,enabled=1) revealTrans(duration=.1,transition=1) blendtrans(duration=.2);
    }
-->
</style>
   <#assign taskList =tasks/>
   <#if RequestParameters['task.arrangeInfo.isArrangeComplete']?default("1")=="0">
   <#include "/pages/course/arrange/taskArrangeSuggestPrompt.ftl"/> 
   <#else>
   <#include "taskArrangeResult.ftl"/> 
   </#if>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
 <div id="toolTipLayer" style="position:absolute; visibility: hidden"></div>
 <script>initToolTips()</script>
<table id="taskListBar"></table>
 <div id="processDIV" style="display:block">页面加载中...</div>
 <div id="contentDIV" style="display:none">
    <script>var taskMap = {};</script>
	<@table.table id="teachTask" width="100%" sortable="true" headIndex="1">
	  	<form name="taskListForm" action="" method="post" onsubmit="return false;">
	  	<#--下面两行代码为显示课程详细信息而设，请勿更改或者同名-->
	  	<input type="hidden" name="type" value="course"/>
	  	<input type="hidden" name="id" value=""/>
	  	
	  	<input type="hidden" name="task.calendar.id" value="${RequestParameters['task.calendar.id']?if_exists}"/>
	  	<input type="hidden" name="task.arrangeInfo.isArrangeComplete" value="${RequestParameters['task.arrangeInfo.isArrangeComplete']?if_exists}"/>
	    <tr bgcolor="#ffffff" onkeypress="DWRUtil.onReturn(event, query)">
	      	<td align="center" >
	        	<img src="images/action/search.gif" align="top" onClick="javascript:query()" alt="<@bean.message key="info.filterInResult" />"/>
	      	</td>
	      	<td><input style="width:100%" type="text" name="task.seqNo" maxlength="32" value="${RequestParameters['task.seqNo']?if_exists}"/></td>
	      	<td><input style="width:100%" type="text" name="task.course.code" maxlength="32" value="${RequestParameters['task.course.code']?if_exists}"/></td>
	      	<td><input style="width:100%" type="text" name="task.course.name" maxlength="20" value="${RequestParameters['task.course.name']?if_exists}"/></td>
	      	<td><input style="width:100%" type="text" name="task.teachClass.name" maxlength="20" value="${RequestParameters['task.teachClass.name']?if_exists}"/></td>
	      	<td><input style="width:100%" type="text" name="teacher.name" maxlength="20" value="${RequestParameters['teacher.name']?if_exists}"/></td>
	      	<td><input style="width:100%" type="text" name="task.courseType.name" maxlength="20" value="${RequestParameters['task.courseType.name']?if_exists}"/></td>
	      	<td><input style="width:100%" type="text" name="task.teachClass.planStdCount" maxlength="7" value="${RequestParameters['task.teachClass.planStdCount']?if_exists}"/></td>
	      	<td><input style="width:100%" type="text" name="task.taskGroup.name" maxlength="20" value="${RequestParameters['task.taskGroup.name']?if_exists}"/></td>
	    </tr>
            <input type="hidden" name="forwardPath" value="formInSuggest"/>
            <input type="hidden" name="params" value="${RequestParameters["params"]?if_exists}"/>
	    </form>
		<@table.thead>
			<@table.selectAllTd id="taskId"/>
			<@table.sortTd name="attr.taskNo" width="8%" id="task.seqNo"/>
			<@table.sortTd name="attr.courseNo" width="8%" id="task.course.code"/>
			<@table.sortTd name="attr.courseName" width="15%" id="task.course.name"/>
			<@table.sortTd name="entity.teachClass" width="20%" id="task.teachClass.name"/>
			<@table.td name="entity.teacher" width="10%"/>
			<@table.sortTd name="entity.courseType" width="10%" id="task.courseType.name"/>
			<@table.sortTd text="计划人数" width="5%" id="task.teachClass.planStdCount"/>
			<@table.sortTd name="attr.groupName" width="10%" id="task.taskGroup.name"/>
		</@>
		<#list tasks as task>
		  	<tr class="${(task_index % 2 == 1)?string("grayStyle", "brightStyle")}" align="center" onmouseover="displayPrompt('${task.id}');" onmouseout="toolTip();">
				<@table.selectTd id="taskId" value=task.id/>
				<script>taskMap["${task.id}"] = {"id":${task.id}, "seqNo":"${task.seqNo}", "arrangeInfo":{"teachDepart":{"id":${task.arrangeInfo.teachDepart.id}}}};</script>
		      	<td><#if task.arrangeInfo.isArrangeComplete == false>${task.seqNo?if_exists}<#else><A href="courseTable.do?method=taskTable&task.id=${task.id}">${task.seqNo?if_exists}</a></#if></td>
		      	<td><A href="javascript:courseInfo('id', ${task.course.id})">${task.course.code}</A></td>
		      	<td><A href="teachTaskCollege.do?method=info&task.id=${task.id}" title="<@bean.message key="info.task.info"/>"><@i18nName task.course/></a></td>
		      	<td title="${task.teachClass.name?html}">${task.teachClass.name?html}</td>
		      	<td id="teachers_${task.id}"><@getTeacherNames task.arrangeInfo.teachers/></td>
		      	<td><@i18nName task.courseType/></td>
		      	<td>${task.teachClass.planStdCount}</td>
		      	<td title="${(task.taskGroup.name)?if_exists?html}" nowrap><span style="display:block;width:100px;overflow:hidden;text-overflow:ellipsis;">${(task.taskGroup.name)?if_exists?html}</span></td>
	      	</tr>
	    </#list>
	    <#if thisPageSize?exists>
	    	<#include "/templates/newPageBar.ftl"/>
	    </#if>
	</@>
</div>
<#list 1..3 as i><br></#list>
<script>
	var bar = new ToolBar('taskListBar','<#if !RequestParameters['task.arrangeInfo.isArrangeComplete']?exists || RequestParameters['task.arrangeInfo.isArrangeComplete']=="0"><@bean.message key="common.notArranged" /><#else><@bean.message key="common.alreadyArranged" /></#if>课程列表',null,true,true);
	bar.setMessage('<@getMessage/>');
    <#if !RequestParameters['task.arrangeInfo.isArrangeComplete']?exists || RequestParameters['task.arrangeInfo.isArrangeComplete']=="0">
	bar.addItem("排课建议","editSuggestTime()");
	bar.addItem("<@bean.message key="action.manualArrange"/>",adjust);
	bar.addItem("修改任务","editTeachTask()",'update.gif');
    <#else>
	bar.addItem("<@bean.message key="action.export"/>","exportData()",'excel.png');
	bar.addItem("更换老师","changeTeacher()");
	bar.addItem("<@bean.message key="action.adjust"/>","adjust()");
	bar.addItem("平移教学周",shift);
	bar.addItem("<@bean.message key="action.delete"/>","removeArrangeResult()","delete.gif");
    </#if>
	
    document.getElementById('processDIV').style.display="none";
    document.getElementById('contentDIV').style.display="block";
    function displayPrompt(taskId){
        <#if !RequestParameters['task.arrangeInfo.isArrangeComplete']?exists || RequestParameters['task.arrangeInfo.isArrangeComplete']=="0">
        displaySuggestOfArrange(taskId);
        <#else>
        displayArrangeResult(taskId);
        </#if>
    }
    function editSuggestTime(){
      var taskId = getSelectId("taskId");
      if (isEmpty(taskId) || taskId.split(",").length > 1) {
          alert("请选择一个教学任务设置排课建议。");
          return;
      }
      if (isInvalidManual(taskMap[taskId].arrangeInfo.teachDepart.id)) {
          alert("本条记录的维护时间未开始或者已经结束了。");
          return;
      }
      window.open("ecuplManualArrange.do?method=editInSuggest&task.id=" + taskId + "&calendar.id=${RequestParameters['task.calendar.id']?if_exists}",'','scrollbars=auto,width=720,height=480,left=200,top=200,status=no');
    }
    
    var validDepartIds = ["${(validDepartIdSeq?replace(",", "\", \""))?if_exists}"];
    var isInvalidAll = ${(!isAdmin)?default(false)?string} || validDepartIds.length == 1 && validDepartIds[0] == "#";
    
    var form = document.taskListForm;
	function query(){
	    transferParams(parent.document.taskForm, form, null, false);
	    form.action="ecuplManualArrange.do?method=search";
	    form.submit();
	}
    
    function contains(sList, dObj) {
        try {
            for (var i = 0; i < sList.length; i++) {
                if (sList[i] == dObj) {
                    return true;
                }
            }
        } catch (e) {
            ;
        }
        return false;
    }
    
	function isInvalidManual(departmentId) {
        return isInvalidAll || !contains(validDepartIds, departmentId);
	}
	
	function courseInfo(selectId, courseId) {
	   if (null == courseId || "" == courseId || isMultiId(selectId) == true) {
	       alert("请选择一条要操作的记录。");
	       return;
	   }
	   form.action = "courseSearch.do?method=info";
	   form[selectId].value = courseId;
	   form.submit();
	}
	
	function changeTeacher(){
	   var taskId = getSelectId("taskId");
	   if (isEmpty(taskId) || taskId.split(",").length > 1) {
	       alert("请选择一条要操作的记录。");
           return;
	   }
	   if (isInvalidManual(taskMap[taskId].arrangeInfo.teachDepart.id)) {
	       alert("本条记录的维护时间未开始或者已经结束了。");
	       return;
	   }
	   setSearchParams();
       form.action="ecuplManualArrange.do?method=displayTeachers";
       form.target = "_self";
       addInput(form, "taskId", taskId, "hidden");
       form.submit();
	}
	function setSearchParams(){
	    var params = getInputParams(form,null,false);
        params += getInputParams(parent.document.taskForm,null,false);
        addInput(form,"params",params);
    }
    function adjust(){
        var taskId = getSelectId("taskId");
        if (isEmpty(taskId) || taskId.split(",").length > 1) {
            alert("请选择一条要操作的记录。");
            return;
        }
        if (isInvalidManual(taskMap[taskId].arrangeInfo.teachDepart.id)) {
            alert("本条记录的维护时间未开始或者已经结束了。");
            return;
        }
        setSearchParams();
        form.action="ecuplManualArrange.do?method=manualArrange&task.id="+taskId;
        form.submit();
    }
    
    function shift(){
        setSearchParams();
        form.action="ecuplManualArrange.do?method=shift";
        var offset = prompt("请输入平移量(正数为向后偏移，负数向前移动)","0");
        if(null!=offset){
        	if (confirm("如果平移教学周超出被设置的教学周范围，将删除被移出的教学周。\n"
        			  + "比如：假设当前被设置的教学周为1-17周时：\n"
        			  + "　　　此时若向前移5周，结果为1-12周；\n"
        			  + "　　　若向后移5周，结果为6-17周。\n\n"
        			  + "是否要继续？") == false) {
        		return;
        	}
        	var taskId = getSelectId("taskId");
            if (isEmpty(taskId) || taskId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            if (isInvalidManual(taskMap[taskId].arrangeInfo.teachDepart.id)) {
                alert("本条记录的维护时间未开始或者已经结束了。");
                return;
            }
          	addInput(form,"offset",offset);
          	form.target = "_self";
          	addInput(form, "taskId", taskId, "hidden");
            form.submit();
        }
    }
    function exportData(){
       setSearchParams();
       form.action="teachTaskCollege.do?method=exportSetting";
       form.submit();
    }
   function editTeachTask(){
       var taskId = getSelectId("taskId");
       if (isEmpty(taskId) || taskId.split(",").length > 1) {
           alert("请选择一条要操作的记录。");
           return;
       }
       if (isInvalidManual(taskMap[taskId].arrangeInfo.teachDepart.id)) {
           alert("本条记录的维护时间未开始或者已经结束了。");
           return;
       }
       window.open("ecuplManualArrange.do?method=editTeachTask&forward=actionResult&task.id=" + taskId);
   }
   
   function removeArrangeResult(){
       var taskIds = getSelectId("taskId");
       if (isEmpty(taskIds)) {
           alert("请选择教学任务。");
           return;
       }
       var taskId_s = taskIds.split(",");
       for (var i = 0; i < taskId_s.length; i++) {
           if (isInvalidManual(taskMap[taskId_s[i]].arrangeInfo.teachDepart.id)) {
               alert(autoWardString("所选记录中存在维护时间未开始或者已经结束了的教学任务，比如课程序号为 " + taskMap[taskId_s[i]].seqNo + " 的。", 50));
               return;
           }
       }
       if(confirm("删除教学任务的排课结果，信息不可恢复确认删除？")){
           document.taskListForm.action="ecuplManualArrange.do?method=removeArrangeResult&taskIds="+taskIds;
           setSearchParams(document.taskListForm,document.taskListForm);
           document.taskListForm["task.arrangeInfo.isArrangeComplete"].value = "";
           document.taskListForm.submit();
       }
   }
  </script>
</body>
<#include "/templates/foot.ftl"/>