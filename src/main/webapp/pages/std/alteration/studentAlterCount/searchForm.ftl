<#assign formElementWidth = "width:100px"/>
<#macro i18nSelectYear datas selected  extra...><select <#list extra?keys as attr>${attr}="${extra[attr]?html}" </#list>>
    <#nested>
    <#list datas as data>
       <option value="${data!}" <#if data?string=selected>selected</#if>>${data!}</option>
    </#list>
</select></#macro>
 <table width="100%">
	    <tr>
	      <td class="infoTitle" align="left" valign="bottom">
	       <img src="images/action/info.gif" align="top"/>
	          <B><@msg.message key="baseinfo.searchStudent"/></B>
	      </td>
	    </tr>
	    <tr>
	      <td colspan="8" style="font-size:0px">
	          <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
	      </td>
	   </tr>	
  </table>
  <table width="100%" class="searchTable" onkeypress="DWRUtil.onReturn(event, search)">
    <input type="hidden" name="pageNo" value="1"/>
    <input type="hidden" name="std_state" value="1"/>
    	<tr>
			<td class="title" id="f_alterationType">学年：</td>
			<td>
				<@i18nSelectYear id="f_mode" datas=calendars name="alterYearId" style="width:100px;" selected=(alterYear)?default("")?string>
				  <option value=""><@msg.message key="common.all"/></option>
				</@>
			</td>
        </tr>
    	<tr>
			<td class="title" id="f_alterationType">学期：</td>
			<td>
				<select id="f_mode" style="width:100px;" name="alterTerm">
				       <option value="1">1</option>
				       <option value="2">2</option>
				</select>
			</td>
        </tr>
    	<tr>
			<td class="title" id="f_alterationType">异动种类：</td>
			<td>
				<@htm.i18nSelect id="f_mode" datas=modes name="alteration.mode.id" style="width:100px;" selected=(alteration.mode.id)?default("")?string>
				  <option value=""><@msg.message key="common.all"/></option>
				</@>
			</td>
        </tr>
    	<tr>
	    <tr align="center" height="50px">
	     <td colspan="2">
		     <button style="width:60px" class="buttonStyle" onClick="search(1)"><@bean.message key="action.query"/></button>
	     </td>
	    </tr>
  </table>
<script>
    var sds = new StdTypeDepart3Select("std_stdTypeOfSpeciality","std_department","std_speciality","std_specialityAspect",true,true,true,true);
    sds.init(stdTypeArray,departArray);
    sds.firstSpeciality=1;
    function changeSpecialityType(event){
       var select = getEventTarget(event);
       sds.firstSpeciality=select.value;
       fireChange($("std_department"));
    }
</script> 
