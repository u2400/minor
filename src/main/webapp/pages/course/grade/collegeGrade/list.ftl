<#include "/templates/head.ftl"/>
<body >
 <table id="taskBar"></table>
 <#include "../taskListTable.ftl"/>
  <form name="actionForm" method="post" action="" onsubmit="return false;">
     <input type="hidden" name="calendar.id" value="${RequestParameters['calendar.id']}"/>
     <input type="hidden" name="gradeState.confirmGA" value="${RequestParameters['gradeState.confirmGA']}"/>
     <input type="hidden" name="params" value=""/>
  </form>
  <script language="JavaScript" type="text/JavaScript" src="scripts/course/grade/gradeSeg.js"></script>
  <script language="JavaScript" type="text/JavaScript" src="scripts/course/grade/grade.js"></script>
  <script> 
  	 var action="${action}";
     var bar=new ToolBar('taskBar','<@bean.message key="entity.teachTask"/> <@bean.message key="entity.list"/>',null,true,true);
     bar.setMessage('<@getMessage/>');
     bar.addItem('成绩状态','gradeStateInfo(document.actionForm)');
     bar.addItem('查看成绩','info(document.actionForm)');
     <#if RequestParameters['gradeState.confirmGA'] == "1">
     var menu1 = bar.addMenu("<@msg.message key="action.print"/>...",null,"print.gif");
     menu1.addItem("教学班成绩","printTeachClassGrade(document.actionForm)",'print.gif');
     menu1.addItem('任务分段统计',"printStatReport(document.actionForm,'task')");
     menu1.addItem('课程分段统计',"printStatReport(document.actionForm,'course')");
     menu1.addItem('试卷分析',"printExamReport(document.actionForm)");    
     var menu2 = bar.addMenu("调整百分比","editGradeState()",'update.gif');
     <#else>
     var menu2 = bar.addMenu("录入成绩","inputGrade()",'new.gif');
     </#if>
     menu2.addItem("批量百分比设置", "editBatchPercent()", "update.gif");
     var menu3 = bar.addMenu("删除成绩...",null,"delete.gif");
     <#list gradeTypes?sort_by("priority") as gradeType>
     menu3.addItem("删除<@i18nName gradeType/>","removeGrade(${gradeType.id})","delete.gif");
     </#list>
    function pageGoWithSize(pageNo,pageSize){
        parent.searchTask(pageNo,pageSize,'${RequestParameters['orderBy']?default("null")}');
    }
    orderBy = function(what){
        parent.searchTask(1,${pageSize},what);
    }
    
    function editBatchPercent() {
        submitId(document.actionForm, "taskId", true, "collegeGrade.do?method=editBatchPercent", "要设置教学任务中可能有成绩，要进入批量修改吗？");
    }
  </script>
</body> 
<#include "/templates/foot.ftl"/> 