<#include "/templates/head.ftl"/>
<body>
  <table id="bar"></table>
  <table class="formTable" width="60%" align="center">
    <form method="post" action="studentAuditManager.do?method=saveCredit" name="actionForm" onsubmit="return false;">
    <input type="hidden" name="offsetCredit.id" id="offsetCredit.id" value=<#if offsetCredit?exists>"${offsetCredit.id}"<#else>""</#if>/>
    <input type="hidden" name="offsetCredit.std.id" id="studentId" value="${student.id}"/>
    <tr>
     <td class="title">学号:</td>
     <td>${student.code}</td>
     <td class="title">姓名:</td>
     <td>${student.name}</td>
    </tr>
    <tr>
    	<td class="title">可冲抵学分:</td>
    	<td><input id="offsetCredit.offsetCredit" name="offsetCredit.offsetCredit" maxlength="5" value=<#if offsetCredit?exists>"${offsetCredit.offsetCredit}"<#else>"0"</#if> style="width:100%"/></td>
	    <td class="title">备注:</td>
	    <td><input id="offsetCredit.remark" name="offsetCredit.remark" maxlength="5" value=<#if offsetCredit?exists>"${(offsetCredit.remark)!}"<#else>""</#if> style="width:100%"/></td>
    </tr>
  </table>
 </form>
 <script>
   var bar = new ToolBar("bar", "修改", null, true, true);
   bar.setMessage('<@getMessage/>');
   bar.addItem("保存", "save()");
   
   function save() {
        var form = document.actionForm;
        if(!check()){
        alert("冲抵学分应为非负数");
        return;
        }
        var offsetCredit = document.getElementById("offsetCredit.offsetCredit").value;
        var remark = document.getElementById("offsetCredit.remark").value;
        form.action = "offsetCredit.do?method=save";
        form.target = "_self";
        addInput(form,"offsetCredit",offsetCredit,"hidden");
        addInput(form,"remark",remark,"hidden");
        addParamsInput(form, '${queryStr}');
        form.submit();
        }
        
    function check(){
       var offsetCredit = document.getElementById("offsetCredit.offsetCredit").value;
       if(!/^([0-9]\d*|\d+\.\d+)$/.test(offsetCredit))
       {return false;}
       else
       {return true;}
    }
 </script>