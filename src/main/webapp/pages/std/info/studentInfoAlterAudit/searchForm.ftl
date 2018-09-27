<table width="100%">
    <tr valign="bottom">
        <td class="infoTitle" style="font-size:10pt;text-align:left;font-weight:bold" colspan="2"><img src="images/action/info.gif" align="top"/>查询条件(模糊匹配)</td>
    </tr>
    <tr style="font-size:0pt">
        <td colspan="2"><img src="images/action/keyline.gif" width="100%" height="2" align="top"/></td>
    </tr>
    <tr>
        <td width="45%">学号:</td>
        <td><input type="text" name="apply.student.code" value="" maxlength="30" style="width:100px"/></td>
    </tr>
    <tr>
        <td>姓名:</td>
        <td><input type="text" name="apply.student.name" value="" maxlength="30" style="width:100px"/></td>
    </tr>
    <tr>
        <td>年级:</td>
        <td><input type="text" name="apply.student.enrollYear" value="" maxlength="7" style="width:100px"/></td>
    </tr>
    <tr>
        <td id="f_className">班级名称:</td>
	   	<td>
	   		<input type="text" name="adminClassName" style="width:100px" value="${RequestParameters['adminClassName']?if_exists}" />
	    </td>
    </tr>
    <tr> 
        <td><@bean.message key="entity.studentType"/>:</td>
        <td>
            <select id="stdTypeOfSpeciality" name="apply.student.type.id" style="width:100px;">
                <option value="${RequestParameters['student.type.id']?if_exists}" selected><@bean.message key="filed.choose"/></option>
            </select>
        </td>
    </tr>
    <tr>
        <td><@bean.message key="common.college"/>:</td>
        <td>
            <select id="department" name="apply.student.department.id" style="width:100px;">
                <option value="" selected><@bean.message key="filed.choose"/>...</option>
            </select>
        </td>
    </tr>
    <tr>
        <td><@bean.message key="entity.speciality"/>：</td>
        <td>
            <select id="speciality" name="apply.student.firstMajor.id" style="width:100px;">
                <option value="" selected><@bean.message key="filed.choose"/>...</option>
            </select>
        </td>
    </tr>
    <tr>
        <td><@bean.message key="entity.specialityAspect"/>：</td>
        <td>
            <select id="specialityAspect" name="apply.student.firstAspect.id" style="width:100px;">
                <option value="" selected><@bean.message key="filed.choose"/>...</option>
            </select>
        </td>
    </tr>
    
    <tr valign="top">
 		<td id="f_auditStatus"><@bean.message key="attr.graduate.auditStatus"/></td>
 		<td>
	   		<select name="apply.passed"  OnMouseOver="changeOptionLength(this);">
	   			<option value="">...</option>
				<option value="1" selected><@bean.message key="attr.graduate.outsideExam.auditPass"/></option>
				<option value="0" selected><@bean.message key="attr.graduate.outsideExam.noAuditPass"/></option>
				<option value="null"selected><@bean.message key="attr.graduate.outsideExam.nullAuditPass"/></option>
			</select>
 		</td>
  	</tr>
  	
    <tr height="50">
        <td colspan="2" align="center"><button onclick="search()">查询</button></td>
    </tr>
</table>
<#assign stdTypeNullable = true/>
<#include "/templates/stdTypeDepart3Select.ftl"/>
