<#include "/templates/head.ftl"/>
 <script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
 <body>
 <table id="myBar" width="100%" ></table>
   <form name="commonForm" action="stdDetail.do?method=saveApply" method="post" onsubmit="return false;">
   <#assign basicInfo=std.basicInfo/>
   <#assign statusInfo=std.studentStatusInfo/>
    <input type="hidden" name="basicInfo.id" value="${basicInfo.id}">
  <table width="90%" align="center" class="formTable">
       <tr class="darkColumn">
	     <td colspan="4" align="center" >
	        如需修改需要审核的信息项，请带上相关文件到崇法楼103教务处行政科进行提交材料，移动电话和电子邮件请务必填写
	     </td>
	   </tr>
	   <tr>
	     <td class="title" id="f_name" width="20%"><input type="checkbox" onclick="changeState(this,'std.name')" name="chk_name"/>姓名：</td>
	     <td><input name="std.name" value="${(std.name)?if_exists}" disabled/></td>
	     <td class="title" id="f_gender" ><input type="checkbox" onclick="changeState(this,'basicInfo.gender.id')" name="chk_gender"/><@bean.message key="attr.gender"/>：</td>
	     <td>
	      <@htm.i18nSelect datas=genders selected=(basicInfo.gender.id)?default('')?string name="basicInfo.gender.id" style="width:100px;" disabled="disabled"/>
	     </td>
	   </tr>
	   <tr>
	   	 <td class="title" id="f_birthday"><input type="checkbox" onclick="changeState(this,'basicInfo.birthday')" name="chk_birthday"/>
	   	 <@bean.message key="attr.birthday"/>：</td>
	     <td>
	      <input type="text" name="basicInfo.birthday" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" maxlength="10"  disabled value="<#if basicInfo.birthday?exists>${basicInfo.birthday?string('yyyy-MM-dd')}</#if>" />
	     </td>
	     <td class="title" id="f_idCard"><input type="checkbox" onclick="changeState(this,'basicInfo.idCard')" name="chk_idCard"/><@bean.message key="std.idCard"/>：</td>
	     <td><input type="text" name="basicInfo.idCard" maxlength="18" value="${basicInfo.idCard?if_exists}" disabled/></td>
	   </tr>
	   <tr>
	     <td class="title" id="f_nation"><input type="checkbox" onclick="changeState(this,'basicInfo.nation.id')" name="chk_nation"/><@bean.message key="entity.nation"/>：</td>
	     <td>
	     <@htm.i18nSelect datas=nations selected=(basicInfo.nation.id)?default('')?string name="basicInfo.nation.id" style="width:100px;" disabled="disabled">
	       <option value="">...</option>
	      </@>
	     </td>
         <td class="title" id="f_politicVisage"><input type="checkbox" onclick="changeState(this,'basicInfo.politicVisage.id')" name="chk_politicVisage"/>
         <@bean.message key="entity.politicVisage"/>：</td>
	     <td>
 	      <@htm.i18nSelect datas=politicVisages selected=(basicInfo.politicVisage.id)?default('')?string name="basicInfo.politicVisage.id" style="width:100px;" disabled="disabled">
	       <option value="">...</option>
          </@>
	     </td>
	   </tr>
	   <tr>
	     <td class="title" id="f_originalAddress"><input type="checkbox" onclick="changeState(this,'statusInfo.originalAddress')" name="chk_originalAddress"/>
	     生源地：</td>
	     <td colspan="3"><input type="text" name="statusInfo.originalAddress" maxlength="25" value="${statusInfo.originalAddress?if_exists}" disabled/></td>
	   </tr>
	    <tr class="darkColumn">
	     <td colspan="4" align="center" >
	        无需审核的信息项
	     </td>
	   </tr>
	   <tr>
	     <td class="title" id="f_mobile"><input type="checkbox" onclick="changeState(this,'basicInfo.mobile')" name="chk_mobile"/><@bean.message key="attr.mobile"/>：</td>
	     <td><input type="text" name="basicInfo.mobile" maxlength="25" value="${basicInfo.mobile?if_exists}" disabled/></td>
	     <td class="title" id="f_mail"><input type="checkbox" onclick="changeState(this,'basicInfo.mail')" name="chk_mail"/><@bean.message key="attr.email"/>：</td>
	     <td><input type="text" name="basicInfo.mail" maxlength="100" value="${basicInfo.mail?if_exists}" disabled/></td>
	   </tr>
	   <tr>
	     <td class="title" id="f_phone"><input type="checkbox" onclick="changeState(this,'basicInfo.phone')" name="chk_phoneOfHome"/><@bean.message key="attr.phoneOfHome"/>：</td>
	     <td><input type="text" name="basicInfo.phone" maxlength="25" value="${basicInfo.phone?if_exists}" disabled/></td>
	     <td class="title" id="f_homeAddress"><input type="checkbox" onclick="changeState(this,'basicInfo.homeAddress')" name="chk_homeAddress"/><@bean.message key="attr.familyAddress"/>：</td>
	     <td><input name="basicInfo.homeAddress" value="${basicInfo.homeAddress?if_exists}" disabled/></td>
	   </tr>
	   <tr>
	     <td class="title" id="f_postCode"><input type="checkbox" onclick="changeState(this,'basicInfo.postCode')" name="chk_postCode"/><@bean.message key="attr.postCode"/>：</td>
	     <td><input type="text" name="basicInfo.postCode" maxlength="16" value="${basicInfo.postCode?if_exists}" disabled/></td>
	     <td class="title" id="f_parentName"><input type="checkbox" onclick="changeState(this,'basicInfo.parentName')" name="chk_parentName"/>父母姓名：</td>
	     <td><input name="basicInfo.parentName" value="${(basicInfo.parentName)?if_exists}" disabled/></td>
	   </tr>

	   <tr class="darkColumn">
	     <td colspan="4" align="center" >
	       <input type="button" value="<@bean.message key="system.button.submit"/>" name="button1" onClick="doAction(this.form)" class="buttonStyle"/>&nbsp;
	       <input type="reset" value="<@bean.message key="system.button.reset"/>" name="reset1" class="buttonStyle"/>
	     </td>
	   </tr>
     </form>
     </table>
  <script language="javascript" >
   var auditItems=['std.name','basicInfo.gender.id','basicInfo.birthday','basicInfo.idCard','basicInfo.nation.id','basicInfo.politicVisage.id','statusInfo.originalAddress'];
   var disauditItems=['basicInfo.mobile','basicInfo.mail','basicInfo.phone','basicInfo.homeAddress','basicInfo.postCode','basicInfo.parentName'];
    function needAudit(name){
      for(var i=0;i<auditItems.length;i++) if(auditItems[i] == name) return true;
      return false;
    }
    function changeState(chk,name){
      if(chk.checked){
         chk.form[name].disabled=false;
         if(needAudit(name)){
           chk.form['basicInfo.mobile'].disabled=false;
           chk.form['chk_mobile'].checked=true;
         }
      }else{
        chk.form[name].disabled=true;
      }
    }
    function doAction(form){
      if(!form['chk_mobile'].checked){
        for(var i=0;i<auditItems.length;i++){
          var n=auditItems[i];
          if(!form[n].disabled){
             form['basicInfo.mobile'].disabled=false;
             form['chk_mobile'].checked=true;
             break;
          }
        }
      }
      validItemCount=0;
      for(var i=0;i<auditItems.length;i++){
        var n=auditItems[i];
        if(!form[n].disabled){
          if(form[n].value==""){
            alert("请填写相应的修改内容");
            return;
          }else{
            validItemCount +=1;
          }
        }
      }
      for(var i=0;i<disauditItems.length;i++){
        var n = disauditItems[i];
        if(!form[n].disabled){
          if(form[n].value==""){
            alert("请填写相应的修改内容");
            return;
          }else{
            validItemCount +=1;
          }
        }
      }
      if(validItemCount==0){
         alert("请选择修改内容");return;
      }
      if(confirm("确定提交"+validItemCount+"项修改内容?")){
       form.submit();
      }
    }
    var bar =new ToolBar("myBar","修改基本信息（请勾选需要修改的项目）",null,true,true);
    bar.addBack("<@msg.message key="action.back"/>");
  </script>
 </body>
<#include "/templates/foot.ftl"/>