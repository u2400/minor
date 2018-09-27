<#include "/templates/head.ftl"/>
 <style  type="text/css">
 .content{
	vertical-align: middle;
	font-size: 12px;
	padding-left: 2px;
	padding-right: 2px;
}
.title{
	width: 100px;
	vertical-align: middle;
	font-weight: 700;
	font-size: 12px;
	background-color: #EEEEEE;
	text-indent: 6px;
	border-bottom-width: 2px;
	padding-left: 4px;
	padding-right: 4px;	
}
 </style>
<body  LEFTMARGIN="0" TOPMARGIN="0" >
 <#assign labInfo><@bean.message key="entity.teachTask"/><@bean.message key="common.detailInfo"/></#assign>
 <#include "/templates/back.ftl"/>
     <table class="infoTable">
       <tr>
	     <td class="title"><@msg.message key="attr.taskNo"/></td>
	     <td class="content" width="20%"> ${task.seqNo?if_exists}</td>
	     <td class="title"><@msg.message key="attr.courseNo"/>:</td>
	     <td class="content">${task.course.code}</td>
	     <td class="title"><@bean.message key="attr.term"/>:</td>
	     <td class="content">${task.calendar.year} ${task.calendar.term}</td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="attr.courseName"/></td>
	     <td class="content" width="20%"><@i18nName task.course/></td>
	     <td class="title"><@bean.message key="entity.courseType"/>:</td>
	     <td class="content"><@i18nName task.courseType/></td>
	     <td class="title"><@bean.message key="attr.credit"/>:</td>
	     <td class="content">${task.course.credits}</td>
	   </tr>
	   <tr>
	   <td colspan="6" style="background-color: #EEEEEE"><@bean.message key="entity.teachClass"/><@bean.message key="common.info"/></td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="entity.teachClass"/>:</td>
	     <td class="content">${task.teachClass.name}</td>
	     <td class="title"><@bean.message key="entity.studentType"/>:</td>
         <td class="content"><@i18nName task.teachClass.stdType/></td>
	     <td class="title"><@bean.message key="attr.enrollTurn"/>:</td>
         <td class="content">${task.teachClass.enrollTurn?if_exists}</td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="entity.college"/>:</td>
	     <td class="content"><@i18nName task.teachClass.depart/>  </td>
	     <td class="title"><@bean.message key="entity.speciality"/>:</td>
         <td class="content"><@i18nName task.teachClass.speciality?if_exists/></td>
	     <td class="title"><@bean.message key="entity.specialityAspect"/>:</td>
         <td class="content"><@i18nName task.teachClass.aspect?if_exists/></td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="entity.adminClass"/>:</td>
	     <td class="content">
	         <#list task.teachClass.adminClasses as adminClass>
	             ${adminClass.name}
	         </#list>
	     </td>
	     <td class="title"><@bean.message key="attr.planStdCount"/>:</td>
         <td class="content">${task.teachClass.planStdCount}</td>
         <td class="title"><@bean.message key="attr.actualStdCount"/>:</td>
         <td class="content">${task.teachClass.stdCount}</td>
	   </tr>
	   <tr>
	   <td colspan="6" style="background-color: #EEEEEE"><@bean.message key="entity.taskRequirement"/></td>
	   </tr>
	   <tr>
	     <td class="title"><@msg.message key="teachTask.classroomRequirement"/>：</td>
	     <td class="content"><@i18nName task.requirement.roomConfigType/></td>
	     <td class="title"><@bean.message key="attr.isGuaPai"/>:</td>
         <td class="content">
         <#if task.requirement.isGuaPai==true> <@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if>
         </td>
	     <td class="title"><@bean.message key="attr.teachLangType"/>:</td>
         <td class="content"><@i18nName (task.requirement.teachLangType)?if_exists/></td>
	   </tr>
	   <tr>
	     <td class="title"><@msg.message key="entity.textbook"/>:</td>
	     <td class="content"><@getBeanListNames task.requirement.textbooks?if_exists/></td>
	     <td class="title"><@bean.message key="attr.referenceBooks"/>:</td>
         <td class="content" colspan="3">${task.requirement.referenceBooks?if_exists}</td>
	   </tr>
       <tr>
	     <td class="title"><@bean.message key="attr.cases"/>:</td>
         <td class="content" colspan="5">${task.requirement.cases?if_exists}</td>
	   </tr>
	   <tr>
	   <td colspan="6" style="background-color: #EEEEEE"><@bean.message key="entity.taskArrangment"/></td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="attr.teachDepart"/>:</td>
	     <td class="content">${task.arrangeInfo.teachDepart.name}</td>
	     <td class="title"><@bean.message key="entity.teacher"/>:</td>
         <td class="content"><@getTeacherNames task.arrangeInfo.teachers/></td>
	     <td class="title"><@msg.message key="task.course.times"/>:</td>
         <td class="content">${task.arrangeInfo.courseUnits}</td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="attr.overallUnits"/>:</td>
	     <td class="content">${task.arrangeInfo.overallUnits}  </td>
	     <td class="title"><@bean.message key="attr.weekHour"/>:</td>
         <td class="content">${task.arrangeInfo.weekUnits}</td>
	     <td class="title"><@bean.message key="attr.weeks"/>:</td>
         <td class="content">${task.arrangeInfo.weeks}</td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="attr.teachWeek"/>:</td>
	     <td class="content">
	     <#if task.arrangeInfo.weekCycle==1><@bean.message key="attr.continuedWeek"/>
	     <#elseif task.arrangeInfo.weekCycle==2><@bean.message key="attr.oddWeek"/>
	     <#elseif task.arrangeInfo.weekCycle==3><@bean.message key="attr.evenWeek"/>
	     <#else><@bean.message key="attr.randomWeek"/>
	     </#if>
	     </td>
	     <td class="title"><@bean.message key="attr.startWeek"/>:</td>
         <td class="content">${task.arrangeInfo.weekStart}</td>
	     <td class="title"><@bean.message key="attr.isArrangeComplete"/>:</td>
         <td class="content"><#if task.arrangeInfo.isArrangeComplete ==true ><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
       </tr>
	   <tr>
	     <td class="title"><@bean.message key="entity.schoolDistrict"/>:</td>
	     <td class="content"><@i18nName (task.arrangeInfo.schoolDistrict)?if_exists/></td>
       </tr>
       <tr>
	   <td colspan="6" style="background-color: #EEEEEE"><@bean.message key="entity.taskElection"/></td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="attr.isElectable"/>:</td>
	     <td class="content"><#if task.electInfo.isElectable ==true ><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
	     <td class="title"><@bean.message key="attr.isCancelable"/>:</td>
         <td class="content"><#if task.electInfo.isCancelable ==true ><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
	     <td class="title"><@bean.message key="attr.maxCount"/>:</td>
	     <td class="content">${task.electInfo.maxStdCount}</td>
	   </tr>
	   <#if task.electInfo.isElectable==true>
	   <tr>
	     <td class="title"><@msg.message key="field.cultivateCourse.HSKConstrain"/>:</td>
         <td class="content"><@i18nName task.electInfo.HSKDegree?if_exists/></td>
         <td class="title"><@msg.message key="field.cultivateCourse.necessaryCourses"/>:</td>
         <td class="content"><#list task.electInfo.prerequisteCourses as course><@i18nName course/>&nbsp;</#list></td>
	     <td class="title"><@bean.message key="attr.minCount"/>:</td>
         <td class="content">${task.electInfo.minStdCount}</td>
	   </tr>
	   
	   <tr>
	     <td class="title" rowspan="${task.electInfo.electScopes?size +1 }"><@bean.message key="entity.electScope"/>:</td>
	     <td class="content" align="center" colspan="5"><@bean.message key="entity.content"/></td>
	   </tr>
	   <#list task.electInfo.electScopes as scope>
	   <tr>
	     <td colspan="5">
	       <#if scope.enrollTurns?exists>
	           <@bean.message key="attr.enrollTurn"/>:${scope.enrollTurns}
	       </#if>
	       <#if scope.stdTypeIds?exists>
	           <@bean.message key="entity.studentType"/>:${scope.stdTypeIds}
	       </#if>
	       <#if scope.departIds?exists>
	           <@bean.message key="entity.college"/>:${scope.departIds}
	       </#if>
	       <#if scope.specialityIds?exists>
	           <@bean.message key="entity.speciality"/>:${scope.specialityIds}
	       </#if>
	       <#if scope.aspectIds?exists>
	           <@bean.message key="entity.specialityAspect"/>:${scope.aspectIds}
	       </#if>
	       <#if scope.adminClassIds?exists>
	           <@bean.message key="entity.adminClass"/>:${scope.adminClassIds}
	       </#if>
	       <#if scope.startNo?exists>
	           <@bean.message key="attr.startNo"/>:${scope.startNo}
	       </#if>
	       <#if scope.endNo?exists>
	           <@bean.message key="attr.endNo"/>:${scope.endNo}
	       </#if>
	      </td>
	   </tr>
	   </#list>
	   </#if>
	   <tr>
	     <td class="title"><@msg.message key="attr.remark"/>:</td>
         <td class="content" colspan="5">${task.remark?if_exists}</td>
	   </tr>
      </table>
 </body>
<#include "/templates/foot.ftl"/>