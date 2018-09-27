<#include "/templates/simpleHead.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/common/onReturn.js"></script>
<body LEFTMARGIN="0" TOPMARGIN="0" scroll=auto>
<TABLE WIDTH="100%" HEIGHT="100%" BORDER="0" CELLPADDING="0" CELLSPACING="0">
 <TR>
  <TD ALIGN="CENTER" VALIGN="MIDDLE">
   <TABLE WIDTH="651" BORDER="0" CELLPADDING="0" CELLSPACING="0" onkeypress="ret.focus(event)">
    <tr>
     <td align="center"><IMG SRC="images/loginForm/tu1.jpg"></td>
    </tr>
    <tr>
     <td align="center"><IMG SRC="images/loginForm/tu2.jpg"></td>
    </tr>
    <TR>
     <TD height="105" ALIGN="CENTER" VALIGN="MIDDLE" BACKGROUND="images/loginForm/tu3.jpg" style="background-attachment: fixed;background-repeat: no-repeat;background-position: center;">
      <TABLE width="50%" BORDER="0" CELLSPACING="0" CELLPADDING="0"  width="651"   >
       <tr>
        <td colspan="3"><font color="red"><@html.errors /><#if userRemark?exists><br>${userRemark}</#if></font></td>
       </tr>
       <form name="loginForm" method="post" action="login.do" onsubmit="return false;">
       <tr>
         <td colspan="2">
         <TABLE WIDTH="100%" BORDER="0" CELLPADDING="0" CELLSPACING="0" style="font-size:16px">
		 <td ALIGN="left">
         </tr>
         <tr>
          <td ALIGN="right" height="30"><STRONG>用户名:</STRONG></td>
          <td width="45">
           <INPUT NAME="name" TYPE="text" value="${(RequestParameters['name']?html)?if_exists}" style="width:150px;background-color:#B0B0B0">
          </td>
         </tr>
         <tr>
          <td ALIGN="right" height="30"><STRONG>密码:</STRONG></td>
          <td><INPUT NAME="password" TYPE="password"   style="width:150px;background-color:#B0B0B0"></td>
         </tr>
         <tr>
          <td ALIGN="right"><INPUT NAME="lang" TYPE="radio" value="chinese" checked >中文</td>
          <td><INPUT NAME="lang"  id="engVersion" TYPE="radio" value="english">ENGLISH</td>
         </tr>
         </table>
        </td>
        <td colspan="2">
        <TABLE WIDTH="100%" BORDER="0" CELLPADDING="0" CELLSPACING="0">
         <tr>
                <td >&nbsp;
                  <button name="submitButton"  onclick ="submitLogin()" style="height:35pt;width:38pt;" BORDER="0"><B>登录</B></button>
                </td>
         </tr>
         </table>
        </td>
       </tr>
       </form>
      </TABLE>
     </TD>
    </TR>

    <form name="formsubmit" method="post" action="" onsubmit="return false;">
    <tr>
     <td ALIGN="right">

         </td>
    </tr>
    </form>
	<tr>
	</tr>
   </TABLE>
  </TD>
 </TR>
</TABLE>

<script>
  var ret = new OnReturn(document.loginForm);
  ret.add("name");
  ret.add("password");
  ret.add("submitButton");
  var form  = document.loginForm;

  function submitLogin(){
     if(form.name.value==""){
        alert("用户名称不能为空");return;
     }
     if(form.password.value==""){
        alert("密码不能为空");return;
     }
     form.submit();
  }

  if("${localName}".indexOf("en")!=-1){
     document.getElementById('engVersion').checked=true;
  }

  var username=getCookie("username");
  if(null!=username){
    form['name'].value=username;
  }

</script>
</body>
<#include "/templates/foot.ftl"/>
