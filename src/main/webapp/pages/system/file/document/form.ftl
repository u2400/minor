<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body>
	<#assign labInfo><B>文档属性修改</B></#assign>
	<#include "/templates/back.ftl"/>
  	<table width="85%" align="center" class="formTable">
     	<form name="electParamsForm" action="document.do?method=save&hold=true&kind=${RequestParameters['kind']}" method="post" onsubmit="return false;">
	   	 <input type="hidden" value="${(document.id)?if_exists}" name="document.id"/>
	   	<tr class="darkColumn">
	     	<td align="center" colspan="4">文档属性设置</td>
	   	</tr>
	   <tr>
         <td width="100%" colspan="4" align="center">文档标题：
         ${document.name?if_exists}
         </td>
       </tr>
       <tr>
         <td width="100%" colspan="2" align="left">文档上传人：
         ${document.uploaded.name?if_exists}
         </td>
         <td width="100%" colspan="2" align="left">文档上传时间：
         ${document.uploadOn?if_exists}
         </td>
       </tr>
       <tr>
	   	 <td class="darkColumn" colspan="4">&nbsp;文档有效期时间<font color="red">*</font>：</td>
       </tr>
       <tr>
	   	 <td class="title" width="25%" id="f_startDate">&nbsp;<@bean.message key="attr.startDate"/><font color="red">*</font>：</td>
	     <td>
	     	<input type="text" maxlength="10" name="document.startDate" value="${(document.startDate?string("yyyy-MM-dd"))?if_exists}" onfocus="calendar()"/>
	     </td>
	     <td class="title" width="25%" id="f_finishDate">&nbsp;<@bean.message key="attr.finishDate"/><font color="red">*</font>：</td>  
         <td>
           <input type="text" maxlength="10" name="document.finishDate" value="${(document.finishDate?string("yyyy-MM-dd"))?if_exists}" onfocus="calendar()"/>
         </td>
       </tr>
       <tr>
         <td class="darkColumn" colspan="4">&nbsp;</td>
       </tr>
	   <tr class="darkColumn">
	     <td colspan="6" align="center" >
	       <input type="button" value="<@bean.message key="action.submit"/>" name="saveButton" onClick="save(this.form)" class="buttonStyle"/>&nbsp;
	       <input type="reset" name="resetButton" value="<@bean.message key="action.reset"/>" class="buttonStyle"/>
	     </td>
	   </tr>
   </form>
  </table>
  <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
   
  <script language="javascript" >
   function save(form){
     var errorInfo="";
     
     
     if(form['document.startDate'].value==form['document.finishDate'].value)
         errorInfo +="<@bean.message key="error.time.finishBeforeStart"/>";
     if(!isDateBefore(form['document.startDate'].value,form['document.finishDate'].value)) 
         errorInfo +="<@bean.message key="error.date.finishBeforeStart"/>";
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