<#include "/templates/head.ftl"/>
<body >
 <table id="settingListBar"></table>
  <@table.table id="listTable" style="width:100%" sortable="true">
  <@table.thead>
    <@table.selectAllTd id="settingId" width="5%"/>
    <@table.sortTd text="名称" id="setting.name" style="width:25%"/>
    <@table.sortTd text="成绩测评学期" id="setting.fromSemester.id" style="width:25%"/>
    <@table.sortTd text="申请开始时间" id="setting.beginAt" style="width:25%"/>
    <@table.sortTd text="申请结束时间" id="setting.endAt" style="width:20%"/>
  </@table.thead>
  <@table.tbody datas=settings;data>
	 <@table.selectTd id="settingId" value=data.id/>
	 <td>${data.name}</td>
	 <td>${data.fromSemester.year}(${data.fromSemester.term})～<#if data.toSemester.year!=data.fromSemester.year>${data.toSemester.year}</#if>(${data.toSemester.term})</td>
	 <td>${data.beginAt?string("yyyy-MM-dd HH:mm:ss")}</td>
     <td>${data.endAt?string("yyyy-MM-dd HH:mm:ss")}</td>
  </@table.tbody>
 </@table.table>
  <form name="actionForm" target="_self" method="post" action="" onsubmit="return false;">
     <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !key?contains("method")>&${key}=${RequestParameters[key]}</#if></#list>"/>
  </form>
  <script>
     var bar = new ToolBar('settingListBar', '设置列表', null, true, false);
     bar.setMessage('<@getMessage/>');
     bar.addItem('<@bean.message key="action.add"/>', 'addSetting()');
     bar.addItem('<@bean.message key="action.edit"/>', 'editSetting()');
     bar.addItem('<@bean.message key="action.delete"/>', 'removeSetting()');
     var form = document.actionForm;
     function addSetting(){
    	form.action="bursarySetting.do?method=edit"
    	form.submit();
     }
     function editSetting(){
    	submitId(form,"settingId",false,"?method=edit");
     }
     function removeSetting(){
    	submitId(form,"settingId",true,"?method=remove");
     }
  </script>
</body> 
<#include "/templates/foot.ftl"/> 
