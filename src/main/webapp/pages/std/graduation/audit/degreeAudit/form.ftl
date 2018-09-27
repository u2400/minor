<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<script type='text/javascript' src='dwr/interface/studentDAO.js'></script>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
  <table id="bar" width="100%"> </table>
  <table class="formTable" align="center" width="80%">
  <form name="actionForm" method="post"  onsubmit="return false;">
<@searchParams/>
    <input name="auditResult.id" type="hidden" value="${(auditResult.id)?default("")}"/>
    <tr>
      <td id="f_stdCode" class="title"><@msg.message key="attr.stdNo"/><font color="red">*</font></td>
      <td><input name="auditResult.std.id" type="hidden" value="${(auditResult.std.id)?default("")}"/>
       <#if auditResult.id?exists>${auditResult.std.code}<#else>
       <input name="auditResult.std.code" value="${(auditResult.std.code)?default("")}" onchange="getStd()" maxlength="32"/>
       </#if>
      </td>
      <td class="title"><@msg.message key="attr.personName"/></td>
      <td id="stdName">${(auditResult.std.name)?default("")}</td>
    </tr>
    <tr>
      <td class="title" id="f_diplomaNo">学位证书号</td>
      <td><input name="diplomaNo" value="${(auditResult.certificateNo)?default("暂无")}" style="width:200px" maxlength="32"/></td>
      <td class="title"  id="f_score"">毕业证书号</td>
      <td><input name="score" value="${(auditResult.diplomaNo)?default("暂无")}" style="width:200px" maxlength="32"/></td>
    </tr>
    <tr style="display:none">
     <td class="title">第一专业:</td>
     <td><input name="majorType" value="${(auditResult.majorType.id)?default(1)}" style="width:200px" maxlength="32"/></td>
    </tr>
    <tr>
        <td id="f_remarkOfDegree" class="title">备注：</td>
        <td colspan="3"><textarea name="auditResult.remarkOfDegree" style="width:500;height:100px">${(auditResult.remarkOfDegree?html)?if_exists}</textarea>(100个字符)</td>
    </tr>
	<tr>
	<td class="darkColumn" colspan="4" align="center">
         <button onclick="save()"><@msg.message key="action.save"/></button>
	</td>
	</tr>
</form>
</table>

<script language="javascript" >
    var bar=new ToolBar("bar","学位管理",null,true,true);
    bar.addItem("<@msg.message key="action.save"/>","save()");
    bar.addPrint("<@msg.message key="action.print"/>");
    bar.addBackOrClose("<@msg.message key="action.back"/>", "<@msg.message key="action.close"/>");
    var form=document.actionForm;
    function save(){
        var a_fields = {};
        <#if !(auditResult.id)?exists>
        a_fields["auditResult.std.code"] = {"l":"学号", "r":true, "t":"f_stdCode"};
        </#if>
        a_fields["auditResult.remarkOfDegree"] = {"l":"备注", "r":false, "t":"f_remarkOfDegree", "mx":100};
        var v = new validator(form, a_fields, null);
        if (v.exec()) {
            if(null == form['auditResult.std.id'].value || "" == form['auditResult.std.id'].value || undefined == form['auditResult.std.id'].value){
                alert("请输入当前系统中存在的学生！");
                return;
            }
            form.action = "degreeAudit.do?method=save";
            form.target = "_self";
	        form.submit();
        }
    }
    
    function getStd() {
        var stdCode = form['auditResult.std.code'].value;
        if (stdCode == "") {
            alert("请输入学号");
            clear();
        } else{
            studentDAO.getBasicInfoName(setStdInfo,stdCode);
        }
    }
    
    function setStdInfo(data) {
        if (null == data) {
            document.getElementById("stdName").innerHTML="没有该学生";
            form['auditResult.std.id'].value="";
        } else {
            $('stdName').innerHTML=data.name;
            form['auditResult.std.id'].value=data.id;
        }
    }
  </script>

  