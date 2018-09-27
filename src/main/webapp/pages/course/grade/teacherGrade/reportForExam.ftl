<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="statBar"></table>
<style>
body{
 font-family:楷体_GB2312;
 font-size:14px;
}
.reportTable {
	border-collapse: collapse;
    border:solid;
	border-width:1px;
    border-color:black;
  	vertical-align: middle;
  	font-style: normal; 
	font-family:楷体_GB2312;
	font-size:15px;
}
table.reportTable td{
	border:solid;
	border-width:1px;
	border-right-width:1;
	border-bottom-width:1;
	border-color:black;

}
</style>
<div id="DATA" width="100%">
<#list courseStats as courseStat>
     <#assign teachTask=courseStat.task>
    <table border="0" width="100%">
     <tr>
      <td>
 	 <div align='center'><h2><@i18nName systemConfig.school/><@i18nName teachTask.teachClass.stdType/>课程考核试卷分析表</h2></div>
 	 <div align='center' style="font-weight:bold;">(${teachTask.calendar.year}学年 <#if teachTask.calendar.term='1'>第一学期<#elseif teachTask.calendar.term='2'>第二学期<#else>${teachTask.calendar.term}</#if>)</div><br> 	 
 	 <table align="center" width="100%" border='0' style="font-weight:bold;">
 	 	<tr>
            <td colspan="3" width='30%' align='left'>开课院(系、部):<@i18nName teachTask.arrangeInfo.teachDepart/></td>
	 	 	<td colspan="3" width='40%'>授课班级:<#if teachTask.requirement.isGuaPai>挂牌<#else><@getBeanListNames teachTask.teachClass.adminClasses/></#if></td>
	 	 	<td colspan="3">主讲教师:<@getTeacherNames teachTask.arrangeInfo?if_exists.teachers/></td>
 	 	</tr>
 	 	<tr>
 	 		<td colspan="3"><@msg.message key="attr.taskNo"/>:${teachTask.seqNo?if_exists}</td>
 	 	    <td colspan="3" width='40%'><@msg.message key="attr.courseName"/>:<@i18nName teachTask.course/></td>
	 	 	<td colspan="3" align='left'><@msg.message key="entity.courseType"/>:<@i18nName teachTask.courseType/></td>
 	 	</tr>
 	 </table>
 	 <br>
   </td></tr>
   <tr><td>
	   <#list courseStat.gradeSegStats as gradeStat>
	   <table width="100%" align="center" class="reportTable">
	     <tr><td rowspan="4">一、成绩分布</td>
	      <td align="left">分数段</td>
	      <#list gradeStat.scoreSegments as seg>
	      <td >${seg.min?string("##.#")}-${seg.max?string("##.#")}</td>
	      </#list>
	     </tr>
	     <tr align="center">
	      <td align="left">人数</td>
	      <#list gradeStat.scoreSegments as seg>
	      <td>${seg.count}</td>
	      </#list>
	     </tr>
	     <tr align="center">
	      <td align="left">比例数</td>
	      <#list gradeStat.scoreSegments as seg>
	      <td>${((seg.count/gradeStat.stdCount)*100)?string("##.#")}%</td>
	      </#list>
	     </tr>
	     <tr align="center">
	      <td align="left">实考人数</td>
	      <td>${gradeStat.stdCount}</td>
	      <td align="left">最高得分数</td>
	      <td><#if gradeStat.heighest?exists>${gradeStat.heighest?string("##.#")}</#if></td>
	      <td align="left">最低得分数</td>
	      <td colspan="2"><#if gradeStat.lowest?exists>${gradeStat.lowest?if_exists?string("##.#")}</#if></td>
	     </tr>
	     <tr>
	       <td colspan="9"><br>
	       二、综合分析：<br>
			1.命题分析（就试卷的难易程度、覆盖面及试卷类型适宜情况等进行分析）<br>
			2.学生考试结果（就教师的教学方法、手段、内容及学生对课程理解、掌握等方面进行分析）<br>
			3.措施与方法（肯定有效措施与方法，寻找不足及其原因，提出改进意见）
	       </td>
	     </tr>
	     <tr>
	      <td colspan="9">
	      <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-color:white">
	      	<tr valign="top">
	      		<td height="380" style="border-color:white" id="contentValue">${(RequestParameters["contentValue"])?default("")}</td>
	      	</tr>
	      </table>
	      <div align="right">授课老师签名：<U><#list 1..15 as  i>&nbsp;</#list></U></div>
	      <div align="right">日期：<U><#list 1..15 as  i>&nbsp;</#list></U></div>
	      </td>
	     </tr>
	   </table>
	   </#list>
   <br>
   </td></tr>
   <tr><td>
	   <table align="center" width="100%" border='0' style="font-size:15px;">
	   <tr>
	     <td  colspan="${2+segStat.scoreSegments?size}">
	      <div align="right">院系部主任签名：<U><#list 1..15 as  i>&nbsp;</#list></U></div>
	      <div align="right">日期：<U><#list 1..15 as  i>&nbsp;</#list></U></div>
	     </td>
	   </tr>
	   <tr>
	     <td colspan="${2+segStat.scoreSegments?size}">
	     注：<br>
		1. 课程考核试卷分析须按班级分析，然后汇总写出该课程考核试卷的综合分析。<br>
		2. 考试结束后随试卷一同交院系保存。<br>
		（如不够书写，请另附纸）<br>
	    </td>
	   </tr>
	  </table>
  </td>
 </tr>
</table>
    <#if courseStat_has_next>
    <div style='PAGE-BREAK-AFTER: always'></div>
    </#if>
</#list>
</div>
<form method="post" action="" name="actionForm">
	<input type="hidden" name="taskIds" value="${RequestParameters['taskIds']?default('')}"/>
</form>
<script>
   	var bar = new ToolBar("statBar","试卷分析表",null,true,true);
   	bar.addItem("编辑打印内容", "editReport()");
   	bar.addPrint("<@msg.message key="action.print"/>");
   	bar.addClose("<@msg.message key="action.close"/>");
   	
   	var form = document.actionForm;
   	function editReport() {
   		form.action = "teacherGrade.do?method=editReport";
   		addInput(form, "contentValue", $("contentValue").innerHTML, "hidden");
   		form.submit();
   	}
</script>
</body>
<#include "/templates/foot.ftl"/>