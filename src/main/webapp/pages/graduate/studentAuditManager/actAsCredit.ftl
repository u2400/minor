<#include "/templates/head.ftl"/>
<body>
  <table id="bar"></table>
  <table class="formTable" width="60%" align="center">
    <form method="post" action="studentAuditManager.do?method=saveCredit" name="actionForm" onsubmit="return false;">
    <input type="hidden" name="offsetCredit.id" value=<#if offsetCredit?exists>"${offsetCredit.id}"<#else>""</#if> />
    <input type="hidden" name="offsetCredit.std.id" value="${student.id}"/>
    <tr>
     <td class="title">学号:</td>
     <td>${student.code?default('')}</td>
     <td class="title">姓名：</td>
     <td>${student.name?default('')}</td>
    </tr>
    <tr>
      <td class="title">可冲抵学分:</td>
      <td><input type="text" id="offsetCredit.offsetCredit" name="offsetCredit.offsetCredit" value=<#if offsetCredit?exists>"${offsetCredit.offsetCredit}"<#else>"0"</#if> /></td>	
      <td class="title">备注:</td> 
      <td><input type="text" id="offsetCredit.remark" name="offsetCredit.remark" value=<#if offsetCredit?exists>"${(offsetCredit.remark)!}"<#else>""</#if> </td>
    </tr>
    </form>
  </table>
 <script>
    var bar = new ToolBar("bar", "可冲抵学分维护", null, true, true);
    bar.setMessage('<@getMessage/>');
    bar.addItem("保存", "save()");
    bar.addBack("<@bean.message key="action.back"/>");
    var chongDiCreditAttrs = new Array();
    
	function save(){
	    errorStr=check();
	    if(errorStr!=""){
	    	alert(errorStr);
	    	return;
	    }
	    form = document.actionForm;
	    addInput(form,"offsetCredit.offsetCredit",document.getElementById('offsetCredit.offsetCredit').value);
		addInput(form,"offsetCredit.remark",document.getElementById('offsetCredit.remark').value);
	    form.action = "studentAuditManager.do?method=saveCredit";
	    addParamsInput(form, '${queryStr}');
		form.submit();
	}
    function check(){
	   var errorStr="";
	   var credit = document.getElementById('offsetCredit.offsetCredit').value
	   if(credit == null || credit == ''){
	   	 errorStr += "！可冲抵学分不能为空";
	   	 return errorStr;
	   }else if(!/^([0-9]\d*|\d+\.\d+)$/.test(credit)){
	   	 errorStr+="！可冲抵学分必须为非负数";
	   }
	   return errorStr;
	}
	
 </script>
 </body>
<#include "/templates/foot.ftl"/>