<table width="100%" align="center" class="listTable">
  <#assign  electParams = electState.params>
   <tr class="darkColumn">
     <td align="center" colspan="4" style="font-weight:bold"><@bean.message key="entity.electParams"/><@bean.message key="common.baseInfo"/></td>
   </tr>
   <tr>
     <td class="grayStyle" width="30%">&nbsp;<@bean.message key="attr.electTurn"/>：</td>
     <td class="brightStyle" width="20%">${electParams.turn?if_exists}</td>
     <td class="grayStyle" width="30%">&nbsp;<@msg.message key="common.switch"/>：</td>
     <td class="brightStyle"><#if electParams.isOpenElection><@msg.message key="common.opened"/><#else><@msg.message key="common.closed"/></#if></td>
   </tr>
   <tr>
   	 <td class="darkColumn" colspan="4" style="font-weight:bold">&nbsp;<@bean.message key="entity.electDateTime"/>：</td>
   </tr>
   <tr>
   	 <td class="grayStyle" id="f_startDate">&nbsp;<@bean.message key="attr.startDate"/>：</td>
     <td class="brightStyle"> ${electParams.electStartAt?string("yyyy-MM-dd HH:mm")}</td>
   	 <td class="grayStyle" id="f_startTime">&nbsp;<@bean.message key="attr.startTime"/>：</td>
     <td class="brightStyle"> ${electParams.electEndAt?string("yyyy-MM-dd HH:mm")}</td>
   </tr>
   <tr>
   	 <td class="darkColumn" colspan="4" style="font-weight:bold">&nbsp;<@bean.message key="entity.electMode"/>：</td>
   </tr>
   <tr>
   	 <td class="grayStyle" >&nbsp;<@bean.message key="attr.isOverMaxAllowed"/>：</td>
     <td class="brightStyle"><#if electParams.isOverMaxAllowed?if_exists><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
   	 <td class="grayStyle" >&nbsp;<@bean.message key="attr.isRestudyAllowed"/>：</td>
     <td class="brightStyle"><#if electParams.isRestudyAllowed?if_exists><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
   </tr>
   <tr>
     <td class="grayStyle" >&nbsp;<@msg.message key="course.elect.withdrawMinimumPeople"/>：</td>
     <td class="brightStyle"><#if electParams.isUnderMinAllowed?if_exists><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
     <td class="grayStyle" >&nbsp;重修时是否限制选课对象：</td>
     <td class="brightStyle"><#if electParams.isCheckScopeForReSturdy?if_exists><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
   </tr>
   <tr>
     <td class="grayStyle" >&nbsp;<@bean.message key="attr.isCancelAnyTime"/>：</td>
     <td class="brightStyle"><#if electParams.isCancelAnyTime?if_exists><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
   	 <td class="grayStyle">&nbsp;<@msg.message key="course.elect.thinkToAwardCredit"/>：</td>
     <td class="brightStyle"><#if electParams.isAwardCreditConsider?if_exists><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
   </tr>
   <tr>
   	 <td class="grayStyle">&nbsp;<@bean.message key="attr.isCheckEvaluation"/>：</td>
     <td class="brightStyle"><#if electParams.isCheckEvaluation?if_exists><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if>
     </td>
   	 <td class="grayStyle">&nbsp;<@bean.message key="attr.floatCredit"/>：</td>
     <td class="brightStyle">${electParams.floatCredit?if_exists}</td>
   </tr>
   <tr>
   	 <td class="grayStyle">&nbsp;是否限制校区：</td>
     <td class="brightStyle">${electParams.isSchoolDistrictRestrict?string("是","否")}</td>
   	 <td class="grayStyle">&nbsp;是否计划内课程：</td>
     <td class="brightStyle">${electParams.isInPlanOfCourse?string("是","否")}</td>
   </tr>
   <tr>
     <td class="grayStyle">&nbsp;教学班开课对象限制：</td>
     <td class="brightStyle">${electParams.isLimitedInTeachClass?default(true)?string("是", "否")}</td>
     <#if electParams.isCheckEvaluation>
     <td class="grayStyle">&nbsp;<@msg.message key="field.studentEvaluate.evaluate"/>：</td>
     <td class="brightStyle"><#if electState.isEvaluated?default(false)><@msg.message key="attr.finished"/><#else><@msg.message key="attr.unfinished"/></#if></td>
     <#else>
     <td class="grayStyle"></td>
     <td class="brightStyle"></td>
     </#if>
   </tr>
   <tr>
   	 <td class="grayStyle">&nbsp;<@msg.message key="course.proposedCredit"/>：</td>
     <td class="brightStyle" colspan="3">
		<#list electState.typeCredits?keys as courseType>
			<#assign creditNeedName><@i18nName courseType/></#assign>
			<#if (electState.getCredits(courseType)>0)>
           	<@bean.message key="course.getCredits" arg0=creditNeedName arg1=(electState.getCredits(courseType)?string)/><br>
           	</#if>
        </#list>
     </td> 
  </tr>
  <tr>
   	 <td class="grayStyle">&nbsp;<@bean.message key="attr.notice"/>：</td>
     <td class="brightStyle" colspan="3">${electParams.notice.notice?if_exists}</td>
  </tr>
  <tr>
   	 <td class="darkColumn" colspan="4" align="center"><button class="buttonStyle" onclick="displayElectState(true)"><@msg.message key="action.close1"/></button></td>
  </tr>
</table>