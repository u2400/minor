<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="manualTable" width="100%"></table>
<script>
   var bar = new ToolBar("manualTable","手工排课（院系）",null,true,true);
   bar.setMessage('<@getMessage/>');
   bar.addItem("教室利用率","roomUtilizations()");
   m1=bar.addMenu("冲突检测...");
   m1.addItem("班级冲突检测","detectCollision('class')");
   m1.addItem("教师冲突检测","detectCollision('teacher')");
   m1.addItem("教室冲突检测","detectCollision('room')");
   m2=bar.addMenu("高级...");
   m2.addItem("排课课时核对", "willAndBeenArrange()");
   m2.addItem("调课变动记录", "arrangeAleration()");
   bar.addHelp("<@msg.message key="action.help"/>");
</script>
    <table class="frameTable_title">
        <tr>
        <form name="taskForm" method="post" target="contentFrame" action="ecuplManualArrange.do?method=index" onsubmit="return false;">
            <td class="infoTitle">是否排完</td>
            <td>
                <select name="task.arrangeInfo.isArrangeComplete" onChange="searchTask()" style="width:100px" value="${(RequestParameters["task.arrangeInfo.isArrangeComplete"])?default("0")}">
                    <#--华政增加“全部”-->
                    <option value="">全部</option>
                    <option value="0" selected><@bean.message key="common.notArranged"/></option>
                    <option value="1"><@bean.message key="common.alreadyArranged"/></option>
                </select>
            </td>
            <td>|</td>
            <input type="hidden" name="task.calendar.id" value="${calendar.id}"/>
            <input type="hidden" name="params" value=""/>
            <#include "/pages/course/calendar.ftl"/>
        </tr>
    </table>
  
  <table width="100%" class="frameTable" height="85%">
    <tr> 
     <td class="frameTable_view" style="width:20%">
     <#include "/pages/course/taskBasicSearchForm.ftl">
     </td>
     </form>
     <td valign="top" >
	     <iframe src="#"
	     id="contentFrame" name="contentFrame" 
	     marginwidth="0" marginheight="0" scrolling="no"
	     frameborder="0" height="100%" width="100%">
	     </iframe>
     </td>
    </tr>
  <table>
 <script>
   var form =document.taskForm;
   
   function courseArrange() {
		form.action = "courseArrangeSwitch.do?method=init";
		form.target = "_self";
		form.submit();
	}
	function arrangeAleration() {
		form.action = "ecuplManualArrange.do?method=arrangeAlterationIndex&forwardPath=arrangeAlterationIndex";
		form.target = "_self";
		form.submit();
	}
   
    
    function searchTask(){
        form.action="ecuplManualArrange.do?method=search";
        form.target = "contentFrame";
        //form["params"].value = "&task.calendar.id=${calendar.id}&task.arrangeInfo.isArrangeComplete=" + form["task.arrangeInfo.isArrangeComplete"].value;
        form["params"].value = "&task.calendar.id=${calendar.id}";
        form.submit();
    }
    
   function setRefreshTime(time){
       setTimeout("searchTask()",time);
   }
   function detectCollision(kind){
      form.action = "ecuplManualArrange.do?method=detectCollision&kind=" + kind;
      form.submit();
   }
   //默认查询50%以下的课程安排
   function roomUtilizations(){
      form.action = "ecuplManualArrange.do?method=roomUtilizations&ratio=0.5";
      form.submit();
   }
   function shiftCalendarWeek(){
      var offset = prompt("请输入平移量(正数为向后偏移，负数向前移动)","0");
      year=DWRUtil.getText("year");
      term=DWRUtil.getText("term");
      if(null!=offset){
    	if (confirm("平移教学周将移动选定学期("+year+"  "+term+")全部排课结果、排考结果\n"
    			  + "是否要继续？") == false) {
    		return;
    	}
    	form.target="_self";
        form.action="ecuplManualArrange.do?method=shiftCalendar&offset="+offset;
        form.submit();
     }
   }
   
   function willAndBeenArrange() {
    form.action = "ecuplManualArrange.do?method=willAndBeenArrange";
    form.submit();
   }
   searchTask();
 </script>
</body>
<#include "/templates/foot.ftl"/> 