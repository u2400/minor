<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
<body  LEFTMARGIN="0" TOPMARGIN="0">

<#assign labInfo>教材基本信息</#assign>
<#include "/templates/back.ftl"/>
  <table width="90%" align="center" class="formTable">
    <form action="textbook.do?method=edit" name="textbookForm" method="post" onsubmit="return false;">
      <input type="hidden" name="textbook.id" value="${(textbook.id)?if_exists}">
     <tr>
      <td id="f_code" class="title"><font color="red">*</font>编号（唯一）:</td>
      <td class="content">
      <input id="codeValue" type="text" maxlength="32" name="textbook.code" value="${(textbook.code)?if_exists}" maxLength="32" style="width:200px"/>
      </td>
      <td id="f_name" class="title"><font color="red">*</font>教材名称:</td>
      <td class="content"><input type="text" name="textbook.name" value="${(textbook.name)?if_exists}" maxLength="100" style="width:200px"/></td>
     </tr>
     <tr>
      <td id="f_auth" class="title">作者:</td>
      <td class="content"><input type="text" name="textbook.auth"  value="${(textbook.auth)?if_exists}" maxLength="25" style="width:200px"/></td>
      <td id="f_press" class="title">出版社:</td>
      <td class="content">
          <select name="textbook.press.id" style="width:200px">
              <option value=""<#if !(textbook.press.id)?exists> selected</#if>>...</option>
              <#list (presses?sort_by("name"))?if_exists as press>
              <option value="${press.id}"<#if (textbook.press.id)?exists && press.id==textbook.press.id> selected</#if>>${press.name}</option>
              </#list>
          </select>
      </td>
     </tr>
     <tr>
      <td class="title" id="f_publishedOn">出版时间:</td>
      <td class="content">
        <input type="text" name="textbook.publishedOn" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" readOnly value="${(textbook.publishedOn?string("yyyy-MM-dd"))?if_exists}" style="width:200px"/>
      </td>
      <td id="f_price" class="title">定价:</td>
      <td class="content"><input type="text" name="textbook.price" value="${(textbook.price?string("##.##"))?if_exists}" maxLength="6" style="width:200px"/></td>
     </tr>
     <tr>
      <td id="f_onSell" class="title">折扣:</td>
      <td class="content"><input type="text" name="textbook.onSell" value="${(textbook.onSell)?if_exists}" maxLength="6" style="width:200px"/></td>
      <td class="title">ISBN:</td>
      <td class="content"><input type="text" name="textbook.onSell" value="${(textbook.onSell)?if_exists}" maxLength="6" style="width:200px"/></td>
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
  <div style="height:200px"></div>
  <script language="javascript">
    function save(form){
	         var a_fields = {
	         'textbook.code':{'l':'书号', 'r':true, 't':'f_code','mx':'32'},
	         'textbook.name':{'l':'教材名称', 'r':true, 't':'f_name'}
	     };	  
	     var v = new validator(form , a_fields, null);
	     if (v.exec()) {
	        form.action="textbook.do?method=save"
	        form.target = "_self";
	        form.submit();
	     }
     }
   
 </script>
 </body>
<#include "/templates/foot.ftl"/>