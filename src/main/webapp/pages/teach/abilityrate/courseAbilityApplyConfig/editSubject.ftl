<#include "/templates/head.ftl"/>
 <script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
 <body> 
 <#assign labInfo>英语升降级科目设置</#assign>
 <#include "/templates/back.ftl"/>
    <table width="90%" align="center" class="formTable">
     <form action="" name="actionForm" method="post" onsubmit="return false;">
       <@searchParams/>
	   <tr class="darkColumn">
	     <td align="center" colspan="2">英语升降级科目设置</td>
	   </tr>	
	   <tr>
	     <td class="title" id="f_name"><font color="red">*</font>名称:</td>
	     <td><input type="text" style="width:100px" maxlength="19" name="subject.name" value='${subject.name!}' id="subject.name" /></td>
	   </tr>
	   <tr>
	     <td class="title" width="20%" id="f_score"><font color="red">*</font>达标分数:</td>
	     <td><input type="text" style="width:100px" name="subject.minScore" value='${subject.minScore!}' maxlength="3"/></td>
	   </tr>
	   <tr>
	     <td class="title" id="f_courseCodes"><font color="red">*</font>课程代码串:</td>
	     <td><input type="text" style="width:300px" maxlength="60" name="subject.courseCodes" value='${subject.courseCodes!}'/></td>
	   </tr>
	   <tr class="darkColumn" align="center">
	     <td colspan="2">
		   <button onClick="doAction(this.form)"> <@bean.message key="system.button.submit"/></button>
           <input type="hidden" name="subject.config.id"value="${subject.config.id}"/> 
           <input type="hidden" name="subject.id"value="${(subject.id)?default('')}"/>
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
         'subject.name':{'l':'名称', 'r':true, 't':'f_name'},
         'subject.minScore':{'l':'达标分数', 'r':true, 't':'f_score'},
         'subject.courseCodes':{'l':'年级', 'r':true, 't':'f_courseCodes'}
     };
     var v = new validator(form , a_fields, null);
     if (v.exec()) {
	    form.action="?method=saveSubject";
        form.submit();
     }
    }
 </script>
</body>
<#include "/templates/foot.ftl"/>