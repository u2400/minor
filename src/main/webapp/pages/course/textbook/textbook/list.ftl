<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<@getMessage/>
     <@table.table width="100%" id="listTable" sortable="true">
       <@table.thead>
	     <td class="select"></td>
	     <@table.sortTd width="10%" text="书号" id="textbook.code"/>
	     <@table.sortTd text="教材名称" id="textbook.name"/>
	     <@table.sortTd width="10%" name="textbook.author" id="textbook.auth"/>
	     <@table.sortTd name="entity.press" id="textbook.press.name"/>
	     <@table.sortTd width="10%" text="出版时间" id="textbook.publishedOn"/>
	     <@table.sortTd id="textbook.price" text='定价' width="8%"/>
	     <@table.sortTd id="textbook.onSell" text='折扣' width="8%"/>
	   </@>
	   <@table.tbody datas=textbooks;textbook>
	    <@table.selectTd type="radio" id='textbookId' value=textbook.id/>
	    <td>${(textbook.code)?if_exists}</td>
	    <td><a href="textbook.do?method=info&textbookId=${textbook.id}">${(textbook.name)?if_exists}</a></td>
	    <td>${(textbook.auth)?if_exists}</td>
	    <td>${(textbook.press.name)?if_exists}</td>
	    <td>${(textbook.publishedOn?string("yyyy-MM-dd"))?if_exists}</td>
	    <td>${(textbook.price)?if_exists}</td>
	    <td>${(textbook.onSell)?if_exists}</td>
	   </@>
     </@>
 </body>
<#include "/templates/foot.ftl"/>