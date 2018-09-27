<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body  LEFTMARGIN="0" TOPMARGIN="0">
<#assign labInfo>德育成绩信息</#assign>
<#include "/templates/back.ftl"/>
 <form action="moralGradeDepart.do?method=edit" name="moralGradeEditForm" method="post" onsubmit="return false;">
  <table width="90%" align="center" class="formTable">
      <input type="hidden" name="moralGrade.id" value="${(moralGrade.id)?if_exists}">
     <tr>
      <td class="title">学号:</td>
      <td class="content">${moralGrade.std.code}</td>
      <td class="title">姓名:</td>
      <td class="content">${moralGrade.std.name}</td>
     </tr>
     <tr>
      <td class="title">学年度:</td>
      <td class="content">${moralGrade.calendar.year}</td>
      <td id="f_score" class="title"><font color="red">*</font>德育成绩:</td>
      <td class="content">
          <#if moralGrade.status==2>${moralGrade.score} 已发布<#else>
          <input type="text" name="moralGrade.score" value="${(moralGrade.score?string("##.#"))?if_exists}" maxLength="6" style="width:200px"/>
          </#if>
      </td>
     </tr>
     <tr>
      <td class="title" id="f_publishedOn">备注:</td>
      <td colspan="3" class="content">
        <#if moralGrade.status==2>${moralGrade.remark!} 已发布<#else>
      	<textarea name="moralGrade.remark" cols="60">${(moralGrade.remark)!}</textarea>
      	</#if>
      </td>
     </tr>
     <#if moralGrade.status!=2>
     <tr align="center" class="darkColumn">
      <td colspan="5">
          <button onclick="save(this.form)" class="buttonStyle">提交</button>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <button onclick="this.form.reset()" class="buttonStyle">重置</button>
      </td>
     </tr>
    </#if>
  </table>
     <input type="hidden" name="params" value="${RequestParameters["params"]}"/>
    </form> 
  <div style="height:200px"></div>
  <script language="javascript">
    function save(form){
	         var a_fields = {
	         'moralGrade.score':{'l':'德育成绩', 'r':true, 't':'f_score','mx':'32'}
	     };	  
	     var v = new validator(form , a_fields, null);
	     if (v.exec()) {
	        form.action="moralGradeDepart.do?method=save"
	        form.target = "_self";
	        form.submit();
	     }
     }
 </script>
 </body>
<#include "/templates/foot.ftl"/>
