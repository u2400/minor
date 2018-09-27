<div style="display:block;" id="view2">
<#assign extraSearchTR_other>
    <tr>
        <td>差额人数:</td>
        <td style="font-family:宋体"><input type="text" name="capacityValueB" value="${RequestParameters["capacityValueB"]?if_exists}" maxlength="4" style="width:40px"/>&nbsp;-&nbsp;<input type="text" name="capacityValueE" value="${RequestParameters["capacityValueE"]?if_exists}" maxlength="4" style="width:40px"/></td>
    </tr>
    <tr>
        <td>指定学生</td>
        <td>
            <select name="stdState" style="width:100px">
                <option value=""><@bean.message key="common.all"/></option>
                <option value="2">需要指定</option>
            </select>
        </td>
    </tr>
    <tr>
        <td class="infoTitle">是否必修:</td>
        <td>
            <select name="task.courseType.isCompulsory" style="width:100px" value="${RequestParameters["task.courseType.isCompulsory"]?if_exists}">
               <option value=""><@bean.message key="common.all"/></option>
               <option value="1">是</option>
               <option value="0">否</option>
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
<#include "/pages/course/taskSearchForm.ftl"/>
</div>