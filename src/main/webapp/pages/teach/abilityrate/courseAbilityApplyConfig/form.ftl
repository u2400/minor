<#include "/templates/head.ftl"/>
 <script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
 <script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
 <body> 
 <#assign labInfo>英语升降级报名设置</#assign>
 <#include "/templates/back.ftl"/>
    <table width="90%" align="center" class="formTable">
     <form action="" name="actionForm" method="post" onsubmit="return false;">
       <@searchParams/>
	   <tr class="darkColumn">
	     <td align="center" colspan="2">英语升降级报名设置</td>
	   </tr>
	   <tr>
	     <td class="title" width="20%" id="f_grade"><font color="red">*</font>年级:</td>
	     <td><input type="text" style="width:280px" maxlength="6" name="config.grade" value='${(config.grade)!}'/></td>
	   </tr>
	   <tr>
	     <td class="title" id="f_beginAt"><font color="red">*</font><@bean.message key="field.soeType.startTime"/>:</td>
	     <td><input type="text" style="width:300px" maxlength="19" class="Wdate" name="config.beginAt" id="config.beginAt" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'config.endAt\')}'})" value='<#if (config.beginAt)?exists>${(config.beginAt)?string("yyyy-MM-dd HH:mm:ss")}</#if>'/></td>
	   </tr>
	   <tr>
	     <td class="title" id="f_endAt"><font color="red">*</font><@bean.message key="field.soeType.endTime"/>:</td>
	     <td><input type="text" style="width:300px" maxlength="19" class="Wdate"  name="config.endAt" id="config.endAt"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'config.beginAt\')}'})"  value='<#if (config.endAt)?exists>${config.endAt?string("yyyy-MM-dd HH:mm:ss")}</#if>'/></td>
	   </tr>
	   <tr>
	     <td class="title"><font color="red">*</font>参与报名的等级:</td>
	     <td>
	     <table  bordercolor="#006CB2" class="formTable" cellpadding="0" cellspacing="0">
	          <tr>
	           <td><br>
	            <div align="center">英语等级列表</div>&nbsp;
	            <select name="ability" MULTIPLE size="10" onDblClick="JavaScript:moveSelectedOption(this.form['ability'], this.form['freeAbility'])" style="width:250px" style="background-color:#CCCCCC">
	 			<#list abilities?if_exists as ability>
	  				<option value="${ability.id}"><@i18nName ability/></option>
		        </#list>
	            </select><br>
	           </td>
	           <td align="center" valign="middle">
	            <br><br>
	            &nbsp;<input OnClick="JavaScript:moveSelectedOption(this.form['ability'], this.form['freeAbility'])" type="button" value="&gt;&gt;" class="buttonStyle" style="width:35px;"/> &nbsp;
	            <br><br>
	            &nbsp;<input OnClick="JavaScript:moveSelectedOption(this.form['freeAbility'], this.form['ability'])" type="button" value="&lt;&lt;" class="buttonStyle" style="width:35px;"> &nbsp;
	            <br>
	           </td>
	           
	           <td align="center" class="normalTextStyle">
	            <div align="center">参与报名的等级列表</div>&nbsp;
	            <select name="freeAbility" MULTIPLE size="10" style="width:250px;" onDblClick="JavaScript:moveSelectedOption(this.form['freeAbility'], this.form['ability'])" style="background-color:#CCCCCC">
	           		<#list (config.abilities)?if_exists as ability>
	  				<option value="${ability.id}"><@i18nName ability/></option>
			        </#list> 
	            </select>&nbsp;
	           </td> 
	        </tr>
	     </table>
	     </td>
	   </tr>	
	   <tr>
	     <td class="title" id="f_upgradeNotice"><font color="red">*</font>学生申请升级时的提示内容:</td>
	     <td>
			<textarea  cols="80" rows="4" name="config.upgradeNotice">${(config.upgradeNotice)!}</textarea>	         
	     </td>
	   </tr>
	   <tr>
	     <td class="title" id="f_degradeNotice"><font color="red">*</font>学生申请降级时的提示内容:</td>
	     <td>
			<textarea  cols="80" rows="4" name="config.degradeNotice">${(config.degradeNotice)!}</textarea>	         
	     </td>
	   </tr>
	   <tr class="darkColumn" align="center">
	     <td colspan="2">
		   <button onClick="doAction(this.form)"> <@bean.message key="system.button.submit"/></button>
           <input type="hidden" name="abilityIds"/>
           <input type="hidden" name="config.calendar.id"value="${config.calendar.id}"/> 
           <input type="hidden" name="config.id"value="${(config.id)?default('')}"/>
	       <input type="reset" name="reset1" value="<@bean.message key="system.button.reset"/>" class="buttonStyle"/>
	     </td>
	   </tr>
	   </table>
     </td>
   </tr>
   </form>
   </table>
 <script language="javascript"/>
    function doAction(form){
     var a_fields = {
         'config.beginAt':{'l':'<@bean.message key="field.soeType.startTime"/>', 'r':true, 't':'f_beginAt'},
         'config.endAt':{'l':'<@bean.message key="field.soeType.endTime"/>', 'r':true, 't':'f_endAt'},
         'config.grade':{'l':'年级', 'r':true, 't':'f_grade'},
         'config.upgradeNotice':{'l':'学生申请升级时的提示内容', 'r':true, 't':'f_upgradeNotice'},
         'config.degradeNotice':{'l':'学生申请降级时的提示内容', 'r':true, 't':'f_degradeNotice'}
     };
     var v = new validator(form , a_fields, null);
     if (v.exec()) {
     	if (form['config.beginAt'].value > form['config.endAt'].value) {
     		alert("<@bean.message key="field.soeType.startTime"/>不能超过<@bean.message key="field.soeType.endTime"/>！");
     		return;
     	}
	    form['abilityIds'].value = getAllOptionValue(form.freeAbility); 
	    form.action="?method=save";
        form.submit();
     }
    }
 </script>
</body>
<#include "/templates/foot.ftl"/>