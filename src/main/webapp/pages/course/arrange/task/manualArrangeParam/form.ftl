<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body>
	<#assign labInfo><B><#if (manualArrangeParam.id)?exists>院系排课开关修改<#else>院系排课开关添加</#if></B></#assign>
	<#include "/templates/back.ftl"/>
  	<table width="85%" align="center" class="formTable">
     	<form name="electParamsForm" action="manualArrangeParam.do?method=save&hold=true" method="post" onsubmit="return false;">
	   	 <input type="hidden" value="${(manualArrangeParam.id)?if_exists}" name="manualArrangeParam.id"/>
         <input type="hidden" value="${(manualArrangeParam.calendar.id)?default(RequestParameters["manualArrangeParam.calendar.id"]?if_exists)}" name="manualArrangeParam.calendar.id"/>
	   	<tr class="darkColumn">
	     	<td align="center" colspan="4">院系排课开关设置</td>
	   	</tr>
	   <tr>
         <td class="title">&nbsp;开关是否开放<font color="red">*</font>：</td>
         <td><@htm.select2 hasAll=false name="manualArrangeParam.isOpenElection" style="width:100px" selected=(manualArrangeParam.isOpenElection?string("1","0"))?default("")/></td>
         <td class="title">院系：</td>
         <td><@htm.i18nSelect datas=departments selected=(manualArrangeParam.department.id?string)?default("") name="manualArrangeParam.department.id" style="width:100px"><option value="">...</option></@>(不选为“通用”)</td>
       </tr>
       <tr>
	   	 <td class="darkColumn" colspan="4">&nbsp;排课时间<font color="red">*</font>：</td>
       </tr>
       <tr>
	   	 <td class="title" width="25%" id="f_startDate">&nbsp;<@bean.message key="attr.startDate"/><font color="red">*</font>：</td>
	     <td>
	     	<input type="text" maxlength="10" name="manualArrangeParam.startDate" value="${(manualArrangeParam.startDate?string("yyyy-MM-dd"))?if_exists}" onfocus="calendar()" style="width:100px"/>
	     </td>
	     <td class="title" width="25%" id="f_finishDate">&nbsp;<@bean.message key="attr.finishDate"/><font color="red">*</font>：</td>  
         <td>
           <input type="text" maxlength="10" name="manualArrangeParam.finishDate" value="${(manualArrangeParam.finishDate?string("yyyy-MM-dd"))?if_exists}" onfocus="calendar()" style="width:100px"/>
         </td>
       </tr>
       <tr>
         <td class="darkColumn" colspan="4">&nbsp;</td>
       </tr>
        <tr>
         <td class="title" width="25%" id="f_notice">&nbsp;<@bean.message key="attr.notice"/>：</td>
         <td colspan="3">
           <textarea name="manualArrangeParam.notice" cols="45" rows="4">${(manualArrangeParam.notice)?if_exists}</textarea>
         </td>
       </tr>
	   <tr class="darkColumn">
	     <td colspan="6" align="center" >
	       <input type="button" value="<@bean.message key="action.submit"/>" name="saveButton" onClick="save(this.form)" class="buttonStyle"/>&nbsp;
	       <input type="reset" name="resetButton" value="<@bean.message key="action.reset"/>" class="buttonStyle"/>
	     </td>
	   </tr>
	   <input type="hidden" name="params" value="${RequestParameters["params"]?if_exists}"/>
   </form>
  </table>
  <br><br><br><br><br><br><br><br>
   
  <script language="javascript" >
   function save(form){
     var errorInfo="";
     
     
     if(form['manualArrangeParam.startDate'].value==form['manualArrangeParam.finishDate'].value)
         errorInfo +="<@bean.message key="error.time.finishBeforeStart"/>";
     if(!isDateBefore(form['manualArrangeParam.startDate'].value,form['manualArrangeParam.finishDate'].value)) 
         errorInfo +="<@bean.message key="error.date.finishBeforeStart"/>";
     var a_fields = {
         'manualArrangeParam.notice':{'l':'注意事项','r':true,'t':'f_notice','mx':200}
     };
     if (errorInfo!="") {
        alert(errorInfo);
     }else{
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
           select.options[i].selected = (ids.indexOf(select.options[i].value) != -1);
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