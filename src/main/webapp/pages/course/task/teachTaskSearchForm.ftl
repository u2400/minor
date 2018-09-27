 <table width="100%">
	    <tr>
	      <td class="infoTitle" align="left" valign="bottom">
	       <img src="images/action/info.gif" align="top"/>
	          <B><@msg.message key="action.advancedQuery.like"/></B>      
	      </td>
	    </tr>
	    <tr>
	      <td colspan="8" style="font-size:0px">
	          <img src="images/action/keyline.gif" height="2" width="100%" align="top">
	      </td>
        </tr>
	  </table>
	  <table class="searchTable" onkeypress="DWRUtil.onReturn(event, search)">	  
	    <tr> 
	     <td class="infoTitle"><@bean.message key="attr.taskNo"/>:</td>
	     <td><input name="task.seqNo" type="text" value="" style="width:100px" maxlength="32"/></td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@bean.message key="attr.courseNo"/>:</td>
	     <td><input name="task.course.code" type="text" value="" style="width:100px" maxlength="32"/></td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@bean.message key="attr.courseName"/>:</td>
	     <td><input type="text" name="task.course.name" value="" style="width:100px" maxlength="20"/></td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@bean.message key="entity.courseType"/>:</td>
	     <td><select name="task.courseType.id"  style="width:100px">
		     	<option value=""><@bean.message key="common.all"/></option>
		     	<#list sort_byI18nName(courseTypes) as courseType>
                <option value=${courseType.id}><@i18nName courseType/></option>
		     	</#list>
		     </select>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@bean.message key="attr.teach4Depart"/>:</td>
	     <td>
		     <select name="task.teachClass.depart.id" value="" style="width:100px">
		     	<option value=""><@bean.message key="common.all"/></option>
		     	<#list (departmentList)?sort_by("code") as depart>
                <option value=${depart.id}><@i18nName depart/></option>
		     	</#list>
		     </select>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@bean.message key="attr.teachDepart"/>:</td>
	     <td>
		     <select name="task.arrangeInfo.teachDepart.id" value="" style="width:100px">
		     	<option value=""><@bean.message key="common.all"/></option>
		     	<#list (teachDepartList)?sort_by("code") as teachDepart>
		     	<option value=${teachDepart.id}><@i18nName teachDepart/></option>
		     	</#list>
		     </select>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@bean.message key="entity.teacher"/>:</td>
	     <td><input type="text" name="teacher.name" id="teacher.name" value="" style="width:65px" maxlength="20"/><input name="hasTeacher" id="hasTeacher" type="checkbox" value="Y" onClick="displayDiv('teacher.name', 'hasTeacher')"/>空
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@bean.message key="attr.enrollTurn"/>:</td>
	     <td><input type="text" name="task.teachClass.enrollTurn" value="" maxlength="7" style="width:100px"/></td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@bean.message key="entity.studentType"/>:</td>
	     <td><@htm.i18nSelect datas=calendarStdTypes selected="" name="task.teachClass.stdType.id"  style="width:100px">
	           	<option value=""><@bean.message key="common.all"/></option>
		     </@>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@msg.message key="attr.credit"/>:</td>
	     <td><input type="text" name="task.course.credits" value="" style="width:100px" maxlength="3"/>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@msg.message key="course.weekHours"/>:</td>
	     <td><input type="text" name="task.arrangeInfo.weekUnits" value="" style="width:100px" maxlength="3"/></td>
	    </tr>
		<tr>
		     <td class="infoTitle"><@msg.message key="course.weekFrom"/>:</td>
		     <td><input name="task.arrangeInfo.weekStart" style="width:100px" value="" maxlength="2"/></td>
		</tr>
		<tr>
		     <td class="infoTitle">组名:</td>
		     <td><input name="task.taskGroup.name" style="width:100px" value="" maxlength="50"/></td>
		</tr>
	    <tr>
	     <td class="infoTitle"><@bean.message key="attr.GP"/>:</td>
	     <td>
	        <select name="task.requirement.isGuaPai" style="width:100px">
	           <option value=""><@bean.message key="common.all"/></option>
	           <option value="1"><@bean.message key="common.yes"/></option>
	           <option value="0"><@bean.message key="common.no"/></option>
	        </select>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@msg.message key="course.week"/>:</td>
	     <td>
		     <select name="courseActivity.time.week" value="" style="width:100px">
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
		     <select name="courseActivity.time.startUnit" value="" style="width:100px">
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
        <select name="task.isConfirm" style="width:100px">
           <option value=""><@bean.message key="common.all"/></option>
           <option value="1"><@bean.message key="action.affirm"/></option>
           <option value="0"><@msg.message key="action.negate"/></option>
        </select>
     </td>
    </tr>
    <tr>
    	<td><@msg.message key="entity.schoolDistrict"/>:</td>
    	<td><@htm.i18nSelect datas=schoolDistricts selected="" name="task.arrangeInfo.schoolDistrict.id" style="width:100%"><option value=""><@msg.message key="common.all"/></option></@></td>
    </tr>
    <tr>
    	<td>计划人数:</td>
    	<td><input type="text" name="planStdCountStart" value="" maxlength="3" style="width:30px"/>&nbsp;-&nbsp;<input type="text" name="planStdCountEnd" value="" maxlength="3" style="width:30px"/></td>
    </tr>
    <tr>
    	<td><@msg.message key="course.factNumberOf"/>:</td>
    	<td><input type="text" name="stdCountStart" value="" maxlength="3" style="width:30px"/>&nbsp;-&nbsp;<input type="text" name="stdCountEnd" value="" maxlength="3" style="width:30px"/></td>
    </tr>
    <tr>
       <td>设置上限:</td>
         <td>
            <select name="task.teachClass.isUpperLimit" value="${RequestParameters["task.teachClass.isUpperLimit"]?if_exists}" style="width:100px">
               <option value=""><@bean.message key="common.all"/></option>
               <option value="1"><@bean.message key="common.yes"/></option>
               <option value="0"><@bean.message key="common.no"/></option>
            </select>
         </td>
    </tr>
	<tr align="center">
	   <td colspan="2">
	     <button onClick="search();" accesskey="Q" class="buttonStyle" style="width:80px">
	       <@bean.message key="action.query"/>(<U>Q</U>)
	     </button>
	    </td>
	   </tr>
	  </table>
<script language="javascript">
	  function displayDiv(divId, checkBoxId) {
            document.getElementById(divId).disabled = $(checkBoxId).checked ? "true" : "";
        }
 </script>