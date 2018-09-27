<#assign formElementWidth = "width:100px"/>
<table width="100%" class="searchTable">
	<tr class="infoTitle" valign="top" style="font-size:8pt">
		<td colspan="2" style="text-align:left;text-valign:bottom;font-weight:bold"><img src="images/action/info.gif" align="top"/>&nbsp;查询项</td>
    </tr>
    <tr>
      	<td style="font-size:0pt" colspan="2"><img src="images/action/keyline.gif" height="2" width="100%" align="top"/></td>
    </tr>
    <tr>
		<td class="infoTitle">学号:</td>
		<td>
		<input type="text" name="apply.std.code"  style="width:100px;"/>
	 	</td>
	</tr>
	<tr>
		<td class="infoTitle">姓名:</td>
		<td>
		<input type="text" name="apply.std.name"  style="width:100px;"/>
	 	</td>
	</tr>
    <tr>
		<td class="infoTitle">年级:</td>
		<td>
		<input type="text" name="apply.std.grade"  style="width:100px;"/>
	 	</td>
	</tr>
	<tr>
		<td id="f_studentType"><@bean.message key="entity.studentType"/></td>
		<td>
			<select id="stdTypeOfSpeciality" name="apply.std.type.id" style="${formElementWidth}">
				<option value="${RequestParameters['apply.std.type.id']?if_exists}">...</option>
			</select> 
		</td>
	</tr>
	<tr>
		<td id="f_departmenty"><@bean.message key="common.college"/></td>
		<td>
			<select id="department" name="apply.std.department.id" style="${formElementWidth}">
				<option value="${RequestParameters['apply.std.department.id']?if_exists}">...</option>
			</select>
		</td>
	</tr>
	<tr>
		<td id="f_speciality"><@bean.message key="entity.speciality"/></td>
		<td>
			<select id="speciality" name="apply.std.major.id" style="${formElementWidth}">
				<option value="${RequestParameters['apply.std.major.id']?if_exists}">...</option>
			</select>
		</td>
	</tr>
	<tr style="display:none">
		<td id="f_specialityAspect"><@bean.message key="entity.specialityAspect"/></td>
	    <td>
        	<select id="specialityAspect" name="apply.std.aspect.id" style="${formElementWidth}">
         		<option value="${RequestParameters['apply.std.aspect.id']?if_exists}">...</option>
           	</select>
        </td>
	</tr>
    <tr>
		<td class="infoTitle">奖项:</td>
		<td>
		<select name="apply.award.id"  style="width:100px;">
		<option value="">...</option>
		<#list setting.awards as award>
		<option value="${award.id}">${award.name}</option>
		</#list>
		</select>
	 	</td>
	</tr>
	<tr align="center" height="50px">
		<td colspan="2">
		    <button onClick="search()" accesskey="Q" class="buttonStyle" style="width:60px">
		       <@bean.message key="action.query"/>(<U>Q</U>)
		 	</button>
	    </td>
	</tr>
</table>
<script>
    var sds = new StdTypeDepart3Select("stdTypeOfSpeciality","department","speciality","specialityAspect", true, true, true, true);    
    sds.init(stdTypeArray,departArray);
    sds.firstSpeciality=1;
</script>
