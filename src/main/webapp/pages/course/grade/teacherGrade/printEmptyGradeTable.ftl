<#include "/templates/head.ftl"/>
<object id="factory2" style="display:none" viewastext classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="css/smsx.cab#Version=6,2,433,14"></object> 
<style>
.printTableStyle {
	border-collapse: collapse;
    border:solid;
	border-width:2px;
    border-color:#006CB2;
  	vertical-align: middle;
  	font-style: normal; 
	font-size: 10pt; 
}
table.printTableStyle td{
	border:solid;
	border-width:0px;
	border-right-width:2;
	border-bottom-width:2;
	border-color:#006CB2;
        height:26px;
}
</style>
<#macro emptyTd count>
     <#list 1..count as i>
     <td></td>
     </#list>
</#macro>
<#assign pagePrintRow = 30 />
<body  onload="SetPrintSettings()">
	<table id="bar"></table>
   <#list tasks?if_exists as task>
   <#assign boycount=0/>
   <#assign girlcount=0/>
    <#assign takes=courseTakes[task.id?string]?sort_by(['student','code'])>
     <table width="100%" align="center" border="0"  >
	   <tr>
	    <td align="center" colspan="6" style="font-size:17pt">
	     <B><@i18nName systemConfig.school/>学生登分册</B>
	    </td>
	   </tr>
	   <#assign colspan = 6/>
	   <tr><td colspan="${colspan}">&nbsp;</td></tr>
	   <#assign titleWidth = (100 / colspan) + "%"/>
	   <tr class="infoTitle">
	       <td width="${titleWidth}">学年学期：${task.calendar.year}学年 <#if task.calendar.term='1'>第一学期<#elseif task.calendar.term='2'>第二学期<#else>${task.calendar.term}</#if></td>
		   <td width="${titleWidth}" align="right"><@msg.message key="attr.taskNo"/>：${task.seqNo}</td>
		   <td width="${titleWidth}" align="right"><@msg.message key="attr.courseNo"/>：${task.course.code}</td>
		   <td width="${titleWidth}" align="right"><@msg.message key="attr.courseName"/>：<@i18nName task.course?if_exists/></td>
		   <td width="${titleWidth}" align="right"><@msg.message key="entity.teacher"/>：<@getTeacherNames task.arrangeInfo.teachers?if_exists/></td>
		   <td width="${titleWidth}" align="right">教学班：${task.teachClass.name?if_exists}</td>
	   </tr>
	 </table>	 
	 <#assign pageNos=(takes?size/(pagePrintRow*2))?int />
	 <#if ((takes?size)>(pageNos*(pagePrintRow*2)))>
	 <#assign pageNos=pageNos+1 />
	 </#if>
	 <#list 0..pageNos-1 as pageNo>
	 <#assign passNo=pageNo*pagePrintRow*2 />

	 <table class="printTableStyle"  width="100%">
	   <tr class="darkColumn" align="center">
	     <td width="4%" >序号</td>
	     <td width="10%"><@msg.message key="attr.stdNo"/></td>
	     <td width="12%"><@msg.message key="attr.personName"/></td>
	     <#list gradeTypes as gradeType>
	     <td width="8%"><@i18nName gradeType/></td>
	     </#list>
	     <td width="8%" >总评成绩</td>
	     <td width="4%">序号</td>
	     <td width="10%"><@msg.message key="attr.stdNo"/></td>
	     <td width="12%"><@msg.message key="attr.personName"/></td>
	     <#list gradeTypes as gradeType>
	     <td width="8%"><@i18nName gradeType/></td>
	     </#list>
	     <td width="8%">总评成绩</td>
	   </tr>
	   <#list 0..pagePrintRow-1 as i>
	   <tr class="brightStyle" >
         <#if takes[i+passNo]?exists>
	     <td>${i+1+passNo}</td>
	     <td>${takes[i+passNo].student.code}</td>
	     <td><@i18nName takes[i+passNo].student/></td>
         <#else><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
         </#if>
         <@emptyTd count=(gradeTypes?size+1)/>
         <#if takes[i+pagePrintRow+passNo]?exists>
	     <td>${i+pagePrintRow+1+passNo}</td>
	     <td>${takes[i+pagePrintRow+passNo].student.code}</td>
	     <td><@i18nName takes[i+pagePrintRow+passNo].student/></td>
         <#else><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></#if>
         <@emptyTd count=(gradeTypes?size+1)/>
	   </tr>
	   </#list>
     </table>
 	 <table width='100%' align='center' border='0' style="font-size:13px">
 	 	<tr>
	 	 	<td width='85%'>任课教师签名:</td>
	 	 	<td align='left'>年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</td>
 	 	</tr>	
 	 </table>
 	 <#if task_has_next||pageNo_has_next><div style='PAGE-BREAK-AFTER: always'></div></#if>
     </#list>
   </#list>
   <table width="100%" align="center">
	   <tr>
		   <td align="center">
		   <button onclick="print()"  class="notprint" ><@msg.message key="action.print"/></button>
		  </td>
	  </tr>
  </table>
  <script>
  	var bar = new ToolBar("bar", "<@i18nName systemConfig.school/>学生登分册", null, true, true);
  	bar.setMessage('<@getMessage/>');
  	bar.addPrint("<@msg.message key="action.print"/>");
  	bar.addBackOrClose("<@msg.message key="action.close"/>", "<@msg.message key="action.back"/>");
  </script>
 </body>
<#include "/templates/foot.ftl"/>