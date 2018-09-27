<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="static/scripts/common/Validator.js"></script>
<script language="JavaScript" type="text/JavaScript" src="static/scripts/prompt.js"></script>  
 <table id="editBar"></table>
 <script>
    var bar= new ToolBar("editBar","修改学号",null,true,true);
    bar.setMessage('<@getMessage/>');
    bar.addBack();
    
    function save(form){
        form.action="studentCodeManager.do?method=save";
        form.submit();
    }
    function updateCode(){
	  	document.getElementById("codeValue").disabled = false;
	}
 </script>
  <form action="studentCodeManager.do?method=save" name="codeForm" method="post" onsubmit="return false;">
     <table class="formTable" width="100%">
       <tr class="darkColumn">
	     <td align="center" colspan="2"><@bean.message key="info.studentRecordBasicInfo"/></td>
	   </tr>
	   <tr>
	     <td class="grayStyle" width="25%" id="f_stdCode">
	      &nbsp;<@bean.message key="attr.stdNo"/><font color="red">*</font>：
	     </td>
	     <td class="brightStyle">
	      <input type="hidden" value="${(std.id)?default('')}" name="std.id"/>
	      <input id="codeValue" type="text" name="std.code" maxlength="32" disabled value="${(std.code)?default('')}"/>
	      <input type="button" name="changeCodeValue" value="修改学号"  onclick="updateCode()">
	      <#include "/pages/std/checkStdNo.ftl"/><font color="red">若需要修改学号,请务必先行禁用原学生账号(在系统管理-学生用户管理中);并建立新学号对应账户.</font>
	     </td>
	   </tr>
	   <tr>
	     <td class="grayStyle" width="25%" id="f_name">
	      &nbsp;<@bean.message key="attr.personName"/><font color="red">*</font>：
	     </td>
	     <td class="brightStyle">${std.name?if_exists}</td>
	   </tr>
      </table>
      
      <table  width="100%" align="center" class="formTable">
	   <tr class="darkColumn" align="center">
	     <td>
           <input type="button" onClick='save(this.form)' value="<@bean.message key="system.button.submit" />" class="buttonStyle"/>           
           <input type="button" onClick='reset()' value="<@bean.message key="system.button.reset" />" class="buttonStyle"/>        
	     </td>
	   </tr>
      </table>
  </form>
</body>
<#include "/templates/foot.ftl"/>