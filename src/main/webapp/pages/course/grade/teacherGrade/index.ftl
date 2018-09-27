<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="taskListBar" width="100%"> </table>
  <script language="JavaScript" type="text/JavaScript" src="scripts/course/grade/gradeSeg.js"></script>
  <script language="JavaScript" type="text/JavaScript" src="scripts/course/grade/grade.js"></script>
<script>
    function inputGrade(taskId){
     window.open("teacherGrade.do?method=editGradeState&taskId="+taskId);
    }
   var bar = new ToolBar("taskListBar","<@msg.message key="info.courseList"/>",null,true,true);
   bar.setMessage('<@getMessage/>');
   //bar.addItem("<@msg.message key="grade.adjustGradePercent"/>","editGradeState()","update.gif");
   bar.addItem("试卷分析表下载","analysisReport()","download.gif");
   bar.addItem("<@msg.message key="grade.viewGrades"/>","info(document.calendarForm)");
   bar.addItem("打印登分册","printEmptyGradeTable()");
   bar.addItem("<@msg.message key="action.print"/>","printTeachClassGrade()");
   var menuBar = bar.addMenu("<@msg.message key="grade.statReport"/>","stat('stat', 'task')","list.gif");
   menuBar.addItem("课程分段统计","stat('stat', 'course')","list.gif");
   //bar.addItem("<@msg.message key="grade.analysisReport"/>","stat('reportForExam')","print.gif");
   //var menu = bar.addMenu("<@msg.message key="action.delete"/>...",null,"delete.gif");
   //menu.addItem("<@msg.message key="grade.deleteFinal"/>","removeGrade(${GAGrade.id},'<@msg.message key="grade.deleteFinalConfirm"/>')","delete.gif");
   <#list gradeTypes as gradeType>
   //menu.addItem("<@msg.message key="action.delete"/> <@i18nName gradeType/>","removeGrade(${gradeType.id},'确认删除成绩?')","delete.gif");
   </#list>
   bar.addItem("<@msg.message key="action.refresh"/>","refresh()");
   action="teacherGrade.do";
   /**
    * 找到老师已经录入期末两次的教学任务id串
    */
   function getPrintableTaskIds(){
      var taskIdSeq = getSelectIds("taskId");
      if(""==taskIdSeq){
          alert("<@msg.message key="action.selectOneObject"/>");
          return "";
      }
      var taskIds = taskIdSeq.split(",");
      for(var i=0;i<taskIds.length;i++){
        if(!printableTaskId[taskIds[i]]){
           alert("你选的任务里，还有没有完全录完的成绩，请选择别的任务或者录入这些成绩。")
           return "";
        }
      }
      return taskIds;
   }
   	var printableTaskId=new Object();
	<#list tasks as task>
	   printableTaskId['${task.id}']=${(task.gradeState.isConfirmed(GAGrade))?default(false)?string};
	</#list>
	
     printTeachClassGrade =function(taskId){
	    var form = document.calendarForm;
	    form.action="teacherGrade.do?method=report";
	    form.target='_blank';
	    var taskIds ="";
	    if(null==taskId){
	       taskIds =getPrintableTaskIds();
	    }else{
	       taskIds=taskId;
	    }
	    if(""!=taskIds){
	       form.action+='&taskIds='+taskIds;
	       form.submit();
	    }
	}
	 printEmptyGradeTable =function(taskId){
	    var form = document.calendarForm;
	    form.action="teacherGrade.do?method=printEmptyGradeTable";
	    form.target='_blank';
	    var taskIds ="";
	    if(null==taskId){
	       taskIds = getSelectIds("taskId")
	    }else{
	       taskIds=taskId;
	    }
	    if(""!=taskIds){
	       form.action+='&teachTaskIds='+taskIds;
	       form.submit();
	    }else{
	       alert("请选择课程.");
	    }
	}
	
   function stat(method, kind){
      var form =document.calendarForm;
      form.target='_blank';
      var taskIds=getPrintableTaskIds();
      if(""==taskIds)return;
      
      for(var i=0;i<seg.length;i++){
         var segAttr="segStat.scoreSegments["+i+"]";
         addInput(form,segAttr+".min",seg[i].min);
         addInput(form,segAttr+".max",seg[i].max);
      }
      form.action="teacherGrade.do?method="+method+"&taskIds="+taskIds+"&kind="+kind;
      form.submit();
    }
    function refresh(){
      changeCalendar(document.calendarForm);
    }
    function removeGrade(gradeTypeId,tip){
       var form =document.calendarForm;
       form.target="_self";
       submitId(form,"taskId",false,"teacherGrade.do?method=removeGrade&gradeTypeId="+gradeTypeId,tip);
    }
    function editGradeState(){
       var form =document.calendarForm;
       form.target="_blank";
       submitId(form,"taskId",false,"teacherGrade.do?method=editGradeState");
    }
    function analysisReport(){
       self.location="download.do?method=download&document.id=3882";
    }
    </script>
   <table class="frameTable_title" width="100%" border="0">
    <form name="calendarForm" action="teacherGrade.do?method=index" method="post" onsubmit="return false;">
    <input type="hidden" name="pageNo" value="1"/>
     <tr  style="font-size: 10pt;" align="left">
     <td width="30%"><@bean.message key="attr.yearAndTerm"/></td>
        <#include "/pages/course/calendar.ftl"/>
     </form>
     </tr>
    </table>
    <#include "taskList.ftl"/>
    <pre>
     操作提示:
        1)录入成绩,直接点击每个任务最后的录入链接. 如您只需要登录平时成绩 请只点击<font color="red">“保存”</font> 到学期末的时候再录入<font color="blue">“期末成绩”</font>。
           点击<font color="red">“提交”</font>后成绩将不能修改 也不能再继续录入
        2)按照学籍管理规定，选修课（包括公选课、通识类选修课、专业限选课）只需录入期末考查成绩，且一律以中文五级制记分。
    </pre>
 </body>
<#include "/templates/foot.ftl"/>