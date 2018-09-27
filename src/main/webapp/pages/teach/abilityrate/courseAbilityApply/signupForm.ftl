<#include "/templates/head.ftl"/>
 <script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="actionBar"></table>
<form name="actionForm" method="post">
	<table class="formTable" width="80%" align="center">
	   <tr class="darkColumn">
	     <td align="center" colspan="4">英语升降级报名</td>
	   </tr>
		<tr>
			<td class="title">学号</td>
			<td>${apply.std.code}</td>
			<td class="title">姓名</td>
			<td>${apply.std.name}</td>
		</tr>
		<tr>
			<td class="title">原级别</td>
			<td>${apply.originAbility.name}</td>
			<td class="title">申请级别</td>
			<td>${apply.applyAbility.name}</td>
		</tr>
		<#if RequestParameters['isUpgrade']=='1'>
		<tr>
			<td class="title" id="f_interview"><font color="red">*</font>面试地点</td>
			<td colspan="3">
			<select name="apply.interview.id" style="width:400px">
	         <#list config.interviewInfos as i>
	         <#if (i.maxviewer>(statMap[i.id?string]!0)) || ((apply.interview.id)!0)==i.id>
	         <option value="${i.id}" <#if ((apply.interview.id)!0)==i.id>selected</#if>>${i.room.name} ${i.beginAt?string("yyyy-MM-dd HH:mm")}～${i.endAt?string("HH:mm")} 已报名${statMap[i.id?string]!0} 容量${i.maxviewer}</option>
	         </#if>
	         </#list>
	        </select>
	        </td>
		</tr>
		</#if>
		<tr>
			<td class="title" width="20%" id="f_mobilephone"><font color="red">*</font>联系手机:</td>
	     	<td><input type="text" style="width:200px" maxlength="11" name="apply.mobilephone" value='${(apply.mobilephone)!}'/></td>
			<td class="title" id="f_address"><font color="red">*</font>联系地址</td>
			<td><input type="text" style="width:300px" maxlength="80" name="apply.address" value='${(apply.address)!}'/></td>
		</tr>
		<tr>
			<td class="title">申请提示</td>
			<td colspan="3">
			<#if RequestParameters['isUpgrade']=='1'>${config.upgradeNotice}<#else>${config.degradeNotice}</#if>
	        </td>
		</tr>
		<tr class="darkColumn" align="center">
	     <td colspan="4">
		   <button onClick="doAction(this.form)">提交申请</button>
		   <input type="hidden" name="isUpgrade" value="${RequestParameters['isUpgrade']}"/>
           <input type="hidden" name="apply.id" value="${(apply.id)?default('')}"/>
           <input type="hidden" name="apply.config.id"value="${(apply.config.id)?default('')}"/>
	       <input type="reset" name="reset1" value="<@bean.message key="system.button.reset"/>" class="buttonStyle"/>
	     </td>
	   </tr>
	</table>
</form>
<script>
  var bar =new ToolBar("actionBar","英语升降级报名",null,true,true);
  bar.setMessage('<@getMessage/>');
  bar.addBack();
  
  function doAction(form){
   	 var a_fields = {
   	 <#if RequestParameters['isUpgrade']=='1'>
         'apply.interview.id':{'l':'面试信息', 'r':true, 't':'f_interview'},
     </#if>
         'apply.mobilephone':{'l':'联系手机', 'r':true, 't':'f_mobilephone'},
         'apply.address':{'l':'联系地址', 'r':true, 't':'f_address'}
     };
     var v = new validator(form , a_fields, null);
     if (v.exec()) {
     	if(confirm("确定提交申请?")){
	    	form.action="?method=signup";
        	form.submit();
        }
     }
  }
</script>
</body>
<#include "/templates/foot.ftl"/> 