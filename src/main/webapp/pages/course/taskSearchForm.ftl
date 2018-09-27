<#assign extraSearchTR>
	<tr>
	     <td class="infoTitle"><@msg.message key="course.week"/>:</td>
	     <td>
		     <select name="courseActivity.time.week" value="${RequestParameters["courseActivity.time.week"]?if_exists}" style="width:100px">
		     	<option value=""><@bean.message key="common.all"/></option>
		     	<#list weeks as week>
		     	<option value=${week.id}><@i18nName week/></option>
		     	</#list>
		     </select>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@msg.message key="course.unit"/>:</td>
	     <td>
		     <select name="courseActivity.time.startUnit" value="${RequestParameters["courseActivity.time.startUnit"]?if_exists}" style="width:100px">
		     	<option value=""><@bean.message key="common.all"/></option>
		     	<#list 1..14 as unit>
		     	<option value=${unit}>${unit}</option>
		     	</#list>
		     </select>
	     </td>
	</tr>
    <tr>
     <td class="infoTitle" style="width:100%"><@msg.message key="course.affirmState"/>:</td>
     <td>
        <select name="task.isConfirm" style="width:100px" value="${RequestParameters["task.isConfirm"]?if_exists}">
           <option value=""><@bean.message key="common.all"/></option>
           <option value="1"><@bean.message key="action.affirm"/></option>
           <option value="0"><@msg.message key="action.negate"/></option>
        </select>
     </td>
    </tr>
    <tr>
     <td class="infoTitle"><@msg.message key="course.arrangeState"/>:</td>
     <td>
        <select name="task.arrangeInfo.isArrangeComplete" style="width:100px" value="${RequestParameters["task.arrangeInfo.isArrangeComplete"]?if_exists}">
           <option value=""><@bean.message key="common.all"/></option>
           <option value="1"><@msg.message key="course.beenArranged"/></option>
           <option value="0"><@msg.message key="course.noArrange"/></option>
        </select>
     </td>
    </tr>
    <tr>
    	<td><@msg.message key="entity.schoolDistrict"/>:</td>
    	<td><@htm.i18nSelect datas=schoolDistricts selected=RequestParameters["task.arrangeInfo.schoolDistrict.id"]?default("") name="task.arrangeInfo.schoolDistrict.id" style="width:100%"><option value=""><@msg.message key="common.all"/></option></@></td>
    </tr>
    <tr>
    	<td>计划人数:</td>
    	<td><input type="text" name="planStdCountStart" value="${RequestParameters["planStdCountStart"]?if_exists}" maxlength="3" style="width:30px"/>&nbsp;-&nbsp;<input type="text" name="planStdCountEnd" value="" maxlength="3" style="width:30px"/></td>
    </tr>
    <tr>
    	<td><@msg.message key="course.factNumberOf"/>:</td>
    	<td><input type="text" name="stdCountStart" value="${RequestParameters["stdCountStart"]?if_exists}" maxlength="3" style="width:30px"/>&nbsp;-&nbsp;<input type="text" name="stdCountEnd" value="" maxlength="3" style="width:30px"/></td>
    </tr>
</#assign>
<#assign extraSearchTR = extraSearchTR + extraSearchTR_other?if_exists/>
<#include "/pages/course/taskBasicSearchForm.ftl"/> 