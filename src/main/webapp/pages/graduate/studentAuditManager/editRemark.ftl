<#include "/templates/head.ftl"/>
<body>
	<table id="bar"></table>
    <@table.table width="100%" sortable="true" id="listTable" >
  	 <@table.thead>
            <@table.selectAllTd id="stdId"/>
            <@table.sortTd id="std.code" name="attr.stdNo" width="10%"/>
            <@table.sortTd id="std.name" name="attr.personName" width="10%"/>
            <@table.sortTd id="std.department.name" name="entity.college" width="10%"/>
            <@table.sortTd id="std.firstMajor.name" name="entity.speciality" width="10%"/>
            <@table.sortTd id="std.enrollYear" name="filed.enrollYearAndSequence" width="10%"/>
            <@table.sortTd id="std.graduateAuditStatus" name="common.status" width="10%"/>
            <@table.sortTd id="std.remark" name="attr.remark"/>
     </@>
    
    <@table.tbody datas=students; student>
            <@table.selectTd id="stdId" value=student.id/>
            <td>${student.code}</td>
            
            <td><a href="studentDetailByManager.do?method=detail&stdId=${student.id}"><@i18nName student?if_exists/></a></td>
            <td><@i18nName student.department?if_exists/></td>
            <td><@i18nName student.firstMajor?if_exists/></td>
            <td align="center">${student.enrollYear}</td>
            <td>
                <a href="javascript:showDetail(${student.id});" title="查看培养计划完成情况">
                    <#if student.graduateAuditStatus?exists&&(student.graduateAuditStatus?string=="true")>
                        <@bean.message key="attr.graduate.outsideExam.auditPass"/>
                    <#elseif student.graduateAuditStatus?exists&&(student.graduateAuditStatus?string=="false")>
                        <font color="red"><@bean.message key="attr.graduate.outsideExam.noAuditPass"/></font>
                    <#else>
                        <@bean.message key="attr.graduate.outsideExam.nullAuditPass"/>
                    </#if>
                </a>
            </td>
            <form name="remarkForm" id="remarkForm" action="studentAuditManager.do" method="post" onsubmit="return false;" >
           <td>
           <#list student.auditResults as aa>
           		<textarea cols="40" rows="2" name="${student.id!}remark" >${aa.remark!}</textarea>
           </#list>
           </td> 
      		<form/>
        </@>
        <tr>
	     <td colspan="8" align="center"  class="darkColumn">
	     <input type="hidden" name="studentIds" value="<#list students as item>${item.id!}<#if item_has_next>,</#if></#list>"/>
	       	 
  	 	
           <input type="button" onClick='saveRemark(this.form)' value="<@bean.message key="system.button.submit"/>" class="buttonStyle"/>&nbsp;&nbsp;&nbsp;
           <input type="button" onClick='reset()' value="<@bean.message key="system.button.reset"/>" class="buttonStyle"/>&nbsp;&nbsp;&nbsp;
	     </td>
	     
      	</tr>
    </@>
  	<script language="javascript">
  	function saveRemark(form){
  		form.action="studentAuditManager.do?method=saveRemark";
  		form.submit();
  	}
  	
  	var bar = new ToolBar("bar","备注修改",null,true,true);
   	bar.addBack("<@msg.message key="action.back"/>");
 	</script>
</body>
<#include "/templates/foot.ftl"/>