<#include "/templates/head.ftl"/>
 <script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url" />"></script>
 <BODY LEFTMARGIN="0" TOPMARGIN="0">
 	<table class="frameTableStyle">
 		<tr>
 			<td  width="80%"/>
 			<td  width="10%" class="infoTitle" style="height:22px;width:300px;font-size:10pt" onclick="javascript:history.back();" onmouseover="MouseOver(event)" onmouseout="MouseOut(event)">
          		<img src="images/action/backward.gif" class="iconStyle" alt="<@bean.message key="action.back"/>" /><@bean.message key="action.back"/>
      		</td>
      		<td  width="10%"/>
      	</tr>
    </table>
  <table cellpadding="0" cellspacing="0" width="100%" border="0">
   <#if result.student?exists> 
   <tr>
    <td>
     <table width="90%" align="center" class="listTable">
       <form name="listForm" action="" onsubmit="return false;">
	   <tr align="center" class="darkColumn">
	     <td ><@msg.message key="attr.courseNo"/></td>
	     <td ><@bean.message key="attr.courseName"/></td>
	     <td ><@bean.message key="entity.courseType"/></td>
	     <td >考勤</td>
	     <td >出勤</td>
	     <td >旷课</td>
	     <td >迟到</td>
	     <td >早退</td>
	     <td >请假</td>
	     <td ><@bean.message key="attr.graduate.attendClassRate"/></td>
	     <td >旷课率</td>
	     <td >修读类别</td>
	   </tr>	
	   <#assign totalRatio = 0 />
	   <#assign totalAbsenteeismRatio = 0 />
	   <#assign totalCount = 0 />
	   <#assign totalDuty = 0 />
	   <#assign totalAbsenteeism = 0 />
	   <#assign totalLateCount = 0 />
	   <#assign totalLeaveEarlyCount = 0 />
	   <#assign totalAskedForLeaveCount = 0 />
	   <#assign totalDutyCount = 0 />
	   <#assign totalAbsenteeismCount = 0 />
	   <#list (result.recordList?sort_by(["teachTask","course","code"]))?if_exists as record>
	   <#if record_index%2==1 ><#assign class="grayStyle" ></#if>
	   <#if record_index%2==0 ><#assign class="brightStyle" ></#if>
	   <tr class="${class}" onmouseover="swapOverTR(this,this.className)" onmouseout="swapOutTR(this)">
	    <td>&nbsp;${record.teachTask.course?if_exists.code?if_exists}</td>
	    <td>
	     <a href="javascript:popupCommonWindow('dutyRecordSearch.do?method=recordDetail&dutyRecordId=${record.id}','recordDetailWin');" >
	      &nbsp;<@i18nName record.teachTask.course?if_exists/>
	     </a>
	    </td>
	    <td>&nbsp;<@i18nName record.teachTask.courseType?if_exists/></td>
	    <td>&nbsp;${record.totalCount?default(0)}<#assign totalCount = totalCount + record.totalCount?default(0) /></td>
	    <td>&nbsp;${record.dutyCount?default(0)}<#assign totalDuty = totalDuty + record.dutyCount?default(0) /></td>
	    <td>&nbsp;${record.absenteeismCount?default(0)}<#assign totalAbsenteeism = totalAbsenteeism + record.absenteeismCount?default(0) /></td>
	    <td>&nbsp;${record.lateCount?default(0)}<#assign totalLateCount = totalLateCount + record.lateCount?default(0) /></td>
	    <td>&nbsp;${record.leaveEarlyCount?default(0)}<#assign totalLeaveEarlyCount = totalLeaveEarlyCount + record.leaveEarlyCount?default(0) /></td>
	    <td>&nbsp;${record.askedForLeaveCount?default(0)}<#assign totalAskedForLeaveCount = totalAskedForLeaveCount + record.askedForLeaveCount?default(0) /></td>
	    <td>&nbsp;${record.dutyRatio?default(0)?string.percent}</td>
	    <td>&nbsp;${record.absenteeismRatio?default(0)?string.percent}</td>
	    <td>&nbsp;<@i18nName record.getCourseTakeType(false) /></td>
	    <#assign totalDutyCount = totalDutyCount + record.getDutyCount(true)?default(0) />
	    <#assign totalAbsenteeismCount = totalAbsenteeismCount + record.getAbsenteeismCount(true)?default(0) />
	   </tr>
	   </#list>
	   <tr class="darkColumn" >
	    <#if totalDuty = 0 ><#assign totalRatio = 0 /><#assign totalAbsenteeismRatio = 0 /><#else><#assign totalRatio = totalDutyCount?default(0)/totalCount?default(0) /><#assign totalAbsenteeismRatio = totalAbsenteeismCount/totalCount?default(0) /></#if>
	    <td colspan="3" align="center">合计</td>
	    <td>&nbsp;${totalCount?default(0)}</td>
	    <td>&nbsp;${totalDuty?default(0)}</td>
	    <td>&nbsp;${totalAbsenteeismCount?default(0)}</td>
	    <td>&nbsp;${totalLateCount?default(0)}</td>
	    <td>&nbsp;${totalLeaveEarlyCount?default(0)}</td>
	    <td>&nbsp;${totalAskedForLeaveCount?default(0)}</td>
	    <td>&nbsp;${totalRatio?string.percent}</td>
	    <td>&nbsp;${totalAbsenteeismRatio?string.percent}</td>
	    <td>&nbsp;</td>
	   </tr>
	   </form>
     </table>
    </td>
   </tr>
   </#if>
  </table>
 </body>
 <script>
 </script>
<#include "/templates/foot.ftl"/>