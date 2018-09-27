<#include "/templates/head.ftl"/>
<#include "/templates/print.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
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
<body>

     <table width="80%" align="center" border="0"  >
	   <tr>
	    <td align="center" colspan="5" style="font-size:17pt" >
	     <B><@i18nName systemConfig.school/>补缓考成绩录入</B>
	    </td>
	   </tr>
	   <tr><td colspan="5">&nbsp;</td></tr>
	 </table>	 
	 
	 <table width="80%" align="center" border="0"  >
	 <tr class="infoTitle">
	       <td >学年学期：${calendar.year}学年 <#if calendar.term='1'>第一学期<#elseif calendar.term='2'>第二学期<#else>${calendar.term}</#if></td>
		   <td ><@msg.message key="attr.courseNo"/>：${course.code}</td>
		   <td ><@msg.message key="attr.courseName"/>：<@i18nName course?if_exists/></td>
		   <td ><@msg.message key="attr.teachDepart"/>：<@i18nName teachDepart/></td>
		   <td >考试学生：${examTakeList?size}</td>
	 </tr>
	 </table>
	 <form name="actionForm" action="" method="post" onsubmit="return false;">
	 <input type="hidden" id="courseIds" name="courseIds" value="${course.id}@${teachDepart.id}" />
	 <input type="hidden" id="calendar.id" name="calendar.id" value="${calendar.id}" />
	 <table id="makeupInputTable" class="printTableStyle" width="80%"  align="center">
	   <tr class="darkColumn" align="center">
	     <td width="4%" >序号</td>
	     <td width="10%"><@msg.message key="attr.stdNo"/></td>
	     <td width="12%"><@msg.message key="attr.personName"/></td>
	     <td width="8%">备注</td>
	     <td width="8%" >考试成绩</td>

	     <td width="4%">序号</td>
	     <td width="10%"><@msg.message key="attr.stdNo"/></td>
	     <td width="12%"><@msg.message key="attr.personName"/></td>
	     <td width="8%">备注</td>
	     <td width="8%" >考试成绩</td>
	   </tr>
	   <#assign examTakeList=examTakeList?sort_by(['std','code'])>
       <#assign pageNo=(((examTakeList?size-1)/2)?int)  />
	   <#list 0..pageNo as i>
	   <tr class="brightStyle" >
         <#if examTakeList[i]?exists>
	     <td>${i+1}</td>
	     <td id="f_${examTakeList[i].std.code}">${examTakeList[i].std.code}</td>
	     <td><@i18nName examTakeList[i].std/></td>
	     <td><@i18nName examTakeList[i].examType/></td>
	     <#assign examGradeNo=examTakeList[i].id/>
	     <td><input id="${examGradeNo}" maxlength="3" name="score_${examGradeNo}" TABINDEX="${i+1}" value="${(examGradeMap[examGradeNo?string].score)?if_exists}" style="width:100px"/></td>
         </#if>
         
         <#assign nextExam=i+pageNo+1>
         <#if examTakeList[nextExam]?exists>
	     <td>${nextExam+1}</td>
	     <td id="f_${examTakeList[nextExam].std.code}">${examTakeList[nextExam].std.code}</td>
	     <td><@i18nName examTakeList[nextExam].std/></td>
	     <td><@i18nName examTakeList[nextExam].examType/></td>
		 <#assign examGradeNo=examTakeList[nextExam].id/>
	     <td><input id="${examGradeNo}" maxlength="3" name="score_${examGradeNo}" TABINDEX="${nextExam+1}" value="${(examGradeMap[examGradeNo?string].score)?if_exists}" style="width:100px"/></td>
         <#elseif examTakeList[i+1]?exists>
          <@emptyTd count=5/>
         </#if>
	   </tr>
	   </#list>	 
	   
     </table>
     <table class="printTableStyle"  width="80%"  align="center">
       <tr>
	   	<td align="center">成绩录入后的状态：已发布<input type="hidden" name="grade.state" value="2"/></td>
       <#--
	   	<td align="center">请选择成绩录入后的状态: 
	   	  <select id="grade.state" name="grade.state" style="width:100px">
	     		<option value="1" >确认</option>
	     		<option value="0" >新录入</option>
	     		<option value="2" >发布</option>
	      </select>
	   	</td>
       -->
	   </tr>
     </table>
     </form>
     <CENTER>
		<button onclick="saveGrade()"  class="notprint" >提交</button>
     </CENTER>
     <script>
		var form =document.actionForm;
		function saveGrade(){
            var a_fields = {
                <#list examTakeList as examTake>
                'score_${examTake.id}':{'l':'${examTake.std.code}的考试成绩', 'r':false, 't':'f_${examTake.std.code}', 'f':'unsignedReal'}<#if examTake_has_next>,</#if>
                </#list>
            };
            var v = new validator(form, a_fields, null);
            if (v.exec()) {
    			form.action = "makeupGrade.do?method=batchSaveCourseGrade"
    			form.submit();
            }
		}
	 </script>
 </body>
<#include "/templates/foot.ftl"/>