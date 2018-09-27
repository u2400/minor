<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="myBar" width="100%"></table>
   <script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
   <form   method="post"  onsubmit="return false;">
   <input type="hidden" name="params" value="&apply.setting.id=${applies?first.setting.id}"/>
   <@table.table  width="100%" id="listTable" sortable="true">
    <@table.thead>
      	<@table.sortTd width="15%" text="学号" id="apply.std.code"/>
        <@table.sortTd width="10%" text="姓名" id="apply.std.name"/>
        <@table.sortTd width="10%" text="年级" id="apply.std.grade"/>
        <@table.sortTd width="18%" text="专业" id="apply.std.major.name"/>
        <@table.sortTd width="29%" text="奖项" id="apply.award.name"/>
    </@>
    <@table.tbody datas=applies;apply>
      	<td>${(apply.std.code)!} <input type="hidden" value="${apply.id}" name="apply.id"/></td>
      	<td><a href="?method=info&apply.id=${apply.id}" target="_new">${(apply.std.name)!}</a></td>
      	<td>${(apply.std.grade)!}</td>
        <td>${(apply.std.major.name)!}</td>
      	<td>${(apply.award.name)!}</td>
    </@>
  </@>
  
     <table  width="90%" align="center" class="formTable">
       <tr class="darkColumn">
	    <td align="center" colspan="6">助学金申请批量审核</td>
	   </tr>
       <tr>
          <td class="title" id="f_approved"><font color="red">*</font>审核结果:</td>
          <td>
          <input type="radio" id="approved_yes" name="approved" value="1"> <label for="approved_yes">同意</label>
          <input type="radio" id="approved_no" name="approved" value="0"> <label for="approved_no">不同意</label>
          </td>
       </tr>
       <tr>
          <td class="title" id="f_opinion">
           <font color="red">*</font>审核意见:
          </td>
          <td>
          <textarea  rows="5" cols="80"  name="schoolOpinion"></textarea>
          </td>
       </tr>
       <tr align="center" class="darkColumn">
      <td colspan="5">
          <button onclick="save(this.form)" class="buttonStyle">提交</button>
      </td>
     </tr>
     </table>
   </form>
   <script>
   function save(form){
	    var a_fields = {
	         'approved':{'l':'审核结果', 'r':true, 't':'f_approved'},
	         'schoolOpinion':{'l':'审核意见', 'r':true, 't':'f_opinion',mx:500}
	     };
	     var v = new validator(form , a_fields, null);
	     if (v.exec()) {
	        form.action="bursarySchool.do?method=batchApprove"
	        form.target = "_self";
	        form.submit();
	     }
     }
  </script>
<script>
    var bar = new ToolBar("myBar", "助学金批量审核", null, true, true);
    bar.setMessage('<@getMessage/>');
    bar.addBack();
</script>
</body>
<#include "/templates/foot.ftl"/>
