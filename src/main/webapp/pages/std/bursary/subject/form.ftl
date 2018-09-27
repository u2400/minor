<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body  LEFTMARGIN="0" TOPMARGIN="0">
<#assign labInfo>助学金申请填写内容</#assign>
<#include "/templates/back.ftl"/>
  <table width="90%" align="center" class="formTable">
    <form action="bursarySubject.do?method=edit" name="subjectForm" method="post" onsubmit="return false;">
      <input type="hidden" name="subject.id" value="${(subject.id)?if_exists}">
     <tr>
      <td id="f_code" class="title"><font color="red">*</font>名称:</td>
      <td class="content">
      <input id="codeValue" type="text" maxlength="32" name="subject.name" value="${(subject.name)?if_exists}" maxLength="300" style="width:500px"/>
      </td>
      <td class="title" id="f_required">是否必填:</td>
      <td class="content" >
           <input type="radio" name="subject.required" <#if subject.required?default(false)>checked</#if> value="1"/>是
           <input type="radio" name="subject.required" <#if !subject.required?default(false)>checked</#if> value="0"/>否
      </td>
     </tr>
    <tr>
     <td class="title" id="f_options">选项：</td>
     <td class="content" ><input type="text" maxlength="100" name="subject.options" value="${(subject.options)?if_exists}" style="width:300px"/>
     <br>
     用于选择题或者是否的问题题目，格式为OptionA;OptionB 例如 是;否
     </td>
     <td class="title" id="f_subjects">限定字数：</td>
     <td class="content" ><input type="text" maxlength="3" name="subject.maxContentLength" value="${(subject.maxContentLength)?if_exists}" style="width:100px"/></td>
   </tr>
     <tr align="center" class="darkColumn">
      <td colspan="5">
          <button onclick="save(this.form)" class="buttonStyle">提交</button>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <button onclick="this.form.reset()" class="buttonStyle">重置</button>
      </td>
     </tr>
    </form> 
  </table>
  <script language="javascript">
    function save(form){
	         var a_fields = {
	         'subject.name':{'l':'名称', 'r':true, 't':'f_code','mx':'300'}
	     };	  
	     var v = new validator(form , a_fields, null);
	     if (v.exec()) {
	        form.action="bursarySubject.do?method=save"
	        form.target = "_self";
	        form.submit();
	     }
     }
 </script>
 </body>
<#include "/templates/foot.ftl"/>