<#include "/templates/head.ftl"/>
 <body>
<#assign labInfo>教材详细信息</#assign>
<#include "/templates/back.ftl"/>
     <table class="infoTable">
	   <tr>
	     <td class="title" style="width:20%">书号:</td>
	     <td width="30%">${textbook.code}</td>
	     <td class="title" style="width:20%">教材名称:</td>
	     <td>${textbook.name}</td>
	   </tr>
	   <tr>
	     <td class="title" style="width:20%"><@msg.message key="textbook.author"/>:</td>
	     <td>${textbook.auth}</td>
	     <td class="title" style="width:20%"><@msg.message key="entity.press"/>:</td>
         <td>${textbook.press.name}</td>
	   </tr>
	   <tr>
	     <td class="title" style="width:20%">定价:</td>
         <td>${textbook.price?string("##.##")}</td>
	     <td class="title">折扣:</td>
         <td>${(textbook.onSell)?if_exists}</td>
	   </tr>
	   <tr>
	     <td class="title" style="width:20%">出版时间:</td>
         <td>${textbook.publishedOn?string("yyyy-MM-dd")}</td>
	     <td class="title" style="width:20%"></td>
         <td></td>
       </tr>
     </table>
 </body>
<#include "/templates/foot.ftl"/>