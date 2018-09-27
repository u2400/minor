<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="myBar" width="100%"></table>
   <table align='center' width="100%">
     <form name="pageGoForm" action="?method=upload&apply.id=${RequestParameters['apply.id']}"  method="post" enctype="multipart/form-data">
     <tr>
     	<td>
	      <input type="file" size=50  name="attachmentFile" class="buttonStyle" value=''/>
	      <input type="button" value="<@bean.message key="system.button.submit" />" name="submitNow" onClick="validateFile(this.form)" class="buttonStyle"><br><br>
        </td>
     </tr>
     <tr>
       <td>
          <font color="red" size="2">
          如果上传一个的文件，请打成压缩包。
          </font>
       </td>
     </tr>
   </form>
   </table>
 </body>
<#include "/templates/foot.ftl"/>
<script>
var bar = new ToolBar("myBar","助学金附件上传",null,true,true);

  function validateFile(form){
  	var value=form.attachmentFile.value;
  	var index=value.indexOf(".xls");
	if(null==value || "" == value){
		alert("请选择附件");
		return false;
	}
	form.submit();
  }
</script>