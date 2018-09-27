<#include "/templates/simpleHead.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/course/TaskActivity.js"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/prompt.js"></script>
<style  type="text/css">
<!--
.trans_msg
    {
    filter:alpha(opacity=100,enabled=1) revealTrans(duration=.2,transition=1) blendtrans(duration=.2);
    }
-->
</style>
<body>
<table id="electCourseBar"></table>
<div id="toolTipLayer" style="position:absolute; visibility: hidden"></div>
<#assign  electParams = electState.params/>
<script>initToolTips()</script>
  <table class="frameTable_title">
     <tr class="toolBar">
      <td id="viewTD0" class="transfer" style="width:60px" onclick="javascript:changeView(this);changeToView('courseTableDIV')" onmouseover="viewMouseOver(event)" onmouseout="viewMouseOut(event)">
        <font color="blue"><@msg.message key="course.myCurriculums"/></font>
      </td>
      <td id="viewTD2" class="padding" style="width:80px" onclick="javascript:changeView(this);changeToView('teachClassDIV')" onmouseover="viewMouseOver(event)" onmouseout="viewMouseOut(event)">
        <font color="blue">班级建议课表</font>
      </td>
      <td id="viewTD1" class="padding" style="width:60px" onclick="javascript:changeView(this);changeToView('courseListDIV')" onmouseover="viewMouseOver(event)" onmouseout="viewMouseOut(event)">
      	  <font color="blue">选课列表</font>
      </td>
      <td>|</td>
      <td style="font-size:12px"><@msg.message key="attr.stdNo"/>:${electState.std.stdNo} <@msg.message key="attr.year2year"/>:${electParams.calendar.year}&nbsp;<@msg.message key="attr.term"/>${electParams.calendar.term}&nbsp;
         <@msg.message key="course.chooseCredit"/>:<input id="electedCredit" readonly style="border:0 solid #000000;width:25px;background-color :#E1ECFF" value="${electState.electedCredit}">
        <@bean.message key="attr.maxCredit"/>：<input id="maxCredit" readonly style="border:0 solid #000000;width:25px;background-color :#E1ECFF" value="${electState.maxCredit}">
        <#if electState.awardedCredit?exists>
        <@bean.message key="attr.awardCredit"/>：<input id="awardedCredit" readonly style="border:0 solid #000000;width:25px;background-color :#E1ECFF" value="${electState.awardedCredit}"></td>
        </#if>
       <td id="message"></td>
      </tr>
  </table>
  <table class="frameTable" id="contentTable">
     <tr>
      <td valign="top">
	    <div id="courseTableDIV" style="display:block">
	       <#include "courseTable.ftl"/>
	    </div>
	    <div id="courseListDIV" style="display:none">
	         <iframe  src="#" 
	        id="courseListFrame" name="courseListFrame" marginwidth="0" marginheight="0"
	        scrolling="no"	 frameborder="0" height="100%" width="100%"></iframe>
	    </div>
        <div id="teachClassDIV" style="display:none">
           <iframe src="#" 
            id="taskListOfClassFrame" name="taskListOfClassFrame" marginwidth="0" marginheight="0"
            scrolling="no" frameborder="0" height="100%" width="100%"></iframe>
        </div>
      </td>
     </tr>
    </table>
    <form name="taskListOfClassForm" method="post" action="electCourse.do?method=taskListOfClass" target="taskListOfClassFrame" onsubmit="return false;">
        <input type="hidden" name="setting.kind" value="class"/>
        <input type="hidden" name="setting.forCalendar" value="0"/>
        <input type="hidden" name="calendarId" value="${electParams.calendar.id}"/>
        <input type="hidden" name="ids" value="${electState.std.adminClassIds?first}"/>
        <input type="hidden" name="ignoreHead" value="1"/>
    </form>
    <form name="searchTaskFrom" method="post" action="quickElectCourse.do?method=taskList" target="courseListFrame" onsubmit="return false;">
      <input type="hidden" name="task.seqNo" value=""/>
      <input type="hidden" name="task.course.code" value=""/>
      <input type="hidden" name="task.course.name" value=""/>
      <input type="hidden" name="task.courseType.name" value=""/>
      <input type="hidden" name="task.arrangeInfo.teachDepart.name" value=""/>
      <input type="hidden" name="teacher.name" value=""/>
      <input type="hidden" name="timeUnit.weekId" value=""/>
      <input type="hidden" name="timeUnit.startUnit" value=""/>
      <input type="hidden" name="weekName" value=""/>
      <input type="hidden" name="unitName" value=""/>
      <input type="hidden" name="calendar.id" value="${electParams.calendar.id}"/>
    </form>
     <div id="electStateDIV" style="display:none;width:550px;height:180px;position:absolute;top:22px;right:0px;border:solid;border-width:1px;">
     <#include "electState.ftl"/>
     </div>
     <div id="electResultDIV" style="display:none;width:450px;height:180px;position:absolute;top:250px;left:200px;border:solid;border-width:1px; ">
     <iframe src="#" id="electResultFrame" name="electResultFrame" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0"  height="100%" width="100%"></iframe>
     </div>
  <script>
   var bar = new ToolBar('electCourseBar','<@bean.message key="info.elect.stdHome"/>',null,true,true);
   bar.setMessage('');
   bar.addItem("<@msg.message key="adminClass.courseQuery"/>",'searchClassTable()','list.gif');
   bar.addItem("<@msg.message key="system.state"/>","displayElectState(true)",'info.gif',"<@msg.message key="common.lookAndCloseSystemState"/>");
   bar.addHelp("<@msg.message key="action.help"/>","course.election.electCourse/index");
   
    var year =${electState.params.calendar.startYear};
    var weekStart =${electState.params.calendar.weekStart};
    var weeks=${electState.params.calendar.weeks};
    // 选课状态
    function ElectState(){
       this.maxCreditLimited = ${electState.maxCredit};
       <#if electState.params.isCheckEvaluation>
       this.isEvaluated=${electState.isEvaluated?if_exists?string};
       <#else>
       this.isEvaluated=true;
       </#if>
       this.constraint=new Object();
       this.constraint.electedCredit =${electState.electedCredit};
       
       this.params=new Object();
       this.params.isCheckEvaluation=${electState.params.isCheckEvaluation?string};
       this.params.startDate ='${electState.params.electStartAt?string("yyyy-MM-dd")}';
       this.params.finishDate ='${electState.params.electEndAt?string("yyyy-MM-dd")}';
       this.params.startTime ='${electState.params.electStartAt?string("HH:mm")}';
       this.params.finishTime ='${electState.params.electEndAt?string("HH:mm")}';
       this.params.isOpenElection =${electState.params.isOpenElection?string};
       this.params.isOverMaxAllowed =${electState.params.isOverMaxAllowed?string};
       this.params.isUnderMinAllowed =${electState.params.isUnderMinAllowed?string};
       this.params.isCancelAnyTime =${electState.params.isCancelAnyTime?string};
       this.params.isRestudyAllowed=${electState.params.isRestudyAllowed?string};
       this.params.isCheckScopeForReSturdy=${electState.params.isCheckScopeForReSturdy?string};
       this.std = new Object();
       this.std.stdNo = '${electState.std.stdNo}';
       this.std.enrollTurn = '${electState.std.enrollTurn}';
       this.std.departId= '${electState.std.departId}';
       this.std.specialityId = '${electState.std.specialityId?if_exists}';
       this.std.aspectId = '${electState.std.aspectId?if_exists}';
       this.std.stdTypeId='${electState.std.stdTypeId}';
       this.std.HSKDegree='${electState.std.HSKDegree?default(100)}';
       this.std.languageAbility='${electState.std.languageAbility?default(0)}'
       this.std.adminClassIds = new Array();
       <#list electState.std.adminClassIds as adminClassId>
       this.std.adminClassIds[${adminClassId_index}]='${adminClassId}'
       </#list>
       this.electedCourseIds = new Object();
       <#list electState.electedCourseIds as courseId>
       this.electedCourseIds['${courseId}']=true;
       </#list>
       this.hisCourses = new Object();
       <#list electState.hisCourses?keys as courseId>
       this.hisCourses['${courseId}']=${electState.isCoursePass(courseId)?string};
       </#list>
       this.substituteIds = new Object();
       <#list electState.substituteIds as courseId>
       this.substituteIds['${courseId}']=true;
       </#list>
       this.hisCourseNames = new Object();
       <#list electState.hisCourseNames as courseName>
       this.hisCourseNames['${courseName?html}']=true;
       </#list>
     }
     
     //替代课程map
     function subsMap(){
         this.subsCourse=new Object();
         <#list subsMap?keys as courseOri>
         this.subsCourse['${courseOri}']='${subsMap[courseOri]}';
         </#list>
     }
     adaptFrameSize();
 </script>
<script language="JavaScript" type="text/JavaScript" src="scripts/course/ElectCourse.js?version=20151208"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/viewSelect.js"></script>
</body>
<#include "/templates/foot.ftl"/> 