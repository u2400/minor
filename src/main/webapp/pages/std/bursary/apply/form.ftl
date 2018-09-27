<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<table id="myBar" width="100%"></table>

    <form action="bursarySetting.do?method=apply" name="settingForm" method="post" onsubmit="return false;">
      <input type="hidden" name="apply.id" value="${(apply.id)?if_exists}">
      <input type="hidden" name="apply.award.id" value="${(apply.award.id)?if_exists}">
      <input type="hidden" name="apply.setting.id" value="${(apply.setting.id)?if_exists}">
      <input type="hidden" name="apply.gradeAchivement.id" value="${(apply.gradeAchivement.id)?if_exists}">
      
      <table width="90%" align="center" class="formTable">
       <tr class="darkColumn">
	    <td align="center" colspan="4">${award.name} 助学金申请</td>
	   </tr>
	   <tr>
	      <td>综合测评结果：</td>
	      <td><#if achivements?size=0>找不到您的综合测评数据
	          <#else>
	             <#assign achivement = achivements?first>
	             <#if achivement.confirmed>
	               ${achivement.score}
	             <#else>
	                 综合测评结果尚未公布,不影响助学金申请
	             </#if>
	          </#if>
	      </td>
	   </tr>
	   <#list award.subjects as subject>
	   <tr>
	     <td id="f_apply_subject_${subject.id}" width="20%"><#if subject.required><font color="red">*</font></#if>${subject.name}<#if subject.maxContentLength!=0>(限${subject.maxContentLength}个字)</#if>:</td>
	     <td width="80%">
	        <#if subject.maxContentLength==0>
	          <#list subject.options?split(";") as option>
	            <input type="radio" name="apply_subject_${subject.id}" <#if option==apply.getStatement(subject)!"__">checked="checked"</#if> value="${option}">${option}
	          </#list>
	        <#else>
	        <textarea rows="${(subject.maxContentLength/30)?int}" cols="100" name="apply_subject_${subject.id}">${apply.getStatement(subject)!}</textarea>
	        </#if>
	     </td>
	   </tr>
	   </#list>
	  <tr align="center" class="darkColumn">
      <td colspan="5">
          <button onclick="save(this.form,1)" class="buttonStyle">提交</button>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <button onclick="save(this.form,0)" class="buttonStyle">保存</button>
      </td>
     </tr>
   </table>
   </form>
<script>
    var bar = new ToolBar("myBar", "助学金申请", null, true, true);
    bar.setMessage('<@getMessage/>');
    bar.addBack();
    function save(form,submited){
	    var a_fields = {
	         <#list award.subjects as subject>
	         'apply_subject_${subject.id}':{'l':'${subject.name}', 'r':${subject.required?string("true","false")}, 't':'f_apply_subject_${subject.id}'<#if subject.maxContentLength!=0>,'mx':'${subject.maxContentLength}'</#if>}<#if subject_has_next>,</#if>
	         </#list>
	     };
	     var v = new validator(form , a_fields, null);
	     if (v.exec()) {
	        form.action="bursaryApply.do?method=apply&apply.submited="+submited
	        form.target = "_self";
	        form.submit();
	     }
     }
</script>
</body>
<#include "/templates/foot.ftl"/>
