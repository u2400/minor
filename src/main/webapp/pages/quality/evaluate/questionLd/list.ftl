<#include "/templates/head.ftl"/>
<body>
  <table id="bar" width="100%"></table>
   <@table.table width="100%" id="listTable" sortable="true" headIndex="1">
     <tr align="center" class="darkColumn" onKeyDown="DWRUtil.onReturn(event, query)">
	     <td><img src="images/action/search.png"  align="top" onClick="query()" title="在结果中过滤"/></td>
	     <form name="searchForm" method="post" action="" onsubmit="return false;">
	     <td><input type="text" name="questionLd.content" maxlength="100" value="${RequestParameters['questionLd.content']?if_exists}" style="width:100%"></td>
	     <td><input type="text" name="questionLd.department.name" maxlength="20" value="${RequestParameters['questionLd.department.name']?if_exists}" style="width:100%"></td>
	     <td><input type="text" name="questionLd.score" maxlength="10" value="${RequestParameters['questionLd.score']?if_exists}" style="width:100%"></td>
	     <td><@htm.i18nSelect datas=questionTypes selected=RequestParameters['questionLd.type.id']?default('') name="questionLd.type.id"  style="width:100%"><option value="">...</option></@></td> 
	     <td><input type='text' name='questionLd.priority' maxlength="5" value='${RequestParameters['questionLd.priority']?if_exists}' style="width:100%"></td>	     
         <td><@htm.select2 name="questionLd.state" selected="${RequestParameters['questionLd.state']?if_exists}" hasAll=true  style="width:100%"/></td>
         </form>
     </tr>
	 <@table.thead>
	   <@table.selectAllTd id="questionId"/>
	   <@table.sortTd width="35%" id="questionLd.content" name="field.question.questionContext"/>
	   <@table.sortTd width="15%" id="questionLd.department.name" text="部门"/>
	   <@table.sortTd width="10%" id="questionLd.score" name="field.question.mark"/>
	   <@table.sortTd width="14%" id="questionLd.type.name" name="field.question.questionType"/>
	   <@table.sortTd width="10%" id="questionLd.priority" text="优先级"/>
	   <@table.sortTd width="10%" id="questionLd.state" text="是否可用"/>
	 </@>
	 <@table.tbody datas=questionLds;questionLd>
	    <@table.selectTd id="questionId" value=questionLd.id/>
	    <td>${questionLd.content}</td>
	    <td><@i18nName questionLd.department/></td>
	    <td>${questionLd.score}</td>
	    <td><@i18nName questionLd.type?if_exists/></td>
	    <td>${questionLd.priority}</td>
	    <td>${questionLd.state?string("有效","无效")}</td>
	 </@>
   </@>
 <@htm.actionForm name="actionForm" action="questionLd.do" entity="questionLd"/>
<script>
   var bar = new ToolBar('bar','问题列表',null,true,true);
   bar.setMessage('<@getMessage/>');
   bar.addItem("<@msg.message key="action.add"/>","add()");
   bar.addItem("<@msg.message key="action.edit"/>","edit()");
   bar.addItem("<@msg.message key="action.delete"/>","remove()");
   //bar.addItem("<@msg.message key="action.info"/>","info()");
   function query(){
      var form=document.searchForm;
      form.action="questionLd.do?method=search";
      form.submit();
   }
</script>
 </body>
<#include "/templates/foot.ftl"/>