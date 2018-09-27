<#include "/templates/head.ftl"/>
<body  LEFTMARGIN="0" TOPMARGIN="0" >
 <#assign labInfo><@bean.message key="entity.teachTask"/><@bean.message key="common.detailInfo"/></#assign>
 <#include "/templates/back.ftl"/>
     <table class="infoTable">
	   <tr>
	   	<td colspan="6" style="background-color: #EEEEEE"><@bean.message key="entity.teachClass"/><@bean.message key="common.info"/></td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="entity.teachClass"/></td>
	     <td class="content">${task.teachClass.name}</td>
	     <td class="title"><@bean.message key="entity.studentType"/></td>
         <td class="content"><@i18nName task.teachClass.stdType/></td>
	     <td class="title"><@bean.message key="attr.enrollTurn"/></td>
         <td class="content">${task.teachClass.enrollTurn?if_exists}</td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="entity.college"/></td>
	     <td class="content"><@i18nName task.teachClass.depart/></td>
	     <td class="title"><@bean.message key="entity.speciality"/></td>
         <td class="content"><@i18nName task.teachClass.speciality?if_exists/></td>
	     <td class="title"><@bean.message key="entity.specialityAspect"/></td>
         <td class="content"><@i18nName task.teachClass.aspect?if_exists/></td>
	   </tr>
	   <tr>
	     <td class="title"><@bean.message key="entity.adminClass"/></td>
	     <td class="content">
	         <#list task.teachClass.adminClasses as adminClass>
	             ${adminClass.name}
	         </#list>
	     </td>
	     <td class="title"><@bean.message key="attr.planStdCount"/></td>
         <td class="content">${task.teachClass.planStdCount}</td>
         <td class="title"><@bean.message key="attr.actualStdCount"/></td>
         <td class="content">${task.teachClass.stdCount}</td>
	   </tr>
       <tr>
          <td class="title">性别</td>
          <td class="content">${(task.teachClass.gender.name)?default("全部")}</td>
          <td class="title"></td>
          <td class="content"></td>
          <td class="title"></td>
          <td class="content"></td>
       </tr>
      </table>
 </body>
<#include "/templates/foot.ftl"/>