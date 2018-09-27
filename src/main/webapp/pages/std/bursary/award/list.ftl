<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<@getMessage/>
     <@table.table width="100%" id="listTable" sortable="true">
       <@table.thead>
	     <td class="select"></td>
	     <@table.sortTd width="10%" text="名称" id="award.name"/>
	     <@table.td width="80%" text="申请填写内容" />
	   </@>
	   <@table.tbody datas=awards;award>
	    <@table.selectTd type="radio" id='awardId' value=award.id/>
	    <td>${(award.name)?if_exists}</td>
	    <td><#list award.subjects as subject>${subject_index+1}.${subject.name}&nbsp;</#list></td>
	   </@>
     </@>
 </body>
<#include "/templates/foot.ftl"/>