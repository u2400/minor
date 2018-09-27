<#include "/templates/head.ftl"/>
<body >
  <table id="taskBar"></table>
  <script>
     var bar = new ToolBar('taskBar', '院系任务管理列表', null, true, false);
     bar.setMessage('<@getMessage/>');
     bar.addItem('<@msg.message key="course.suggestTime"/>', 'suggestTime()');
     bar.addItem('<@bean.message key="action.add"/>', 'addTeachTask()');
     menu = bar.addMenu('<@msg.message key="action.batchEdit"/>', 'batchEdit()');
     menu.addItem('<@msg.message key="task.arrangeInfo"/>', 'batchUpdateArrangeInfo()', "update.gif");
     menu.addItem('<@msg.message key="course.courseCredit"/>', 'batchUpdateCourseSetting()');
     menu.addItem('<@msg.message key="course.choiceRequirement"/>', 'batchUpdateElectInfoSetting()', "update.gif");
     menu.addItem('<@msg.message key="course.courseRequirement"/>', 'batchUpdateRequirement()', "update.gif");
    
     menu1 = bar.addMenu('<@msg.message key="attr.option"/>',null);
     menu1.addItem('<@bean.message key="action.split"/>','splitTeachTask()');
     menu1.addItem('<@bean.message key="action.merge"/>','mergeTeachTask()');
         
         
         
          <#--此功能为华政所使用-->
     menu1.addItem("挂牌分组","buildGroupSetting()");
     menu1.addItem('<@bean.message key="action.export"/>','exportTeachPlanPrompt()');
     menu1.addItem('<@msg.message key="course.exportStdList"/>','exportStdList()');
     menu1.addItem('<@msg.message key="course.defaultExport"/>','exportDefault()');
     menu1.addItem('<@msg.message key="course.copy"/>','copySetting()');
     menu1.addItem('<@msg.message key="adminClass.planStdsRecount"/>','calcPlanStdCountByAdminClass()',"action.gif","<@msg.message key="teachPlan.recount.explain"/>");
     menu1.addItem("任务申报表","declarationForm()");
     menu1.addItem("任务申报表导出","exportDeclarationForm()");
     menu2 = bar.addMenu('<@msg.message key="action.print"/>..',"printAction('printTaskList')",'print.gif');
     menu2.addItem("<@msg.message key="adminClass.rollBook"/>","printAction('printStdListForDuty')",'print.gif');
     menu2.addItem("<@msg.message key="adminClass.stdNamesList"/>","printAction('printStdList')",'print.gif');
     menu2.addItem("<@msg.message key="adminClass.regScoreList"/>","printAction('printStdListForGrade')",'print.gif');
     menu2.addItem("<@msg.message key="teachTask.taskBook"/>","printAction('taskTemplate')",'print.gif');
     menu2.addItem("汇总表","printTaskSummary()",'print.gif');
     bar.addItem('<@bean.message key="action.modify"/>', 'editTeachTask()');
     bar.addItem('<@bean.message key="action.delete"/>', 'removeTeachTask()');
</script>
  <#include "/pages/course/task/teachTaskList.ftl"/>
  <form name="actionForm" method="post" action="" onsubmit="return false;">
     <input type="hidden" name="task.calendar.id" value="${RequestParameters["task.calendar.id"]}"/>
     <input type="hidden" name="calendar.id" value="${RequestParameters["task.calendar.id"]}"/>
     <input type="hidden" name="calendarId" value="${RequestParameters["task.calendar.id"]}"/>
     <input type="hidden" name="params" value="<#list RequestParameters?keys as key>&${key}=${RequestParameters[key]}</#list>"/>
     <input type="hidden" name="orderBy" value=""/>
  </form>
  <form name="taskDeclarationForm" method="post" action="" onsubmit="return false;">
    <#list RequestParameters?keys as key>
      <input type="hidden" name="${key}" value="${RequestParameters[key]}" />
    </#list>
  </form>
  <script>
    var form = document.actionForm;
    
    <#--还原参数-->
    function resetParameters() {
        if (null != form["taskIds"]) {
            form["taskIds"].value = "";
        }
        form["orderBy"].value = "";
    }
    
    resetParameters();

	function checkConfirm(id){
	    var elem = document.getElementById(id);
	    return elem.value!=0;
	}
	function copySetting(){
       setSearchParams();
       submitId(form,"taskId",true,"?method=copySetting","是否拷贝选定的所有任务?");
     }
	function query(pageNo,pageSize,orderBy){
	    var form = document.taskListForm;
	    form.action="?method=search";
	    form.target = "_self";
	    transferParams(parent.document.taskForm,form,null,false);
	    goToPage(form,pageNo,pageSize,orderBy);
	}
	function setSearchParams(){
	    document.actionForm.params.value = queryStr;
	    form.target = "_self";
	}
    
    function printTaskSummary() {
    	form.action = "teachTaskCollege.do?method=printTaskSummary";
    	setSearchParams();
    	form.target = "_blank";
    	form.submit();
    }
    function exportTeachPlanPrompt(){
       setSearchParams();
       form.action="teachTaskCollege.do?method=exportSetting";
       form.submit();
    }
	function checkConfirmIdSeq(idSeq){
	   var idArray = idSeq.split(",");
       for(var i=0;i<idArray.length;i++){
          if(checkConfirm(idArray[i])) {alert("选择的教学任务中包含已经确认的，请选择未确认的任务");return false;}
       }
       return true;
	}
    
    function mergeTeachTask(){
       var ids = getSelectIds("taskId");
       if (!isMultiId(ids)) {
        alert("<@bean.message key="common.MultiSelectPlease"/>");
        return;
       }
       var IdS = new String(ids);
       if (!checkConfirmIdSeq(ids)) {
        return;
       }
       
       var taskIds = ids.split(",");
       for (var i = 1; i < taskIds.length; i++) {
        if ($("course_" + taskIds[0]).innerHTML.trim() != $("course_" + taskIds[i]).innerHTML.trim()) {
            alert("不能合并不同课程代码的课程。");
            return;
        }
       }
       
       form.action="teachTaskCollege.do?method=mergeSetting";
       setSearchParams();
       addInput(form,"taskIds",ids);
       form.submit();
    }
    function suggestTime(){
      var id = getSelectIds("taskId");
      if(id=="") {alert("<@bean.message key="prompt.task.selector" />");return;}
      if(isMultiId(id)) {alert("<@bean.message key="common.singleSelectPlease" />。");return;}
      if(checkConfirm(id)) {alert("<@bean.message key="error.task.modifyUnderConfirm"/>");return;}
      window.open("arrangeSuggest.do?method=edit&task.id="+id,'','resizable=1,scrollbars=auto,width=720,height=480,left=200,top=200,status=no');      
    }
    function splitTeachTask(){
       id = getSelectIds("taskId");
       if(id=="") {alert("<@bean.message key="prompt.task.selector" />");return;}
       if(isMultiId(id)) {alert("<@bean.message key="common.singleSelectPlease" />。");return;}
       if(checkConfirm(id)) {alert("<@bean.message key="error.task.modifyUnderConfirm"/>");return;}
       var count = prompt("<@bean.message key="prompt.task.splitNum"/>","3");
       while(count!=null){
          if(!/^\d+$/.test(count)){
            alert("请输入整数(>2)");
            count = prompt("<@bean.message key="prompt.task.splitNum"/>","3");
          }
          else break;
       }
       if(null==count)return;
       form.action = "teachTaskCollege.do?method=splitSetting&task.id=" + id + "&splitNum=" + count;
       setSearchParams();
       form.submit();
    }
     function printAction(method){
         var Ids = getSelectIds("taskId");
         if(""==Ids){alert("请选择一个或多个教学任务");return;}
         window.open("teachTaskCollege.do?teachTaskIds="+Ids+"&method="+method);
     }
     function exportStdList(){
         var Ids = getSelectIds("taskId");
         if(""==Ids){alert("请选择一个或多个教学任务");return;}
         form.action="teachTaskCollege.do?method=exportStdList";
         addInput(form,"teachTaskIds",Ids);
         addInput(form,"attrs","task.seqNo,task.course.code,task.course.name,std.code,std.name,std.enrollYear,std.department.name,firstMajor.name,firstAspect.name,courseTake.courseTakeType.name");
         addInput(form,"attrNames","<@msg.message key="attr.taskNo"/>,<@msg.message key="attr.courseNo"/>,<@msg.message key="attr.courseName"/>,<@msg.message key="attr.stdNo"/>,<@msg.message key="attr.personName"/>,入学年份,<@msg.message key="entity.department"/>,<@msg.message key="entity.speciality"/>,方向,修读类别");
         form.submit();
     }
     
    function batchEdit(){
      var ids = getSelectIds("taskId");
      if(ids=="") {alert("<@bean.message key="prompt.task.selector" />");return;}
      var idArray = ids.split(",");
      for(var i=0;i<idArray.length;i++){
          if(checkConfirm(idArray[i])) {alert("选择的教学任务中包含已经确认的，请选择未确认的任务");return;}
      }
      window.open("?method=batchEdit&taskIds="+ids+"&orderBy="+orderByStr);
    }
     function exportDefault(){
        resetParameters()
        var taskIds = getSelectIds("taskId");
        var confirmCaption = "是否导出查询出的所有任务?";
        if (null != taskIds && "" != taskIds) {
            confirmCaption = "是否导出下面选中的" + taskIds.split(",").length + "条教学任务。 ";
            addInput(form, "taskIds", taskIds, "hidden");
        }
        if(confirm(confirmCaption)){
            form.action="teachTaskCollege.do?method=export"+queryStr;
            addInput(form,"keys",'seqNo,course.code,course.name,courseType.name,teachClass.name,arrangeInfo.teacherCodes,arrangeInfo.teachers,arrangeInfo.teachers.department.name,arrangeInfo.activities.time,arrangeInfo.activities.room,requirement.roomConfigType.name,requirement.teachLangType.name,requirement.isGuaPai,electInfo.maxStdCount,arrangeInfo.activities.room.capacityOfCourse,teachClass.stdCount,arrangeInfo.weeks,arrangeInfo.weekUnits,arrangeInfo.activities.weeks,arrangeInfo.courseUnits,arrangeInfo.overallUnits,course.credits');
            addInput(form,'titles','课程序号,课程代码,课程名称,课程性质,面向班级,教师职工号,授课教师,教师所在院系,上课时间,上课地点,教室设备配置,<@msg.message key="attr.teachLangType"/>,是否挂牌,人数上限,可容纳人数,实选人数,周数,周课时,上课周状态,节次,总课时,学分');
            form["orderBy"].value = "${RequestParameters["orderBy"]?if_exists}";
            form.submit();
        }
     }
     function calcPlanStdCountByAdminClass(){
       setSearchParams();
       var taskIds = getSelectIds("taskId");
       if (null == taskIds || "" == taskIds) {
        alert("请选择要操作的记录。");
        return;
       }
       var inputNum = prompt("任务的计划人数统计方式，请输入：\n1.行政班计划人数\n2.行政班实际人数\n3.取消(可以按任意键)");
       if (null == inputNum || "" == inputNum) {
        inputNum = "3";
        return;
       }
       if(inputNum == "1" || inputNum == "2"){
        form.action = "?method=calcPlanStdCountByAdminClass";
        addInput(form, "taskIds", taskIds, "hidden");
        addInput(form, "inputNum", inputNum, "hidden");
        form.submit();
       }
    }
    function editTeachTask(){
       id = getSelectIds("taskId");
       if(id=="") {alert("<@bean.message key="prompt.task.selector"/>");return;}
       if(isMultiId(id)) {alert("<@bean.message key="common.singleSelectPlease"/>。");return;}
       if(checkConfirm(id)) {alert("<@bean.message key="error.task.modifyUnderConfirm"/>");return;}
       form.action = "teachTaskCollege.do?method=edit&task.id=" + id;
       setSearchParams();
       form.submit();
    }
    function addTeachTask(){
       form.action = "?method=selectCourse&calendar.studentType.id=" + parent.document.taskForm['calendar.studentType.id'].value;
       setSearchParams();
       form.submit();
    }
     function declarationForm() {
        var form = document.taskDeclarationForm;
     	form.action = "teachTaskCollege.do?method=declarationForm";
     	var perPageRows = prompt("请指定每页显示的行数，默认为  10 行）。", "10");
     	if (perPageRows == null || perPageRows == "" || !/^\d+$/.test(perPageRows)) {
     		perPageRows = 10;
     	}
     	addInput(form, "perPageRows", perPageRows, "hidden");
     	//默认排序规则：课程类别的是否必修，是否挂牌、课程代码、教学班名称
     	var orderBy = "task.courseType.isCompulsory,task.requirement.isGuaPai,task.course.code,task.teachClass.name";
     	addInput(form, "orderBy", orderBy, "hidden");
     	form.target = "_blank";
     	form.submit();
     }
     function exportDeclarationForm() {
        var form = document.taskDeclarationForm;
     	form.action = "teachTaskCollege.do?method=exportDeclarationForm";
     	addInput(form, "template", "taskDeclarationForm.xls", "hidden");
     	addInput(form, "fileName", "任务申报表", "hidden");
     	form.submit();
     }
    
    function buildGroupSetting() {
        form.target = "_blank";
        submitId(form, "taskId", true, "taskGroup.do?method=buildGroupSetting");
    }
    function taskConfirm(scope,isConfirm){
        if(scope=="selected"){
           var taskIds = getSelectIds("taskId");
           if (taskIds=="") {
             alert("<@bean.message key="common.selectPlease" />");
             return;
           }
           if(!confirm(isConfirm == "1" ? "<@bean.message key="prompt.task.confirmSelected"/>" : "<@bean.message key="prompt.task.unconfirmSelected"/>")) {
                return;
           }
           form.action="teachTaskCollege.do?method=confirm";
           addInput(form, "taskIds", taskIds, "hidden");
           addInput(form, "isConfirm", isConfirm, "hidden");
           form.submit();
       }
    }
    
    function removeTeachTask(){
       ids = getSelectIds("taskId");
       if(ids=="") {alert("<@bean.message key="prompt.task.selector" />");return;}
       if(!checkConfirmIdSeq(ids)) return;
       if(confirm("将要删除选定的:"+countId(ids)+"个任务\n<@bean.message key="prompt.task.delete"/>")!=true)return;
       form.action="?method=remove&taskIds=" + ids;
       setSearchParams();
       form.submit();
    }
     function batchUpdateArrangeInfo(){
       setSearchParams();
       submitId(form,"taskId",true,"?method=arrangeInfoSetting","是否批量设置选定任务的安排信息?");
     }
       //页面转向：更新任务的课程和学分
     function batchUpdateCourseSetting() {
        var ids = getSelectIds("taskId");
        if (ids == null || ids == "") {
            alert("<@bean.message key="prompt.task.selector" />");
            return;
        }
        if (confirm("是否要更改课程学分？")) {
	        setSearchParams();
	        form.action="?method=batchUpdateCourseSetting";
	        addInput(form, "taskIds", ids, "hidden");
	        form.submit();
        }
     }
     //批量更改选课要求
	function batchUpdateElectInfoSetting() {
     	var ids = getSelectIds("taskId");
     	if (ids == null || ids == "") {
     		alert("请选择要操作的课程。");
     		return;
     	}
     	form.action = "?method=batchUpdateElectInfoSetting";
     	form.target = "";
     	addInput(form, "taskIds", ids, "hidden");
     	setSearchParams();
     	form.submit();
    }
     //批量更改课程要求
	function batchUpdateRequirement() {
     	var ids = getSelectIds("taskId");
     	if (ids == null || ids == "") {
     		alert("请选择要操作的课程。");
     		return;
     	}
     	form.action ="?method=batchUpdateRequirementSetting";
     	addInput(form, "taskIds", ids, "hidden");
     	setSearchParams();
     	form.submit();
    }
  </script>
</body> 
<#include "/templates/foot.ftl"/> 