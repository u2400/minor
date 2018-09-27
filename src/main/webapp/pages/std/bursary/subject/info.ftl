<#include "/templates/head.ftl"/>
 <body>
<#assign labInfo>教材详细信息</#assign>
<#include "/templates/back.ftl"/>
     <table class="infoTable">
	   <tr>
	     <td class="title" style="width:20%">书号:</td>
	     <td width="30%">${subject.code}</td>
	     <td class="title" style="width:20%">教材名称:</td>
	     <td>${subject.name}</td>
	   </tr>
	   <tr>
	     <td class="title" style="width:20%"><@msg.message key="subject.author"/>:</td>
	     <td>${subject.auth}</td>
	     <td class="title" style="width:20%"><@msg.message key="entity.press"/>:</td>
         <td>${subject.press.name}</td>
	   </tr>
	   <tr>
	     <td class="title" style="width:20%">定价:</td>
         <td>${subject.price?string("##.##")}</td>
	     <td class="title">折扣:</td>
         <td>${(subject.onSell)?if_exists}</td>
	   </tr>
	   <tr>
	     <td class="title" style="width:20%">出版时间:</td>
         <td>${subject.publishedOn?string("yyyy-MM-dd")}</td>
	     <td class="title" style="width:20%"></td>
         <td></td>
       </tr>
     </table>
 </body>
<#include "/templates/foot.ftl"/>