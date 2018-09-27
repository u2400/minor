<#assign extraSearchTR>
    <tr>
    	<td>计划人数:</td>
    	<td><input type="text" name="planStdCountStart" value="" maxlength="3" style="width:30px"/>&nbsp;-&nbsp;<input type="text" name="planStdCountEnd" value="" maxlength="3" style="width:30px"/></td>
    </tr>
    <tr>
    	<td><@msg.message key="course.factNumberOf"/>:</td>
    	<td><input type="text" name="stdCountStart" value="" maxlength="3" style="width:30px"/>&nbsp;-&nbsp;<input type="text" name="stdCountEnd" value="" maxlength="3" style="width:30px"/></td>
    </tr>
    <tr>
       <td class="infoTitle">是否排完:</td>
       <td class="infoTitle">
         <select name="task.arrangeInfo.isArrangeComplete" style="width:60px">
             <option value="1" selected><@bean.message key="common.alreadyArranged"/></option>
             <option value="0"><@bean.message key="common.notArranged"/></option>
             <option value=""><@bean.message key="common.all"/></option>
             
         </select>
       </td>
    </tr>
    <tr>
       <td class="infoTitle"  >允许退课:</td>
       <td class="infoTitle">
         <select name="task.electInfo.isCancelable" style="width:60px">
             <option value="" selected><@bean.message key="common.all"/></option>
             <option value="1"><@bean.message key="common.yes"/></option>
             <option value="0"><@bean.message key="common.no"/></option>
         </select>
       </td>
    </tr>
   	<tr>
   		<td>指定学生</td>
   		<td>
   			<select name="stdState">
   				<option value="">...</option>
   				<option value="2">需要指定</option>
   			</select>
   		</td>
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
</#assign>
<#include "/pages/course/taskBasicSearchForm.ftl"/> 