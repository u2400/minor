<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url" />"></script>
<body>
 <table id="bar"></table>
 <table width="90%" class="formTable" align="center" style="padding:0px;bolder-spacing:0px;">
	<form name="alterationForm" action="studentAlteration.do?method=edit" method="post" onsubmit="return false;">
	<tr> 
   	  <td align="center" class="darkColumn"><B>学籍变动详细信息</B></td>
  	</tr>
  	<tr>
  		<td style="text-align:center;padding:0px;bolder-spacing:0px">
			<table width="100%" class="formTable" align="center" style="border-bottom-width:0px">
				<tr>
					<td class="title" width="20%" id="f_stdId"><@msg.message key="attr.stdNo"/><font color="red">*</font></td>		
					<td width="30%" >
						<input name="stdNo" id="stdNo" type="text"/>
						<input type="button" onClick="save()" value="<@bean.message key="action.next" />" name="button1" class="buttonStyle" />
					</td>
				</tr>
			</table>
  		</td>
  	</tr>
   </form>
 </table>
<table width="80%" align="center" class="formTable">
	<form name="stdPlanForm" method="post" action="" onsubmit="return false;">
	<tr>
	   <td>请输入学号:</td>
	   <td><input type="text" name="stdCode" tabIndex="0"  >
	       <#assign majorTypeId = RequestParameters['majorType.id']?default("1")>
		   <select name="majorType.id">
			   <option value="1" <#if majorTypeId="1"> selected</#if>>第一专业</option>
			   <option value="2" <#if majorTypeId="2"> selected</#if>>第二专业</option>
		   </select>
		   学期
		   <input name="terms" value="${RequestParameters['terms']?default("")}" type="text" style="width:60px" maxlength="200"/>
		   多个学期可以使用,隔开
	   </td>
	   <td><button name="query" class="buttonStyle" onclick="getTeachPlan()">查询</button></td>
	</tr>
	
	</form>
</table>
<script>
  var bar=new ToolBar("bar","学籍变动查询",null,true,true);
  bar.setMessage('<@getMessage/>');
  bar.addBack("<@msg.message key="action.back"/>");
  function save(){
    var stdNo=document.getElementById("stdNo").value;
    if(""==stdNo){
     alert("学号必须填写!");
    }else{
      alterationForm.submit();
    }
  }
  
     function getTeachPlan(){
       var form= document.stdPlanForm;
       if(form['stdCode'].value==""){
         alert("学号为必填项");
         return;
       }
       form.action="stdTeachPlan.do?method=edit";
       form.submit();
    }
 
</script>
</body>
<#include "/templates/foot.ftl"/>