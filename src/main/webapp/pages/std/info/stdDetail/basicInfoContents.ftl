	<table class="infoTable">
	   	<tr>
	     	<td width="18%" class="title"><@msg.message key="attr.gender"/>：</td>
	     	<td width="32%"><#if (std.basicInfo.gender)?exists><@i18nName std.basicInfo.gender/><#else>&nbsp;</#if></td>
	     	<td width="18%" class="title"><@msg.message key="attr.birthday"/>：</td>
	     	<td width="32%">${((std.basicInfo.birthday?string('yyyy-MM-dd'))?default('　'))?html}</td>
	   </tr>
	   <tr>
		    <td class="title"><@msg.message key="entity.country"/>：</td>
		    <td><#if (std.basicInfo.country)?exists><@i18nName std.basicInfo.country/><#else>&nbsp;</#if></td>
		    <td class="title" id="f_nation"><@msg.message key="entity.nation"/>：</td>
		    <td><#if (std.basicInfo.nation)?exists><@i18nName std.basicInfo.nation/><#else>&nbsp;</#if></td>
	   </tr>
	   <tr>
		    <td class="title"><@msg.message key="attr.ancestralAddress"/>：</td>
		    <td>${(std.basicInfo.ancestralAddress?default('　'))?html}</td>
		    <td class="title"><@msg.message key="std.idCard"/>：</td>
		    <td>${(std.basicInfo.idCard?default('　'))?html}</td>
	   </tr>
	   <tr>
		    <td class="title"><@msg.message key="entity.politicVisage"/>：</td>
		    <td><#if (std.basicInfo.politicVisage)?exists><@i18nName std.basicInfo.politicVisage/><#else>&nbsp;</#if></td>
		    <td class="title"><@msg.message key="baseCode.maritalStatus"/>：</td>
		    <td><#if (std.basicInfo.maritalStatus)?exists><@i18nName std.basicInfo.maritalStatus/><#else>&nbsp;</#if></td>
	   </tr>
	   <tr>
	     	<td class="title"><@msg.message key="attr.mobile"/>：</td>
	     	<td>${std.basicInfo.mobile?default('　')?html}</td>
	     	<td class="title"><@msg.message key="attr.email"/>：</td>
	     	<td>${std.basicInfo.mail?default('　')?html}</td>
	   </tr>
	   <tr>
		    <td class="title">家庭<@msg.message key="attr.postCode"/>：</td>
		    <td>${(std.basicInfo.postCode?default('　'))?html}</td>
		    <td class="title"><@msg.message key="attr.familyAddress"/>：</td>
		    <td>${(std.basicInfo.homeAddress?default('　'))?html}</td>
	   </tr>
	   <tr>
		    <td class="title"><@msg.message key="attr.phone"/>：</td>
		    <td>${(std.basicInfo.phone?default('　'))?html}</td>
		    <td class="title"><@msg.message key="std.parentsName"/>：</td>
		    <td>${((std.basicInfo.parentName)?default('　'))?html}</td>
	   </tr>
	</table>
	<#if applies?exists && applies?size!=0>
<@table.table width="100%" sortable="true" id="listTable">
	  <@table.thead>
	     <@table.td width="70%"id="apply.newMobile" text="修改内容"/>
	     <@table.td id="apply.applyAt" text="申请时间"/>
	     <@table.td id="apply.passed" width="15%" text="审核状态"/>
	   </@>
	   <@table.tbody datas=applies;apply>
        <td>
          <#list apply.items as item>
            ${item.meta.name} : ${studentInfoAlterApplyService.getString(item.meta,item.oldValue)!} ⇒ ${studentInfoAlterApplyService.getString(item.meta,item.newValue)!} <#if item_index%2==1><br/></#if>
          </#list>
        </td>
        <td>${apply.applyAt?string("yyyy-MM-dd HH:mm")}</td>
        <td>
        <#if !(apply.passed??)>
          未审核
          <a href="#" onclick="cancelApply(${apply.id})">取消</a>
        <#else>
        ${apply.passed?string("通过","未通过")}
        </#if>
        </td>
	   </@>
     </@>
     <form name="actionForm" method="post" action="stdDetail.do?method=cancelApply"/>
     <script>
       function cancelApply(applyId){
          if(confirm("确定取消?")){
            document.actionForm.action="stdDetail.do?method=cancelApply&applyId=" +applyId;
            document.actionForm.submit();
          }
       }
     </script>
	</#if>
