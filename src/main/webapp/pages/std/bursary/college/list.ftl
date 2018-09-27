<#include "/templates/head.ftl"/>
<#include "../status.ftl"/>
<body >
 <table id="applyListBar"></table>
  <@table.table  width="100%" id="listTable" sortable="true">
    <@table.thead>
      	<@table.selectAllTd width="5%" id="applyId"/>
      	<@table.sortTd width="15%" text="学号" id="apply.std.code"/>
        <@table.sortTd width="10%" text="姓名" id="apply.std.name"/>
        <@table.sortTd width="10%" text="年级" id="apply.std.grade"/>
        <@table.sortTd width="18%" text="专业" id="apply.std.major.name"/>
        <@table.sortTd width="29%" text="奖项" id="apply.award.name"/>
        <@table.td width="13%" text="状态" />
    </@>
    <@table.tbody datas=applies;apply>
    	<@table.selectTd type="checkbox" value=apply.id id="applyId"/>
      	<td>${(apply.std.code)!}</td>
      	<td>${(apply.std.name)!}</td>
      	<td>${(apply.std.grade)!}</td>
        <td>${(apply.std.major.name)!}</td>
      	<td>${(apply.award.name)!}</td>
      	<td><a href="?method=info&apply.id=${apply.id}" target="_new"><@status apply/></a></td>
    </@>
  </@>
  <form name="actionForm" target="_self" method="post" action="" onsubmit="return false;">
     <input type="hidden" name="apply.setting.id" value="${RequestParameters['apply.setting.id']}"/>
     <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !key?contains("method")>&${key}=${RequestParameters[key]}</#if></#list>"/>
  </form>
  <script>
  	var bar=new ToolBar("applyListBar","助学金申请列表",null,true,true);
    bar.setMessage('<@getMessage/>');
    bar.addItem("单个审核", "approve()");
    bar.addItem("批量审核", "batchApprove()");
    bar.addItem("退回", "reject()");
    bar.addItem("导出列表", "exportList()");
    bar.addItem("导出申请表", "exportApply()");
    function exportList() {
    	var form = document.actionForm;
    	form.action = "bursaryCollege.do?method=export<#if (RequestParameters['apply.award.id']!"")?length!=0>&apply.award.id=${RequestParameters['apply.award.id']}<#else>&template=bursaryApplyList.xls</#if>";
    	var applyIds = getCheckBoxValue(document.getElementsByName("applyId"));
    	if (null != applyIds && '' != applyIds){
    		form.action = form.action + "&applyIds=" + applyIds;
    	}
		addHiddens(form, queryStr);
		form.submit();
	}
    function exportApply() {
    	var form = document.actionForm;
    	form.action = "bursaryCollege.do?method=export&template=bursaryApply.xls";
    	var applyIds = getCheckBoxValue(document.getElementsByName("applyId"));
    	if (null != applyIds && '' != applyIds){
    		form.action = form.action + "&applyIds=" + applyIds;
    	}
		addHiddens(form, queryStr);
		form.submit();
	}
	function approve() {
    	var form = document.actionForm;
    	submitId(document.actionForm, "applyId", false, "bursaryCollege.do?method=approveForm");
	}
    function batchApprove() {
        var form = document.actionForm;
        submitId(document.actionForm, "applyId", true, "bursaryCollege.do?method=batchApproveForm");
    }
	function reject() {
    	var form = document.actionForm;
    	submitId(document.actionForm, "applyId", false, "bursaryCollege.do?method=reject","确定退回?");
	}
  </script>
</body> 
<#include "/templates/foot.ftl"/> 