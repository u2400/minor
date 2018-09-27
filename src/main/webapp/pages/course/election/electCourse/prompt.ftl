<#include "/templates/simpleHead.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/common/ToolBar.js"></script>
<link href="css/toolBar.css" rel="stylesheet" type="text/css">
<body>
<table id="promptBar" width="100%"></table>
<script>
  	var bar = new ToolBar("promptBar","<@msg.message key="course.std.weclomeInterface"/>",null,true,true);  
   	bar.addHelp("&nbsp;<@msg.message key="action.help"/>");
</script>
 	<table width="80%" align="center" class="listTable">
	<#if electState?exists>
	<#assign  electParams = electState.params/>
	<#assign  isEvaluated = electState.isEvaluated?default(false)/>
	</#if>
	   <tr class="darkColumn">
	     <td align="center" colspan="4"><@i18nName electParams.calendar.studentType/> <@msg.message key="attr.year2year"/>：${electParams.calendar.year}<@msg.message key="attr.term"/>：${electParams.calendar.term} <@msg.message key="course.noticeItemOfElective"/></td>
	   </tr>
	   <tr>
	     <td class="grayStyle" width="25%" id="f_turn">&nbsp;<@bean.message key="attr.electTurn"/>：</td>
	     <td class="brightStyle">${electParams.turn?if_exists}</td>
	     <td class="grayStyle" width="25%" id="f_turn">&nbsp;<@msg.message key="common.switch"/>：</td>
	     <td class="brightStyle"><#if electParams.isOpenElection><@msg.message key="common.opened"/><#else><@msg.message key="common.closed"/></#if></td>
	   </tr>
       <tr>
	   	 <td class="darkColumn" width="25%" colspan="4">&nbsp;<@bean.message key="entity.electDateTime"/>：</td>
       </tr>
       <tr>
	   	 <td class="title"  id="f_startDate">&nbsp;熟悉课表情况开始时间：</td>
	     <td>${electParams.startAt?string("yyyy-MM-dd HH:mm:ss")}</td>
	   	 <td class="title"  id="f_startTime">&nbsp;熟悉课表情况结束时间：</td>
	     <td>${(electParams.endAt?string("yyyy-MM-dd HH:mm:ss"))}</td>
       </tr>
       <tr>
	   	 <td class="title"  id="f_startDate">&nbsp;正式选课开始时间：</td>
	     <td>${electParams.electStartAt?string("yyyy-MM-dd HH:mm:ss")}</td>
	   	 <td class="title"  id="f_startTime">&nbsp;正式选课结束时间：</td>
	     <td>${electParams.electEndAt?string("yyyy-MM-dd HH:mm:ss")}</td>
       </tr>
       <tr>
	   	 <td class="darkColumn" width="25%"  colspan="4">&nbsp;<@bean.message key="entity.electMode"/>：</td>
       </tr>
       <tr>
	   	 <td class="grayStyle" width="25%" >&nbsp;<@bean.message key="attr.isOverMaxAllowed"/>：</td>
	     <td class="brightStyle"><#if electParams.isOverMaxAllowed?if_exists==true><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
	   	 <td class="grayStyle" width="25%" >&nbsp;<@bean.message key="attr.isRestudyAllowed"/>：</td>
	     <td class="brightStyle"><#if electParams.isRestudyAllowed?if_exists==true><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>	     
       </tr> 
       <tr>
         <td class="grayStyle" width="25%" >&nbsp;<@msg.message key="course.elect.withdrawMinimumPeople"/>：</td>
	     <td class="brightStyle"><#if electParams.isUnderMinAllowed?if_exists==true><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
         <td class="grayStyle" width="25%" >&nbsp;重修时是否限制选课对象：</td>
	     <td class="brightStyle"><#if electParams.isCheckScopeForReSturdy?if_exists==true><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>	     
       </tr>
       <tr>
         <td class="grayStyle" width="25%" >&nbsp;<@bean.message key="attr.isCancelAnyTime"/>：</td>
	     <td class="brightStyle"><#if electParams.isCancelAnyTime?if_exists==true><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>	     
	   	 <!--<td class="grayStyle" width="25%">&nbsp;<@msg.message key="course.elect.thinkToAwardCredit"/>：</td>
	     <td class="brightStyle"><#if electParams.isAwardCreditConsider?if_exists==true><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>  -->  
		<td class="grayStyle" width="25%">&nbsp;<@bean.message key="attr.isCheckEvaluation"/>：</td>
	     <td class="brightStyle"><#if electParams.isCheckEvaluation?if_exists==true><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>		 
       </tr>
       <!--<tr>
	   	 
	   	 <td class="grayStyle" width="25%">&nbsp;<@bean.message key="attr.floatCredit"/>：</td>
	     <td class="brightStyle">${electParams.floatCredit?if_exists}</td>
       </tr> -->
       <tr>
	   	 <td class="grayStyle" width="25%">&nbsp;是否限制校区：</td>
	     <td class="brightStyle">${electParams.isSchoolDistrictRestrict?string("是","否")}</td>
	   	 <td class="grayStyle" width="25%">&nbsp;是否计划内课程：</td>
	     <td class="brightStyle">${electParams.isInPlanOfCourse?string("是","否")}</td>
       </tr>
       <tr>
         <td class="grayStyle">&nbsp;教学班开课对象限制：</td>
         <td class="brightStyle">${electParams.isLimitedInTeachClass?default(true)?string("是", "否")}</td>
       <#if electParams.isCheckEvaluation>
	   	 <td class="grayStyle">&nbsp;<@msg.message key="field.studentEvaluate.evaluate"/>：</td>
	     <td class="brightStyle"><#if isEvaluated><@msg.message key="attr.finished"/><#else><@msg.message key="attr.unfinished"/></#if></td>
	   <#else>
         <td class="grayStyle"></td>
         <td class="brightStyle"></td>
       </#if>
       </tr>
       <tr class="darkColumn">
	   	 <td align="center" colspan="4" style="font-size:20px;font-weight:bold;">选课协议</td>
	   </tr>
	   <tr>
	     <td class="brightStyle" colspan="4">${(electParams.notice.notice)?if_exists}</td>
	   </tr>
	   <tr class="darkColumn">
	     <td colspan="4" align="center">
			<input type="checkbox" class="pc" name="agreebbrule" value="850cbc09" id="agreebbrule" /> <label for="agreebbrule">已知晓以上事项，并遵守选课规则</a></label>
		 <br>
	       <input type="button" class="INPUT_button" id="goButton" value="同意以上选课协议，开始选课" name="goElection" onClick="enterCheck()" class="buttonStyle"/>&nbsp;
	     </td>
	   </tr>
  </table>
  <script>
     var nowDate ='${now?string("yyyy-MM-dd")}';
     var nowTime ='${now?string("HH:mm")}';
     function  goElectHome(){
         var enrollYear = ${currStd.enrollYear?split("-")[0]};
         var nowAt = new Date();
         if (nowAt.getFullYear() >= enrollYear + ${currStd.schoolingLength} - 1) {
            window.showModalDialog("auditOperationByStudent.do?method=detail&termsShow=true&showBackward=false&showStudent=false", "", "dialogHeight:600px;dialogWidth:800px;center:yes;help:no;status:no;resizable:no");
         }
         document.getElementById("goButton").value="<@msg.message key="course.loadingSystem"/>";
         document.getElementById("goButton").disabled=true;
         self.window.location="electCourse.do?method=index&electParams.id=${electParams.id}";
     }
     function ElectState(){
       this.constraint=new Object();
       this.params=new Object();
       this.params.isCheckEvaluation=${electParams.isCheckEvaluation?string};
       <#if electParams.isCheckEvaluation>
       this.isEvaluated=${isEvaluated?if_exists?string};
       <#else>
       this.isEvaluated=true;
       </#if>
       this.params.startDate ='${electParams.startAt?string("yyyy-MM-dd")}';
       this.params.finishDate ='${electParams.endAt?string("yyyy-MM-dd")}';
       this.params.startTime ='${electParams.startAt?string("HH:mm")}';
       this.params.finishTime ='${electParams.endAt?string("HH:mm")}';
       this.params.isOpenElection =${electParams.isOpenElection?string};
     }
     function canEnterElectSystem(state){
        if(!state.params.isOpenElection) {
           alert("<@msg.message key="course.noOpenedElective"/>");
           return  false;
        }
        if(state.params.isCheckEvaluation&&!state.isEvaluated){
          alert("<@msg.message key="course.unfinishEvaluate"/>");
          return false;
         }
        if(checkDate(state)) {
            return true;
         }
        else{
          alert("<@msg.message key="course.notElectivetime"/>");
          return false;
        }
     }
     function checkDate(state){
         var startDateInfo = state.params.startDate.split("-");
         var startTimeInfo =state.params.startTime.split(":");
         var a = new Date(startDateInfo[0],startDateInfo[1]-1,startDateInfo[2],startTimeInfo[0],startTimeInfo[1],0,0);
         startTime=a.valueOf();
         
         var finishDateInfo = state.params.finishDate.split("-");
         var finishTimeInfo =state.params.finishTime.split(":");
         b =new Date(finishDateInfo[0],finishDateInfo[1]-1,finishDateInfo[2],finishTimeInfo[0],finishTimeInfo[1],0,0);
         finishTime=b.valueOf();
         
         var nowDateInfo = nowDate.split("-");
         var nowTimeInfo = nowTime.split(":");
         c =new Date(nowDateInfo[0],nowDateInfo[1]-1,nowDateInfo[2],nowTimeInfo[0],nowTimeInfo[1],0,0);
         nowTimeMills=c.valueOf();
         
         return (startTime<=nowTimeMills&&nowTimeMills<=finishTime);
     }
     function setElectEnable(state){
         if(canEnterElectSystem(state)){
           document.getElementById("goButton").disabled=false;
         }
         else{
           document.getElementById("goButton").disabled =true;
         }
     }
	function enterCheck(){
       if(!document.getElementById("agreebbrule").checked) {
		alert("请先阅读以上选课协议");return;
	   }
		goElectHome();
 
    }
     setElectEnable(new ElectState());
  </script>
  </body>
<#include "/templates/foot.ftl"/>