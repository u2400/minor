<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body  LEFTMARGIN="0" TOPMARGIN="0">
<#assign labInfo>助学金奖项基本信息</#assign>
<#include "/templates/back.ftl"/>
    <form action="bursaryAward.do?method=edit" name="awardForm" method="post" onsubmit="return false;">
  <table width="90%" align="center" class="formTable">
      <input type="hidden" name="award.id" value="${(award.id)?if_exists}">
     <tr>
      <td id="f_name" class="title"><font color="red">*</font>名称:</td>
      <td class="content" colspan="3">
      <input id="codeValue" type="text" name="award.name" value="${(award.name)?if_exists}" maxLength="300" style="width:500px"/>
      </td>
     </tr>
    <tr>
    <td class="title" id="f_subjects"><font color="red">*</font>填写的内容：</td>
    <td colspan="3">
     <table>
      <tr>
       <td>
        <select name="subjects" MULTIPLE size="10" style="width:200px" onDblClick="JavaScript:moveSelectedOption(this.form['subjects'], this.form['selectedSubjects'])" >
         <#list subjects?sort_by('name') as subject>
          <option value="${subject.id}">${subject.name}</option>
         </#list>
        </select>
       </td>
       <td  valign="middle">
        <br><br>
        <input OnClick="JavaScript:moveSelectedOption(this.form['subjects'], this.form['selectedSubjects'])" type="button" value="&gt;"> 
        <br><br>
        <input OnClick="JavaScript:moveSelectedOption(this.form['selectedSubjects'], this.form['subjects'])" type="button" value="&lt;"> 
        <br>
       </td> 
       <td  class="normalTextStyle">
        <select name='selectedSubjects' MULTIPLE size="10" style="width:200px;" onDblClick="JavaScript:moveSelectedOption(this.form['selectedSubjects'], this.form['subjects'])">
         <#list award.subjects as subject>
          <option value="${subject.id}">${subject.name}</option>
         </#list>
        </select>
       </td>
      </tr>
     </table>
    </td>
   </tr>
     <tr align="center" class="darkColumn">
      <td colspan="5">
          <button onclick="save(this.form)" class="buttonStyle">提交</button>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <button onclick="this.form.reset()" class="buttonStyle">重置</button>
      </td>
     </tr>
  </table>
    </form> 
  <div style="height:200px"></div>
  <script language="javascript">
    function save(form){
	         var a_fields = {
	         'award.name':{'l':'名称', 'r':true, 't':'f_name','mx':'300'}
	     };	  
	     var v = new validator(form , a_fields, null);
	     if (v.exec()) {
	        form.action="bursaryAward.do?method=save"
	        selectAll(form['selectedSubjects'])
	        form.target = "_self";
	        form.submit();
	     }
     }
     function selectAll(o){
       for(i=0;i<o.options.length;i++)
         o.options[i].selected=true
     }
 </script>
 </body>
<#include "/templates/foot.ftl"/>