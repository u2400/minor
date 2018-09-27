<#include "/templates/head.ftl"/>
<body >
 <table id="moralGradeInputSwitchListBar"></table>
  <@table.table id="listTable" style="width:100%" sortable="true">
  <@table.thead>
    <@table.selectAllTd id="moralGradeInputSwitchId"/>
    <@table.sortTd text="开始日期" id="moralGradeInputSwitch.beginOn" style="width:40%"/>
    <@table.sortTd text="结束日期" id="moralGradeInputSwitch.endOn" style="width:40%"/>
    <@table.sortTd text="是否开放" id="moralGradeInputSwitch.opened" style="width:10%"/>
  </@table.thead>
  <@table.tbody datas=moralGradeInputSwitches;data>
	 <@table.selectTd id="moralGradeInputSwitchId" value=data.id/>
	 <td>${data.beginOn?string("yyyy-MM-dd")}</td>
	 <td>${data.endOn?string("yyyy-MM-dd")}</td>
     <td>${data.opened?string("是","否")}</td>
  </@table.tbody>
 </@table.table>
  <form name="actionForm" target="_self" method="post" action="" onsubmit="return false;">
     <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !key?contains("method")>&${key}=${RequestParameters[key]}</#if></#list>"/>
     <input type="hidden" name="moralGradeInputSwitch.calendar.id" value="${RequestParameters['moralGradeInputSwitch.calendar.id']}"/>
  </form>
  <script>
     var bar = new ToolBar('moralGradeInputSwitchListBar', '开关列表', null, true, false);
     bar.setMessage('<@getMessage/>');
     bar.addItem('<@bean.message key="action.add"/>', 'addSwitch()');
     bar.addItem('<@bean.message key="action.edit"/>', 'editSwitch()');
     var form = document.actionForm;
     function addSwitch(){
    	form.action="moralGradeInputSwitch.do?method=edit"
    	form.submit();
     }
     function editSwitch(){
    	submitId(form,"moralGradeInputSwitchId",false,"?method=edit");
     }
  </script>
</body> 
<#include "/templates/foot.ftl"/> 
