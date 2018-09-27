<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body>
	<#assign labInfo><B><#if (electParams.id)?exists><@bean.message key="action.new"/><#else><@bean.message key="action.modify"/></#if><@bean.message key="entity.electParams"/></B></#assign>
	<#include "/templates/back.ftl"/>
  	<table width="85%" align="center" class="formTable">
     	<form name="electParamsForm" action="electParams.do?method=save&hold=true" method="post" onsubmit="return false;">
	   	<tr class="darkColumn">
	     	<td align="center" colspan="4"><@bean.message key="entity.electParams"/> <@bean.message key="common.baseInfo"/></td>
	   	</tr>
	   <tr>
	     <input type="hidden" value="${(electParams.id)?if_exists}" name="electParams.id"/>
	     <input type="hidden" value="${(electParams.calendar.id)?if_exists}" name="electParams.calendar.id"/>
	     <input type="hidden" value="${(RequestParameters["electParams.calendar.id"])?if_exists}" name="calendar.id"/>
	     <td class="title" width="25%" id="f_turn">&nbsp;<@bean.message key="attr.electTurn"/><font color="red">*</font>：</td>
	     <td>
	     	<input type="text" name="electParams.turn" maxlength="5" value="${(electParams.turn)?if_exists}"/>
	     </td>
       	 <td class="title" width="25%" >&nbsp;<@bean.message key="attr.electState"/>是否开放<font color="red">*</font>：</td>
	     <td><@htm.select2 hasAll=false name="electParams.isOpenElection" style="width:100px" selected=(electParams.isOpenElection?string("1","0"))?default("")/></td>
	   </tr>
       <tr>
	   	 <td class="darkColumn" width="25%" id="f_name" colspan="4">&nbsp;<@bean.message key="attr.electParamsForStd"/>：</td>
       </tr>
       <tr>
         <td class="title" width="25%" id="f_enrollTurns">&nbsp;<@bean.message key="attr.enrollTurn"/>：</td>
 	     <td colspan="3">
 	     	<input type="text" name="enrollTurns" maxlength="30" value="<#list (electParams.enrollTurns)?if_exists as enrollTurn>${enrollTurn},</#list>"/>
 	     	多个所在年级之间用","隔开
 	     </td>
       </tr>
     <tr>
         <td class="title" width="25%" id="f_stdTypeIds">&nbsp;<@bean.message key="entity.studentType"/><font color="red">*</font>：</td>
         <td colspan="3">
         <div id="stdTypesDiv" style='display: block'>
            <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
	 	     <td>
		 	     <input type="hidden" name="stdTypeIds" value="<#list (electParams.stdTypes)?if_exists as stdType>${stdType.id},</#list>"/>
		 	     <input type="text" readonly name="stdTypeNames" value="<#list (electParams.stdTypes)?if_exists as stdType><@i18nName stdType/>,</#list>" style="width:80%" maxlength="20"/>
		 	     <input type="button" value="<@bean.message key="entity.studentType"/>" onclick="editList('stdType')" class="buttonStyle"/>
	 	     </td>
	 	     </tr>
	 	     </table>
	 	 </div>
 	     <div id="stdTypeListDiv" style='display:none'>
 	     <table width="100%" cellpadding="0" cellspacing="0">
 	       <tr>
 	     	<td>
 	     	    <select id="stdTypeListSelect" multiple size="10">
 	     	        <#list stdTypeList as stdType>
 	     	           <option value=${stdType.id}><@i18nName stdType/></option>
 	     	        </#list>
 	     	    </select>
	 	 	    <input type="button" value="<@bean.message key="action.confirm"/>" onclick="setList('stdType')" class="buttonStyle"/>
 	    	 </td>
 	    	</tr>
 	       </table>
 	     </div>
 	     </td>
       </tr> 
       
       <tr>
         <td class="title" width="25%" id="f_departIds">&nbsp;<@bean.message key="entity.college"/><font color="red">*</font>：</td> 
         <td colspan="3">
         <div id="departsDiv" style='display: block'>
            <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
	 	     <td>
		 	     <input type="hidden" name="departIds" value="<#list (electParams.departs)?if_exists as depart>${depart.id},</#list>"/>
		 	     <input type="text" readonly name="departNames" maxlength="20" value="<#list (electParams.departs)?if_exists as depart><@i18nName depart/>,</#list>" style="width:80%"/>
		 	     <input type="button" value="<@bean.message key="entity.college"/>" onclick="editList('depart')" class="buttonStyle"/>
	 	     </td>
	 	     </tr>
	 	     </table>
	 	 </div>
	 	 
 	     <div id="departListDiv"  style='display:none'>
 	     <table width="100%" cellpadding="0" cellspacing="0">
 	       <tr>
 	     	<td>
 	     	    <select id="departListSelect" multiple size="10">
 	     	        <#list departmentList as depart>
 	     	           <option value=${depart.id}><@i18nName depart/></option>
 	     	        </#list>
 	     	    </select>
	 	 	    <input type="button" value="<@bean.message key="action.confirm"/>" onclick="setList('depart')" class="buttonStyle"/>
 	    	 </td>
 	    	</tr>
 	       </table>
 	     </div>
 	     </td>
       </tr>
       <tr>
         <td class="title" width="25%" id="f_majorIds">&nbsp;<@bean.message key="entity.speciality"/>(可选)：</td>
         <td colspan="3">
         <div id="majorsDiv" style='display: block'>
            <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
	 	     <td>
		 	     <input type="hidden" name="majorIds" value="<#list (electParams.majors)?if_exists as major>${major.id},</#list>"/>
		 	     <input type="text" readonly name="majorNames" maxlength="20" value="<#list (electParams.majors)?if_exists as major><@i18nName major/>,</#list>" style="width:80%"/>
		 	     <input type="button" value="<@bean.message key="entity.speciality"/>" onclick="editList('major')" class="buttonStyle"/>
	 	     </td>
	 	     </tr>
	 	     </table>
	 	 </div>
	 	 
 	     <div id="majorListDiv" style='display:none'>
 	     <table width="100%" cellpadding="0" cellspacing="0">
 	       <tr>
 	     	<td>
 	     	    <select id="majorListSelect" multiple size="10">
 	     	        <option value="">...</option>
 	     	        <#list majors as major>
 	     	           <option value=${major.id}><@i18nName major/></option>
 	     	        </#list>
 	     	    </select>
	 	 	    <input type="button" value="<@bean.message key="action.confirm"/>" onclick="setList('major')" class="buttonStyle"/>
 	    	 </td>
 	    	</tr>
 	       </table>
 	     </div>
 	     </td>
       </tr>

       <tr>
         <td class="title" width="25%" id="f_majorFieldIds">&nbsp;<@bean.message key="entity.specialityAspect"/>(可选)：</td>
         <td colspan="3">
         <div id="majorFieldsDiv" style='display: block'>
            <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
	 	     <td>
		 	     <input type="hidden" name="majorFieldIds" value="<#list (electParams.majorFields)?if_exists as majorField>${majorField.id},</#list>"/>
		 	     <input type="text" readonly name="majorFieldNames" maxlength="20" value="<#list (electParams.majorFields)?if_exists as majorField><@i18nName majorField/>,</#list>" style="width:80%"/>
		 	     <input type="button" value="<@bean.message key="entity.specialityAspect"/>" onclick="editList('majorField')" class="buttonStyle"/>
	 	     </td>
	 	     </tr>
	 	     </table>
	 	 </div>
	 	 
 	     <div id="majorFieldListDiv" style='display:none'>
 	     <table width="100%" cellpadding="0" cellspacing="0">
 	       <tr>
 	     	<td>
 	     	    <select id="majorFieldListSelect" multiple size="10">
 	     	        <option value="">...</option>
 	     	        <#list majorFields as majorField>
 	     	           <option value=${majorField.id}><@i18nName majorField/></option>
 	     	        </#list>
 	     	    </select>
	 	 	    <input type="button" value="<@bean.message key="action.confirm"/>" onclick="setList('majorField')" class="buttonStyle"/>
 	    	 </td>
 	    	</tr>
 	       </table>
 	     </div>
 	     </td>
       </tr>
        <tr>
            <td class="title" width="25%" id="f_courseTypeIds">&nbsp;允许非当轮可退课程类别(可选)：</td> 
            <td colspan="3">
                <div id="courseTypesDiv" style='display: block'>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <input type="hidden" name="courseTypeIds" value="<#list electParams.notCurrentCourseTypes as courseType>${courseType.id},</#list>"/>
                                <input type="text" readonly name="courseTypeNames" maxlength="20" value="<#list electParams.notCurrentCourseTypes as courseType>${courseType.name},</#list>" style="width:80%"/>
                                <input type="button" value="课程类别" onclick="editList('courseType')" class="buttonStyle"/>
                            </td>
                        </tr>
                    </table>
                </div>
                
                <div id="courseTypeListDiv" style='display:none'>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <select id="courseTypeListSelect" multiple size="10">
                                    <option value="">...</option>
                                    <#list courseTypes as courseType>
                                    <option value=${courseType.id}>${courseType.name}</option>
                                    </#list>
                                </select>
                                <input type="button" value="确认" onclick="setList('courseType')" class="buttonStyle"/>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
		<tr>
            <td class="title" width="25%" id="f_studentStateIds">&nbsp;允许可退课的学生学籍状态：</td> 
            <td colspan="3">
                <div id="studentStatesDiv" style='display: block'>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <input type="hidden" name="studentStateIds" value="<#list electParams.studentStates ?if_exists as studentState>${studentState.id},</#list>"/>
                                <input type="text" readonly name="studentStateNames" maxlength="20" value="<#list electParams.studentStates as studentState>${studentState.name},</#list>" style="width:80%"/>
                                <input type="button" value="学籍状态" onclick="editList('studentState')" class="buttonStyle"/>
                            </td>
                        </tr>
                    </table>
                </div>
                
                <div id="studentStateListDiv" style='display:none'>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <select id="studentStateListSelect" multiple size="10">
                                    <option value="">...</option>
                                    <#list studentStates as studentState>
                                    <option value=${studentState.id}>${studentState.name}</option>
                                    </#list>
                                </select>
                                <input type="button" value="确认" onclick="setList('studentState')" class="buttonStyle"/>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
       <tr>
	   	 <td class="title">特殊学生(学号之间采用,分隔):</td>
	   	 <td colspan="3">
	     	 <textarea name="stdCodes" cols="45" rows="3"><#list electParams.stds as std>${std.code},</#list></textarea>
	     </td>
       </tr>
       <tr>
	   	 <td class="darkColumn" colspan="4">&nbsp;<@bean.message key="entity.electDateTime"/><font color="red">*</font>：</td>
       </tr>
       <tr>
	   	 <td class="title" width="25%" id="f_startAt">&nbsp;总体开始时间<font color="red">*</font>：</td>
	     <td>
	     	<input type="text" maxlength="19" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'electParams.endAt\')}'})"  id="electParams.startAt" name="electParams.startAt" value="${(electParams.startAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}" onfocus="calendar()"/>
	     </td>
	   	 <td class="title" width="25%" id="f_electStartAt">&nbsp;选课开始时间<font color="red">*</font>：</td>
	     <td>
	     	<input type="text" maxlength="19" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'electParams.electEndAt\')}',minDate:'#F{$dp.$D(\'electParams.startAt\')}'})"  name="electParams.electStartAt" id="electParams.electStartAt" value="${(electParams.electStartAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}"/>
	     </td>
       </tr>
       <tr>
	   	 <td class="title" width="25%" id="f_endAt">&nbsp;总体结束时间<font color="red">*</font>：</td>	
	     <td>
	       <input type="text" maxlength="19" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'electParams.startAt\')}'})" name="electParams.endAt" id="electParams.endAt"  value="${(electParams.endAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}" onfocus="calendar()"/>
	     </td>
	   	 <td class="title" width="25%" id="f_electEndAt">&nbsp;选课结束时间<font color="red">*</font>：</td>
	     <td>
	       <input type="text" maxlength="19" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'electParams.endAt\')}',minDate:'#F{$dp.$D(\'electParams.electStartAt\')}'})" id="electParams.electEndAt" name="electParams.electEndAt" value="${(electParams.electEndAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}"/>
	     </td>
       </tr>
       <tr>
	   	 <td class="darkColumn" width="25%"  colspan="4">&nbsp;<@bean.message key="entity.electMode"/><font color="red">*</font>：</td>
       </tr>
       <tr>
	   	 <td class="title" width="25%" >&nbsp;<@bean.message key="attr.isOverMaxAllowed"/><font color="red">*</font>：</td>	
	     <td>
	       	<select name="electParams.isOverMaxAllowed" style="width:100px">
				<option value="1" <#if (electParams.isOverMaxAllowed)?if_exists==true>selected</#if> ><@bean.message key="common.yes"/></option>
	            <option value="0" <#if (electParams.isOverMaxAllowed)?if_exists==false>selected</#if>><@bean.message key="common.no"/></option>
	        </select>
	     </td>
	   	 <td class="title" width="25%" >&nbsp;<@bean.message key="attr.isRestudyAllowed"/><font color="red">*</font>：</td>
	     <td>
	       	<select name="electParams.isRestudyAllowed" style="width:100px">
				<option value="1" <#if (electParams.isRestudyAllowed)?if_exists==true>selected</#if> ><@bean.message key="common.yes"/></option>
	            <option value="0" <#if (electParams.isRestudyAllowed)?if_exists=false>selected</#if>><@bean.message key="common.no"/></option>
	        </select>
	     </td>
       </tr> 
       <tr>
         <td class="title" width="25%" >&nbsp;退课时允许低于人数下限<font color="red">*</font>：</td>
	     <td>
	       	<select name="electParams.isUnderMinAllowed" style="width:100px">
				<option value="1" <#if (electParams.isUnderMinAllowed)?if_exists==true>selected</#if> ><@bean.message key="common.yes"/></option>
	            <option value="0" <#if (electParams.isUnderMinAllowed)?if_exists==false>selected</#if>><@bean.message key="common.no"/></option>
	        </select>
	     </td>
         <td class="title" width="25%" >&nbsp;重修是否限制选课范围<font color="red">*</font>：</td>
	     <td><@htm.select2 name="electParams.isCheckScopeForReSturdy" hasAll=false selected=((electParams.isCheckScopeForReSturdy)?default(false))?string("1","0") style="width:100px"/></td>
       </tr>
       <tr>
         <td class="title" width="25%" >&nbsp;<@bean.message key="attr.isCancelAnyTime"/><font color="red">*</font>：</td>
	     <td>
	       	<select name="electParams.isCancelAnyTime" style="width:100px">
				<option value="1" <#if (electParams.isCancelAnyTime)?if_exists==true>selected</#if> ><@bean.message key="common.yes"/></option>
	            <option value="0" <#if (electParams.isCancelAnyTime)?if_exists==false>selected</#if>><@bean.message key="common.no"/></option>
	        </select>
	     </td>
	   	 <td class="title" width="25%">&nbsp;是否考虑奖励学分<font color="red">*</font>：</td>
	     <td>
	       	<select name="electParams.isAwardCreditConsider" style="width:100px">
				<option value="1" <#if (electParams.isAwardCreditConsider)?if_exists==true>selected</#if> ><@bean.message key="common.yes"/></option>
	            <option value="0" <#if (electParams.isAwardCreditConsider)?if_exists==false>selected</#if>><@bean.message key="common.no"/></option>
	        </select>
	     </td>
       </tr>
       <tr>
	   	 <td class="title" width="25%">&nbsp;<@bean.message key="attr.isCheckEvaluation"/><font color="red">*</font>：</td>
	     <td>
	       	<select name="electParams.isCheckEvaluation" style="width:100px">
				<option value="1" <#if (electParams.isCheckEvaluation)?if_exists==true>selected</#if> ><@bean.message key="common.yes"/></option>
	            <option value="0" <#if (electParams.isCheckEvaluation)?if_exists==false>selected</#if>><@bean.message key="common.no"/></option>
	        </select>
	     </td>
         <td class="title">&nbsp;是否计划内课程<font color="red">*</font>：</td>
	     <td><@htm.select2 name="electParams.isInPlanOfCourse" hasAll=false selected=((electParams.isInPlanOfCourse)?default(true))?string("1","0") style="width:100px"/></td>
       </tr>
       <tr>
         <td class="title">&nbsp;是否限制校区<font color="red">*</font>：</td>
	     <td><@htm.select2 name="electParams.isSchoolDistrictRestrict" hasAll=false selected=((electParams.isSchoolDistrictRestrict)?default(false))?string("1","0") style="width:100px"/></td>
		 <td class="title" width="25%" id="f_floatCredit">&nbsp;教学班开课对象限制<font color="red">*</font>：</td>
	     <td><@htm.select2 name="electParams.isLimitedInTeachClass" hasAll=false selected=((electParams.isLimitedInTeachClass)?default(true))?string("1","0") style="width:100px"/></td>
       </tr>
       <tr>
		 <td class="title" width="25%" id="f_notice">&nbsp;选课协议<font color="red">*</font>：</td>
	     <td colspan="3">
	       <textarea name="electParams.notice.notice" cols="45" rows="4">${(electParams.notice.notice)?if_exists}</textarea>
	     </td>
       </tr>
	   <tr class="darkColumn">
	     <td colspan="6" align="center" >
	       <input type="button" value="<@bean.message key="action.submit"/>" name="saveButton" onClick="save(this.form)" class="buttonStyle"/>&nbsp;
	       <input type="reset" name="resetButton" value="<@bean.message key="action.reset"/>" class="buttonStyle"/>
	     </td>
	   </tr>
   </form>
  </table>
   
  <script language="javascript" >
   function save(form){
     var errorInfo="";
     if(form['enrollTurns'].value!=""){
         var enrollTurns = form['enrollTurns'].value.split(",");
         for(var i=0;i<enrollTurns.length;i++)
           if(enrollTurns[i]!=""&&!isYearMonth(enrollTurns[i])){
              errorInfo+=enrollTurns[i]+"格式不正确\n";
           }
     }
     //日期相等情况下，判断时间
     if(errorInfo!="") {alert(errorInfo);return;}
     var a_fields = {
         'electParams.turn':{'l':'<@bean.message key="attr.electTurn"/>','r':true,'f':'unsigned','t':'f_turn'},
         'enrollTurns':{'l':'<@bean.message key="error.enrollTurn"/>','r':false,'t':'f_enrollTurns', 'mx':30},
         
         'stdTypeIds':{'l':'<@bean.message key="entity.studentType"/>','r':true,'t':'f_stdTypeIds'},
         'departIds':{'l':'<@bean.message key="entity.college"/>','r':true,'t':'f_departIds'},
         'electParams.notice.notice':{'l':'注意事项','r':true,'t':'f_notice','mx':20000000000}
     };
 
     var v = new validator(form, a_fields, null);
     if (v.exec()) {
        form.submit();
     }
   }
   
   function editList(type){
       var listDiv= document.getElementById(type+'ListDiv');
       var div = document.getElementById(type+'sDiv');
       div.style.display="none";
       listDiv.style.display="block";
       var ids=document.electParamsForm[type+'Ids'].value;
       var select = document.getElementById(type+'ListSelect');
       
       for(var i=0;i<select.options.length;i++){
           if (select.options[i].value == "") {
           	continue;
           }
           select.options[i].selected = (null != ids && "" != ids && null != ("," + ids + ",").match("," + select.options[i].value + ",", "gi") && ("," + ids + ",").match("," + select.options[i].value + ",", "gi").length == 1);
       }
   }
   
   function setList(type){
       var departListDiv= document.getElementById(type+'ListDiv');
       var departsDiv = document.getElementById(type+'sDiv');
       departsDiv.style.display="block";
       departListDiv.style.display="none";
       var ids=",";
       var names="";
       var select = document.getElementById(type+'ListSelect');
       for(var i=0;i<select.options.length;i++){
           if(select.options[i].selected){
	           ids +=select.options[i].value +",";
	           names += select.options[i].innerHTML+",";
	       }
       }
       if (ids != ",") {
           document.electParamsForm[type+'Ids'].value=ids;
           document.electParamsForm[type+'Names'].value=names.substr(0,names.lastIndexOf(","));
       }
   }
   
   function isDateBefore(first,second){
       var firstYear = first.substring(0,4);
       var secondYear = second.substring(0,4);
       if (firstYear > secondYear) {
       	return false;
       } else if (firstYear < secondYear) {
       	return true;
       }

       var firstMonth = new Number(first.substring(first.indexOf('-')+1,first.lastIndexOf('-')));
       var secondMonth = new Number(second.substring(second.indexOf('-')+1,second.lastIndexOf('-')));

       if (firstMonth > secondMonth) {
       	return false;
       } else if (firstMonth < secondMonth) {
       	return true;
       }
       
       var firstDay = new Number(first.substring(first.lastIndexOf('-')+1));
       var secondDay = new Number(second.substring(second.lastIndexOf('-')+1));
       return firstDay <= secondDay;
   }
  </script>
</body>
<#include "/templates/foot.ftl"/>