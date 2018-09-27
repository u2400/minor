<#include "/templates/head.ftl"/>
 <script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
 <script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
 <body> 
 <#assign labInfo>英语升降级面试设置</#assign>
 <#include "/templates/back.ftl"/>
    <table width="90%" align="center" class="formTable">
     <form action="" name="actionForm" method="post" onsubmit="return false;">
       <@searchParams/>
	   <tr class="darkColumn">
	     <td align="center" colspan="2">英语升降级面试设置</td>
	   </tr>	
	   <tr>
	     <td class="title" width="20%" id="f_room"><font color="red">*</font>房间:</td>
	     <td>
	     <@htm.i18nSelect datas=rooms?sort_by("name") selected="${(interview.room.id)?default('')?string}" name="interview.room.id" style="width:150px"/>
	     </td>
	   </tr>
	   <tr>
	     <td class="title" id="f_beginAt"><font color="red">*</font>面试开始时间:</td>
	     <td><input type="text" style="width:300px" maxlength="19" class="Wdate" name="interview.beginAt" id="interview.beginAt" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'interview.endAt\')}'})" value='<#if (interview.beginAt)?exists>${(interview.beginAt)?string("yyyy-MM-dd HH:mm:ss")}</#if>'/></td>
	   </tr>
	   <tr>
	     <td class="title" id="f_endAt"><font color="red">*</font>面试结束时间:</td>
	     <td><input type="text" style="width:300px" maxlength="19" class="Wdate"  name="interview.endAt" id="interview.endAt"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'interview.beginAt\')}'})"  value='<#if (interview.endAt)?exists>${interview.endAt?string("yyyy-MM-dd HH:mm:ss")}</#if>'/></td>
	   </tr>
	   <tr>
	     <td class="title" id="f_maxviewer"><font color="red">*</font>最大面试人数:</td>
	     <td><input type="text" style="width:100px" name="interview.maxviewer" value='${interview.maxviewer!}' maxlength="3"/></td>
	   </tr>
	   <tr class="darkColumn" align="center">
	     <td colspan="2">
		   <button onClick="doAction(this.form)"> <@bean.message key="system.button.submit"/></button>
           <input type="hidden" name="interview.config.id"value="${interview.config.id}"/> 
           <input type="hidden" name="interview.id"value="${(interview.id)?default('')}"/>
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
         'interview.beginAt':{'l':'<@bean.message key="field.soeType.startTime"/>', 'r':true, 't':'f_beginAt'},
         'interview.endAt':{'l':'<@bean.message key="field.soeType.endTime"/>', 'r':true, 't':'f_endAt'},
         'interview.maxviewer':{'l':'最大面试人数', 'r':true, 't':'f_maxviewer'}
     };
     var v = new validator(form , a_fields, null);
     if (v.exec()) {
	    form.action="?method=saveInterview";
        form.submit();
     }
    }
 </script>
</body>
<#include "/templates/foot.ftl"/>