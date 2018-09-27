<#include "/templates/head.ftl"/>
<body  LEFTMARGIN="0" TOPMARGIN="0">
<table id="courseTakeForTaskBar" ></table>
<#assign electable = RequestParameters['task.electInfo.isElectable']?if_exists/>
<#include "electableTaskList.ftl"/>
<#include "filterPrompt.ftl"/>
<form method="post" action="" name="taskFormOne" target="blank">
    <input type="hidden" name="taskIds" value=""/>
	<#list RequestParameters?keys as key>
	    <#if {"calendar.id":1}?keys?seq_contains(key)>
    <input type="hidden" name="${key}" value="${RequestParameters[key]}"/>
	    </#if>
	</#list>
	<#assign filterKeys = ["method"]/>
	<input type="hidden" name="params" value="<#list RequestParameters?keys as key>&${key}=${(RequestParameters[key]?html)?if_exists}</#list>"/>
</form>
<#--
<form method="post" action="" name="taskFormMore" target="blank">
    <input type="hidden" name="totalSize" value="${totalSize}"/>
<#list RequestParameters?keys as key>
    <#if !{"method":1, "pageNo":1, "pageSize":1}?keys?seq_contains(key)>
    <input type="hidden" name="${key}" value="${RequestParameters[key]}"/>
    </#if>
</#list>
</form>
-->
 <script>
   var bar = new ToolBar('courseTakeForTaskBar','<@bean.message key="entity.teachTask" /> <@bean.message key="common.list" />',null,true,true);
   bar.setMessage('<@getMessage/>');
   bar.addItem('选课筛选','filterTasks()');
   bar.addItem('修改人数', 'batchUpdateStdCountSetting()');
   var menu=bar.addMenu("学生名单","submitId(document.taskListForm,'taskId',false,'courseTakeForTask.do?method=teachClassStdList')",'list.gif');
   menu.addItem("班级人数分布","submitId(document.taskListForm,'taskId',true,'courseTakeForTask.do?method=adminClassStdCount')",'list.gif');
   menu.addItem("选课数据","submitId(document.taskListForm,'taskId',false,'courseTakeForTask.do?method=electRecordList')",'list.gif');
   menu.addItem("退课名单","submitId(document.taskListForm,'taskId',false,'courseTakeForTask.do?method=withdrawList')",'list.gif');
   menu.addItem('导出学生名单','exportStdList(document.taskListForm)');
   bar.addItem('排课调整',adjust);
   var menu = bar.addMenu("更换教室","changeClassroom()");
   menu.addItem("自动更换", "autoChangeRoom()");
   bar.addItem("<@bean.message key="action.assignStd" />","assignStds();",'update.gif');
   bar.addItem("任务操作", "taskOperation()", "update.gif", "对选择的任务进行操作。");
   
   <#--排课状态，结果是或者关系-->
    var arrangedMap=new Object();
    <#list tasks as task>
    arrangedMap["${task.id}"]=${task.arrangeInfo.isArrangeComplete?string("true", "false")};
    </#list>
    function isBeenArranged(isArranged) {
        if (isEmpty(isArranged)) {
            isArranged = false;
        }
        var taskIds = getSelectIds("taskId").split(",");
        var tmp = isArranged;
        for (var i = 0; i < taskIds.length; i++) {
            if (arrangedMap[taskIds[i]] == isArranged) {
                return tmp;
            }
        }
        return !tmp;
    }
   
    var form = document.taskListForm;
    function pageGoWithSize(pageNo,pageSize){
        transferParams(parent.document.taskForm,document.taskListForm,null,false);
   		document.taskListForm.action="courseTakeForTask.do?method=taskList";
   		goToPage(document.taskListForm,pageNo,pageSize);
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
    function assignStds(){
        form.action = "courseTakeForTask.do?method=assignStds";
        var taskIds = getSelectIds("taskId");
        if(""==taskIds){
          if(!confirm("没有选择一个或多个教学任务，系统将为查询条件内的所有任务指定学生。\n点击[确定]继续"))return;
           form.action+="&updateSelected=0";
           transferParams(parent.document.taskForm,form,null,false);
        }else{
           if(!confirm("要为选定的教学任务，按照班级指定学生?\n点击[确定]继续"))return;
           form.action+="&updateSelected=1&taskIds="+taskIds;
        }        
        if(confirm("对于已经指定的任务，是否删除学生名单是否重新指定?\n重新指定请点击[确定]，否则点击[取消]"))
           form.action+="&deleteExisted=1";
        else form.action+="&deleteExisted=0";
        form.submit();
   }
   function exportStdList(form){
         var Ids = getSelectIds("taskId");
         if(""==Ids){alert("请选择一个或多个教学任务");return;}
         form.action="teachTask.do?method=exportStdList";
         addInput(form,"teachTaskIds",Ids);
         addInput(form,"attrs","task.seqNo,task.course.code,task.course.name,std.code,std.name,std.enrollYear,std.department.name,firstMajor.name,firstAspect.name,courseTake.courseTakeType.name");
         addInput(form,"attrNames","<@msg.message key="attr.taskNo"/>,<@msg.message key="attr.courseNo"/>,<@msg.message key="attr.courseName"/>,<@msg.message key="attr.stdNo"/>,<@msg.message key="attr.personName"/>,入学年份,<@msg.message key="entity.department"/>,<@msg.message key="entity.speciality"/>,方向,修读类别");
         form.submit();
   }
   function filterTasks(){
      var taskIds = getSelectIds("taskId");
      if(""==taskIds){
        alert("请选择超过人数上线的教学任务,进行筛选!");return;
      }else{
         addInput(document.taskListForm,"taskIds",taskIds);
         displayPrompt();
      }
   }
   function setSearchParams(){
	    var params = getInputParams(form,null,false);
        params += getInputParams(parent.document.taskForm,null,false);
        addInput(form,"params",params);
   }
   function filter(){
      var selectId=document.getElementById("selectId").value;
      form.action="courseTakeForTask.do?method=filter";
      setSearchParams();
      addInput(document.taskListForm,"selectId",selectId);
      transferParams(parent.document.taskForm,document.taskListForm,null,false);
      form.submit();
   }
   
   	function batchUpdateStdCountSetting() {
   		var ids = getSelectIds("taskId");
   		if (ids == null || ids == "") {
   			alert("请选择要修改人数的教学任务。");
   			return;
   		}
   		form.action = "courseTakeForTask.do?method=batchUpdateStdCountSetting";
   		setSearchParams();
   		addInput(form, "taskIds", ids, "hidden");
   		form.submit();
   	}
   function adjust(){
        var taskId = getCheckBoxValue(document.getElementsByName("taskId"));
        if(taskId.indexOf(",")!=-1){alert("请选择一个进行调整");return;}
        if(taskId=="") {alert("<@bean.message key="prompt.task.selector" />");return;}
        window.open ("manualArrange.do?method=manualArrange&forward=actionResult&task.id=" + taskId ,'','height=400,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
    }
    
    function taskOperation() {
        var ids = getSelectIds("taskId");
        <#--对教学任务的操作-->
        if (ids == null || ids == "") {
            alert("请选择要操作的任务记录。");
            return;
        }
        if (confirm("要对所选择的记录进行操作吗？")) {
            document.taskFormOne.action = "courseTakeForTask.do?method=listWithTeachTask";
            document.taskFormOne["taskIds"].value = ids;
            document.taskFormOne.submit();
        }
    }
    
    <#--不能访问，参数默认为未排(即，使用范围，比如只能在未排课的情况下进行，则isArranged写false)-->
    function isAccess(isArranged) {
        if (isEmpty(isArranged)) {
            isArranged = false;
        }
        if (isArranged) {
            <#--只能对未排课的任务提出警告-->
            if (!isBeenArranged(!isArranged)) {
                alert("当前所选择任务（可能有部分）还没有进行排课。");
                return false;
            }
        } else {
            <#--只能对已排课的任务提出警告-->
            if (isBeenArranged(!isArranged)) {
                alert("只能对皆为未排课的任务进行操作。");
                return false;
            }
        }
        return true;
    }
    
    function changeClassroom() {
        <#--true：只能对已排课的任务操作-->
        if (isAccess(true)) {
            setSearchParams();
            form.action="manualArrange.do?method=displayClassrooms";
            submitId(form,"taskId",false);
        }
    }
    
    function autoChangeRoom() {
        <#--true：只能对已排课的任务操作-->
        if (isAccess(true)) {
            var taskIds = getSelectIds("taskId");
            if (null == taskIds || undefined == taskIds || "" == taskIds) {
                alert("请选择要操作的记录！");
                return;
            }
            if (taskIds.split(",").length > 300) {
                alert("当前系统最多支持300条教学任务。");
                return;
            }
            setSearchParams();
            form.action="courseTakeForTask.do?method=autoChangeRoomEdit";
            submitId(form,"taskId",true);
        }
    }
  </script>
</body> 
<#include "/templates/foot.ftl"/> 