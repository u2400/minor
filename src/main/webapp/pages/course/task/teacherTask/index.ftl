<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="taskListBar" width="100%"> </table>
   <table class="frameTable_title" width="100%" border="0">
    <form name="calendarForm" action="teacherTask.do?method=index" method="post" onsubmit="return false;">
    <input type="hidden" name="pageNo" value="1" /> 
     <tr  style="font-size: 10pt;" align="left">
     <td width="30%"><@bean.message key="entity.studentType" />&nbsp;<@bean.message key="attr.yearAndTerm"/></td>
        <#include "/pages/course/calendar.ftl"/>
    </form>
        </tr>
    </table>
    <#include "taskList.ftl"/>
    <form method="post" action="" name="actionForm">
        <input type="hidden" name="task.id" value=""/>
        <input type="hidden" name="returnPath" value="teacherTask"/>
        <input type="hidden" name="returnMothed" value="index"/>
    </form>
    <script>
	   	var bar = new ToolBar("taskListBar", "<@bean.message key="task.list" />", null, true, true);
	   	bar.setMessage('<@getMessage/>');
	   	bar.addItem("<@msg.message key="task.studentList" />", "doAction('stdList')", "list.gif");
	   	bar.addItem("<@msg.message key="task.attendanceSheet" />", "printStdListForDuty()", 'print.gif');
	   	bar.addItem("<@msg.message key="action.info" />", "taskInfo()");
	   	var menu = bar.addMenu("指定教材", "editBook()", "update.gif");
	   	menu.addItem("查看指定", "bookInfo()");
	   	bar.addItem("指定进度", "teachingSchedule()", "update.gif")
	   	
      	var form = document.actionForm;
      	function doAction(method) {
         	var id = getRadioValue(document.getElementsByName("taskId"));
         	if ("" == id) {
         		alert("<@msg.message key="action.selectOneObject"/>");
         		return;
         	}
         	form.action = "teacherTask.do?method=" + method;
         	form.target = "_self";
         	addInput(form, "teachTask.id", id, "hidden");
         	form.submit();
      	}
      	
      	function printStdListForDuty() {
         	var id = getRadioValue(document.getElementsByName("taskId"));
         	if ("" == id) {
         		alert("<@msg.message key="action.selectOneObject"/>");
         		return;
         	}
         	form.action = "teacherTask.do?method=printDutyStdList";
         	form.target = "_blank";
         	addInput(form, "teachTaskIds", id, "hidden");
         	form.submit();
     	}
     	
     	function taskInfo(id) {
            var taskId = (null == id || "" == id) ? getSelectId("taskId") : id;
            if (null == taskId || "" == taskId || isMultiId(taskId)) {
                alert("请选择一条要操作的记录。");
                return;
            }
            form.action = "teachTaskSearch.do?method=info&task.id=" + taskId;
            form.submit();
     	}
     	
     	function editBook() {
            var taskId = getRadioValue(document.getElementsByName("taskId"));
            if (null == taskId || undefined == taskId || "" == taskId) {
                alert("请选择一条要操作的记录。");
                return;
            }
            form['task.id'].value=taskId;
            form.action = "teacherTask.do?method=edit";
            form.submit();
         }
     	
     	function bookInfo(pTaskId) {
            var taskId = pTaskId;
            if (null == taskId || undefined == taskId || "" == taskId) {
                taskId = getRadioValue(document.getElementsByName("taskId"));
                if (null == taskId || undefined == taskId || "" == taskId) {
                    alert("请选择一条要操作的记录。");
                    return;
                }
            }
            form['task.id'].value=taskId;
            form.action = "teacherTask.do?method=bookInfo";
            form.submit();
         }
         
         function teachingSchedule() {
            var taskId = getRadioValue(document.getElementsByName("taskId"));
            if (null == taskId || undefined == taskId || "" == taskId) {
                alert("请选择一条要操作的记录。");
                return;
            }
            form['task.id'].value=taskId;
            form.action = "teachingSchedule.do?method=edit";
            form.submit();
         }
    </script>
</body>
<#include "/templates/foot.ftl"/>