<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="actionBar"></table>
 <table class="frameTable_title" width="100%" >
  <tr>
   <td>详细查询</td>
   <td>|</td> 
  <form name="applyForm" action="?method=index" target="takeListFrame" method="post" onsubmit="return false;">
  <input type="hidden" name="apply.config.calendar.id" value="${calendar.id}" /> 
  <#include "/pages/course/calendar.ftl"/>
  </tr>
 </table>
  <table width="100%" colspacing="0" class="frameTable" height="85%">
    <tr>
     <td valign="top" style="width:160px" class="frameTable_view">
     	   <table width="100%">
	    <tr>
	      <td class="infoTitle" align="left" valign="bottom">
	       <img src="images/action/info.gif" align="top"/>
	          <B>详细查询(模糊输入)</B>
	      </td>
	    </tr>
	    <tr>
	      <td colspan="8" style="font-size:0px">
	          <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
	      </td>
	   </tr>
	  </table>
	  <table class="searchTable" onkeypress="DWRUtil.onReturn(event, search)">
	    <tr>
	     <td class="infoTitle">升降级:</td>
	     <td>
	        <select name="isUpgrade" style="width:100px">
	           <option value="1" selected>升级</option>
	           <option value="0">降级</option>
	        </select>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle" ><@msg.message key="attr.stdNo"/>:</td>
	     <td><input name="apply.std.code" maxlength="32" type="text" value="${RequestParameters["apply.std.code"]?if_exists}" style="width:100px"/></td>
	    </tr>
	    <tr>
	     <td class="infoTitle" ><@msg.message key="attr.personName"/>:</td>
	     <td><input name="apply.std.name" type="text" value="${RequestParameters["apply.std.name"]?if_exists}" style="width:100px" maxlength="20"/></td>
	    </tr>
	    <tr>
	     <td class="infoTitle"><@msg.message key="entity.department"/>:</td>
	     <td>
		     <select name="apply.std.department.id" style="width:100px" value="${RequestParameters["apply.std.department.id"]?if_exists}">
		        <option value=""><@msg.message key="common.all"/></option>
		     	<#list sort_byI18nName(departmentList) as depart>
                <option value=${depart.id}><@i18nName depart/></option>
		     	</#list>
		     </select>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle"/>当前级别:</td>
	     <td><select name="apply.originAbility.id" style="width:100px" value="${RequestParameters["apply.originAbility.id"]?if_exists}">
	         <option value="">全部</option>
	         <#list abilities as a><option value="${a.id}"><@i18nName a/></option></#list>
	         </select>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle"/>申请级别:</td>
	     <td><select name="apply.applynAbility.id" style="width:100px" value="${RequestParameters["apply.applynAbility.id"]?if_exists}">
	         <option value="">全部</option>
	         <#list abilities as a><option value="${a.id}"><@i18nName a/></option></#list>
	         </select>
	     </td>
	    </tr>
	    <tr>
	     <td class="infoTitle" >面试地点:</td>
	     <td><input name="apply.interview.room.name" type="text" style="width:100px" maxlength="20"/></td>
	    </tr>
	    <#if config??>
	    <tr>
	     <td class="infoTitle"/>分数区间:</td>
	     <td><select name="subjectId" style="width:100px">
	         <#list config.subjects as s><option value="${s.id}">${s.name}</option></#list>
	         </select><br>
	         <input name="score_begin" maxlength=3/>~<input name="score_end" maxlength=3/>
	     </td>
	    </tr>
	    </#if>
	    <tr>
	     <td class="infoTitle">是否通过:</td>
	     <td>
	        <select name="apply.passed" style="width:100px">
	           <option value="" selected>全部</option>
	           <option value="0">否</option>
	           <option value="1">是</option>
	        </select>
	     </td>
	    </tr>
	    <tr align="center">
	     <td colspan="2">
		     <button onClick="search()"><@bean.message key="action.query"/></button>
	     </td>
	    </tr>
	  </table>
     </form>
     </td>
     <td valign="top">
     <iframe src="#"
     id="takeListFrame" name="takeListFrame"
     marginwidth="0" marginheight="0" scrolling="no"
     frameborder="0" height="100%" width="100%">
     </iframe>
     </td>
    </tr>
  <table>
 <script>
  var bar =new ToolBar("actionBar","英语升降级申请名单管理",null,true,true);
  bar.setMessage('<@getMessage/>');

  function search(pageNo,pageSize,orderBy){
   		var applyForm =document.applyForm;
   		applyForm.action="?method=search";
        goToPage(applyForm,pageNo,pageSize,orderBy);
  }
  search();
</script>
</body>
<#include "/templates/foot.ftl"/> 
