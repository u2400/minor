<#include "/templates/head.ftl"/>
 <BODY LEFTMARGIN="0" TOPMARGIN="0" >
  <style>
 .reportTable {
	border-collapse: collapse;
    border:solid;
	border-width:1px;
    border-color:#006CB2;
  	vertical-align: middle;
  	font-style: normal; 
	font-size: 10pt; 
}
table.reportTable td{
	border:solid;
	border-width:0px;
	border-right-width:1;
	border-bottom-width:1;
	border-color:#006CB2;

}
 </style>
 <table id="myBar" width="90%"> </table>
 <#macro displayGrades(index,grade,gradeTypes)>
    <td>${index+1}</td>
    <td>${grade.std.code}</td>
    <td>${grade.std.name}</td>
    <td>${(grade.std.firstMajorClass.name)?default('')}</td>
    <td><@i18nName (grade.std.basicInfo.gender)?if_exists/></td>
    <#list gradeTypes as gradeType>
     <#if gradeType.id=USUAL&& grade.courseTakeType?if_exists.id?if_exists=REEXAM>
     <td>免修</td>
     <#elseif grade.getExamGrade(gradeType)?exists>
       <#if !grade.getExamGrade(gradeType).examStatus.isAttend>
         <td><@i18nName grade.getExamGrade(gradeType).examStatus/></td>
       <#else>
         <td>${grade.getScoreDisplay(gradeType)}</td>
       </#if>
     <#else>
     <td>${grade.getScoreDisplay(gradeType)}</td>
     </#if>
    </#list>
    <td></td>
 </#macro>
 <div id = "DATA" width="100%" align="center" cellpadding="0" cellspacing="0">
 <#assign pageSize=35>
 <#list reports as report>
 	 <#assign grades=report.courseGrades>
 	 <#assign pages=(grades?size/pageSize)?int />
 	 <#if grades?size==0><#break></#if>
 	 <#if (pages*pageSize<grades?size)><#assign pages=pages+1></#if>
     <#assign teachTask = report.task>
     <#list 1..pages as page>
 	 <div align='center'><h3><@i18nName systemConfig.school/>课程成绩登记表</h3></div>
 	 <div align='center'>${teachTask.calendar.year}年度 <#if teachTask.calendar.term='1'>第一学期<#elseif teachTask.calendar.term='2'>第二学期<#else>${teachTask.calendar.term}</#if></div>
 	 <table width='90%' align='center' border='0' style="font-size:13px">
 	 	<tr>
	 	 	<td width='25%'><@msg.message key="attr.courseNo"/>:${teachTask.course.code}</td>
	 	 	<td width='40%'><@msg.message key="attr.courseName"/>:${teachTask.course.name}</td>
	 	 	<td align='left'><@msg.message key="entity.courseType"/>:${teachTask.courseType.name}</td>
 	 	</tr>
 	 	<tr>
	 	 	<td><@msg.message key="attr.taskNo"/>:${teachTask.seqNo?if_exists}</td>
	 	 	<td><@msg.message key="task.arrangeInfo.primaryTeacher"/>:<@getTeacherNames teachTask.arrangeInfo?if_exists.teachers/></td>
	 	 	<td align='left'>授课院系:${teachTask.arrangeInfo?if_exists.teachDepart?if_exists.name?if_exists}</td>
 	 	</tr>	
 	 	<tr>
 	 	    <td colspan="3"><#list report.gradeTypes as gradeType><#if teachTask.gradeState.getPercent(gradeType)?exists><@i18nName gradeType/>${teachTask.gradeState.getPercent(gradeType)?string.percent}&nbsp;</#if></#list></td>
 	 	</tr>
 	 </table>
     <table width="90%" class="reportTable">
	   <tr align="center">
	     <td align="center" width="4%"><@msg.message key="attr.index"/></td>
	     <td align="center" width="8%"><@bean.message key="attr.stdNo" /></td>
	     <td width="10%"><@bean.message key="attr.personName" /></td>
	     <td width="12%">所在班级</td>
	     <td width="5%">性别</td>
	     <#list report.gradeTypes as gradeType>
	     <td width="7%"><@i18nName gradeType/></td>
	     </#list>
	     <td align="center" width="8%"><@msg.message key="attr.remark"/></td>  	
	   </tr>
	   <#list 1..pageSize as i>	   
	   <tr>
		   <#assign j=(i-1)+(page-1)*pageSize>
		   <#if grades[j]?exists>
		     <@displayGrades j,grades[j],report.gradeTypes/>
		   <#else>
		      <#break>
		   </#if>
	   </tr>
	   </#list>
     </table>
 	 <table width='90%' align='center' border='0' style="font-size:13px">
                <tr><td colspan="2">第${page}页 共${pages}页</td></tr>
                 <#if pages==page>
					<tr>
					       <td colspan="2">备注:考试后五天内,请将此表打印一式二份，其中一份随试卷、课程考试情况分析表、
				考生签名表交试卷档案室(刑司学院对面平房),一份归入课程档案</td>
					</tr>
                </#if>
 	 	<tr>
	 	 	<td width='85%'>任课教师签名:</td>
	 	 	<td align='left'>年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</td>
 	 	</tr>	
 	 </table>
     <#if page_has_next><div style='PAGE-BREAK-AFTER: always'></div> </#if>
     </#list>
 	 <#if report_has_next>
	 	 <div style='PAGE-BREAK-AFTER: always'></div> 
 	 </#if>
</#list>  
</div>
<script>
   var bar = new ToolBar("myBar","教学班成绩打印",null,true,true);
   bar.setMessage('<@getMessage/>');
   bar.addItem("<@msg.message key="action.print"/>","print()");
   bar.addItem("<@msg.message key="action.export"/>","exportData()");
   bar.addClose();
   function exportData(){
       <#if RequestParameters['taskIds']?exists>
       self.location="teachClassGradeReport.do?method=export&template=teachClassGradeReport.xls&taskIds=${RequestParameters['taskIds']}";
       <#--该页面可能从单个成绩的录入跳转过来-->
       <#elseif RequestParameters['taskId']?exists>
       self.location="teachClassGradeReport.do?method=export&template=teachClassGradeReport.xls&taskIds=${RequestParameters['taskId']}";
       </#if>
   }
</script>
 </body>
<#include "/templates/foot.ftl"/>      