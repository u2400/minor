<#include "/templates/head.ftl"/>
 <body>
  <table id="bar" width="100%"></table>
   <@table.table width="100%" align="center" sortable="true" id="questionnaireLd">
	 <@table.thead>
	   <@table.selectAllTd id="questionnaireLdId"/>
	   <@table.sortTd id="questionnaireLd.description" text="问卷描述"/>
	   <@table.sortTd id="questionnaireLd.depart.name" text="制作部门"/>
	   <@table.sortTd id="questionnairLd.state" name="field.questionnaire.estate"/>
	 </@>
	 
	 <@table.tbody datas=questionnaireLds;questionnaireLd>
	 	<@table.selectTd id="questionnaireLdId" value=questionnaireLd.id/>
	    <td ><A href="#" onclick="detail(${questionnaireLd.id})">${questionnaireLd.description?if_exists}</A></td>
	    <td><@i18nName questionnaireLd.depart/></td>
	    <td>${questionnaireLd.state?string("有效","无效")}</td>
	 </@>
   </@>
 <@htm.actionForm name="actionForm" action="questionnaireLd.do" entity="questionnaireLd"/>
<script>
   var bar = new ToolBar('bar','领导评教问卷列表',null,true,true);
   bar.setMessage('<@getMessage/>');
   bar.addItem("<@msg.message key="action.add"/>","add()");
   bar.addItem("<@msg.message key="action.edit"/>","edit()");
   bar.addItem("<@msg.message key="action.delete"/>","remove()");
   bar.addItem("<@msg.message key="action.info"/>","detail()");
   function detail(questionnaireLdId){
   		form.action = "questionnaireLd.do?method=detail";
   		if (null == questionnaireLdId || "" == questionnaireLdId) {
   		   submitId(document.actionForm,"questionnaireLdId",false);
   		} else {
   		   addInput(form, "questionnaireLdId", questionnaireLdId, "hidden");
   		   form.submit();
   		}
   }
</script>
 </body>
<#include "/templates/foot.ftl"/>